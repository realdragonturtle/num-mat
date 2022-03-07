using LinearAlgebra

"""
    T*v

Izračunaj produkt tridiagonalne matrike `T` z vektorjem `v`.
"""
struct Tridiagonalna{T} 
    s::Vector{T}
    d::Vector{T}
    z::Vector{T}
end

export Tridiagonalna
import Base:size, length, *, Matrix, \

"""
    T\\b

Izračunaj rešitev sistema Tx = b za tridiagonalno matriko T.
"""
function \(T::Tridiagonalna, b)
    x = copy(b)
    d = copy(T.d)
    n = length(b)
    # eliminacija
    for i = 2:n
        l = T.s[i-1]/d[i-1]
        d[i] -= l*T.z[i-1]
        x[i] -= l*x[i-1]
    end
    # obratno vstavljanje
    x[n] = x[n]/d[n]
    for i = n-1:-1:1
        x[i] = (x[i] - x[i+1]*T.z[i])/d[i]
    end
    return x
end

"""
    size(T)

Vrni dimenzije tridiagonalne matrike T
"""
function size(T::Tridiagonalna)
    n = length(T.d)
    return (n, n)
end

"""
    n = length(T::Tridiagonalna)

Vrni dimenzijo tridiagonalne matrike T.
"""
function length(T::Tridiagonalna)
    length(T.d)
end

"""
    y = T*x

Izračunaj produkt tridiagonalne matrike T z vektorjem v
"""
function *(T::Tridiagonalna, v::Vector)
    n = length(T)
    # TODO razmisli, kako je s tipi
    y = zeros(n)
    y[1] = T.d[1]*v[1] + T.z[1]*v[2]
    for i=2:n-1
        y[i] = T.s[i-1]*v[i-1] + T.d[i]*v[i] + T.z[i]*v[i+1]
    end
    y[n] = T.s[n-1]*v[n-1] + T.d[n]*v[n]
    return y
end

"""
    A = Matrix(T::Tridiagonalna)

Spremeni matriko v tridiagonalnem formatu v kvadratni format.
"""
function Matrix(T::Tridiagonalna{Tip}) where Tip
    n = length(T)
    A = zeros(Tip, n, n)
    A[1,1:2] = [T.d[1], T.z[1]]
    for i=2:n-1
        A[i, i-1:i+1] = [T.s[i-1], T.d[i], T.z[i]]
    end
    A[n, n-1:n] = [T.s[n-1], T.d[n]]
    return A
end

"""
    L, U = lu(T::Tridiagonalna)

Izračunaj LU razcep brez pivotiranja za tridiagonalno matriko `T`. Faktorja `L` in `U` sta 
ravno tako matriki tipa `Tridiagonalna`. 
"""
function LinearAlgebra.lu(T::Tridiagonalna)
    lsp = copy(T.s)
    ud = copy(T.d)
    n = length(T)
    for i=2:n # zanka po vrsticah
        lsp[i-1] = T.s[i-1]/ud[i-1]
        ud[i] = ud[i] - lsp[i-1]*T.z[i-1]
    end
    L = Tridiagonalna(lsp, ones(n), zeros(n-1))
    U = Tridiagonalna(zeros(n-1), ud, T.z)
    return (L, U)
end
