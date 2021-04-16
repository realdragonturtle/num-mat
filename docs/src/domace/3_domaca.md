# 3. domača naloga

```@contents
Pages = ["3_domaca.md"]
Depth = 3
```

## Navodila

Tokratna domača naloga je sestavljena iz dveh delov. V prvem delu morate
implementirati program za računanje vrednosti dane funkcije $f(x)$. V drugem
delu pa izračunati eno samo številko. Obe nalogi rešite na **10 decimalk** (z
relativno natančnostjo $\mathbf{10^{-10}}$) Uporabite lahko le osnovne
operacije, vgrajene osnovne matematične funkcije `exp`, `sin`, `cos`, ...,
osnovne operacije z matrikami in razcepe matrik. Vse ostale algoritme morate
implementirati sami.

Namen te naloge ni, da na internetu poiščete optimalen algoritem in ga
implementirate, ampak da uporabite znanje, ki smo ga pridobilili pri tem
predmetu, čeprav na koncu rešitev morda ne bo optimalna. Uporabite lahko
interpolacijo ali aproksimacijo s polinomi, integracijske formule, Taylorjevo
vrsto, zamenjave spremenljivk, itd. Kljub temu pazite na **časovno in prostorsko
zahtevnost**, saj bo od tega odvisna tudi ocena.

Izberite **eno** izmed nalog. Domačo nalogo lahko delate skupaj s kolegi, vendar
morate v tem primeru rešiti toliko različnih nalog, kot je študentov v skupini.

Če uporabljate drug programski jezik, ravno tako kodi dodajte osnovno
dokumentacijo, teste in demo.

## Naloge s funkcijami

### Porazdelitvena funkcija normalne slučajne spremenljivke

Napišite učinkovito funkcijo, ki izračuna vrednosti porazdelitvene funkcije  za
standardno normalno porazdeljeno slučajno spremenljivko $X\sim N(0,1)$.

```math
\Phi(x) = P(X\le x) = \frac{1}{\sqrt{2\pi}}\int_{-\infty}^x e^{-\frac{t^2}{2}}dt
```

### Fresnelov integral

Napišite učinkovito funkcijo, ki izračuna vrednosti Fresnelovega
kosinusa

```math
C(x) = \sqrt{2/\pi}\int_0^x \cos(t^2)dt.
```

 **Namig**:
Uporabite pomožni funkciji

```math
f(x) = \sqrt{2/\pi} \int_0^\infty e^{-2xt} \cos(t^2) dt
```

```math
g(x) = \sqrt{2/\pi} \int_0^\infty e^{-2xt} \sin(t^2) dt
```

### Funkcija kvantilov za $N(0,1)$

Napišite učinkovito funkcijo, ki izračuna funkcijo kvantilov za normalno
porazdeljeno slučajno spremenljivko. Funkcija kvantilov je inverzna funkcija
porazdelitvene funkcije.

### Integralski sinus

Napišite učinkovito funkcijo, ki izračuna integralski sinus

```math
Si(x) = \int_0^x \frac{\sin(t)}{t}dt.
```

Uporabite pomožne funkcije, kot je opisano v
[priročniku Abramowitz in Stegun](http://people.math.sfu.ca/~cbm/aands/page_232.htm).

### Besselova funkcija

Napišite učinkovito funkcijo, ki izračuna Besselovo funkcijo $J_0$:

```math
J_0(x) =  \frac{1}{\pi} \int_0^\pi \cos(x\sin t)dt.
```

## Naloge s števili

### Sila težnosti

Izračunajte velikost sile težnosti med dvema vzporedno postavljenima
enotskima homogenima kockama na razdalji 1. Predpostavite, da so vse
fizikalne konstante, ki nastopajo v problemu, enake 1. Sila med dvema
telesoma $T_1,T_2\subset \mathbb{R}^3$ je enaka

```math
\mathbf{F} = \int_{T_1}\int_{T_2}
\frac{\mathbf{r}_1-\mathbf{r_2}}{\left\|\mathbf{r}_1-\mathbf{r_2}\right\|^2}
d\mathbf{r}_1d\mathbf{r}_2.
```

### Ploščina hipotrohoide

Izračunajte ploščino območja, ki ga omejuje hypotrochoida podana
parametrično z enačbama:

```math
x(t) = (a+b)\cos(t) + b\cos\left(\frac{a+b}{b}t\right)
```

```math
y(t) = (a+b)\sin(t) + b\sin\left(\frac{a+b}{b}t\right)
```

za parametra $a=1$ in $b=-\frac{11}{7}$.

### Povprečna razdalja

Izračunajte povprečno razdaljo med dvema točkama znotraj telesa $T$, ki
je enako razliki dveh kock:

```math
T= [-1,1]^3 - [0,1]^3.
```

Povprečno razdaljo na produktu razlik množic $(A-B)\times(A-B)$ lahko
določimo z integralom:

```math
\int_{A-B}\int_{A-B}\|\vec{r_1}-\vec{r_2}\|dr_1dr_2=
\int_A\int_A\|\vec{r_1}-\vec{r_2}\| -
2\int_{A}\int_{B}\|\vec{r_1}-\vec{r_2}\|dr_1dr_2 +
\int_{B}\int_{B}\|\vec{r_1}-\vec{r_2}\|dr_1dr_2
```

### Ploščina Bézierove krivulje

Izračunajte ploščino zanke, ki jo omejuje Bézierova krivulja dana s
kontrolnim poligonom:

```math
 (0,0),(1,1),(2,3),(1,4),(0,4),(-1, 3), (0,1),(1,0).
```

## Lažje naloge (ocena največ 9)

Naloge so namenjen tistim, ki jih je strah eksperimentiranja ali pa za
to preprosto nimajo interesa ali časa. Rešiti morate eno od obeh nalog:

### Ineterpolacija z baricentrično formulo

Napišite program, ki za dano funkcijo $f$ na danem intervalu $[a,b]$
izračuna polinomski interpolant, v Čebiševih točkah. Vrednosti naj
računa z *baricentrično Lagrangevo interpolacijo,* po formuli

```math
l(x)=\begin{cases}
\frac{\sum\frac{f(x_{j})\lambda_{j}}{x-x_{j}}}{\sum\frac{\lambda_{j}}{x-x_{j}}} & x\not=x_{j}\\
f(x_{j}) & \text{sicer}
\end{cases}
```

kjer so vrednosti uteži $\lambda_{j}$ izbrane, tako da je
$\prod_{i\not=j}(x_{j}-x_{i})=1$. Čebiševe točke so podane na intrvalu
$[-1,1]$ s formulo

```math
x_{i}=\cos\left(\frac{i\pi}{n}\right);\quad i=0\ldots n,

```

vrednosti uteži $\lambda_{i}$ pa so enake

```math
\lambda_{i}=(-1)^{i}\begin{cases}
1 & 0<i<n\\
\frac{1}{2} & i=0,n.
\end{cases}
```

Za interpolacijo na splošnem intervalu $[a,b]$ si pomagaj z linearno
preslikavo na interval $[-1,1]$. Program uporabi za tri različne
funkcije $e^{-x^{2}}$ na $[-1,1]$, $\frac{\sin x}{x}$ na $[0,10]$ in
$|x^{2}-2x|$ na $[1,3]$. Za vsako funkcijo določi stopnjo polinoma, da
napaka ne bo presegla $10^{-6}$.

### Gauss-Legendrove kvadrature

Izpelji Gauss-Legendreovo integracijsko pravilo na dveh točkah

```math
\int_{0}^{h}f(x)dx=Af(x_{1})+Bf(x_{2})+R_{f}
```

vključno s formulo za napako $R_{f}$. Izpelji sestavljeno pravilo za
$\int_{a}^{b}f(x)dx$ in napiši program, ki to pravilo uporabi za
približno računanje integrala. Oceni, koliko izračunov funkcijske
vrednosti je potrebnih, za izračun približka za

```math
\int_{0}^{5}\frac{\sin x}{x}dx
```

 na 10 decimalk natančno.
