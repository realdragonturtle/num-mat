import LinearAlgebra: norm
export konvergencno_obmocje, newton
"""
    x, it = newton(f, df, x0; maxit=100, tol=1e-12)

Poišči ničlo funkcije `f` z Newtonovo metodo. Če Newtonova metoda 
ne konvergira naj metoda vrne par `nothing, maxit`.

# Primer
Poiščimo ``\\sqrt{2}`` kot ničlo funkcije ``f(x)=x^2-2``:
```jldoctest
julia> newton(x->x^2-2, x->2x, 1.5)
(1.4142135623730951, 4)
```
"""
function newton(f, df, x0; maxit=100, tol=1e-12)
    x = copy(x0)
    z = f(x)
    for i=1:maxit
        x -= df(x)\f(x)
        z = f(x)
        if (norm(z)<tol)
            return x, i
        end
    end
    return nothing, maxit

end



"""
    x, y, Z = konvergencno_obmocje(obmocje, metoda; n=50, m=50, maxit=50, tol=1e-3)

Izračuna, h katerim vrednostim konvergira metoda `metoda`, če uporabimo različne
začetne približke.

# Primer
Konvergenčno območje za Newtonovo metodo za kompleksno enačbo ``z^3=1``

```jldoctest
julia> F((x, y)) = [x^3-3x*y^2; 3x^2*y-y^3];
julia> JF((x, y)) = [3x^2-3y^2 -6x*y; 6x*y 3x^2-3y^2]
julia> metoda(x0) = newton(F, JF, x0; maxit=10; tol=1e-3);

julia> x, y, Z = konvergencno_obmocje((-2,2,-2,2), metoda; n=5, m=5); Z
5×5 Array{Float64,2}:
 1.0  1.0  2.0  3.0  3.0
 1.0  1.0  2.0  3.0  3.0
 1.0  1.0  0.0  3.0  3.0
 2.0  2.0  2.0  2.0  2.0
 2.0  2.0  2.0  2.0  2.0
```
"""
function konvergencno_obmocje(obmocje, metoda; n=50, m=50, tol=1e-3)
    a, b, c, d = obmocje
    Z = zeros(n, m)
    x = LinRange(a, b, n)
    y = LinRange(c, d, m)
    nicle = []
    for i = 1:n, j = 1:m
        z = [x[i], y[j]]
        try
            z, it = metoda([x[i],y[j]])
        catch
            continue
        end
        if z == nothing
          continue
        end
        k = findfirst([norm(z-z0, Inf)<2tol  for z0 in nicle])
        if k == nothing
          push!(nicle, z)
          k = length(nicle)
        end
        Z[i,j] = k
    end
    return x, y, Z
end