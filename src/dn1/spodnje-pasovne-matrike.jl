using LinearAlgebra

import Base.*, Base.\
import LinearAlgebra.lu


"""
    SpodnjePasovnaMatrika{T}(pasovi, n)

Matrika ki ima nekaj neničelnih pasov pod diagonalo
Attributes:
n - velikost matrike
pasovi - Dict{Int, Vector{T}}, kjer so keyi ... -2, -1, 0, oz tisti pasovi ki vsebujejo neničelne vrednosti, 
            negativne vrednosti označujejo pasove pod diagonalo, 0 je pas diagonale 

Primer:
PasovnaMatrika(Dict([(0, [1, 2, 3, 4]), (-1, [5, 6, 7])]), 4)
describes matrix [1 0 0 0; 5 2 0 0; 0 6 3 0; 0 0 7 4]
"""
struct SpodnjePasovnaMatrika{T} <: AbstractArray{T, 2}
    pasovi::Dict{Int, Vector{T}} 
    n::Int
end

export SpodnjePasovnaMatrika


"""
    size(M)

Vrne velikost spodnje pasovne matrike M
"""
function Base.size(M::SpodnjePasovnaMatrika)
    return (M.n, M.n)
end


"""
    getindex(M, I(2))

Vrne element spodnje pasovne matrike na mestu I
"""
function Base.getindex(M::SpodnjePasovnaMatrika, I::Vararg{Int, 2})
    pas = I[2] - I[1] 
    if haskey(M.pasovi, pas)
        return M.pasovi[pas][I[2]]
    else
        return 0
    end
end


"""
    setindex(M, v, I(2))

Nastavi element na mestu I na vrednost v
Vrne napako če spreminjamo vrednosti v ničelih pasovih
"""
function Base.setindex!(M::SpodnjePasovnaMatrika, v, I::Vararg{Int, 2})
    pas = I[2] - I[1]
    if haskey(M.pasovi, pas)
        M.pasovi[pas][I[2]] = v
    else
        return error("Vrednosti se lahko nastavi samo v neničelnih pasovih") 
    end
end


"""
    M*v

Zmnoži spodnje pasovno matriko M z vektorjem v
"""
function *(M::SpodnjePasovnaMatrika, v::Vector)
    y = zeros(length(v))
    for (k, pas) in M.pasovi
        for i=1:length(pas)
            row = -k+i # indeks elemneta v pasu
            col = i # indeks elemnta v pasu
            y[row] += v[col] * pas[i]
        end
    end
    return y
end


"""
    M\\b

Izračuna rešitev sistema Mx=b za spodnje pasovno matriko M
"""
function \(M::SpodnjePasovnaMatrika, b::Vector)
    l_pas = minimum(M.pasovi.keys)
    x = zeros(M.n)
    for i=1:M.n
        curr = b[i] 
        for ii=max(1, l_pas+i):(i-1)
            curr -= M[i, ii] * x[ii]
        end
        x[i] = curr / M[i, i]
    end
    return x
end