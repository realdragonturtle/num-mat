using SparseArrays

export prehodna_matrika_konj, invariantna_porazdelitev

const vsi_skoki = [[1,2], [2,1],
             [-1, 2], [-2, 1],
             [1, -2], [2, -1],
             [-1, -2], [-2, -1]]

"""
    skoki(i, j, m, n)

Vrne vse možne skoke konja iz polja (i,j) na m x n šahovnici.
"""
function skoki(i,j, m, n)
    s = []
    for skok in vsi_skoki
        k, l = skok
        if !((1<= i + k <=n) && (1<= j + l <=m))
            continue
        end
        push!(s, [i+k, j+l])
    end
    return s
end

"""
    prehodna_matrika_konj(n, m)

Vrne prehodno matriko za slučajni sprehod konja na šahovnici
dimenzije `n` krat `m`.
"""
function prehodna_matrika_konj(n, m)
    P = spzeros(n*m, n*m)
    for i=1:n, j=1:m
        k = i + n*(j-1)
        for skok in vsi_skoki
            i1 = i + skok[1]
            j1 = j + skok[2]
            k1 = i1 + n*(j1-1)
            if (1<=i1<=n) && (1<=j1<=m)
                P[k, k1] = 1
            end
        end
        P[k,:] /= sum(P[k,:])
    end
    return P
end


"""
    invariantna_porazdelitev(p0; maxit=100, tol=1e-5)

Izračunaj invariantno porazdelitev markovske verige, ki predstavlja
slučajni sprehod konja po šahovnici. Argument `p0` je začetna porazdelitev
po poljih na šahovnici.

# Primer

```julia
p0 = rand(8,8)
p = invariantna_porazdelitev(p0)
```
"""
function invariantna_porazdelitev(p0; maxit=100, tol=1e-5)
    n, m = size(p0)
    v = reshape(p0, n*m)
    A = prehodna_matrika_konj(n, m)' + I # premik za 1, ker ima P tudi lastno vrednost -1
    λ, p, it = potencna(A, p0; maxit=maxit, tol=tol)
    return reshape(p/sum(p), n, m)
end

import Base:*

"Markovska veriga za konja na šahovnici"
struct MCKonj
end


"""
    *(MCKonj(), p)

Izračuna produkt porazdelitve `p` po šahovskih poljih s 
transponirano prehodno matriko za slučajni sprehod konja na šahovnici.
"""
function *(::MCKonj, x)
    n, m = size(x)
    y = zero(x)
    for i=1:n, j=1:m
        mogoci_skoki = skoki(i, j, n, m)
        stevilo = length(mogoci_skoki)
        for skok in mogoci_skoki
            k, l = skok
            # na mestu skoka prištejemo produkt
            y[k,l] += x[i, j]/stevilo
        end
    end
    return y
end