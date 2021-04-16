# Računanje kvadratnega korena

Računalniški procesorji navadno implementirajo le osnovne številske operacije:
 seštevanje, množenje in deljenje. Za računanje drugih matematičnih funkcij 
 mora nekdo napisati program.
 
!!! note "Elementarne funkcije so v stadardni knjižnici večine jezikov"
 
     Večina programskih jezikov vsebuje elementarne funkcije v standardni 
     knjižnici. Tako tudi `julia`. Lokacijo metod, ki računajo kvadratni koren 
     lahko dobite z ukazom `methods(sqrt)`.

## Naloga

Na različne načine izračunaj kvadratni koren. Napiši več metod za funkcijo 
`koren`, tako da uporabiš [večlično razpošiljanje (multiple dispatch)](https://en.wikipedia.org/wiki/Multiple_dispatch) na 
abstraktne tipe, ki predstavljajo različne metode. Na primer definiramo dve 
različni metodi za koren

```@example koren_1
struct NapacenKoren end
struct VgrajenaFunkcija end

function koren(x, metoda::NapacenKoren)
 x/2
end

function koren(x, metoda::VgrajenaFunkcija)
 sqrt(x)
end

```

ki jih nato lahko pokličemo, tako da spremenimo 2. argument:


```@repl koren_1
koren(2, NapacenKoren())
koren(2, VgrajenaFunkcija())
```
