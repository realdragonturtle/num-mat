# Aproksimacija s polinomi Čebiševa

[Weierstrassov izrek](https://en.wikipedia.org/wiki/Stone%E2%80%93Weierstrass_theorem#Weierstrass_approximation_theorem) 
pravi, da lahko poljubno zvezno funkcijo na končnem
intervalu enakomerno na vsem intervalu aproksimiramo s polinomi. Polinom
dane stopnje, ki neko funkcijo najbolje aproksimira je težko poiskati. Z
razvojem funkcije po ortogonalnih polinomih Čebiševa, pa se optimalni
aproksimaciji zelo približamo. Naj bo $f:[-1,1]\to \mathbb{R}$ zvezna
funkcija. Potem lahko $f$ zapišemo z neskončno vrsto

$$f(t)=\sum_{n=0}^\infty a_nT_n(t),$$

kjer so $T_n$ polinomi Čebiševa. Polinomi Čebiševa so definirani z
relacijo

$$T_n(\cos(\phi))=\cos(n\phi)$$

in zadoščajo dvočlenski rekurzivni enačbi

$$T_{n+1}(x)=2xT_n(x)-T_{n-1}(x).$$

Namesto cele vrste, lahko obdržimo le prvih nekaj členov in funkcijo
**aproksimiramo** s funkcijo oblike

$$f(x)\sim \sum_{n=0}^N a_nT_n(x).$$

Iščemo torej koeficiente funkcije $f(x)$ v razvoju po $T_n$.

```math
\begin{equation}
a_k = \frac{2}{\pi}\int_{-1}^1 \frac{f(x) T_k(x)}{\sqrt{1-x^2}}dx,
\end{equation}
```

kjer za $k=0$ faktor $\frac{2}{\pi}$ zamenjamo z $\frac{1}{\pi}$. Koeficiente lahko približno izračunamo z [gaussovimi kvadraturnimi formulami](https://en.wikipedia.org/wiki/Gaussian_quadrature).

!!! note "Koeficiente Čebiševe vrste natančneje računamo s FFT"

    Na vajah bomo koeficiente $a_n$ računali približno z gaussovimi kvadraturnimi formulami. V praksi je mogoče koeficiente $a_k$ izračunati bolj natančno z
    diskretno Fourierovo kosinusno transformacijo funkcijskih vrednosti v
    Čebiševih interpolacijskih točkah.

## Primer

Uporabimo Čebiševo vrsto za implementacijo funkcije $\arctan(x)$. Definicijsko območje so vsa realna števila, zato si pomagamo z enakostjo

```math
\arctan(x)+\arctan\left(\frac{1}{x}\right)=
        \begin{cases}\frac{\pi}{2}; x>0\cr 
                     -\frac{\pi}{2}; x < 0
        \end{cases}
```
tako da lahko funkcijo računamo le na intervalu $[-1,1]$.

```@example atan
using NumMat, Plots
catan = chebfun(atan, -1, 1)
println("Stopnja aproksimacijskega polinoma: ", stopnja(catan))
plot(x->catan(x)-atan(x), -1, 1, title="Napaka aproksimacije funkcije arkus tangens.")
```

## Povezave

* [Knjižnica \`chebfun\`](http://www.chebfun.org/)
* [THE AUTOMATIC SOLUTION OF PARTIAL DIFFERENTIAL EQUATIONS USING A GLOBAL SPECTRAL METHOD](http://arxiv.org/pdf/1409.2789v2.pdf)
* [Trefetnova knjiga](http://www.chebfun.org/ATAP/)

## Koda

```@index
Pages = ["08_chebfun.md"]
```

```@autodocs
Modules = [NumMat]
Pages = ["cheb.jl"]
Order   = [:function, :type]
```