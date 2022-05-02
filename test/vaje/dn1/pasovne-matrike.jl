using Test
using NumMat
using LinearAlgebra


@testset "pasovna" begin
    eps = 1e-6

    M = [1 8 11 0; 5 2 9 12; 0 6 3 10; 0 0 7 4]
    P = PasovnaMatrika(Dict([(0, [1, 2, 3, 4]), (-1, [5, 6, 7]), (1, [8, 9, 10]), (2, [11, 12])]), 4)
    for i=1:4, j=1:4
        @test P[i, j] == M[i, j] 
    end
    @test size(P) == size(M) 

    for a = [1, 2], b = [1, 3]
        val = a+b
        P[a, b] = val
        @test P[a, b] == val
    end

    # *
    P = PasovnaMatrika(Dict([(0, [1, 2, 3, 4]), (-1, [5, 6, 7]), (1, [8, 9, 10]), (2, [11, 12])]), 4)
    v = [1, 2, 3, 4]
    @test norm(P*v - M*v) < eps

    P = PasovnaMatrika(Dict([(0, [1.0, 2, 3, 4]), (-1, [5.0, 6, 7]), (1, [8.0, 9, 10]), (2, [11.0, 12])]), 4) # float
    v = [1, 2, 3, 4.0]
    x = P\v
    @test norm(P*x - v) < eps

    # lu
    P = PasovnaMatrika(Dict([(0,[10.0, 15.0, 9.0]), (-1,[4.0, 8.0]), (1, [2.0, 6.0]), (-2, [7.0])]), 3)
    M = [10 2 0; 4 15 6; 7 8 9]
    L, U = lu(P)
    @test norm(L*U - P) < eps
    Lm, Um = lu(M)
    @test norm(L - Lm) < eps
    @test norm(U - Um) < eps

    # large matrix test 64*64
    n = 8
    pasoviA = Dict{Int64, Vector{Float64}}(i => (1/(abs(i)+1)) * ones(n*n-abs(i)) for i=-2n:2n)
    A = PasovnaMatrika(pasoviA, n*n)
    
    b = collect(2:1+n*n) / 1.0
    x = A\b
    @test norm(A*x - b) < eps

    M = copy(A)
    @test norm(A - M) < eps
    L, U = lu(A)
    @test norm(L*U - A) < eps
    Lm, Um = lu(M)
    @test norm(L - Lm) < eps
    @test norm(U - Um) < eps

end

@testset "zgornje-pasovna" begin
    eps = 1e-6

    M = [1 8 11 0; 0 2 9 12; 0 0 3 10; 0 0 0 4]
    P = ZgornjePasovnaMatrika(Dict([(0, [1, 2, 3, 4]), (1, [8, 9, 10]), (2, [11, 12])]), 4)
    for i=1:4, j=1:4
        @test P[i, j] == M[i, j] 
    end
    @test size(P) == size(M) 

    for a = [1, 2], b = [2, 3]
        val = a+b
        P[a, b] = val
        @test P[a, b] == val
    end

    P = ZgornjePasovnaMatrika(Dict([(0, [1, 2, 3, 4]), (1, [8, 9, 10]), (2, [11, 12])]), 4)
    v = [1, 2, 3, 4]
    @test norm(P*v - M*v) < eps

    P = ZgornjePasovnaMatrika(Dict([(0, [1.0, 2, 3, 4]), (1, [8.0, 9, 10]), (2, [11.0, 12])]), 4)
    v = [1, 2, 3, 4.0]
    x = P\v
    @test norm(P*x - v) < eps
end

@testset "spodnje-pasovna" begin
    eps = 1e-6

    M = [1 0 0 0; 5 2 0 0; 11 6 3 0; 0 12 7 4]
    P = SpodnjePasovnaMatrika(Dict([(0, [1, 2, 3, 4]), (-1, [5, 6, 7]), (-2, [11, 12])]), 4)
    for i=1:4, j=1:4
        @test P[i, j] == M[i, j] 
    end
    @test size(P) == size(M) 

    for a = [3, 4], b = [2, 3]
        val = a+b
        P[a, b] = val
        @test P[a, b] == val
    end

    P = SpodnjePasovnaMatrika(Dict([(0, [1, 2, 3, 4]), (-1, [5, 6, 7]), (-2, [11, 12])]), 4)
    v = [1, 2, 3, 4]
    @test norm(P*v - M*v) < eps

    P = SpodnjePasovnaMatrika(Dict([(0, [1.0, 2, 3, 4]), (-1, [5.0, 6, 7]), (-2, [11.0, 12])]), 4)
    v = [1, 2, 3, 4.0]
    x = P\v
    @test norm(P*x - v) < eps
end
