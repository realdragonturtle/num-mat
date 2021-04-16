using Test
using NumMat

L2 = LaplaceovOperator(2) 
@testset "Laplaceova matrika 3x4" begin
    A = matrika(3, 4, L2)
    @testset "velikost" begin
        @test size(A) == (12, 12)
    end
    @testset "Diagonalni bloki" begin
        L3 = [-4 1 0; 1 -4 1; 0 1 -4]
        @test A[1:3, 1:3] == L3
        @test A[4:6, 4:6] == L3
        @test A[7:9, 7:9] == L3
        @test A[10:12, 10:12] == L3
    end
    @testset "Obdiagonalni bloki" begin
        I3 = [1 0 0; 0 1 0; 0 0 1]
        @test A[1:3, 4:6] == I3
        @test A[4:6, 1:3] == I3
        @test A[7:9, 4:6] == I3
        @test A[4:6, 7:9] == I3
        @test A[7:9, 10:12] == I3
        @test A[10:12, 7:9] == I3
    end
    @testset "Ničle" begin
        @test all(A[1:3, 7:end] .== 0)
        @test all(A[7:end, 1:3] .== 0)
        @test all(A[4:6, 10:end] .== 0)
        @test all(A[10:end, 4:6] .== 0)
    end
end

@testset "Laplaceova matrika 4x3" begin
    A = matrika(4, 3, L2)
    @testset "velikost" begin
        @test size(A) == (12, 12)
    end
    @testset "Diagonalni bloki" begin
        L4 = [-4 1 0 0; 1 -4 1 0; 0 1 -4 1; 0 0 1 -4]
        @test A[1:4, 1:4] == L4
        @test A[5:8, 5:8] == L4
        @test A[9:12, 9:12] == L4
    end
    @testset "Obdiagonalni bloki" begin
        I4 = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]
        @test A[1:4, 5:8] == I4
        @test A[5:8, 1:4] == I4
        @test A[9:12, 5:8] == I4
        @test A[5:8, 9:12] == I4
    end
    @testset "Ničle" begin
        @test all(A[1:4, 9:end] .== 0)
        @test all(A[9:end, 1:4] .== 0)
    end
end


    
@testset "desne strani enačbe" begin
#      0  11 12 13 14 0 
#      10 09 00 01 02 9
#      8  05 06 07 08 7
#      6  01 02 03 04 5
#      0  1  2  3  4  0
    b = desne_strani( -[1, 2, 3, 4], -[5, 7, 9], 
                       -[11, 12, 13, 14], -[6, 8, 10], L2)
    @testset "velikost" begin
        @test size(b) == (12,)
    end
    @testset "vogali" begin
        @test b[1] == 1 + 6
        @test b[4] == 4 + 5
        @test b[9] == 10 + 11
        @test b[12] == 14 + 9
    end
    @testset "rob" begin
        @test (b[2], b[3]) == (2, 3)
        @test (b[5], b[8]) == (8, 7)
        @test (b[10], b[11]) == (12, 13)
    end
    @testset "notranjost" begin
        @test all((b[6],b[7]) .== 0)
    end
end

@testset "robni problem" begin
    fs(x) = x
    fd(y) = y+1
    fz(x) = x+2
    fl(y) = y
    h = 0.1
    meje = ((0, 1), (0, 2))
    robni_problem = RobniProblemPravokotnik(L2, meje, [fs, fd, fz, fl])
    Z, x, y = resi(robni_problem; nx = 10, ny = 20)
    @testset "dimenzije" begin
        @test size(Z) == (22, 12)
    end
    @testset "rob" begin
        @test fs.(x) ≈ Z[1, :]
        @test fz.(x) ≈ Z[end, :]
        @test fd.(y) ≈ Z[:, end]
        @test fl.(y) ≈ Z[:, 1]
    end
    @testset "notranjost" begin
        @test Z ≈ y.+ x'
    end
end
