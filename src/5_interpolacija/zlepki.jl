using RecipesBase
import Base.length
import Base.convert
import LinearAlgebra.diag

export Zlepek, NewtonovPolinom, deljene_diference, polyval, polyder, lagrangev_zlepek, hermitov_zlepek

"""
    NewtonovPolinom{T}(a::Vector{T}, x::Vector{T})

Vrne [newtonov interpolacijski polinom](https://en.wikipedia.org/wiki/Newton_polynomial)
oblike `a[1]+a[2](x-x[1])+a[3](x-x[1])(x-x[2])+...`
s koeficienti `a` in vozlišči `x`.

# Primer

Poglejmo si polinom ``1+x+x(x-1)``, ki je definiran s koeficienti `[1,1,1]` in z vozlišči 
``x_0=0`` in ``x_1=1``

```jldoctest
julia> p = NewtonovPolinom([1, 1, 1], [0, 1])
NewtonovPolinom{Int64}([1, 1, 1], [0, 1])

julia> p.([1,2,3])
3-element Array{Int64,1}:
  2
  5
 10
```
"""
struct NewtonovPolinom{T}
  koef::Vector{T}
  tocke::Vector{T}
end

NewtonovPolinom(koef, tocke) = NewtonovPolinom(promote(koef, tocke)...)

"""
    polyval(p::NewtonovPolinom, x)

Izračuna vrednot newtonovega polinoma `p` v `x` s Hornerjevo methodo. Objekte tipe `NewtonovPolinom` 
lahko kličemo kot funkcijo, ki pokliče to funkcijo.

# Primer

```jldoctest
julia> p = NewtonovPolinom([0, 0, 1], [0, 1]);

julia> polyval(p, 2)
2

julia> p(2)
2
```
"""
function polyval(p::NewtonovPolinom, x)
  n = length(p.koef)
  y = p.koef[n]
  for i = n-1:-1:1
	  y = y*(x - p.tocke[i]) + p.koef[i]
  end
  return y
end

# 
(p::NewtonovPolinom)(x) = polyval(p, x)
convert(::Type{NewtonovPolinom{T}}, p::NewtonovPolinom) where {T} = 
          NewtonovPolinom(convert(Vector{T},p.koef), convert(Vector{T}, p.tocke)) 

"""
    dy = polyder(p::NewtonovPolinom, x)

Izračuna vrednost odvoda newtonovega polinoma `p` v točki `x` s hornerjevim algoritmom, 
ki je dopolnjen tako, da računa tudi odvod. 

# Primer

Vzemimo primer polinoma ``1+x^2=1-x+x(x+1)``, katerega odvod je ``2x``

```jldoctest
julia> p = NewtonovPolinom([1,-1,1], [0,-1]);

julia> odvodp(x) = polyder(p, x); odvodp.((1, 2, 3))
(2, 4, 6)
```
"""
function polyder(p::NewtonovPolinom, x)
  n = length(p.koef)
  y = p.koef[n]
  dy = 0
  for i = n-1:-1:1
    dy = dy*(x - p.tocke[i]) + y
    y = y*(x - p.tocke[i]) + p.koef[i]
  end
  return dy
end

"""
    p::NewtonovPolinom{T} = deljene_diference(x::Array{T}, f::Array{U})

Izračuna koeficiente Newtonovega interpolacijskega polinoma, ki interpolira
podatke `y(x[k])=f[k]`. Če se katere vrednosti `x` večkrat ponovijo, potem
metoda predvideva, da so v `f` poleg vrednosti, podani tudi odvodi.

# Primer

Polinom ``x^2-1`` interpolira podatke `x=[0,1,2]` in `y=[-1, 0, 3]` lahko v
Newtonovi obliki zapišemo kot ``1 + x + x(x-1)``

```jldoctest
julia> p = deljene_diference([0, 1, 2], [-1, 0, 3])
NewtonovPolinom{Float64,Int64}([-1.0, 1.0, 1.0], [0, 1])
```

Če imamo več istih vrednosti abscise `x`, moramo v `f` podati vrednosti funkcije
in odvodov. Na primer polinom ``p(x) = x^4 = x + 3x(x-1) + 3x(x-1)^2 + x(x-1)^3``
ima v ``x=1`` vrednosti ``p(1)=1, p'(1)=4, p''(1)=12``

```jldoctest
julia> p = deljene_diference([0,1,1,1,2], [0,1,4,12,16])
NewtonovPolinom{Float64,Int64}([0.0, 1.0, 3.0, 3.0, 1.0], [0, 1, 1, 1])

julia> x = (1,2,3,4,5); p.(x).-x.^4
(0.0, 0.0, 0.0, 0.0, 0.0)
```
""" 
function deljene_diference(x::Array{T},
f::Array{U}) where {T, U}
  n = length(x) - 1
  m = length(f) - 1
  @assert n == m
  a = zeros(n+1, n+1)
  a[:,1] = f;
  fakulteta = 1
  for j = 2:n+1
    fakulteta *= j-1
    for i = j:n+1
      if x[i] != x[i-j+1]
	      a[i,j] = (a[i,j-1] - a[i-1,j-1])/(x[i] - x[i-j+1]);
      else
        a[i,j] = a[i,j-1]/fakulteta
        a[i,j-1] = a[i-1,j-1]
      end
   	end
  end
  return NewtonovPolinom(diag(a), x[1:end-1])
end

"""
    Zlepek(funkcije::Vector{F}, vozlisca::Vector{T})

Vrednost tipa `Zlepek` predstavlja funkcijo podano kot zlepek različnih predpisov na
različnih intervalih

```math
f(x) = \\begin{cases}
f_1(x); x\\in [x_1, x_2]\\cr
f_2(x); x\\in (x_2, x_3]\\cr
\\vdots
\\end{cases}
```

Krajišča intervalov so podana v seznamu `vozlisca`, medtem ko so predpisi zbrani 
v seznamu `funkcije`.

# Primer

```jldoctest
julia> z = Zlepek([x->x, x->2-x], [0, 1, 2]);

julia> z(0.5), z(1.5)
(0.5, 0.5)

```
""" 
struct Zlepek{F, T}
  funkcije::Vector{F}
  vozlisca::Vector{T}
end

length(z::Zlepek) = length(z.funkcije)
"""
    findinterval(x, endpoints)

Poišči index intervala na katerem leži x.
"""
function findinterval(endpoints, x)
  n = length(endpoints)
  a, b = 0, (n + 1)
  c = a + (b - a) ÷ 2
  while (b-a) > 1
   if endpoints[c] > x
     b = c
   elseif endpoints[c] < x
    a = c
   else
    return c
   end
   c = a + (b - a) ÷ 2
   println(a, b, c)
  end
  return c
end

function (z::Zlepek)(x)
  k = findinterval(z.vozlisca, x)
  if k > length(z) || k < 1
    error("Vrednost $x ni v definicijskem območju zlepka z vozlišči $(z.vozlisca)")
  end
  return z.funkcije[k](x)
end
  
"""
    lagrangev_zlepek(x,f)

Izračuna koeficiente kubičnega ``C^1`` zlepka, ki interpolira podatke
``p_i(x_{2i-1})=f_{2i-1}, p_i(x_{2i})=f_{2i}`` in ``p_i(x_{2i+1})=f_{2i+1}``,
poleg tega pa je zvezno odvedljiv. Dodatna lasntost zlepka je ``p_1''(x_1) =
0``. 

# Primer

```jldoctest 
julia> z = lagrangev_zlepek([1, 2, 3, 4, 5], [0, 1, 2, 1, 0]);

julia> z.(1:5) - [0, 1, 2, 1, 0]
5-element Array{Float64,1}:
 0.0
 0.0
 0.0
 0.0
 0.0
```
"""
function lagrangev_zlepek(x, f)
  n = length(x)
  m = length(f)
  @assert n == m
  @assert n%2 == 1
  A = [1 0 0 0;
       1 (x[2]-x[1]) 0 0;
       1 (x[3]-x[1]) (x[3]-x[1])*(x[3]-x[2]) 0;
       0 0 2 4x[1]-2x[2]-2x[3]]
  np = NewtonovPolinom(A\vcat(f[1:3], 0), x[1:3])
  funkcije =[np]
  for k=3:2:n-2
    dp = polyder(np, x[k])
    np = deljene_diference(vcat(x[k],x[k:k+2]),[f[k], dp, f[k+1], f[k+2]])
    push!(funkcije, np)
  end
  return Zlepek(funkcije, x[1:2:end])
end

"""
    z::Zlepek = hermitov_zlepek(x, f, df)

Izračuna koeficiente kubičnega C^1 zlepka, ki interpolira podatke
``p_i(x_i) = f_i, p_i(x_{i+1}) = f_{i+1}`` in ``p_i'(x_i) = df_i, p_i'(x_{i+1})=df_{i+1}``. 

# Primer

```jldoctest 
julia> z = hermitov_zlepek([1, 2, 3], [0, 1, 0], [0, 0, 0]);

julia> z.(1:3) - [0, 1, 0]
3-element Array{Float64,1}:
 0.0
 0.0
 0.0

 julia> polyder(z.funkcije[1], 1)
 0
```
"""
function hermitov_zlepek(x::Array{T}, f::Array{T}, df::Array{T}) where {T}
  n, m, k = length(x), length(f), length(df)
  @assert n==m && m==k
  funkcije = []
  for i=1:n-1
    np = deljene_diference(x[[i, i, i+1, i+1]], [f[i], df[i], f[i+1], df[i+1]])
    push!(funkcije, np)
  end
  return Zlepek(funkcije, x)
end

"""
Recept za risanje grafa zlepka
"""
@recipe function plot(z::Zlepek; points=100, colors=[:red :blue])
  color --> colors, :force
  legend --> :none
  n = length(z)
  x = LinRange(0, 1, points)
  seriestype := :path
  for i=1:n
    @series begin
      a, b = z.vozlisca[i:i+1]
      x = LinRange(a, b, points)
      x, z.funkcije[i].(x)
    end
  end
end

"""
Recept za risanje Newtonovega polinoma
"""
@recipe plot(::Type{NewtonovPolinom{T}}, p::NewtonovPolinom{T}) where {T} = x->p(x)