# 1. domača naloga

## Oddaja naloge

Naloge oddajte na [Gitlab](https://gitlab.com/nummat/nummat-1920/).

!!! warning

    Naloge, ki jih boste oddali na Gitlabu, bodo **javno dostopne**. Če kdo
    ne želi, da je njegov izdelek javno dostopen, naj si ustvari
    privatno [različico(fork)](https://docs.gitlab.com/ee/gitlab-basics/fork-project.html)
    repozitorija [nummat-1920](https://gitlab.com/nummat/nummat-1920) in
    naj povabi zraven kolega, ki bo kodo pregledal in asistenta(@mrcinv). Če
    kdo ne želi uporabljati Gitlaba ali programskega jezika julia, naj
    se oglasi asistentu.

Navodila za oddajo naloge (glejte tudi [dokument o delu z gitom in Gitlabom](../workflow.md))

- [Ustvarite](https://gitlab.com/nummat/nummat-1920/issues/new) svoj
   zahtevek(issue) in [zahtevo za združitev(merge request)](https://docs.gitlab.com/ee/gitlab-basics/add-merge-request.html#how-to-create-a-merge-request).
- Napište kodo, teste in kratek dokument z opisom rešitve in primerom. Kodo
   potisnite na repozitorij v svoji git veji.
- Povabite kolega, da pregleda vašo kodo, tako da ga omenite kot `@vzdevek`
   v komentarju na zahtevi za združitev(merge request).
- Ko je pregled končan in pripombe kolega upoštevane, povabite še asistenta (`@mrcinv`).

Rešitev naloge naj vsebuje vsaj 3 datoteke:

- izvorna kodo v `src/domace/vzdevek/ImeNaloge.jl`
- testi v `test/domace/vzdevek/ImeNaloge.jl`, ki so vključeni v `test/runtests.jl`
- kratek dokument z opisom rešitve v `doc/src/domace/vzdevek/ImeNaloge.md` in „praktičnim“ primerom uporabe (slikice prosim :-)).

Po lastni presoji, lahko rešitev vsebuje tudi več drugih datotek. Vsaka funkcija
naj tudi vsebuje
[docstring](https://docs.julialang.org/en/v1/manual/documentation/) z opisom
funkcije.

## Naloga

### Pasovne diagonalno dominantne matrike

[Pasovna matrika](https://sl.wikipedia.org/wiki/Pasovna_matrika) je matrika, ki
ima neničelne elemente le v glavni diagonali in v nekaj stranskih diagonalah ob
glavni diagonali. Matrika je diagonalno dominantna po vrsticah, če za vse $i$
velja

```math
|a_{ii}|\ge\sum_{j\not=i}|a_{ij}|.
```

Definirajte podatkovni tipe

- `PasovnaMatrika`, ki predstavlja pasovno matriko,
- `ZgornjePasovnaMatrika`, ki predstavlja zgornje trikotno pasovno matriko in
- `SpodnjePasovnaMatrika`, ki predstavlja spodnje trikotno pasovno matriko

Podatkovni tipi naj hranijo le neničelne elemente matrike. Za omenjene
podatkovne tipe definirajte metode za naslednje funkcije:

- indeksiranje: `Base.getindex`,`Base.setindex!` in `Base.size`. Podatkovni tipi naj
  ustrezajo vmesniku [AbstractArray](https://docs.julialang.org/en/v1/manual/interfaces/#man-interface-array-1), da lahko do elementov dostopamo s sintaksno `A[i,j]`.
- množenje z desne `Base.*` z vektorjem
- „deljenje“ z leve `Base.\`
- `lu`, ki izračuna LU-razcep brez pivotiranja, če je matrika diagonalno
   dominantna, sicer pa javi napako. Vrnjena faktorja naj bosta tipa `SpodnjePasovnaMatrika` in `ZgornjePasovnaMatrika`.

Časovna zahtevnost omenjenih funkcij naj bo linearna (odvisna od širine pasu).
Več informacij o [tipih](https://docs.julialang.org/en/v1/manual/types/) in
[vmesnikih](https://docs.julialang.org/en/v1/manual/interfaces/).

Za primer rešite sistem za [Laplaceovo matriko v 2D](../vaje/2_linearni_sistemi/03_minimalne_ploskve.md).
