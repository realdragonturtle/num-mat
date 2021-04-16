using Test
using NumMat

@testset "SOR iteracija" begin
    U0 = [1. 2 3 4;
          5 0 0 6;
          7 0 0 8;
          9 10 11 12;]
    L = LaplaceovOperator{2}()
    @testset "korak iteracije" begin
        Ugs = korak_sor(L, U0)
        Uw2 = korak_sor(L, U0, 2)
        @test Ugs[1:4, 1] ≈ Uw2[1:4, 1] ≈ U0[1:4, 1]
        @test Ugs[1:4, 4] ≈ Uw2[1:4, 4] ≈ U0[1:4, 4]
        @test Ugs[1, 1:4] ≈ Uw2[1, 1:4] ≈ U0[1, 1:4]
        @test Ugs[4, 1:4] ≈ Uw2[4, 1:4] ≈ U0[4, 1:4]
        @test Ugs[2:3, 2:3] ≈ [1.75 (1.75+9)/4; (17+1.75)/4 (19+4.6875+2.6875)/4]
        @test Uw2[2:3, 2:3] ≈ [7/2 25/4; 41/4 71/4]
    end
    @testset "robni indeksi" begin
        Ugs = korak_sor(L, U0, 1, [(3,2), (2,3)])
        @test Ugs[2:3, 2:3] ≈ [0 9/4; 17/4 0]
    end
    @testset "iteracija" begin
        fgs = x -> korak_sor(L, x)
        x, it = iteracija(fgs, U0; maxit=1)
        @test x[2:3, 2:3] ≈ [1.75 (1.75+9)/4; 
                        (17+1.75)/4 (19+4.6875+2.6875)/4]
        x, it = iteracija(fgs, U0; tol=1e-3)
        @test it > 0
        @test x ≈ fgs(x) atol=1e-3
    end
end

