# Okolje za predmet Numerična Matematika

Da bomo lažje uskladili delo je na voljo [julia
projekt](https://docs.julialang.org/en/v1.0/stdlib/Pkg/#Creating-your-own-projects-1)
`vaje`. V tem projektu se zbirajo programi in primeri, ki jih delamo na vajah. Poleg tega datoteka `Projekt.toml` poskrbi, da se namestijo vse knjižnice, ki jih bomo na
vajah potrebovali. Paket aktiviramo z opcijo `--project=vaje` ukazu `julia`

    cd vaje-nummat
    julia --project=vaje

ali pa znotraj julie z ukazom `Pkg.activate("vaje")` oziroma `activate vaje` v
[načinu za
pakete](https://docs.julialang.org/en/v1.0/stdlib/Pkg/#Getting-Started-1), v
katerega pridete z vnosom `]` v julia [REPL](https://docs.julialang.org/en/v1.0/stdlib/REPL/)

```julia-repl
julia>]
(v1.0) >activate vaje
(vaje) >
```

## Inicializacija

V programu `julia` najprej naložimo vse potrebne pakete

```julia-repl
julia>]
(vaje) pkg>instantiate
```

Okolje lahko preiskusimo tako, da naložimo paket `NumMat`

```julia-repl
julia> using NumMat
julia>?NumMat
```

in poskusimo kaj narisati

```julia
using Plots
plot(sin, 0, pi)
```

## Paket Revise

Ko kodo razvijamo, moramo večkrat ponovno naložiti datoteko s kodo. Pogosto pa
tudi to ne zadošča in moramo julia REPL ponovno zagnati. Paket
[Revise.jl](https://timholy.github.io/Revise.jl/dev/) omogoča, da se koda
avtomatsko posodobi, ko se datoteka spremeni na disku. Najbolj preprosto lahko
uporabimo Revise, če ga naložimo, preden naložimo kodo

```julia-repl
julia> using Revise

julia> using NumMat
```

Če želimo naložiti le posamezno datoteko `include` uporabimo ukaz [`includet`](https://timholy.github.io/Revise.jl/dev/user_reference/#Revise.includet)

```julia-repl
julia> includet("src/vaje/1_uvod/koren.jl")
```

## Testi

Kodo lahko preiskusimo s testi

```julia-repl
julia> include("test/runtests.jl")
```

Lahko pa uporabimo `Pkg`:

```julia-repl
julia> ]
(v1.3) pkg> activate .
NumMat pkg> test
```