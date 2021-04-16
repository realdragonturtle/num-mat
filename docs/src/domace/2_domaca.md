# 2. domača naloga

```@contents
Pages = ["2_domaca.md"]
Depth = 3
```

## Navodila

Izberite eno izmed spodnjih nalog. Po možnosti tako, ki je ni še nihče drug
izbral (preverite [zahtevke na Gitlabu](https://gitlab.com/nummat/nummat-1920/issues)).

!!! note

    Domačo nalogo lahko delate skupaj s kolegi, vendar morate v tem primeru
    rešiti toliko različnih nalog, kot je študentov v skupini.

### SOR iteracija za razpršene matrike

Naj bo *A n × n* diagonalno dominantna razpršena matrika(velika večina elementov
je ničelnih $a_{ij}=0$).

Definirajte nov podatkovni tip `RazprsenaMatrika`, ki matriko zaradi prostorskih
zahtev hrani v dveh matrikah $V$ in $I$, kjer sta $V$ in $I$ matriki $n \times
m$, tako da velja

```math
V(i,j)=A(i,I(i,j)).
```

V matriki $V$ se torej nahajajo neničelni elementi matrike $A$. Vsaka
vrstica matrike $V$ vsebuje ničelne elemente iz iste vrstice v $A$. V
matriki $I$ pa so shranjeni indeksi stolpcev teh neničelnih elementov.

Za podatkovni tip `RazprsenaMatrika` definirajte metode za naslednje funkcije:

- indeksiranje: `Base.getindex`,`Base.setindex!`,`Base.firstindex` in `Base.lastindex`
- množenje z desne `Base.*` z vektorjem

Več informacij o [tipih](https://docs.julialang.org/en/v1/manual/types/) in
[vmesnikih](https://docs.julialang.org/en/v1/manual/interfaces/).

Napišite funkcijo `x, it = sor(A, b, x0, omega, tol=1e-10)`, ki reši
tridiagonalni sistem $Ax=b$ z SOR iteracijo. Pri tem je `x0` začetni približek,
`tol` pogoj za ustavitev iteracije in `omega` parameter pri SOR iteraciji.
Iteracija naj se ustavi, ko je

```math
|A\mathbf{x}^{(k)}-\mathbf{b}|_\infty < nat.
```

Metodo uporabite za vožitev grafa v ravnino ali prostor [s fizikalno
metodo](https://en.wikipedia.org/wiki/Force-directed_graph_drawing). Če so
$(x_i, y_i, z_i)$ koordinate vozlišč grafa v prostoru, potem vsaka koordinata
posebej zadošča enačbam

```math
\begin{array}{lcl}
 -st(i)x_i + \sum_{j\in N(i)} x_j &=& 0,\\
 -st(i)y_i + \sum_{j\in N(i)} y_j &=& 0,\\
 -st(i)z_i + \sum_{j\in N(i)} z_j &=& 0,
 \end{array}
```

kjer je $st(i)$ stopnja $i$-tega vozlišča, $N(i)$ pa množica indeksov sosednjih vozlišč. Če nekatera vozlišča fiksiramo, bodo ostala zavzela ravnovesno lego med fiksiranimi vozlišči.

Za primere, ki jih boste opisali, poiščite optimalni `omega`, pri katerem SOR
najhitreje konvergira in predstavite odvisnost hitrosti konvergence od izbire
$\omega$.

### Metoda konjugiranih gradientov za razpršene matrike

Definirajte nov podatkovni tip `RazprsenaMatrika`, kot je opisano v prejšnji
nalogi.

Napišite funkcijo `[x,i]=conj_grad(A, b)`, ki reši sistem

```math
Ax=b,
```

z metodo konjugiranih gradientov za `A` tipa `RazprsenaMatrika`.

Metodo uporabite na primeru vložitve grafa v ravnino ali prostor s fizikalno
metodo, kot je opisano v prejšnji nalogi.

### Metoda konjugiranih gradientov s predpogojevanjem

Za pohitritev konvergence iterativnih metod, se velikokrat izvede t. i.
predpogojevanje(angl. preconditioning). Za simetrične pozitivno definitne
matrike je to pogosto nepopolni razcep Choleskega, pri katerem sledimo algoritmu
za razcep Choleskega, le da ničelne elemente pustimo pri miru.

Naj bo A $n\times n$ pozitivno definitna razpršena matrika(velika večina
elementov je ničelnih $a_{ij}=0$). Matriko zaradi prostorskih zahtev hranimo kot
*sparse* matriko. Poglejte si dokumentacijo za [razpršene
matrike](https://docs.julialang.org/en/v1/stdlib/SparseArrays/).

Napišite funkcijo `L = nep_chol(A)`, ki izračuna nepopolni razcep Choleskega za
matriko tipa `AbstractSparseMatrix`. Napišite še funkcijo `x, i = conj_grad(A,
b, L)`, ki reši linearni sistem

```math
Ax = b
```

s predpogojeno metodo konjugiranih gradientov za matriko $M = L^T L$ kot
predpogojevalcem. Pri tem pazite, da matrike $M$ ne izračunate, ampak uporabite
razcep $M = L^TL$. Za različne primere preverite, ali se izboljša hitrost
konvergence.

### QR razcep zgornje hessenbergove matrike

Naj bo $H$ $n\times n$ zgornje hessenbergova matrika (velja $a_{ij}=0$ za $j <
j-2i$). Definirajte podatkovni tip `ZgornjiHessenberg` za zgornje hessenbergovo
matriko.

Napišite funkcijo `Q, R = qr(H)`, ki izvede QR razcep matrike `H` tipa
`ZgornjiHessenberg` z Givensovimi rotacijami. Matrika `R` naj bo zgornje
trikotna matrika enakih dimenzij kot `H`, v `Q` pa naj bo matrika tipa `Givens`.

Podatkovni tip `Givens` definirajte sami tako, da hrani le zaporedje rotacij, ki
se med razcepom izvedejo in indekse vrstic, na katere te rotacije delujejo.
Posamezno rotacijo predstavite s parom

```math
[\cos(\alpha);\sin(\alpha)],
```

kjer je α kot rotacije na posameznem koraku. Za podatkovni tip definirajte še
množenje `Base.*` z vektorji in matrikami.

Uporabite QR razcep za QR iteracijo zgornje hesenbergove matrike. Napišite
funkcijo `lastne_vrednosti, lastni_vektorji = eigen(H)`, ki poišče lastne
vrednosti in lastne vektorje zgornje hessenbergove matrike.

Preverite časovno zahtevnost vaših funkcij in ju primerjajte z metodami `qr` in
`eigen` za navadne matrike.

### QR razcep simetrične tridiagonalne matrike

Naj bo $A$ $n × n$ simetrična tridiagonalna matrika (velja $a_{ij}=0$ za
$|i-j|>1$).

Definirajte podatkovni tip `SimetricnaTridiagonalna` za simetrično tridiagonalno
matriko, ki hrani glavno in stransko diagonalo matrike. Za tip
`SimetricnaTridiagonalna` definirajte metode za naslednje funkcije:

- indeksiranje: `Base.getindex`,`Base.setindex!`,`Base.firstindex` in `Base.lastindex`
- množenje z desne `Base.*` z vektorjem ali matriko

Časovna zahtevnost omenjenih funkcij naj bo linearna. Več informacij o
[tipih](https://docs.julialang.org/en/v1/manual/types/) in Napišite funkcijo `Q,
R = qr(T)`, ki izvede QR razcep matrike `T` tipa `Tridiagonalna` z Givensovimi
rotacijami. Matrika `R` naj bo zgornje trikotna dvodiagonalna matrika tipa
`ZgornjeDvodiagonalna`, v `Q` pa naj bo matrika tipa `Givens`.
[vmesnikih](https://docs.julialang.org/en/v1/manual/interfaces/).

Podatkovna tipa `ZgornjeDvodiagonalna` in `Givens` definirajte sami (glejte tudi
nalogo [QR razcep zgornje hessenbergove matrike](@ref)). Poleg tega
implementirajte množenje `Base.*` matrik tipa `Givens` in
`ZgornjeDvodiagonalna`.

Uporabite QR razcep za QR iteracijo simetrične tridiagonalne matrike. Napišite
funkcijo `lastne_vrednosti, lastni_vektorji = eigen(T)`, ki poišče lastne
vrednosti in lastne vektorje simetrične tridiagonalne matrike.

Preverite časovno zahtevnost vaših funkcij in ju primerjajte z metodami `qr` in
`eigen` za navadne matrike.

### Inverzna potenčna metoda za zgornje hessenbergovo matriko

Lastne vektorje matrike $A$ lahko računamo z **inverzno potenčno
metodo**. Naj bo $A_\lambda = A-\lambda I$. Če je $\lambda$ približek za
lastno vrednost, potem zaporedje vektorjev

```math
x^{(n+1)}=\frac{A_\lambda^{-1}x^{(n)}}{|A_\lambda^{-1}x^{(n)}|},
```

konvergira k lastnemu vektorju za lastno vrednost, ki je po absolutni vrednosti
najbližje vrednosti $\lambda$.

Da bi zmanjšali število operacij na eni iteraciji, lahko poljubno matriko $A$
prevedemo v zgornje hessenbergovo obliko (velja $a_{ij} = 0$ za $j < i - 2$). S
hausholderjevimi zrcaljenji lahko poiščemo zgornje hesenbergovo matriko H, ki je
podobna matriki A:

```math
H=Q^T A Q.
```

Če je $v$ lastni vektor matrike $H$, je $Qv$ lastni vektor
matrike $A$, lastne vrednosti matrik $H$ in $A$ pa so enake.

Napišite funkcijo `H, Q = hessenberg(A)`, ki s Hausholderjevimi zrcaljenji
poišče zgornje hesenbergovo matriko `H` tipa `ZgornjiHessenberg`, ki je podobna
matriki `A`.

Tip `ZgornjiHessenberg` definirajte sami, kot je opisano v nalogi o QR razcepu
zgornje hessenbergove matrike. Poleg tega implementirajte metodo `L, U = lu(A)`
za matrike tipa `ZgornjiHessenberg`, ki bo pri razcepu upoštevala lastnosti
zgornje hessenbergovih matrik. Matrika `L` naj ne bo polna, ampak tipa
`SpodnjaTridiagonalna`. Tip `SpodnjaTridiagonalna` definirajte sami, tako da bo
hranil le neničelne elemente in za ta tip matrike definirajte operator `Base.\`,
tako da bo upošteval strukturo matrikw `L`.

Napišite funkcijo `lambda, vektor = inv_lastni(A, l)`, ki najprej naredi
hessenbergov razcep in nato izračuna lastni vektor in točno lastno matrike `A`,
kjer je `l` približek za lastno vrednost. Inverza matrike `A` nikar ne
računajte, ampak raje uporabite LU razcep in na vsakem koraku rešite sistem
$L(Ux^{n+1})=x^n$.

Metodo preskusite za izračun ničel polinoma. Polinomu

```math
x^n + a_{n-1}x^{n-2} + ... a_1x + a_0
```

lahko priredimo matriko

```math
\begin{bmatrix}
0 &0&\ldots&0&-a_0\\
1&0&\ldots&0&-a_1\\
0&1&\ldots&0&-a_2\\
\vdots &\vdots& \ddots& \vdots&\vdots\\
0 & 0& \ldots &1&-a_{n-1}
\end{bmatrix},
```

katere lastne vrednosti se ujemajo z ničlami polinoma.

### Inverzna potenčna metoda za tridiagonalno matriko

Lastne vektorje matrike $A$ lahko računamo z **inverzno potenčno
metodo**. Naj bo $A_\lambda = A-\lambda I$. Če je $\lambda$ približek za
lastno vrednost, potem zaporedje vektorjev

```math
x^{(n+1)}=\frac{A_\lambda^{-1}x^{(n)}}{|A_\lambda^{-1}x^{(n)}|},
```

konvergira k lastnemu vektorju za lastno vrednost, ki je po absolutni
vrednosti najbližje vrednosti $\lambda$.

Naj bo $A$ **simetrična matrika**. Da bi zmanjšali število operacij na eni iteraciji, lahko poljubno
simetrično matriko $A$ prevedemo v tridiagonalno obliko. S hausholderjevimi zrcaljenji lahko poiščemo tridiagonalno matriko T, ki je podobna matriki A:

```math
T=Q^T A Q.
```

Če je $v$ lastni vektor matrike $T$, je $Qv$ lastni vektor
matrike $A$, lastne vrednosti matrik $T$ in $A$ pa so enake.

Napišite funkcijo `T, Q = tridiag(A)`, ki s Hausholderjevimi
zrcaljenji poišče tridiagonalno matriko `H` tipa `Tridiagonalna`, ki je podobna matriki `A`.

Tip `Tridiagonalna` definirajte sami, kot je opisano v nalogi o QR razcepu
tridiagonalne matrike. Poleg tega implementirajte metodo `L, U = lu(A)` za
matrike tipa `Tridiagonalna`, ki bo pri razcepu upoštevala lastnosti
tridiagonalnih matrik. Matrike `L` in `U` naj ne bodo polne matrike. Matrika `L`
naj bo tipa `SpodnjaTridiagonalna`, matrika `U` pa tipa `ZgornjaTridiagonalna`.
Tipa `SpodnjaTridiagonalna` in `ZgornjaTridiagonalna` definirajte sami, tako da
bosta hranila le neničelne elemente. Za oba tipa definirajte operator `Base.\`,
tako da bo upošteval strukturo matrik.

Napišite funkcijo `lambda, vektor = inv_lastni(A, l)`, ki najprej naredi hessenbergov razcep in nato izračuna lastni vektor in točno lastno matrike `A`, kjer je `l` približek za lastno
vrednost. Inverza matrike `A` nikar ne računajte, ampak raje uporabite
LU razcep in na vsakem koraku rešite sistem $L(Ux^{n+1})=x^n$.

Metodo preskusite na laplaceovi matriki, ki ima vse elemente $0$ razen
$l_{ii}=-2, l_{i+1,j}=l_{i,j+1}=1$.
Poiščite nekaj lastnih vektorjev
za najmanjše lastne vrednosti in jih vizualizirajte z ukazom `plot`.

Lastni vektorji laplaceove matrike so približki za rešitev robnega problema za diferencialno enačbo

```math
y''(x) = \lambda^2 y(x),
```

katere rešitve sta funkciji $\sin(\lambda x)$ in $\cos(\lambda x)$.

### Naravni zlepek

Danih je $n$ interpolacijskih točk $(x_i,f_i)$, $i=1,2,...,n$.
**Naravni interpolacijski kubični zlepek** $S$ je funkcija, ki
izpolnjuje naslednje pogoje:

1. $S(x_i)=f_i, \quad i=1,2,...,n.$
2. $S$ je polinom stopnje $3$ ali manj na vsakem podintervalu $[x_i,x_{i+1}]$,
   $i=1,2,...,n-1$.
3. $S$ je dvakrat zvezno odvedljiva funkcija na interpolacijskem intervalu
   $[x_1,x_n]$
4. $S^{\prime\prime}(x_1)=S^{\prime\prime}(x_n)=0$.

Zlepek $S$ določimo tako, da postavimo

```math
S(x)=S_i(x)=a_i+b_i\,(x-x_i)+c_i\,(x-x_i)^2+d_i\,(x-x_i)^3, \quad
  x\in[x_i,x_{i+1}],
```

nato pa izpolnimo zahtevane pogoje [^2].

Napišite funkcijo `Z = interpoliraj(x, y)`, ki izračuna koeficient polinoma $S_i$ in vrne element tipa `Zlepek`.

Tip `Zlepek` definirajte sami in naj vsebuje koeficiente polinoma in interpolacijske točke. Za tip `Zlepek` napišite dve funkciji

- `y = vrednost(Z, x)`, ki vrne vrednost zlepka v dani točki `x`.
- `plot(Z)`, ki nariše graf zlepka, tako da različne odseke izmenično nariše z rdečo in modro barvo(uporabi paket `Plots`).

[^2]: pomagajte si z: Bronštejn, Semendjajev, Musiol, Mühlig:
    **Matematični priročnik**, Tehniška založba Slovenije, 1997, str.
    754 ali pa J. Petrišič: **Interpolacija**, Univerza v Ljubljani,
    Fakulteta za strojništvo, Ljubljana, 1999, str. 47

### QR iteracija z enojnim premikom

Naj bo $A$ simetrična matrika. Napišite funkcijo, ki poišče lastne vektorje in vrednosti simetrične matrike z naslednjim algoritmom

- Izvedi Hessenbergov razcep matrike $A=U^T T U$ (uporabite lahko vgrajeno funkcijo `LinearAlgebra.hessenberg`)
- Za tridiagonalno matriko $T$ ponavljaj, dokler ni $h_{n-1,n}$ dovolj majhen:
  - za $T - \mu I$ za $\mu = h_{n,n}$ izvedi QR razcep
  - nov približek je enak $RQ + \mu I$
- Postopek ponovi za podmatriko brez zadnjega stolpca in vrstice

Napiši metodo `lastne_vrednosti, lastni_vektorji = eigen(A, EnojniPremik(), vektorji = false)`, ki vrne

- vektor lastnih vrednosti simetrične matrike `A`, če je vrednost `vektorji` enaka `false`.
- vektor lastnih vrednosti `lambda` in matriko s pripadajočimi lastnimi
   vektorji `V`, če je `vektorji` enaka `true`

Pazi na časovno in prostorsko zahtevnost algoritma. QR razcep tridiagonalne
matrike izvedi z Givensovimi rotacijami in hrani le elemente, ki so nujno
potrebni (glej nalogo [QR razcep simetrične tridiagonalne matrike](@ref)).

Funkcijo preiskusi na Laplaceovi matriki grafa podobnosti (glej [vajo o
spektralnem gručenju](../vaje/3_lastne_vrednosti/06_spektralno_grucenje.md)).