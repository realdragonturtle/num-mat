using Test
using NumMat

@testset "Newtonova metoda" begin
  @test newton(x->x-1, x->1, 2) == (1,1)
  x, it = newton(x->x^2-1, x->2x, 2; maxit=1, tol=Inf)
  @test 4(x-2) == -3
  x, it = newton(x->sin(x), x->cos(x), 3)
  @test it <= 5
  @test x ≈ pi; atol=1e-10
  x, it = newton(x->x^2-1, x->2x, 2; maxit=1)
  @test x == nothing && it==1
end

@testset "Obmocje konvergence" begin
  metoda((x,y); kwargs...) = newton(x->x^2-1, x->2x, x+y*im; kwargs...)
  x, y, Z = konvergencno_obmocje((-2,2,-2,2), metoda; n=3, m=3)
  @test Z ≈ [1.0 1.0 1.0; 0.0 0.0 0.0; 2.0 2.0 2.0]
end
