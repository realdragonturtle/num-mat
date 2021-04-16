using Test
using NumMat

@testset "K-d drevo" begin
  @testset "robni primeri" begin
    @test kddrevo([]) == nothing
    @test kddrevo([1]) == Drevo(1, 1, nothing, nothing)
    @test kddrevo([(1,2), (3, 4)]) == Drevo((1, 2), 1, nothing,
                                            Drevo((3, 4), 2, nothing, nothing))
  end
@testset "iskanje eps okolice" begin
    tocke = [(2,3), (5,4), (9,6), (4,7), (8,1), (7,2)]
    drevo = kddrevo(tocke)
    okolica = najdi_okolico(2, drevo, (8,2))
    @test kddrevo(tocke) == Drevo((5,4), 1, 
                              Drevo((2,3), 2,
                                  nothing,
                                  Drevo((4, 7), 1, nothing, nothing)), 
                              Drevo((7,2), 2, 
                                  Drevo((8, 1), 1, nothing, nothing),
                                  Drevo((9, 6), 1, nothing, nothing)))
    @test Set(okolica) == Set([(7,2), (8,1)])
    @test length(okolica) == 2
end
end