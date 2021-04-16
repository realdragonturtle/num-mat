# Automatsko odvajanje

```@meta
CurrentModule = NumMat
DocTestSetup  = quote
    using NumMat
end
```

V grobem poznamo 3 načine, kako lahko odvajamo funkcije z računalnikom

* simbolično odvajanje
* numerično odvajanje z končnimi diferencami
* avtomatsko odvajanje programske kode

Tokrat se bomo posvetili [avtomatskemu odvajanju](https://en.wikipedia.org/wiki/Automatic_differentiation). 
Programi 

## Avtomatsko odvajanje z dualnimi števili

Avtomatično odvajanje lahko implementiramo tako, da realna števila razširimo s
posebnim elementom $\varepsilon$, za katerega velja $\varepsilon\not=0$ in
$\varepsilon^2=0$. Tako dobimo množico [dualnih
števil](https://en.wikipedia.org/wiki/Dual_number), podobno kot dobimo množico
kompleksnih številih, če realna števila razširimo z imaginarno enoto. 

!!! note "Dualna števila"

    **Dualna števila** so elementi oblike $a+b\varepsilon$, pri čemer sta $a$ in $b$ poljubni realni števili. 
    Z dualna števili računamo kot z navadnimi binomi, le da upoštevamo, da je $\varepsilon^2=0$. Tako je
    produkt dveh dualnih števil enak
    ```math
    (a+b\varepsilon)(c+d\varepsilon) = ac + (ad+bc)\varepsilon + bd\varepsilon^2,
    ```
    ker pa je $\varepsilon^2=0$, dobimo naslednje pravilo za produkt
    ```math
    (a+b\varepsilon)(c+d\varepsilon) = ac + (ad+bc)\varepsilon.
    ```
    Podobno lahko izpeljemo pravilo za deljenje, oziroma inverz
    
    ```math
    \frac{1}{a+b\varepsilon} = \frac{a-b\varepsilon}{(a+b\varepsilon)(a-b\varepsilon)} = \frac{1}{a} - \frac{b}{a^2}\varepsilon
    ```

    Za izpeljavo pravila za potenciranje z naravnimi števili, si pomagamo s potenco binoma

    ```math
    (a+b\varepsilon)^n = a^n + \binom{n}{n-1}a^{n-1}b\varepsilon + \varepsilon^2(\ldots...) = a^n + n a^{n-1}b\varepsilon,
    ```
    za racionalne in realne potence, lahko uporabimo binomsko vrsto, za potence, kjer 
    nastopa $\varepsilon$ v eksponentu, pa bi potrebovali potenčno vrsto za funkcijo $e^x$.


Dualna števila lahko izkoristimo za računanje odvodov. Z dualnimi števili se
namreč računa podobno kot z diferenciali oziroma z linearnim delom Taylorjeve
vrste imenovanim tudi [1-tok (1-jet)](https://en.wikipedia.org/wiki/Jet_(mathematics)).
Poglejmo si primer produkta dveh 1-tokov za dve funkciji v neki točki $x_0$

```math
\left(f(x_0) + f'(x_0)dx\right)\left(g(x_0) + g'(x_0)dx\right) = f(x_0)g(x_0) + (f(x_0)g'(x_0)+f'(x_0)g(x_0))dx + O(dx^2).
```

Vse potence $dx^k$ za $k>1$, lahko potisnemo v člen $O(dx^2)$ oziroma jih
zanemarimo. Diferencial $dx$ se tako obnaša enako kot element $\varepsilon$. Dualna števila
imajo isto aritmetiko kot 1-tokovi funkcij v neki točki $x_0$. To dejstvo izkoristimo 
za računanje odvoda. 

## Implementacija dualnih števil v programskem jeziku julia

Definirali bomo podatkovno strukturo `Dual` za dualna števila in osnovne aritmetične operacije za to strukturo.

Poleg tega bomo definirali funkcijo `odvod(f, x)`, ki izračuna odvod funkcije v dani točki.

Obe funkciji preiskusimo na primeru funkcije, ki računa kvadratni koren z Newtonovo metodo.

```julia
function koren(x)
    y = 1+(x-1)/2 # Taylor
    for i=1:100
      y = (y + x/y)/2
    end
    return y
end
```

## Koda

```@index
Pages = ["11_quadnD.md"]
```

```@docs
DualNumber
odvod
```