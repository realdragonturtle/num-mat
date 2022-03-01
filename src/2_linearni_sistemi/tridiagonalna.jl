struct Tridiagonalna{T} 
    s::Vector{T}
    d::Vector{T}
    z::Vector{T}
end

import Base:*,\

export Tridiagonalna

"""
    T*v

Izračunaj produkt tridiagonalne matrike `T` z vektorjem `v`.
"""
function *(T::Tridiagonalna, v::Vector)
    n = length(v)
    y = zero(v)
    y[1] = T.d[1]*v[1] + T.z[1]*v[2]
    for i = 2:n-1
        y[i] = T.s[i-1]*v[i-1] + T.d[i]*v[i] + T.z[i]*v[i+1]
    end
    y[n] = T.s[n-1]*v[n-1] + T.d[n]*v[n]
    return y
end

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
