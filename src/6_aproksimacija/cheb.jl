export ChebFun, chebfun, chebval, stopnja
"""
Podatkovni tip za vrsto Čebiševih polinomov
"""
struct ChebFun{T}
  an::Vector{T}
  interval::Vector{T}
end

ChebFun(an, interval) = ChebFun(promote(an, interval)...)
stopnja(f::ChebFun) = length(f.an) - 1

(cfun::ChebFun{T})(x) where T = chebval(cfun, x)

"""
    fp = chebkoef(fun,n) 

izračuna koeficiente v razvoju funkcije fun na intervalu [-1,1] po Čebiševih polinomih 
stopnje največ n.
"""
function chebkoef(fun, n::Integer)
  k = 0:n
  α = pi*(2*k.+1)/(2*n+2)
  f = fun.(cos.(α))
  c = zeros(n+1)
  c[1] = sum(f)/(n+1);
  for j=2:n+1
    c[j] = 2*sum(f.*cos.((j-1)α))/(n+1);
  end
  return c
end

"""
    chebfun(fun, a, b, n)

vrne razvoj funkcije po Čebiševih polinomih stopnje največ n na intervalu [a, b]
"""
chebfun(fun, a, b, n::Integer) = ChebFun(chebkoef(t->fun((b-a)/2*t+(a+b)/2), n), [a, b])
natancnost(cfun::ChebFun) = maximum(abs.(cfun.an[end-2:end]))/maximum(abs.(cfun.an))

"""
    chebfun(fun, a, b)

vrne razvoj funkcije v Čebiševo vrsto.
"""
function chebfun(fun, a, b; eps=1e-14 , maxit=12)
  for i=2:maxit
    cfun = chebfun(fun, a, b, 2^i)
    rel_eps = maximum(abs.(cfun.an))*eps
    if maximum(abs.(cfun.an[end-2:end])) < rel_eps
      k = findlast(x->abs(x) > rel_eps, cfun.an)
      return ChebFun(cfun.an[1:k], cfun.interval)
    end
  end
  error("Funkcije ni mogoče razviti v vrsto!")
end


"""
    y = chebval(p,x)
    
izračuna vrednost polinoma, ki je podan v Čebiševi bazi
p(x) = p(1)T0(x) + p(2)T1(x) + ... + p(n+1)Tn(x)

```jldoctest
julia> p = [2 0 -1]; t = LinRange(-1, 1, 100);

julia> @assert chebval([0,0,1],t) ≈ 2t.^2 - 1
```
"""
function chebval(fun::ChebFun, x)
  a, b = fun.interval
  x = 2(x - (a+b)/2)/(b-a)
  p = fun.an
  n = length(p);
  if n == 1
    y = one(x);
  elseif n == 2
    y = x;
  else
    y = p[1]+p[2]*x;
    Tp = 1; T = x;
    for i=3:n
      Tn = 2*x*T - Tp;
      Tp = T; T = Tn;
      y += p[i]*T;
    end
 end
 return y
end
