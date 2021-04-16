using Test
using NumMat

@testset "Produkt z vektorjem" begin
    T = Tridiagonalna(-ones(2), 2 .* ones(3), -ones(2))
    x = T*ones(3)
    @test x == [1, 0, 1]
end

@testset "Reševanje sistema" begin
    T = Tridiagonalna(-ones(2), 2 .* ones(3), -ones(2))
    x = T\ones(3)
    @test x ≈ [1.5, 2, 1.5]
end