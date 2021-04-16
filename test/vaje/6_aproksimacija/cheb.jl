using Test, NumMat

@testset "Čebiševi polinomi" begin
  @testset "Čebiševi koeficienti" begin
    c = chebkoef(x->x^3, 3)
    @test c ≈ [0, 3/4, 0, 1/4]
  end
  @testset "Vrednosti čebiševe vrste" begin
    cfun = ChebFun([0,0,0,1], [-1,1])
    @test cfun.([1,cos(pi/6), cos(3pi/6),cos(5pi/6)])≈[1, 0, 0, 0]
  end
end
