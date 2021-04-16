export gradient_razdalje, hessian_razdalje

"""
    d = razdalja(K1, K2)

Vrne funkcijo razdalje 
```math
d(t, s) = ||K1(t) - K2(s)||
```
med dvema točkama na krivuljama `K1(t)` in `K2(s)`.

# Primer
```julia-repl
julia> K1(t) = [2*cos(t)+1/3, (sin(t))+1/4];
julia> K2(s) = [cos(s)/3-sin(s)/2, cos(s)/3+sin(s)/3];
julia> razdalja(K1, K2)
#15 (generic function with 1 method)
```
"""
function razdalja(K1, K2)
    return function d(t, s)
    end
end

"""
    fgrad = gradient_razdalje(K1, K2, dK1, dK2)

Vrne funkcijo `fgrad`, ki izračuna gradient kvadrata razdalje med dvema točkama
na krivuljah `K1` in `K2`. Argumenti `K1`, `K2`, `dK1` in `dK2` so funkcije
parametra, ki opisujejo krivulji in njuna smerna odvoda.

Funkcija uporabi `ForwardDiff.gradient` za izračun gradienta. 
"""
function gradient_razdalje(K1, K2, dK1, dK2)
    
end

"""
    fhess = hessian_razdalje(K1, K2, dK1, dK2, d2K1, d2K2)

Vrne funkcijo `fhess`, ki izračuna hessian kvadrata razdalje med dvema točkama
na krivuljah `K1` in `K2`. Argumenti `K1`, `K2`, `dK1`, `dK2`, `d2K1`, `d2K2` so 
funkcije parametra, ki opisujejo krivulji, njuna smerna odvoda in njuna druga odvoda
po parametru.

Funkcija uporabi `ForwardDiff.hessian` za izračun hessove matrike.
"""
function hessian_razdalje(K1, K2, dK1, dK2, d2K1, d2K2)
    
end