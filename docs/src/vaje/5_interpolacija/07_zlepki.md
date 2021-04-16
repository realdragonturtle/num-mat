# Interpolacija z zlepki

```@contents
Pages = ["07_zlepki.md"]
Depth = 3
```
## Interpolacija s polinomi

Poglejmo si najprej primer interpolacije s polinomom. Interpolirali bomo
funkcijo $e^{2x}$ v tokah $-1, 0, 1, 2$ z [newtonovim interpolacijskim
polinomom](https://en.wikipedia.org/wiki/Newton_polynomial). Nato napako ocenimo
z oceno

```math
\begin{equation}\label{eq:napaka}
f(x) - p_n(x) = \frac{f^{n+1}(\xi)}{(n+1)!}\Pi_{k=1}^n(x-x_i)
\end{equation}
```  
in oceno primerjamo z numerično napako.

### Newtonova interpolacija

Naj bodo $x_1, \ldots x_{n+1}$ vrednosti neodvisne spremenljivke in $y_1,\ldots
y_{n+1}$ vrednosti neznane funkcije. Interpolacijski polinom je polinom, ki
zadošča enačbam
 
```math
\begin{equation}\label{eq:enacbe}
p(x_1) = y_1, p(x_2)=y_2, \ldots p(x_{n+1})=y_{n+1}
\end{equation}
```

Newtonov interpolacijski je interpolacijski polinom 

```math
p(x) = a_0 + a_1(x-x_1) +a_2(x-x_1)(x-x_2) + \ldots a_n(x-x_1)\ldots (x-x_{n-1}),
```

ki je zapisan v bazi 

```math
1, x-x_1, (x-x_1)(x-x_2), \ldots (x-x_1)\ldots (x-x_{n-1}).
```

Koeficiente $a_i$ je tako lažje izračunati, kot če bi bil polinom zapisan v
standardni bazi. Poleg tega je računanje vrednosti polinoma v standardni bazi
lahko numerično nestabilno, če so vrednosti $x_i$ relativno skupaj.

Koeficiente $a_i$ lahko poiščemo bodisi tako, da rešimo spodnje trikotni sistem,
ki ga dobimo iz enačb \eqref{eq:enacbe} ali pa z [deljenimi
diferencami](https://en.wikipedia.org/wiki/Divided_differences)

```@example polinom
using Plots
x = [-1, 0, 1, 2]
y = exp.(2x)
slika = scatter(x, y)
```

Ustvarimo tabelo deljenih diferenc in zapišemo Newtonov interpolacijski polinom
```@example polinom
using NumMat
p = deljene_diference(x,y)
plot!(slika, p, -1, 2, label="interpolacijski polinom")
plot!(slika, x->exp(2x), -1, 2, label="exp(2x)")
```

Razlika med funkcijo in interpolacijskim polinomom lahko ocenimo s formulo
\eqref{eq:napaka}, če upoštevamo, da je $f^{(4)}=16e^{2x}\le 16e^4\simeq 873$.
Potem je 

```math
|p(x)-f(x)|\le 36.4 (x+1)x(x-1)(x-2)\le 36.4
```

medtem ko dejansko napako najlepše prikažemo grafično

```@example polinom
plot(x->p(x)-exp(2x), -1, 2, label="napaka", title="Napaka polinomske interpolacije")
```

Ocena, ki smo jo dobili s formulo \eqref{eq:napaka} je tako precej pesimistična,
čeprav je vsaj red velikosti približno pravilen.

!!! tip "Tipi in večlična dodelitev omogoča izražanje podobno kot v matematičnemu jeziku"

    Na primeru Newtonovega polinoma lahko ilustriramo, kako izkoristimo tipe 
    in [večlično dodelitev](https://docs.julialang.org/en/v1/manual/methods/#Methods-1),
    da lahko transparentno definiramo operacije, ki so v matematiki naravne, v programskih jeziki pa pogosto njihova uporaba ni več tako intuitivna. Za Newtonov interpolacijski polinom smo tako definirali tip [`NewtonovPolinom`](@ref) in metodo [`polyval`](@ref), s katero lahko izračunamo vrednost Newtonovega interpolacijskega polinoma v dani točki. Lahko gremo še dlje in definiramo, da se vrednosti tipa `NewtonovPolinom` obnašajo kot funkcije
    ```julia
    (p::NewtonovPolinom)(x) = polyval(p, x)
    ```
    tako da lahko vrednosti polinoma dobimo tako, da kličemo polinom sam, kot bi bil funkcija
    ```julia
    p = NewtonovPolinom([1,0,0],[1, 2, 3])
    p(1.23)
    ```

### Rungejev pojav

Pri nizkih stopnjah polinomov se napaka interpolacije zmanjšuje, če povečamo število interpolacijskih točk. 
A le do neke mere, če stopnja polinoma preveč povečamo, začne napaka spet naraščati.
Interpolirajmo funkcijo $\sin(3x)+\cos(2x)$ v točkah $x_i=\frac{i-1}{2}$, za $i=1\ldots 13$.

```@example runge
using Plots
using NumMat
x = 0:0.5:6
f(x) = sin(3x)+cos(2x)
scatter(x, f.(x), title="Interpolacija s polinomom stopnje 12", grid=false)
plot!(f, 0, 6; label="f(x)")
p = deljene_diference(Array(x), f.(x))
plot!(p, 0, 6; label="polinom stopnje 12")
```
Večja napaka se v tem primeru pojavi blizu roba interpolacijskega intervala 

```@example runge
plot(x->p(x)-f(x), 0, 6; title="Napaka interpolacije", label="p12(x)-f(x)")
```

!!! warning "Interpolacija s polinomi visokih stopenj je lahko problematična"

    V prejšnjem primeru opazimo, da se napaka na robu znatno poveča. Povečanje je posledica velikih oscilacij, ki se pojavijo na robu, če interpoliramo s polinomom **visoke stopnje** na **ekvidistančnih točkah**. To je znan pojav pod imenom [Rungejev pojav](https://en.wikipedia.org/wiki/Runge%27s_phenomenon) in se pojavi, če interpoliramo s polinomom visoke stopnje v ekvidistančnih točkah. Problemu se lahko izognemo, če namesto ekvidistančnih točk uporabimo [Čebiševe točke](https://en.wikipedia.org/wiki/Chebyshev_nodes).

## Zlepki

!!! note "Zakaj zlepki"

    Pogosto je bolje uporabiti različne definicije funkcije na različnih intervalih, kot eno funkcijo z veliko parametri. Funkcijam, ki so sestavljene iz več različnih definicij pravimo **zlepki**. Če interpoliramo z zlepkom, se izognemo Rungejevemu pojavu in ne dobimo velikih oscilacij na robu.

### Linearen zlepek

Interpoliraj funkcijo $sin$ z linearnim zlepkom. Numerično oceni napako.

### Hermitovi zlepki

Za točke $x_1, \ldots x_n$ imamo podane vrednosti funkcije $f_1, \ldots f_n$ in vrednosti odvoda $df_1, \ldots df_n$. Poiskati želimo gladek zlepek sestavljen iz polinomov $S_i(x)$ na intervalu $[x_i, x_{i+1}]$, ki interpolira dane podatke. To pomeni, da so izpolnjene naslednje enačbe

```math
\begin{equation}\label{eq:hermite}
\begin{array}{ll}
S_i(x_i) = f_i & S_{i}(x_{i+1})=f_{i+1}\cr
S_i'(x_i) = df_i& S_{i}'(x_{i+1})=df_{i+1}
\end{array}
\end{equation}
```

Hermitov zlepek je vedno zvezen in zvezno odvedljiv, ker se vrednosti funkcije
in vrednosti odvoda predpisane v točkah, kjer se dva predpisa dotikata in se
zato avtomatično ujemajo.

#### Newtonova interpolacija vrednosti in odvodov

Če poleg funkcijskih vrednosti podamo še odvode, lahko še vedno uporabimo
deljene diference za izračun Newtonovega interpolacijskega polinoma. Pri tem
vrednosti neodvisne spremenljivke $x_i$, v katerih je podan tudi odvod, v tabeli
deljenih diferenc napišemo večkrat (točko ponovimo tolikokrat, kolikor je
podanih višjih odvodov). Poglejmo si primer. Interpolirajmo podatke 
$x_1=0, x_2=1, f(x_1)=0, f(x_2)=0$ in $f'(x_1)=1, f''(x_1)=-4$. V tabelo deljenih 
diferenc zapišemo $0,0,0,1$ za vrednosti $x$ in $0, 1, --4, 0$ za vrednosti $f$.

```math
\begin{array}{c|cccc}
x& f & f[\cdot,\cdot]& f[\cdot,\cdot, \cdot] & f[\cdot,\cdot, \cdot, \cdot]\cr
\hline
0 &  0& 1& \frac{-4}{2!}& 1\cr
0 &  1& 1& -1& \cr
0 & -4& 0& & \cr
1 &  0& & & \cr
\end{array}
```

Hermitove zlepke sedaj lahko preprosto poiščemo tako da na vsakem intervalu
uporabimo deljene diference za vrednosti in odvode v krajščih (enačbe
\eqref{eq:hermite}).

```@example
using Plots # hide
using NumMat # hide
zlepek = hermitov_zlepek([0, 1, 2, 4], [0, 1, 2, 0], [0, -1, 0, 1])
plot(zlepek, title="Heremitov zlepek")
```

### Laplaceovi $\mathcal{C}^1$ zlepki

Za točke $x_1, \ldots x_n$ so podane vrednosti funkcije $f_1, \ldots f_n$.
Predpostavimo, da je $n$ liho število. Poiskati želimo zlepek sestavljen iz
kubičnih polinomov $S_i(x)$ na intervalu $[x_{2i-1}, x_{2i+1}]$, ki interpolira
dane podatke. Poleg tega zahtevamo, da se v točkah, v katerih se predpisi
stikajo ujemajo odvodi, da dobimo zvezno odvedljiv zlepek.

!!! tip "Število parametrov naj bo enako številu zahtev"

    Pri interpolaciji s polinomi lahko zadostimo toliko zahtevanim pogojem, kolikor ima polinom koeficientov oz kolikor je dimenzija prostora poplinomov. Za polinome 3. stopnje je dimenzija 4, kar pomeni, da lahko in moramo predpisati 4 zahteve, bodisi za vrednosti polinoma ali vrednosti odvodov v 4 različnih točkah. Na vsakem intevalu $[x_{2i-1}, x_{2i+1}]$ so 3 vrednosti predpisane (v točkah $x_{2i-1}$, $x_{2i}$, $x_{2i+1}$), to pomeni, da lahko dodamo še eno zahtevo, s katero dosežemo zvezno odvedljivost zlepka. 

Omenjene zahteve lahko zapišemo z naslednjimi enačbami

```math
\begin{array}{lll}
S_i(x_{2i-1}) = f_{2i-1} & S_i(x_{2i})=f_{2i} & S_i(x_{2i+1})&=f_{2i+1}\cr
S_{i-1}'(x_{2i-1}) = S_i'(x_{2i-1}) & S_{i}'(x_{2i+1}) = S_{i+1}'(x_{2i+1}) &
\end{array}
```

To je sicer 5 zahtev za vsak polinom $S_i$, a če preštejemo vse enačbe in koeficiente, vidimo, da manjka le še ena enačba za polinom na robu $S_1$ ali $S_{(n-1)/2}$. Predpišemo lahko vrednost prvega ali drugega odvoda v eni od robnih točk $x_1$ ali $x_{n}$[^1]. 

Koeficiente polinomov $S_i$ lahko tako računamo zaporedoma tako, da izpolnijo naslednje 4 enačbe

```math
\begin{array}{ll}
S_i(x_{2i-1}) = f_{2i-1} & S_i(x_{2i})=f_{2i}\cr 
S_i(x_{2i+1}) =f_{2i+1} & S_i'(x_{2i-1})=S_{i-1}'(x_{2i-1})\cr
\end{array}
```

Za prvi polinom $S_1$ pa zadnjo enačbo nadomestimo z enačbo

```math
S_1''(x_1)=0
```

!!! warning "Običajno se uporabljajo naravni zlepki"

    Lagrangeovega $C^1$ zlepka, kot smo ga opisali v tem razdelku običajno ne 
    uporabljamo, saj je lahko za iste podatke sestavimo [naravni kubični zlepek](https://en.wikipedia.org/wiki/Spline_interpolation), 
    ki ima boljlše lastnosti. Naravni zlepek je dvakrat zvezno odvedljiv in 
    med vsemi funkcijami, ki interpolirajo dane točke ima najmanjšo 
    povprečno ukrivljenost.


!!! tip "Kaj smo se naučili"

    * deljene diference in Newtonov polinom lahko uporabimo tudi, če so poleg vrednosti podani tudi odvodi
    * zaradi Rungejevega pojava interpolacija s polinomi visokih stopenj na ekvidistančnih točkah ni najboljša izbira 
    * zlepki so enostavni za uporabo, učinkoviti (malo operacij za izračun) in imajo v določenih primerih boljše lastnosti kot polinomi visokih stopenj
    * poznamo različne vrste zlepkov glede na zveznost in podatke, ki jih potrebujemo za določitev (linearni zlepek, Hermitov zlepek in Lagrangeov zlepek)

[^1]:

    Najpogosteje zahtevamo, da je drugi odvod v robnih točkah enak 0. Če
    predpišemo prvi odvod, določimo tangente v robnih točkah, kar je pogosto preveč
    vpliva na končno obliko zlepka.

## Koda

Julia omogoča, da definirmo metode za transparentno risanje in računanje z zlepki
[PlotRecipies.jl](https://github.com/JuliaPlots/RecipesBase.jl)

```@index
Pages = ["07_zlepki.md"]
```

```@autodocs
Modules = [NumMat]
Pages = ["zlepki.jl"]
Order   = [:function, :type]
```