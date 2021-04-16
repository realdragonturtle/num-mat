import LinearAlgebra:norm

export potencna

"""
    λ, v, it = potencna(A, x0; maxit=100, tol=1e-5)

Poišči po absolutni vrednosti največjo lastno vrednost in 
pripadajoči lastni vektor za matriko A s potenčno metodo. Če
potenčna metoda ne konvergira, javi napako tipa `ErrorException`. 
"""
function potencna(A, x0; maxit=100, tol=1e-5)
    x = copy(x0)
    for i=1:maxit
        y = A*x
        λ = y[argmax(abs.(x))]
        y = y/λ
        if norm(y - x, Inf) < tol
            return λ, y, i
        end
        x = y
    end
    throw(ErrorException("Potenčna metoda ne konvergira"))
end
