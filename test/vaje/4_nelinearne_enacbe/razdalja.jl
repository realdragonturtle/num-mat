using Test
using NumMat

@testset "Razdalja med krivuljama" begin
  K1(t) = [t^2,0]
  K2(s) = [0,s^2]
  D2((t,s)) = t^4 + s^4
  dK1(t) = [2t, 0]
  dK2(s) = [0, 2s]
  @testset "Gradient" begin
    grad = gradient_razdalje(K1, K2, dK1, dK2) 
    @test grad([1,2]) == 4*[1, 8]
    @test grad([-1,2]) == 4*[-1, 8]
  end
  @testset "Hessian razdalje" begin
    ddK1(t) = [2,0]
    ddK2(s) = [0,2]
    hess =  hessian_razdalje(K1, K2, dK1, dK2, ddK1, ddK2)
    @test hess([3,4]) == 12*[9 0; 0 16]
    K1(t) = [t^2, t]; dK1(t) = [2t, 1]; ddK1(t) = [2,0]
    hess = hessian_razdalje(K1, K2, dK1, dK2, ddK1, ddK2)
    @test hess([1,2]) == [14 -8; -8 44]
  end
end
