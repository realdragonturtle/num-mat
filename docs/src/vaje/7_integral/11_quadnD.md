# Večrazsežni integrali

```@meta
CurrentModule = NumMat
DocTestSetup  = quote
    using NumMat
end
```

V poglavju o enojnih integralis smo spoznali, da je večina kvadraturnih formul preprosta utežena vsota

```math
\int_a^b f(x)dx \approx \sum w_k f(x_k), 
```

kjer so uteži $w_k$ in vozlišča $x_k$ izbrana tako, da je formula točna za polinome čim višjega reda.

Pri večkratnih integralih se stvari nekoliko zakomplicirajo, a v bistvu ostanejo enake. Kvadrature so 
tudi za večkratne integrale večinoma navadne utežene vsote vrednosti v izbranih točkah na območju. 

## Dvojni integral in integral integrala

Oglejmo si najbolj enostaven primer, ko integriramo funkcijo na kocki $[a,b]^2$. 
Dvojni integral lahko zapišemo kot dva gnezdena enojna integrala [^1]

```math
\int\int_{[a,b]^2} f(x,y)dxdy = \int_a^b\left(\int_a^b f(x,y)dy\right)dx = \int_a^b\left(\int_a^b f(x,y)dx\right)dy 
```

Najbolj enostavno je izpeljati kvadrature za večkratni integral, če za vsak od gnezdenih enojnih integralov 
uporabimo isto kvadraturno formulo

```math
\begin{equation}\label{eq:quad}
\int_a^b f(x) dx \approx \sum_{k=1}^n w_k f(x_k)
\end{equation}
```
z danimi utežmi $w_1, w_2, \ldots w_n$ in vozlišči $x_1, x_2, \ldots x_n$. Če za zunanji integral uporabimo kvadrature \eqref{eq:quad}, dobimo

```math
\int\int_{[a,b]^2} f(x,y)dxdy = \int_a^b\left(\int_a^b f(x,y)dy\right)dx = \sum w_i Fy(x_i),
```

kjer je funkcija $Fy(x)$ enaka integralu po $y$, za katero lahko zopet uporabimo kvadrature \eqref{eq:quad}


```math
Fy(x) = \int_a^b f(x,y) dy \approx \sum w_j f(x, y_j)
```

Dvojni integral lahko tako približno izračunamo kot dvojno vsoto 

```math
\begin{equation}\label{eq:quad2d}
\int\int_{[a,b]^2} f(x,y)dxdy \approx \sum_{i,j} w_i w_j f(x_i, y_j).
\end{equation}
```
Kvadraturni formuli, ki jo dobimo na ta način, pravimo *produktna formula*. 

!!! note "Produktne formule trpijo za prekletstvom dimenzionalnosti"

    Število vozlišč, ki jih dobimo, ko uporabimo produktno formulo, narašča eksponentno z dimenzijo prostora, na katerem integriramo. Zato produktne kvadrature postanejo hitro (že v dimenzijah nad 6, 7) časovno tako zahtevne, da celo slabše konvergirajo kot metoda [Monte Carlo](https://en.wikipedia.org/wiki/Monte_Carlo_integration). 
    Ta pojav, da s povečevanjem dimenzij, zahtevnost problemov exponentno narašča imenujemo [prekletstvo dimenznionalnosti](https://en.wikipedia.org/wiki/Curse_of_dimensionality) in se pojavi tudi na drugih področjih.

!!! tip "Razpršene mreže omilijo prekletsvo dimenzionalnosti"

    Z dimenzijo narašča delež volumna, ki je „na robu“. Oglejmo si $d-$dimenzionalno enotsko kocko $[-1,1]^d$. Če interval $[-1,1]$  razdelimo 
    na točke v notranjosti $[-\frac{1}{2}, \frac{1}{2}]$ in točke na robu $[-1,1]-[-\frac{1}{2}, \frac{1}{2}]$, sta v eni dimenziji oba dela enako dolga.
    V višjih dimenzijah pa delež točk v kocki, ki so na robu v primerjavi s točkami v notranjosti narašča.
    Delež točk v notranjosti lahko preprosto izračunamo:
    ```math
    P\left(\left[-\frac{1}{2},\frac{1}{2}\right]^d\right) = \frac{1}{2^d}
    ```
    in pada eksponentno z dimenzijo. Zato je smiselno na robu uporabiti bolj gosto mrežo kot v notranjosti. Tako je matematik Sergey A. Smolyak razvil [razpršene mreže](https://en.wikipedia.org/wiki/Sparse_grid), ki izkoriščajo to idejo in delno omilijo prekletstvo dimenzionalnosti.
 
[^1]:  Več o tem, kdaj je mogoče večkratni integral zamenjati z gnezdenimi enojnimi integrali pove [Fubinijev izrek](https://en.wikipedia.org/wiki/Fubini's_theorem). 

### Dodatna naloga

Izpelji formulo za ostanek pri izračunu dvojnega integrala na kvadratu
$[a,b]^2$, če za kvadraturo \eqref{eq:quad} uporabiš sestavljeno Simpsonovo
pravilo

```math
\int_a^b f(x) dx \approx \frac{h}{3} \sum_{i=0}^{n-1} \left(f(x_{2i}) + 4f(x_{2i+1}) + f(x_{2i+2})\right) + R_f,
```
kjer je $h=\frac{b-a}{2n}$, vozlišča $x_i = a +ih$ in ostanek je enak

```math
R_f = -\frac{h^4}{180}(b-a)f^{(4)}(\xi),
```

za nek $\xi\in (a,b)$.

## Povprečna razdalja med točkama na kvadratu $[0,1]^2$

### Naloga

Izračunaj povprečno razdaljo med dvema točkama na kvadratu $[0,1]\times[0,1]$. Primerjaj različne metode.

### Rešitev 
Povprečna razdaljo lahko izračunamo s štirikratnem integralom

```math
\bar{d} = \int_{[0,1]^4} \sqrt{(x_1-x_2)^2 + (y_1-y_2)^2} dx_1 dx_2 dy_1 dy_2.
```

Za izračun bom uporabili produktno kvadraturo s sestavljeno Simpsonovo formulo in metodo Monte Carlo.

```@example razdalja
using NumMat, LinearAlgebra
## povprečna razdalja med točkama v kocki [0,1]^2
f(x) = norm(x[1:2]-x[3:4]); # razdalja
x0 = LinRange(0, 1, 7); w = (x0[2]-x0[1])/3*[1 4 2 4 2 4 1];
I = ndquad(f, x0, w, 4)
```

Poskusimo še z metodo Monte Carlo, kjer vozlišča izberemo slučajno enakomerno na izbranem območju.

```@example razdalja
function mcquad(fun, n, dim)
    Ef = 0
    for i=1:n
      Ef += fun(rand(dim))
    end
    return Ef/n
end
mcquad(f, 100000, 6)
```

### Primerjava različnih metod

#### Produktna kvadratura s sestavljeno Simpsonovo formulo

Poglejmo si, kako je s hitrostjo konvergence pri produktnih kvadraturah.

```@example razdalja
using Plots, Random
Random.seed!(1234)
ndquad_simpson(f, n, dim) = ndquad(f, LinRange(0, 1, 2n+1), 
                            1/(6n)*vcat([1], repeat([4,2], n-1), [4, 1]), dim)
dim = 4
I = ndquad_simpson(f, 20, dim)
n = 3:15
napake_s = []
napake_mc = []
for nk in n
    push!(napake_s, ndquad_simpson(f, nk, dim) - I)
    push!(napake_mc, mcquad(f, (2nk+1)^4, dim) - I)
end
scatter((2n.+1).^4, abs.(napake_s), scale=:log10, label="simpson")
scatter!((2n.+1).^4, abs.(napake_mc), scale=:log10, label="Monte Carlo", title="Napake v odvisnosti od števila izračunov")
```
Z zbranimi podatki lahko določimo približni red simpsonove produktne metode za 4 kratne integrale

```@example razdalja
konst, red = hcat(ones(size(n)), log.((2n.+1).^4))\log.(abs.(napake_s)) 
println("Napaka produktne simpsonove formule pada z n^(", red, "), kjer je n število izračunov funkcijske vrednosti.")
```
Podobno lahko vsaj približno ocenimo hitrost konvergence za metodo Monte Carlo. Pri čemer se moramo zavedati, da je 
vrednost in tudi napaka odvisna od zaporedja slučajnih vozlišč, zato je ocena zgolj okvirna:

```@example razdalja
konst, red = hcat(ones(size(n)), log.((2n.+1).^4))\log.(abs.(napake_mc))
println("Napaka pri Monte Carlo pada približno z n^(", red, ") za izbrane vzorce.")
```

!!! note "Centralni limitni izrek in konvergenca Monte Carlo"

    Konvergenco metode Monte Carlo(MC) je posledica [centralnega limitnega izreka](https://en.wikipedia.org/wiki/Central_limit_theorem), ki pove, 
    da je vzorčno povprečje $\bar{x} = \frac{1}{n}\sum_{i=1}^n x_i$, s katerim ocenimo integral pri metodi MC, porazdeljen približno normalno
    ```math
    \bar{x}\sim N(\mu, \sigma) = N(\mu_0, \frac{\sigma_0}{\sqrt{n}}),
    ```
    kjer je $\mu_0=E(X)$ povprečje in $\sigma_0 = \sigma(X)$ standardni odklon porazdelitve, ki jo vzorčimo.
    Standardni odklon porazdelitve vzorčnih povprečij torej pada s korenom velikosti vzorca $\sqrt{n}$, s tem pa tudi širina porazdelitve 
    za $\bar{x}$ in natančnost izračuna z metodo MC. 

## Koda

```@index
Pages = ["11_quadnD.md"]
```

```@docs
ndquad
```