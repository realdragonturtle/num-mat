# Računanje kvadratnega korena

Računalniški procesorji navadno implementirajo le osnovne številske operacije:
 seštevanje, množenje in deljenje. Za računanje drugih matematičnih funkcij 
 mora nekdo napisati program.
 
!!! note "Elementarne funkcije so v stadardni knjižnici večine jezikov"
 
     Večina programskih jezikov vsebuje elementarne funkcije v standardni 
     knjižnici. Tako tudi `julia`. Lokacijo metod, ki računajo kvadratni koren 
     lahko dobite z ukazom `methods(sqrt)`.

## Naloga

Na različne načine izračunaj kvadratni koren. Napiši več metod za funkcijo 
`koren`, tako da uporabiš [večlično razpošiljanje (multiple dispatch)](https://en.wikipedia.org/wiki/Multiple_dispatch) na 
abstraktne tipe, ki predstavljajo različne metode. Na primer definiramo dve 
različni metodi za koren

```@example koren_1
struct NapacenKoren end
struct VgrajenaFunkcija end

function koren(x, metoda::NapacenKoren)
 x/2
end

function koren(x, metoda::VgrajenaFunkcija)
 sqrt(x)
end

```

ki jih nato lahko pokličemo, tako da spremenimo 2. argument:


```@repl koren_1
koren(2, NapacenKoren())
koren(2, VgrajenaFunkcija())
```

## Računajne kvadratnega korena z babilonskim obrazcem

Z računajnjem kvadratnega korena so se ukvarjali pred 3500 leti v Babilonu. O tem si lahko več preberete v [članku v reviji Presek](http://www.presek.si/21/1160-Domajnko.pdf). Moderna verzija metode računanja približka predstavlja rekurzivno 
zaporedje, ki konvergira k vrednosti kvadratnega korena danega števila $x$. Rekurzivna formula


```math
a_{n+1} = \frac{1}{2}\cdot(a_n + \frac{x}{a_n}).
```

Če izberemo začetni približek, zgornja formula določa zaporedje, ki vedno konvergira bodisi k $\sqrt{x}$ ali $-\sqrt{x}$, odvisno od izbire začetnega približka. Poleg tega, da zaporedje hitro konvergira k limiti, je program, ki računa člene izjemno preprost. Poglejmo si primer računanje $\sqrt{2}$

```@example koren_2_babilon
let 
  x = 1.5
  for n = 1:5
    x = (x + 2/x)/2
    println(x)
  end
end
```

Vidimo, da se približki začnejo ponavljati že po 4. koraku. To pomeni, da se zaporedje ne bo več spreminjalo in smo dosegli najboljši približek, kot a lahko v 64 bitnih številih s plavjočo vejico. 

Napišimo zgornji algoritem še kot funkcijo.

```@example koren_babilon; continued = true
"""
    koren_babilonski(x, x0, n)

Izračuna približek za koren števila `x` z `n` koraki babilonskega obrazca z začetnim približkom `x0`.
"""
function koren_babilonski(x, x0,  n)
    a = x0
    for i = 1:n
        a = (a + x/a)/2
    end
    return a
end
```

Preskusimo funkcijo na številu 3.

```@example koren_babilon; continued=false
x  = koren_babilonski(3, 1.7, 5)
println("Koren števila 3: $x")
println("Razlika z vgrajeno funkcijo: $(x-sqrt(3))")
```

!!! note "Metoda navadne iteracije in tangentna metoda"

     Metoda računanja kvadratnega korena z rekurzivnim zaporedjem je poseben primer [tangentne metode](https://sl.wikipedia.org/wiki/Newtonova_metoda), ki je poseben primer [metode fiksne točke](https://sl.wikipedia.org/wiki/Metoda_navadne_iteracije). Obe metodi, si bomo podrobneje ogledali, v poglavju o nelinearnih enačbah.


### Izbira začetnega približka

Funkcija `koren_babilonski(x, x0, n)` ni uporabna za splošno rabo, saj mora uporabnik poznati tako začetni približek, 
kot tudi število korakov, ki so potrebni, da dosežemo željeno natančnost. Funkcija mora sama izbrati začetni približek, kot tudi število korakov.

Kako bi učinkovito izbrali dober začetni približek? Ker rekurzivno zaporedje konvergira ne glede na izbran začetni približek, lahko uporabimo kar samo število $x$. Ali pa uporabimo diferencial(prva dva člena v Taylorjevem razvoju) okrog števila 1

```math
\sqrt{x} = 1 + \frac{1}{2}(x-1) + ... \approx 1/2 + x/2
``` 

Začetni približek $1/2 + x/2$ dobro deluje za števila blizu 1, če isto formulo za začetni približek preskusimo za večja števila, dobimo večjo relativno napko. Oziroma potrebujemo več korakov zanke, da pridemo do enake natančnosti. Razlog je v tem, da je $\frac{x}{$ dober približek za majhna števila, če pa se 
od števila 1 oddaljimo, je približek vedno slabši, dlje kot smo oddaljeni od 1:

```@example
using Plots
plot(x->x/2, 0, 10, label="začetni približek")
plot!(x->sqrt(x), 0, 10, label="korenska funkcija")
savefig("koren_zacetni_priblizek.png")
```

![začetni približek v primerjavi z dejansko vrednostjo korena](koren_zacetni_priblizek.png)

Da bi dobili boljši približek, si pomagamo s tem, kako so števila predstavljena v računalniku. Realna števila predstavimo s števili s [plavajočo vejico](https://sl.wikipedia.org/wiki/Plavajo%C4%8Da_vejica). Število je zapisano v obliki

```math
 x = m 2^e
```

kjer je $0.5\le m<1$ mantisa, $e$ pa eksponent. Za 64 bitna števila s plavajočo vejico se za zapis mantise uporabi 53 bitov (52 bitov za decimalke, en bit pa za predznak), 11 bitov pa za eksponent (glej [IEE 754 standard](https://en.wikipedia.org/wiki/IEEE_754)).

Koren števila $x$ lahko potem izračunamo kot

```math
\sqrt{x} = \sqrt{m} 2^{e/2}
```

dober začetni približek dobimo tako, da $\sqrt{m}$ aproksimiramo razvojem v Taylorjevo vrsto okrog točke 1 

```math
\sqrt{m} \approx 1 + \frac{1}{2}(m-1) = 1/2 + m/2
```

Če eksponent delimo z 2 in upoštevamo ostanek $e = 2d + o$, lahko $\sqrt{2^e}$ približno zapišemo kot

```math
\sqrt{2^e} \approx 2^d,
```

pri čemer smo ostanek zanemarili. Celi del števila pri deljenju z 2 lahko dobimo z binarnim premikom v desno (right shift).
Tako lahko zapišemo naslednjo funckijo za začetni približek

```@example koren_priblizek
"""
    zacetni_priblizek(x)

Izračunaj začetni približek za tangentno metodo za računanjekvadratnega korena števila `x`. 
"""
function zacetni_priblizek(x)
  d = exponent(x) >> 1 # desni premik, oziroma deljenje z 2
  m = significand(x)
  return (0.5 + 0.5*m)*(2^d)
end
```

Poglejmo, kako se obnaša relativna napaka, če uporabimo izboljšano verzijo začetnega približka.

```@example
using Plots
scatter(x -> log10(abs(koren_babilonski(x, zacetni_priblizek(x), 6) - x)/x),0, 10000, label="Logaritem napake", markersize=1)
savefig("napaka_koren.png")
```

![Desetiški logaritem napake](napaka-koren.png)

## Transformacija definicijskega območja

Določena formula ali metoda ni vedno uporabna na celotnem definicijskem območju funkcije. Tako smo videli v prejšnjem razdelku, da je fiksno število korakov tangentne metode s preprosto formulo za začetni približek dalo dober rezultat le v bližini števila 1. Rešitev lahko naslovimo s transformacijo definicijskega območja na ožji interval, na katerem izbrana metoda dobro deluje. Poglejmo si zopet zapis s plavajočo vejico

```math
 x = m\cdot 2^{2d+o}
```

kjer smo eksponent že razstavili na sodo število in ostanek. Če izračunamo koren

```math
\sqrt{x} = \sqrt{m\cdot 2^o}\cdot 2^d
```

Ker je $m\in [0.5, 1)$, je $x\cdot 2^{-2d} = m\cdot 2^o \in [0.5, 2)$, lahko za izračun korena uporabimo formulo, ki deluje na intervalu $[0.5, 2)$.

Izbrati moramo število korakov, pri katerem bo relativna napaka ustrezno majhna na intervalu $[0.5, 2)$. To se zgodi 
pri $n = 6$ za izbiro začetnega približka $1/2 + x/2$.

```@example
using Plots
rel_napaka(x) = (koren_babilonski(x, 0.5 + x/2, 6)^2 - x)/x
plot(rel_napaka, 0.5, 2)
savefig("napaka_koren.png")
```

![Relativna napaka na [0.5, 2]](napaka_koren.png)


Sedaj lahko sestavimo funkcijo za računanje korena, ki potrebuje le število in ima konstantno časovno zahtevnost

```@example
"""
    metoda = BabilonskiObrazec()

Pomožni podatkovni tip, ki predstavlja metodo računanja korena z babilonskim obrazcem
"""
struct BabilonskiObrazec
end

"""
    koren(x, BabilonskiObrazec())

Izračunaj kvadratni koren danega števila `x` z babilonskim obrazcem. 
"""
function koren(x, metoda::BabilonskiObrazec)
    d = (exponent >> 1) # polovični exsponent
    x_trans = x * 2^(-(d << 1)) # transfromacija na interval [0.5, 2)
    x_0 = 0.5 + x_trans/2 
    return koren_babilonski(x_trans, x_0, 6) * 2^d
end
```

Relativna napaka je neodvisna od izbranega števila, prav tako za izračun tudi potrebujemo enako število operacij.

## Hitro računanje obratne vrednosti kvadratnega korena

Pri razvoju računalniških iger, ki poskušajo verno prikazati 3 dimenzionalni svet na zaslonu, se veliko uporablja normiranje 
vektorjev. Pri operaciji normiranja je potrebno komponente vektorja deliti s korenom vsote kvadratov komponent. Kot smo 
spoznali pri računanju kvadratnega korena z babilonskim obrazcem, je posebej problematično poiskati ustrezen začetni približek, ki je dovolj blizu pravi rešitvi. Tega problema so se zavedali tudi inžinirji igre Quake, ki so razvili posebej 
zvit, skoraj magičen način za dober začetni približek. Metoda uporabi posebno vrednost `0x5f3759df`, da pride do začetnega 
približka, nato pa še en korak [tangentne metode](ttps://sl.wikipedia.org/wiki/Newtonova_metoda).
Več o [računanju obratne vrednosti kvadratnega korena](https://en.wikipedia.org/wiki/Fast_inverse_square_root).


## Koda

```@index
Pages = ["01_koren.md"]
```

```@autodocs
Modules = [NumMat]
Pages = ["koren.jl"]
```