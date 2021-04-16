import LinearAlgebra.norm
"""
    gruce = kmeans(tocke, k)

Točke `tocke` razvrsti v gruče z metodo [k-povpečij](https://en.wikipedia.org/wiki/K-means_clustering).
"""
function kmeans(tocke, k::Int; maxit=100)
  n = length(tocke)
  gruce = rand(1:k, n) 
  for i=1:maxit
    centri = [0 .* first(tocke) for i=1:k]
    velikosti = zeros(k)
    koncaj = true
    for i=1:n
      centri[gruce[i]] = centri[gruce[i]] .+ tocke[i]
      velikosti[gruce[i]] += 1
    end
    for j=1:k
      centri[j] = centri[j] ./ velikosti[j]
    end

    for i=1:n
      nova_gruca = argmin([norm(c.-tocke[i]) for c in centri])
      koncaj = koncaj & (nova_gruca == gruce[i])
      gruce[i] = nova_gruca
    end
    if koncaj
      return gruce
    end
  end
end