using LinearAlgebra

import Base.*, Base.\
import LinearAlgebra.lu
# import LinearAlgebra.norm


"""
    PasovnaMatrika{T}(pasovi, n)

Matrika ki ima le nekaj neničelnih pasov
Attributes:
n - velikost matrike
pasovi - Dict{Int, Vector{T}}, kjer so keyi ... -2, -1, 0, 1, 2 ..., oz tisti pasovi ki vsebujejo neničelne vrednosti, 
            negativne vrednosti označujejo pasove pod diagonalo, 0 je pas diagonale in pozitivni so pasovi nad diagonalo

Primer:
PasovnaMatrika(Dict([(0, [1, 2, 3, 4]), (-1, [5, 6, 7]), (1, [8, 9, 10]), (2, [11, 12])]), 4)
describes matrix [1 8 11 0; 5 2 9 12; 0 6 3 10; 0 0 7 4]
"""
struct PasovnaMatrika{T} <: AbstractArray{T, 2}
    pasovi::Dict{Int, Vector{T}} # 0 diagonala, 1, 2, 3...nad diagonalo, -1, -2, ... pod diagonalo
    n::Int
end

export PasovnaMatrika


"""
    size(M)

Vrne velikost pasovne matrike M
"""
function Base.size(M::PasovnaMatrika)
    return (M.n, M.n)
end


"""
    getindex(M, I(2))

Vrne element pasovne matrike na mestu I
"""
function Base.getindex(M::PasovnaMatrika, I::Vararg{Int, 2})
    pas = I[2] - I[1]
    if haskey(M.pasovi, pas)
        if pas >= 0
            return M.pasovi[pas][I[1]]
        else 
            return M.pasovi[pas][I[2]]
        end
    else
        return 0
    end
end


"""
    setindex(M, v, I(2))

Nastavi element na mestu I na vrednost v
Vrne napako če spreminjamo vrednosti v ničelih pasovih
"""
function Base.setindex!(M::PasovnaMatrika, v, I::Vararg{Int, 2})
    pas = I[2] - I[1]
    if haskey(M.pasovi, pas)
        if pas >= 0
            M.pasovi[pas][I[1]] = v
        else 
            M.pasovi[pas][I[2]] = v
        end
    else
        return error("Vrednosti se lahko nastavi samo v neničelnih pasovih") # dodaj cel pas naenkrat? -> setindex!(A, X, I...)
    end
end


"""
    M*v

Zmnoži pasovno matriko M z vektorjem v
"""
function *(M::PasovnaMatrika, v::Vector)
    y = zeros(length(v))
    for (k, pas) in M.pasovi
        for i=1:length(pas)
            row = k<=0 ? -k+i : i # indeks elemneta v pasu
            col = k<=0 ? i : k+i # indeks elemnta v pasu
            y[row] += v[col] * pas[i]
        end
    end
    return y
end


"""
    M\\b

Izračuna rešitev sistema Mx=b za pasovno matriko M
"""
function \(M_in::PasovnaMatrika, b::Vector)
    bc = deepcopy(b)
    M = deepcopy(M_in)
    z_pas = maximum(M.pasovi.keys)
    l_pas = minimum(M.pasovi.keys)

    for j=1:M.n
        for i=j+1:min(M.n, -l_pas+j)
            l = M[i, j] / M[j, j]
            M[i, j] = 0
            for k=j+1:min(z_pas+j+1, M.n)
                M[i, k] -= l * M[j, k]
            end
            bc[i] -= bc[j] * l 
        end
    end

    x = zeros(M.n)
    for i=M.n:-1:1
        curr = bc[i] 
        for ii=min(M.n, z_pas+i):-1:i
            curr -= M[i, ii] * x[ii]
        end
        x[i] = curr / M[i, i]
    end
    return x
end


"""
    lu(M)

Izračuna LU razcep pasovne matrike M, vrne zgornje pasovno matriko U in spodnje pasovno matriko L
L, U = lu(M)
"""
function lu(M::PasovnaMatrika)
    p = Dict{Int64, Vector{Float64}}()
    for (k, pas) in M.pasovi
        if k<0
            p[k] = zeros(length(pas))
        elseif  k==0
            p[k] = ones(length(pas))
        end
    end
    L = SpodnjePasovnaMatrika(p, M.n)
    
    l_pas = minimum(M.pasovi.keys)
    z_pas = maximum(M.pasovi.keys)
    A = deepcopy(M)
    
    for j=1:M.n
        for i=j+1:-l_pas+1
            l = A[i, j] / A[j,j]
            L[i, j] = l

            for k=j+1:min(z_pas+j+1, M.n)
                if A[j,j] < A[j,k]
                    error("Ni diagonalno dominantna")
                end
                A[i, k] = A[i, k] - l * A[j, k]
            end
        end
    end 

    pu = Dict{Int64, Vector{Float64}}()
    for (k, pas) in A.pasovi
        if  k==0
            pu[k] = copy(pas)
        elseif k>0
            pu[k] = copy(pas)
        end
    end
    U = ZgornjePasovnaMatrika(pu, M.n)
    return (L, U)
end

