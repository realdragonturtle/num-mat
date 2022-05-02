using LinearAlgebra

import Base.*, Base.\
import LinearAlgebra.lu


"""
ZgornjePasovnaMatrika{T}(pasovi, n)

Matrika ki ima nekaj neničelnih pasov nad diagonalo
Attributes:
n - velikost matrike
pasovi - Dict{Int, Vector{T}}, kjer so keyi 0, 1, 2 ..., oz tisti pasovi ki vsebujejo neničelne vrednosti, 
        0 je pas diagonale, pozitivni so pasovi nad diagonalo

Primer:
PasovnaMatrika(Dict([(0, [1, 2, 3, 4]), (1, [8, 9, 10]), (2, [11, 12])]), 4)
describes matrix [1 8 11 0; 0 2 9 12; 0 0 3 10; 0 0 0 4]
"""
struct ZgornjePasovnaMatrika{T} <: AbstractArray{T, 2}
pasovi::Dict{Int, Vector{T}} 
n::Int
end

export ZgornjePasovnaMatrika


"""
    size(M)

Vrne velikost zgornje pasovne matrike M
"""
function Base.size(M::ZgornjePasovnaMatrika)
    return (M.n, M.n)
end


"""
    getindex(M, I(2))

Vrne element zgornje pasovne matrike na mestu I
"""
function Base.getindex(M::ZgornjePasovnaMatrika, I::Vararg{Int, 2})
    pas = I[2] - I[1]
    if haskey(M.pasovi, pas)
        return M.pasovi[pas][I[1]]
    else
        return 0
    end
end


"""
    setindex(M, v, I(2))

Nastavi element na mestu I na vrednost v
Vrne napako če spreminjamo vrednosti v ničelih pasovih
"""
function Base.setindex!(M::ZgornjePasovnaMatrika, v, I::Vararg{Int, 2})
    pas = I[2] - I[1]
    if haskey(M.pasovi, pas)
        M.pasovi[pas][I[1]] = v
    else
        return error("Vrednosti se lahko nastavi samo v neničelnih pasovih") 
    end
end


"""
    M*v

Zmnoži tgornje pasovno matriko M z vektorjem v
"""
function *(M::ZgornjePasovnaMatrika, v::Vector)
    y = zeros(length(v))
    for (k, pas) in M.pasovi
        for i=1:length(pas)
            row = i # indeks elemneta v pasu
            col = k+i # indeks elemnta v pasu
            y[row] += v[col] * pas[i]
        end
    end
    return y
end


"""
    M\\b

Izračuna rešitev sistema Mx=b za zgornje pasovno matriko M
Podana matrika in vektor morata biti tipa Float
"""
function \(M::ZgornjePasovnaMatrika, b::Vector)
    z_pas = maximum(keys(M.pasovi))
    x = zeros(M.n)
    for i=M.n:-1:1
        curr = b[i] 
        for ii=min(M.n, z_pas+i):-1:i
            curr -= M[i, ii] * x[ii]
        end
        x[i] = curr/ M[i, i]
    end
    return x
end