import LinearAlgebra.norm

export RBF, interpoliraj!, vrednost

mutable struct RBF
    φ # funkcija oblike
    tocke # tocke
    w # utezi
end

function interpoliraj!(model::RBF, f)
    n = length(model.tocke)
    A = [model.φ(norm(x.-y)) for x in model.tocke, 
                                          y in model.tocke]
    model.w = A\f
    return model
end

"""

# Primer
```
tocke = [(0,0), (1,0), (0,1), (1,1), (0.5,0.5)]
model = RBf(r->exp(-r^2), tocke, [])
interpoliraj!(model, [0 0 0 0 1])
x = LinRange(-2,2,20)
contour(x, x, (x,y) -> vrednost(model, (x, y)))
```
Uporabimo ginput
```julia
tocke = PyPlot.ginput(5)
```
"""
vrednost(model::RBF, x) = sum(model.w.*[model.φ(norm(x.-y)) for 
                                                y in model.tocke])
