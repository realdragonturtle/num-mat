# Konvergenčna območja iteracijskih metod

Za reševanje nelinearnih enačb so najbolj pogosto uporablja iteracijske metode,
pri katerih približek za rešitev konstruiramo z rekurzivno formulo. Konstrukcija rekurzivnega zaporedja zagotavlja, da je limita zaporedja približkov vedno rešitev enačbe. Glavna težava je, če zaporedje sploh konvergira in h kateri rešitvi konvergira. To je v veliki meri odvisno od začetnega približka in lastnosti funkcije v okolici rešitve.

## Kompleksni koreni enote

Kot primer si poglejmo enačbo za kompleksne korene enote. Vemo, da ima enačba

```math
z^n = 1
```

$n$ kompleksnih rešitev, ki ležijo enakomerno razporejene na enotskem krogu.
Poglejmo si, kako konvergira Newtonova metoda, v odvisnosti od začetnega približka.

```@example
using NumMat
using Plots
n = 3
f(z) = z^(n)-1
df(z) = n*z^(n-1)
metoda((x, y); maxit=20, tol=1e-3) = newton(f, df, x + y*im; maxit=maxit, tol=tol)
meje = (-2, 2, -2, 2)
x, y, Z = konvergencno_obmocje(meje, metoda, n=500, m=500)
heatmap(x, y, Z', title="Konvergenca newtonove metode")
savefig("01_konvergenca.png")
```

![Konvergenca newtonove metode](01_konvergenca.png)

## Koda

```@index
Pages = ["01_konvergenca.md"]
```

```@autodocs
Modules = [NumMat]
Pages = ["nelinearne_enacbe.jl"]
Order   = [:function, :type]
```