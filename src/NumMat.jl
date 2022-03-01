"Programi pri numerični matematiki na FRI"
module NumMat

include("1_uvod/koren.jl")
include("2_linearni_sistemi/tridiagonalna.jl")
include("2_linearni_sistemi/rbf.jl")
include("2_linearni_sistemi/Laplace2D.jl")
include("2_linearni_sistemi/Laplace2Diter.jl")
include("2_linearni_sistemi/implicit.jl")
include("3_lastne_vrednosti/kddrevo.jl")
include("3_lastne_vrednosti/kmeans.jl")
include("3_lastne_vrednosti/potencna.jl")
include("3_lastne_vrednosti/konj.jl")
include("4_nelinearne_enacbe/nelinearne_enacbe.jl")
include("4_nelinearne_enacbe/razdalja.jl")
include("5_interpolacija/zlepki.jl")
include("6_aproksimacija/cheb.jl")
include("7_integrali/quad.jl")
include("8_odvodi/autodiff.jl")
end # module
