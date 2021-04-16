import Base: *, length, getindex, size
import LinearAlgebra: norm, diag, diagm, qr, Eigen

export Graf, LaplaceovaMatrika, inverzna_iteracija, graf_eps_okolice

struct Graf
  sosedi::Array{Array{Int, 1}, 1}
end

struct LaplaceovaMatrika
  graf::Graf
end

length(g::Graf) = length(g.sosedi)

function *(L::LaplaceovaMatrika, x::Vector)
  n = length(x)
  y = copy(x)
  for i=1:n
    y[i] = length(L.graf.sosedi[i])*x[i]
    y[i] -= sum(x[L.graf.sosedi[i]])
  end
  return y
end

function *(L::LaplaceovaMatrika, x::Matrix)
  n, m = size(x)
  y = copy(x)
  for i=1:n
    y[i,:] = length(L.graf.sosedi[i]).*x[i,:]
    y[i,:] -= sum(x[L.graf.sosedi[i],:], dims=1)'
  end
  return y
end

"""
    Matrix(L::LaplaceovaMatrika)

Izračuna laplaceovo matriko grafa `L::LaplaceovaMatrika` kot polno 
matriko.

# Primer

```julia-repl
julia> g = Graf([[2, 3], [1, 3], [1, 2]]);

julia> Matrix(LaplaceovaMatrika(g))
3×3 Array{Float64,2}:
  2.0  -1.0  -1.0
 -1.0   2.0  -1.0
 -1.0  -1.0   2.0

```

"""
function Matrix(L::LaplaceovaMatrika)
  n = length(L.graf)
  M = diagm(0 => ones(n))
  return L*M
end

size(L::LaplaceovaMatrika) = (length(L.graf), length(L.graf))

"""
    vrednosti, vektorji = inverzna_iteracija(A, k)
    
Poišče k najmanjših lastnih vrednosti z inverzno iteracijo.

# Primer
```jldoctest
julia> import LinearAlgebra.lu;

julia> F = lu([3 1 1; 1 3 1; 1 1 5]);

julia> inverzna_iteracija(F, 2)
Eigen{Float64,Float64,Array{Float64,2},Array{Float64,1}}
eigenvalues:
2-element Array{Float64,1}:
 3.000008583040198
 2.000000000140471
eigenvectors:
3×2 Array{Float64,2}:
 -0.577914   0.707108  
 -0.577914  -0.707105  
  0.576222   3.42474e-6

```
"""
function inverzna_iteracija(A, k::Int, resi = (A, b) -> A\b; maxit=1000, tol=1e-10)
  n, m = size(A)
  x0 = ones(n,k)
  x = copy(x0)
  eye = vcat(diagm(0=>ones(k)), zeros(n-k, k))
  lp = zeros(k)
  for i=1:maxit
    for i=1:k
      x[:,i] = resi(A, x0[:,i])
    end
    q, r = qr(x)
    x0 = q*eye
    ln = diag(r)
    if norm(ln -lp, Inf) < tol
      lp = ln
    break
    end
    lp = ln
  end
  return Eigen(1 ./ lp, x0) # Eigen je tip za spektralni razcep
end


struct TockaZIndeksom{T}
   tocka::T
   indeks::Int
end

length(t::TockaZIndeksom{T}) where {T} = length(t.tocka)
getindex(t::TockaZIndeksom{T}, i::Int) where {T} = t.tocka[i]

"""
    G = graf_eps_okolice(tocke, ε)

Poišče graf `G::Graf`, v katerem so povezane točke, ki so bližje kot ε.

# Primer

```jldoctest
julia> graf_eps_okolice([(0,0), (1,0), (1,1), (0,1)], 1.2)
Graf(Array{Int64,1}[[4, 2, 1], [3, 2, 1], [4, 3, 2], [4, 3, 1]])

```
"""
function graf_eps_okolice(tocke, ε)
  n = length(tocke)
  tocke_z_indeksom = [TockaZIndeksom(tocke[i], i) for i=1:n]
  drevo = kddrevo(tocke_z_indeksom)
  graf = Graf([])
  for i=1:n
    okolica = najdi_okolico(ε, drevo, tocke_z_indeksom[i], 
                              razdalja = (x, y) -> norm(x.tocka .- y.tocka))
    push!(graf.sosedi, [tocka.indeks for tocka in okolica])
  end
  return graf
end

function poln_razdaljni_graf(tocke, razdalja)
  n = length(tocke)
  G = zeros(n, n)
  for i=1:n, j=1:n
    G[i,j] = razdalja(tocke[i], tocke[j])
  end
  return G
end