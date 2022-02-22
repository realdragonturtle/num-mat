export BabilonskiObrazec, zacetni_priblizek, koren_babilonski, koren

"""
    zacetni_priblizek(x)

Izračunaj začetni približek za tangentno metodo za računanjekvadratnega korena števila `x`. 
"""
function zacetni_priblizek(x)
  d = exponent(x) >> 1 # desni premik, oziroma deljenje z 2
  m = significand(x)
  if d < 0
    return (0.5 + 0.5*m)/(1 << -d)
  end
  return (0.5 + 0.5*m)*(1 << d) # levi premik je množenje s potenco števila 2
end


"""
    koren_babilonski(x, x0, n)

Izračuna približek za koren števila `x` z `n` koraki babilonskega obrazca z začetnim približkom `x0`.
"""
function koren_babilonski(x, x0,  n)
    a = x0
    for i = 1:n
        a = (a + x/a)/2
    end
    return a
end


"""
    metoda = BabilonskiObrazec()

Pomožni podatkovni tip, ki predstavlja metodo računanja korena z babilonskim obrazcem
"""
struct BabilonskiObrazec
end

"""
    koren(x, BabilonskiObrazec())

Izračunaj kvadratni koren danega števila `x` z babilonskim obrazcem. 
"""
function koren(x, metoda::BabilonskiObrazec)
    d = (exponent >> 1) # polovični exsponent
    x_trans = x * 2^(-(d << 1)) # transfromacija na interval [0.5, 2)
    x_0 = 0.5 + x_trans/2 
    return koren_babilonski(x_trans, x_0, 6) * 2^d
end