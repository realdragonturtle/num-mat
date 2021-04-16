using Test, NumMat

@testset "Simpsonova formula" begin
  Ip = cos(1)-cos(3)
  @test simpson(sin, 1, 3, 1) ≈ (sin(1) + 4sin(2) + sin(3))/3
  @test simpson(sin, 1, 3, 1000) ≈ Ip
  @testset "Red metode" begin
    n = 2 .^(2:10)
    napaka = [simpson(sin, 1, 3, nk)-Ip for nk in n]
    konst, red = hcat(ones(size(n)), log.(n))\log.(abs.(napaka))
    @test red <= -4
  end
end

@testset "Golub-Welsch" begin
  @testset "Gauss-Legendre" begin
    a(n) = (2*n-1)/n; b(n) = 0.0; c(n) = (n-1)/n;
    x0, w = gauss_quad_rule(a, b, c, 2, 2);
    @test sort(x0) ≈ [-1, 1]./sqrt(3)
    @test w ≈ [1, 1]
    x0, w = gauss_quad_rule(a, b, c, 2, 3);
    @test sort(x0) ≈ [-1, 0, 1]*sqrt(3/5)
    @test sort(w) ≈ [5, 5, 8]./9
  end
  @testset "Gauss-Čebišev" begin
    a(n) = -1/n; b(n) = (2*n-1)/n; c(n) = (n-1)/n;
    x0, w = gauss_quad_rule(a,b,c,1,2);
    @test sort(x0) ≈ 2 .+ sqrt(2)*[-1, 1]
    @test sort(w) ≈ (2 .+ sqrt(2)*[-1, 1])./4
  end
end

@testset "n-D kvadrature" begin
  f(x) = x[1].^2 + x[2].^2 # simpson bi moral vrniti točno vrednost
  I = 2/3
  @testset "Simpson" begin
    x0 = [0, 0.5, 1]
    w = 0.5/3*[1, 4, 1]
    @test I == ndquad(f, x0, w, 2)
  end
  @testset "trapezna" begin
    x0 = [0, 1, 2, 3, 4]./4
    w = 1/8*[1 2 2 2 1]
    It = ndquad(f, x0, w, 2)
    @test !(I ≈ It)
    @test abs(I - It) < 0.1
  end
end