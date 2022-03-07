using LinearAlgebra
using NumMat

# Primer

T = Tridiagonalna([1.0,2,3], [2,5.0,5,10], [1.0,2,3])

A = Matrix(T)

# Množenje

v = [1,2,3,4]

T*v
A*v
T*v - A*v

L, U = lu(T)

Matrix(L)*Matrix(U)

A