# Integrali

```@meta
CurrentModule = NumMat
DocTestSetup  = quote
    using NumMat
end
```

## Metoda nedoločenih koeficientov
!!! note "Kvadrature ali integral"

    **Kvadratura** je zgodovinsko ime za integral. Izraz se je ohranil pri formulah za numerično računanje integralov, ki jim pogosto rečemo **kvadraturne formule** ali preprosto **kvadrature**.

Kvadraturne formule lahko izpeljemo s preprostim postopkom imenovanim *metoda nedoločenih koeficientov*. Kvadraturna formula bo tem višjega reda, za kolikor višjo stopnjo polinomov bo formula točna, brez napake. Tako lahko koeficiente določimo preporsto tako, da v formulo zaporedoma vstavljamo polinome vedno višjih stopenj, dokler ne določimo vseh koeficientov kvadraturne formule.

### Primer
Izpeljite kvadraturno formulo za integral

```math 
\int_{-1}^1 f(x)dx = Af(-x_0)+Bf(0)+Cf(x_0)
```

z metodo nedoločenih koeficientov. Iz omenjenega pravila izpeljite še sestavljeno pravilo in izpeljite tudi oceno za napako.

## Gaussove kvadraturne formule

Že pri interpolaciji smo videli, da ekvidistančne točke niso najboljša izbira. Podobno velja pri kvadraturnih formulah. Če želimo poiskati kvadraturno formulo s kar največjega reda, s čim manj izračuni funkcije, ekvidistančne točke niso prava izbira. Boljša izbira so ničle ortogonalnih polinomov.

### Primer

Izračunajte integral 
   
```math
\int_0^5\sin(x)dx
```   
s sestavljeno trapezno, sestavljeno Simpsonovo in Gauss-Lagendrovimi kvadraturami. 
Primerjajte število zahtevanih izračunov funkcije za različne
metode, ki dajo isto natančnost $10^{-12}$. Gauss-Legendrove kvadraturne
formule izračunamo z [Golub-Welschovim algoritmom](https://en.wikipedia.org/wiki/Gaussian_quadrature#The_Golub-Welsch_algorithm). 

## Koda

```@index
Pages = ["10_quad.md"]
```

```@docs
gauss_quad_rule
```