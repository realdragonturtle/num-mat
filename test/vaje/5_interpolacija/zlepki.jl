using Test
using NumMat

@testset "Newtonova interpolacija" begin
  p2 = deljene_diference([0, 1, 2], [0, 1, 4])
  p4 = deljene_diference([0, 1, 1, 1, 2], [0, 1, 4, 12, 16])
  t = LinRange(0,1,10)
  @testset "Različne točke x^2" begin
    @test p2.koef == [0, 1, 1]
    @test p2.tocke == [0, 1]
  end
  @testset "Enake točke x^4" begin
    @test p4.koef == [0, 1, 3, 3, 1]
    @test p4.tocke == [0, 1, 1, 1]
  end
  @testset "Vrednosti" begin
    @test p4.(t) ≈ t.^4
    @test p2.(t) ≈ t.^2
  end
end

@testset "Zlepki" begin
  z = Zlepek([x->x, x->x-1], [0, 1, 2]);
  @test z(0.5) == 0.5
  @test z(1.5) == 0.5
  @test z(1) == 1
  @test z(2) == 1
  @test z(0) == 0
  @testset "napake" begin
    @test_throws ErrorException z(-1)
    @test_throws ErrorException z(2.2)
  end
end

@testset "Iskanje intervala" begin
  krajisca = [1, 2, 3]
  @test NumMat.findinterval(krajisca, 0) == 0
  @test NumMat.findinterval(krajisca, 1) == 1
  @test NumMat.findinterval(krajisca, 1.5) == 1
  @test NumMat.findinterval(krajisca, 2) == 2
  @test NumMat.findinterval(krajisca, 2.5) == 2
  @test NumMat.findinterval(krajisca, 3) == 3
  @test NumMat.findinterval(krajisca, 4) == 3
end