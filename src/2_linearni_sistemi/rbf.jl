import LinearAlgebra.norm

"Podatkovni tip za radialne bazne funkcije"
struct BazaRBF
    tocke::Array
    fun
end

"""
    matrika(baza::BazaRBF)

Izračunaj matriko radialnih baznih funkcij(RBF) za dane 
točke in funkcijo oblike
"""
function matrika(baza::BazaRBF)
    n = length(baza.tocke)
    A = zeros(n, n)
    for i=1:n j=1:n
        A[i, j] = baza.fun(norm(baza.tocke[i] - baza.tocke[i]))
    end
    return A
end

"""
    vrednost(x, koef, baza::BazaRBF)

Izračunaj vrednost funkcije, ki je linearna kombinacija RBF 
z danimi koeficienti `koef`, v dani točki `x`.
"""
function vrednost(x, koef, baza::BazaRBF)
    n = length(baza.tocke)
    sum(koef[i]*baza.fun(norm(x-baza.tocke[i])) for i in 1:n)
end