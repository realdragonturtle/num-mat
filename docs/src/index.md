# Rešeni problemi iz numerične matematike

To je dokumentacija z gradivi za vaje in domače naloge pri predmetu [Numerična matematika](https://ucilnica.fri.uni-lj.si/1920/course/view.php?id=117).

Za praktično delo pri tem predmetu bomo uporabljali platformo GitLab, ki omogoča
vodenje projektov in sodelovanje. Preberite si več o načinu dela v [vodiču za sodelovanje](contributing.md) in 
[kako poteka delo v GitLab](workflow.md).

## Navodila za hiter začetek

Prenesite kodo na svoj računalnik z ukazom `git clone`

    git clone https://gitlab.com/nummat/nummat-1920.git

Programi so napisani v programskem jeziku [julia](https://julialang.org/). Za urejanje programov priporočamo uporabo urejevalnikov [Atom](https://atom.io/), [Visual Studio Code](https://code.visualstudio.com/) ali [emacs](https://www.gnu.org/software/emacs/), a vsak sodoben urejevalnik bi moral zadoščati. Za začetek poženite julia [REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop), v katerem lahko preiskusite programe in primere iz vaj

    cd nummat-1920
    julia --project=@.

V julia REPL naložimo [paket/knjižnico](https://docs.julialang.org/en/v1/stdlib/Pkg/) `Nummat` in pogledamo opis  [modula](https://docs.julialang.org/en/v1/manual/modules/) z [makro](https://docs.julialang.org/en/v1/manual/metaprogramming/#man-macros-1) ukazom `@doc`

```@repl
using NumMat
@doc NumMat
```

!!! tip "Posebnosti julia REPL"

    Julia REPL omogoča različne načine, v katerih je vnos različno interpretiran. V druge načine pridemo, če na začetku vnesemo enega od posebnih znakov `;`, `?` ali `]`:
    * če pritisnemo `;`, se vsi ukazi izvedejo v sistemski lupini
    * če pritisnemo `?` lahko iščemo po dokumentaciji za funkcije in tipe
    * če pritisnemo `]` lahko upravljamo s paketi

### Testi

Teste za cel projekt lahko poženemo z ukazom `Pkg.test()`:

```julia-repl
julia> import Pkg
julia> Pkg.test()
```

Če želimo pognati le teste v določeni datoteki, uporabimo funkcijo `include`

```julia-repl
include("../test/vaje/vaja03/laplace2D.jl")
```

### Dokumentacija

Dokumentacija je shranjena v mapi `docs/src/`. Za generiranje html strani z dokumentacijo uporabljamo [Documenter.jl](ttps://juliadocs.github.io/Documenter.jl). Najprej moramo pripraviti okolje za pripravo dokumentacije

```julia-repl
julia> import Pkg
julia> Pkg.activate("docs")
julia> Pkg.instantiate()
```

Html strani nato generiramo z ukazom

```julia-repl
julia> include("docs/make.jl")
```

Ko je dokumentacija izdelana, se jo najde v `docs/build/`.

## Program vaj

### Uvod

```@contents
Pages = ["vaje/1_uvod/01_koren.md", "vaje/1_uvod/02_pi.md"]
Depth = 1
```

### Linearni sistemi

```@contents
Pages = ["vaje/2_linearni_sistemi/02_tridiagonalni_sistemi.md",
    "vaje/2_linearni_sistemi/03_minimalne_ploskve.md",
    "vaje/2_linearni_sistemi/04_iteracijske_metode.md",
    "vaje/2_linearni_sistemi/05_implicitne_ploskve.md"]
Depth = 1
```

### Lastne vrednosti

```@contents
Pages = ["vaje/3_lastne_vrednosti/06_spektralno_grucenje.md",]
Depth = 1
```

### Nelinearne enačbe

```@contents
Pages = ["vaje/4_nelinearne_enacbe/09_razdalja.md",]
Depth = 1
```

### Interpolacija in aproksimacija

```@contents
Pages = ["vaje/5_interpolacija/07_zlepki.md",
         "vaje/5_interpolacija/08_chebfun.md",]
Depth = 1
```

### Integracija

```@contents
Pages = ["vaje/7_integral/10_quad.md",
         "vaje/7_integral/11_quadnD.m"]
Depth = 1
```

### Odvod

```@contents
Pages = ["vaje/8_odvod/12_autodiff.md",]
Depth = 1
```

### Diferencialne enačbe

```@contents
Pages = ["vaje/9_nde/13_lotka_volterra.md",
         "vaje/9_nde/14_perioda.md"]
Depth = 1
```

## Povezave

* [Algoritmi numerične matematike](http://matematika.fri.uni-lj.si/nm/alg/)
* [Predmet Numerična matematika](https://ucilnica.fri.uni-lj.si/course/view.php?id=117) na spletni učilnici