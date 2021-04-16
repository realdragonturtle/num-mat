import LinearAlgebra.norm
import Base.*

export korak_sor, iteracija, conjgrad

"""
    *(L::LaplaceovOperator{2}, X::Matrix)

množi matriko `X` z matriko za laplaceov operator.

# Primer

```jldoctest
julia> L = LaplaceovOperator{2}();

julia> L*[1 2 3 4; 5 0 1 6; 7 8 9 10]
3×4 Array{Int64,2}:
 1   2  3   4
 5  -1  4   6
 7   8  9  10
```
"""
function *(L::LaplaceovOperator{2}, x::Matrix)
  n, m = size(x)
  y = copy(x)
  x = copy(x)
  x[1,:] .= 0; x[end, :] .= 0;
  x[:, 1] .= 0; x[:, end] .= 0;
  for i=2:n-1, j=2:m-1
    y[i,j] = -(x[i-1, j] + x[i, j-1] - 4*x[i, j] + x[i+1, j] + x[i, j+1])
  end
  return y
end
"""
    b = desne_strani(L::LaplaceovOperator{2}, U::Matrix)

Izračuna matriko desnih strani za Laplaceovo enačbo v 2D iz začetnih pogojev.
"""
function desne_strani(L::LaplaceovOperator{2}, U::Matrix)
  b = copy(U)
  b[2,2:end-1] .+= U[1, 2:end-1]
  b[2:end-1,2] .+= U[2:end-1, 1]
  b[end-1,2:end-1] .+= U[end, 2:end-1]
  b[2:end-1, end-1] .+= U[2:end-1, end]
  return b
end


"""
    U1 = korak_sor(L, U0, ω = 1, spremeni_indekse = [])

Izvede en korak SOR iteracije pri reševanju enačb

```math
u_{i-1,j}+u_{i,j-1} - 4u_{ij} + u_{i+1,j}+u_{i,j+1} = 0.
``` 

# Parametri 
 - `L::LaplaceovOperator{2}``
 - `U0::Matrix` matika vrednosti ``u_{ij}``
 - `ω::Float` relaksacijski parameter ``\\omega\\in[0,2]``
 - `spremeni_indekse::Array{Tuple,2}` seznam indeksov točk, ki 
   niso podane kot robni pogoji

# Rezultat 
 - `U1::Matrix` vrednost matrike ``U`` na naslednji iteraciji
# Primer
```jldoctest ; setup = :(using NumMat)
julia> korak_sor(LaplaceovOperator{2}(), [1. 1 1; 2  0 3; 1 4 1])
3×3 Array{Float64,2}:
 1.0  1.0  1.0
 2.0  2.5  3.0
 1.0  4.0  1.0
```
"""
function korak_sor(L::LaplaceovOperator{2}, U0, ω=1, notranji_indeksi=[])
  U = copy(U0)
  n, m = size(U)
  if length(notranji_indeksi) == 0
    notranji_indeksi = [(i,j) for i=2:n-1, j=2:m-1]
  end
  for (i,j) in notranji_indeksi
    U[i, j] = (1-ω)*U[i, j] + ω*(U[i-1, j] + U[i, j-1] + U[i+1, j] + U[i, j+1])/4
  end
  return U
end

"""
    U = iteracija(korak, U0, robni_indeksi)

Poišče limito rekurzivnega zaporedja ``U_n = korak(U_{n-1})``
z začetnim členom `U0`
# Rezultat
- `U` limita zaporedja
- `it` število korakov iteracija
"""
function iteracija(korak, U0; maxit=1000, tol=1e-10)
  n, m = size(U0)
  it = 0
  U = copy(U0)
  Up = copy(U0)
  for k=1:maxit
    U = korak(Up)
    if norm(U - Up, Inf) < tol
      it = k
      break 
    end
    Up = copy(U)
  end
  return U, it
end


"""
    it = conjgrad!(A, b, x; tol=1e-10, maxit=1000)

metoda konjugiranih gradientov za reševanje sistema enačb 

```math
Ax =b
```
# Primer
```jldoctest setup = :(using NumMat)
julia> A = [2 1 0;1 2 1; 0 1 2]; b = ones(3);

julia> x0 = zeros(3);

julia> x, it = conjgrad(A, b, x0)
([-0.5, -1.0, -0.5], 2)
```
"""
function conjgrad(A, b, x=nothing; tol=1e-10)
  if x == nothing
    x = copy(b)
  end
  r = b - A * b
  p = r
  rsold = sum(r .* r)
  it = 0
  for i = 1:length(b)
      Ap = A * p
      alpha = rsold / sum(p .* Ap)
      x = x + alpha * p
      r = r - alpha * Ap
      rsnew = sum(r .* r)
      if sqrt(rsnew) < tol
          it = i
          break
      end
      p = r + (rsnew / rsold) * p
      rsold = rsnew;
  end
  return x, it
end
