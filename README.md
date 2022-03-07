# Vaje pri predmetu Numerična matematika

[![status testov](https://gitlab.com/nummat/vaje-nummat/badges/master/pipeline.svg)](https://gitlab.com/nummat/vaje-nummat/commits/master)
[![coverage report](https://gitlab.com/nummat/vaje-nummat/badges/master/coverage.svg)](https://gitlab.com/nummat/vaje-nummat/commits/master)
[![documentation (placeholder)](https://img.shields.io/badge/docs-latest-blue.svg)](https://nummat.gitlab.io/vaje-nummat/)


## Navodila

To je projekt z gradivi in domačimi nalogami pri predmetu [Numerična matematika](https://ucilnica.fri.uni-lj.si/2122/course/view.php?id=117).
Za praktično delo pri tem predmetu bomo uporabljali platformo GitLab, ki omogoča 
vodenje projektov in sodelovanje. 

Preberite si več o načinu dela v [vodiču za sodelovanje](CONTRIBUTING.adoc) in 
[kako poteka delo v GitLab](workflow.adoc).

## Organizacija direktorijev

Repozitorij je organiziran kot [paket](https://pkgdocs.julialang.org) z imenom `NumMat` za 
[programski jezik julia](https://julialang.org/), ki ga uporabljamo na vajah. 

* `src` vseguje splošno uporabne funkcije, ki jih sprogramiramo na vajah in so del paketa `NumMat`
* `docs` vsebuje dokumente v formatu [Markdown](https://en.wikipedia.org/wiki/Markdown) z gradivi 
  za vaje in opisi domačih nalog.
* `vaje` vsebuje programe, ki jih naredimo na vajah, vključno z vhodnimi podatki in grafično vizualizacijo. Programi ilustrirajo, kako uporabiti funkcije iz paketa `NumMat`.
* `test` vsebuje kodo za testiranje funkcij iz paketa `NumMat`

# Program vaj

## Uvod

### Vaja 1

Računanje kvadratnega korena s Taylorjevo vrsto in Newtonovo metodo.

### Vaja 2

Računanje vrednosti funkcij *sin* in *cos*.

## Linerani sistemi

### Vaja 3

Tridiagonalni linearni sistemi enačb. 

### Vaja 4

Ravnovesna lega mreže vzmeti.

## Lastne vrednosti

### Vaja 5

Invariantna porazdelitev [Markovske verige](https://en.wikipedia.org/wiki/Markov_chain)

### Vaja 6

Spektralno razvrščanje v gruče

## Interpolacija in aproksimacija

### Vaja 7

Newtonova interpolacija, Hermitova interpolacija, zlepki

### Vaja 8

Lagrangeva interpolacija v  Čebiševih točkah ([chebfun](http://www.chebfun.org/))

## Nelinearne enačbe

### Vaja 9

Konvergenčno območje Newtonove metode

## Integracija

### Vaja 10

Metoda nedoločenih koeficientov in sestavljene kvadraturne formule

### Vaja 11

Večkratni integrali

## Odvod

### Vaja 12

Numerični odvod, metoda končnih razlik za Laplaceovo enačbo (minimalne ploskve)

## Diferencialne enačbe

### Vaja 13

Eulerjeva in trapezna metoda.

### Vaja 14

Perioda geostacionarne orbite
