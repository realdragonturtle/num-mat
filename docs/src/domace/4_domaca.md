# 4. domača naloga

```@contents
Pages = ["4_domaca.md"]
Depth = 3
```

## Navodila

Zahtevana števila izračunajte na **10 decimalk** (z
relativno natančnostjo $\mathbf{10^{-10}}$) Uporabite lahko le osnovne
operacije, vgrajene osnovne matematične funkcije `exp`, `sin`, `cos`, ...,
osnovne operacije z matrikami in razcepe matrik. Vse ostale algoritme morate
implementirati sami.

Namen te naloge ni, da na internetu poiščete optimalen algoritem in ga
implementirate, ampak da uporabite znanje, ki smo ga pridobilili pri tem
predmetu, čeprav na koncu rešitev morda ne bo optimalna. Kljub temu pazite 
na **časovno in prostorsko zahtevnost**, saj bo od tega odvisna tudi ocena.

Izberite **eno** izmed nalog. Domačo nalogo lahko delate skupaj s kolegi, vendar
morate v tem primeru rešiti toliko različnih nalog, kot je študentov v skupini.

Če uporabljate drug programski jezik, ravno tako kodi dodajte osnovno
dokumentacijo in teste.

## Težje naloge

### Ničle Airijeve funkcije 

Airyjeva funkcija je dana kot rešitev začetnega problema

```math
  Ai''(x)-x\,Ai(x)=0,\quad Ai(0)=\frac{1}{3^\frac{2}{3}\Gamma\left(\frac{2}{3}\right)}\,Ai'(0)=-\frac{1}{3^\frac{1}{3}\Gamma\left(\frac{1}{3}\right)}.
```
Poiščite čim več ničel funkcije $Ai$ na 10 decimalnih mest natančno. Ni
dovoljeno uporabiti vgrajene funkcijo za reševanje diferencialnih enačb.
Lahko pa uporabite Airyjevo funkcijo ` airyai` iz paketa `SpecialFunctions.jl`, da preverite ali ste res dobili pravo ničlo.

#### Namig
Za računanje vrednosti $y(x)$ lahko uporabite Magnusovo metodo reda 4 za reševanje enačb oblike

```math
y'(x) = A(x)y,
```
pri kateri nov približek $\mathbf{Y}_{k+1}$ dobimo takole:

```math
\begin{array}{ccc}
 A_1&=&A\left(x_k+\left(\frac{1}{2}-\frac{\sqrt{3}}{6}\right)h\right)\\ 
A_2&=&A\left(x_k+\left(\frac{1}{2}+\frac{\sqrt{3}}{6}\right)h\right)\\ 
\sigma_{k+1}&=&\frac{h}{2}(A_1+A_2)-\frac{\sqrt{3}}{12}h^2[A_1,A_2]\\ 
\mathbf{Y}_{k+1}&=&\exp(\sigma_{k+1})\mathbf{Y}_k.
 \end{array}
```

Izraz $[A,B]$ je komutator dveh matrik in ga izračunamo kot
$[A,B]=AB-BA$. Eksponentno funkcijo na matriki ($\exp(\sigma_{k+1})$) pa
v programskem jeziku julia dobite z ukazom `exp`.

### Dolžina implicinto podane krivulje

Poiščite približek za dolžino krivulje, ki je dana implicitno z enačbama

```math
\begin{align*}
F_1(x,y,z)&=x^4+y^2/2+z^2=12\\
F_2(x,y,z)&=x^2+y^2-4z^2=8.
\end{align*}
```

Krivuljo lahko poiščete kot rešitev diferencialne enačbe 

```math
\dot{\mathbf{x}}(t) = \nabla F_1\times \nabla F_2.
```

### Perioda limitnega cikla


Poiščite periodo limitnega cikla za diferencialno enačbo

```math
x''(t)-4(1-x^2)x'(t)+x=0
```
na 10 decimalk natančno.

### Obhod lune

Sondo Appolo pošljite iz Zemljine orbite na tir z vrnitvijo brez potiska
(free-return trajectory), ki obkroži Luno in se vrne nazaj v Zemljino
orbito. Rešujte sistem diferencialnih enačb, ki ga dobimo v koordinatnem
sistemu, v katerem Zemlja in Luna mirujeta (omejen krožni problem treh
teles). Naloge ni potrebno reševati na 10 decimalk.

#### Omejen krožni problem treh teles

Označimo z $M$ maso Zemlje in z $m$ maso Lune. Ker je masa sonde
zanemarljiva, Zemlja in Luna krožita okrog skupnega masnega
središča. Enačbe gibanja zapišemo v vrtečem koordinatnem
sistemu, kjer masi $M$ in $m$ mirujeta. Označimo 

```math
     \mu = \frac{m}{M+m} \quad \textrm{ ter } \quad \bar{\mu} = 1 - \mu = \frac{M}{M+m} \textrm{. }
``` 

V brezdimenzijskih koordinatah (dolžinska enota je kar razdalja
med masama $M$ in $m$) postavimo maso $M$ v točko $(-\mu,0,0)$, maso
$m$ pa v točko $(\bar{\mu},0,0)$. Označimo z $R$ in $r$ oddaljenost
satelita s položajem $(x,y,z)$ od mas $M$ in $m$, tj.

```math
\begin{align*}
   R &= R(x,y,z) = \sqrt{(x+\mu)^2 + y^2 + z^2}, \\
   r &= r(x,y,z) = \sqrt{(x-\bar{\mu})^2 + y^2 + z^2}.
\end{align*}
```

Enačbe gibanja sonde so potem:

```math
\begin{align*}
   \ddot{x} &= x + 2 \dot{y} - \frac{\bar{\mu}}{R^3} (x + \mu) - \frac{\mu}{r^3} (x - \bar{\mu}), \\
   \ddot{y} &= y - 2 \dot{x} - \frac{\bar{\mu}}{R^3} y - \frac{\mu}{r^3} y, \\
   \ddot{z} &= - \frac{\bar{\mu}}{R^3} z - \frac{\mu}{r^3} z.
\end{align*}
```

## Lažja naloga (ocena največ 9)

Naloga je namenjena tistim, ki jih je strah eksperimentiranja ali pa za
to preprosto nimajo interesa ali časa.

### Matematično nihalo

Kotni odmik $\theta(t)$ (v radianih) pri nedušenem nihanju nitnega
nihala opišemo z diferencialno enačbo

```math
{g\over l}\sin(\theta(t))+\theta^{\prime\prime}(t)=0, \quad \theta(0)=
\theta_0,\ \theta^{\prime}(0)=\theta^{\prime}_0,
```
kjer je $g=9.80665m/s^2$ težni pospešek in $l$ dolžina nihala. Napišite funkcijo
`nihalo`, ki računa odmik nihala ob določenem času. Enačbo drugega reda
prevedite na sistem prvega reda in računajte z metodo Runge-Kutta četrtega reda:

```math
\begin{array}{ccc}  
k_1& = &h\,f(x_n,y_n)\\ 
k_2& = & h\,f(x_n+h/2,y_n+k_1/2)\\ 
k_3& = & h\,f(x_n+h/2,y_n+k_2/2)\\ 
k_4& = & h\,f(x_n+h,y_n+k_3)\\ 
y_{n+1}& = & y_n+(k_1+2k_2+2k_3+k_4)/6. \end{array}
```

Klic funkcije naj bo oblike `odmik=nihalo(l,t,theta0,dtheta0,n)`

-   kjer je `odmik` enak odmiku nihala ob času `t`,
-   dolžina nihala je `l`,
-   začetni odmik (odmik ob času $0$) je `theta0`
-   in začetna kotna hitrost ($\theta'(0)$) je `dtheta0`,
-   interval $[0,t]$ razdelimo na `n` podintervalov enake dolžine.

Primerjajte rešitev z nihanjem harmoničnega nihala. Za razliko od
harmoničnega nihala (sinusno nihanje), je pri matematičnem nihalu
nihajni čas odvisen od začetnih pogojev (energije). Narišite graf, ki
predstavlja, kako se nihajni čas spreminja z energijo nihala.