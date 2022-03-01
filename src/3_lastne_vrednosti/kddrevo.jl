import LinearAlgebra.norm
import Base.print 
import Base.show

export kddrevo, Drevo, najdi_okolico

struct Drevo{T}
    tocka::T
    dim::Int
    levo_poddrevo::Union{Drevo{T}, Nothing}
    desno_poddrevo::Union{Drevo{T}, Nothing}
end

"""
    drevo = kddrevo(tocke, dim, globina)

Točke iz seznama `tocke` razvrsti v [k-d drevo](https://en.wikipedia.org/wiki/K-d_tree)
začenši z dimenzijo `dim`.

# Primer:
```jldoctest
julia> tocke = [(2,3), (5,4), (9,6), (4,7), (8,1), (7,2)];

julia> drevo = kddrevo(tocke);

julia> print(drevo)
(5, 4)
 `--(7, 2)
 |   `--(9, 6)
 |   `--(8, 1)
 `--(2, 3)
     `--(4, 7)

"""
function kddrevo(tocke, dim=1)
    n = length(tocke)
    if n == 0
        return nothing
    elseif n == 1
        return Drevo(tocke[1], dim, nothing, nothing)
    end
    tocke = sort(tocke; lt = (x, y) -> x[dim] ≤ y[dim])
    n2 = (n-1)÷2 + 1
    mediana = tocke[n2]
    nova_dim = dim%length(mediana) + 1
    drevo = Drevo{typeof(mediana)}(
        mediana, dim, 
        kddrevo(tocke[1:n2-1], nova_dim),
        kddrevo(tocke[n2+1:end], nova_dim)
    )
    return drevo
end


function print(io::IO, drevo::Drevo{T}, padding = "") where {T}
    println(io, drevo.tocka)
    if drevo.desno_poddrevo != nothing
        print(io, padding, " `--")
        if drevo.levo_poddrevo != nothing
            padding *= " |  "
        else 
            padding *=  "    "
        end
        print(io, drevo.desno_poddrevo, padding)
        padding = padding[1:end-4]
    end
    if drevo.levo_poddrevo != nothing
        print(io, padding, " `--")
        padding *= "    "
        print(io, drevo.levo_poddrevo, padding)
        padding = padding[1:end-4]
    end
    return nothing
end

"""
    okolica = najdi_okolico(r, drevo::Drevo{T}, tocka::T; razdalja)

Poišče točke v [k-d drevesu](https://en.wikipedia.org/wiki/K-d_tree), 
ki so manj kot `r` oddaljeni od dane točke `tocka`.

# Primer

```jldoctest
julia> drevo = kddrevo([(2,3), (5,4), (9,6), (4,7), (8,1), (7,2)]);

julia> najdi_okolico(2, drevo, (8,2))
2-element Array{Tuple{Int64,Int64},1}:
 (8, 1)
 (7, 2)
 
```
"""
function najdi_okolico(r, drevo::Drevo{T}, tocka::T; 
                 razdalja=(x,y)->norm(x.-y)) where {T}
    x = tocka[drevo.dim]
    x0 = drevo.tocka[drevo.dim]
    if abs(x-x0) > r # isci le v eni polovico drevesa
        if x < x0
            okolica = najdi_okolico(r, drevo.levo_poddrevo, 
                            tocka; razdalja=razdalja)
        else
            okolica = najdi_okolico(r, drevo.desno_poddrevo, 
                            tocka; razdalja=razdalja)
        end
    else
        okolica = vcat(
            najdi_okolico(r, drevo.levo_poddrevo,
                    tocka, razdalja=razdalja),
            najdi_okolico(r, drevo.desno_poddrevo,
                    tocka, razdalja=razdalja),
        )
    end
    # dodaj točko, če je dovolj blizu
    if razdalja(tocka, drevo.tocka) < r
        push!(okolica, drevo.tocka)
    end
    return okolica
end

najdi_okolico(r, drevo::Nothing, tocka::T; razdalja=nothing) where {T} = Array{T,1}()

