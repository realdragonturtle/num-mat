# Aproksimacija z linearnim modelom

## Linearni model

V znanosti pogosto želimo opisati odvisnost dveh količin npr. kako se
spreminja koncentracija $\mathrm{CO}_2$ v odvisnosti od časa.
Matematičnemu opisu povezave med dvema ali več količinami pravimo
**matematični model**. Primer modela je Hookov zakon za vzmet, ki pravi,
da je sila vzmeti $F$ sorazmerna z raztezkom $x$: $$F=k x$$ Model
povezuje dve količini silo $F$ in raztezek $x$. Poleg tega Hookov zakon
vpelje še koeficient vzmeti $k$. Koeficientu $k$ pravimo **parameter
modela** in ga lahko določimo za vsako vzmet posebej z meritvami sile in
raztezka.

Najpreporstejši je **linearni model**, pri katerem odvisno količino $y$
zapišemo kot linearno kombinacijo baznih funkcij $\phi_j(x)$ neodvisne
spremenljivke $x$:

```math
\begin{equation}
  y(x) = M(p,x) = p_1\phi_1(x) + p_2\phi_2(x) + \ldots + p_k \phi_k(x).
\end{equation}
```

Koeficientom $p_j$ pravimo parametri modela in jih določimo na podlagi
meritev. Znanstveniki hočejo model, pri katerem imajo parametri $p_i$
preprosto interpretacijo in pomagajo pri razumevanju pojava, ki ga
opisujejo. Zato so bazne funkcije pogosto elementarne funkcije, pri
katerih je jasno razvidna narava odvisnosti.

### Metoda najmanjših kvadratov

Koeficiente modela, ki najbolje opisujejo izmerjene podatke lahko
poiščemo z metodo najmanjših kvadratov. Napišemo najprej pogoje, ki bi
jim zadoščali parametri, če bi izmerjeni podatki povsem sledili modelu.
Za vsako meritev $y_i=y(x_i)$ bi bila vrednost odvisne količine $y_i$
natanko enaka vrednosti, ki jo predvidi model $M(p,x_i)$. To
predpostavko lahko zapišemo s sistemom enačb

```math
\begin{equation}\label{eq:sistem}
y_i = M(p, x_i) = p_1\phi_1(x_i)+\ldots p_k\phi_k(x_i)
\end{equation}
```

Neznanke v zgornjem sistemu so parametri $p_j$ in za **linearni model**
so enačbe linearne. To je tudi ena glavnih prednosti linearnega modela.
Meritve redko povsem sledijo modelu, zato sistem \eqref{eq:sistem} v
splošnem ni rešljiv, saj je meritev običajno več kot je parametrov
sistema. Sistem \eqref{eq:sistem} je **predoločen**. Lahko pa poiščemo
vrednosti parametrov $p_j$ pri katerih bo razlika med meritvami in
modelom kar se da majhna. Izkaže se, da je najboljša mera za odstopanje
modela od podatkov kar vsota kvadratov razlik med meritvami in napovedjo
modela:

```math
\begin{equation}
\label{eq:minkvad}
(y_1-M(p,x_1))^2+\ldots + (y_n-M(p,x_n))^2 = \sum_{i=1}^n (y_i + M(p,x_i))^2
\end{equation}
```

Sistem (\ref{eq:sistem}) lahko zapišemo v matrični obliki
$$A\mathbf{p} = \mathbf{y},$$ kjer so stolpci matrike sistema enaki
vrednostim baznih funkcij 

```math
A = \begin{bmatrix}
\phi_1(x_1) & \phi_2(x_1) & \ldots &\phi_k(x_1)\\
\phi_1(x_2) & \phi_2(x_2) & \ldots &\phi_k(x_2)\\
\vdots & \vdots & \ddots &\vdots \\
\phi_1(x_n) & \phi_2(x_n) & \ldots &\phi_k(x_n)\\
\end{bmatrix}
```

in stolpec desnih strani je enak meritvam

```math
\mathbf{y} = [y_1,y_2,\ldots, y_n]^\mathsf{T}.
```

Pogoj najmanjših kvadratov razlik (\ref{eq:minkvad})
za optimalne vrednosti parametrov $\mathbf{p}_{opt}$ lahko sedaj
zapišemo s kvadratno vektorsko normo

```math
\begin{equation}
\mathbf{p}_{opt} = \mathrm{argmin}_{\mathbf{p}} \left\|A\mathbf{p}-\mathbf{y}\right\|_2^2.
\end{equation}
```

## Opis sprememb koncentracije CO2

Na observatoriju [Mauna Loa](http://www.esrl.noaa.gov/gmd/obop/mlo/) na
Hawaiih že leta spremljajo koncentracijo $\mathrm{CO}_2$ v ozračju. Podatke lahko dobimo na njihovi spletni strani v različnih oblikah. Oglejmo si tedenska povprečja od začetka maritev leta 1974

```@example co2
using FTPClient
url = "ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_weekly_mlo.txt"
io = download(url)
data = readlines(io)
```

Nato odstranimo komentarje in izluščimo podatke

```@example co2
using Plots
filter!(l->l[1]!='#', data)
data = strip.(data)
data = [split(line, r"\s+") for line in data]
data = [[parse(Float64, x) for x in line] for line in data]
filter!(l->l[5]>0, data)
t = [l[4] for l in data]
co2 = [l[5] for l in data]
scatter(t, co2, title="Atmosferski CO2 na Mauna Loa", 
        xlabel="leto", ylabel="parts per milion (ppm)", label="co2",
        markersize=1)
```

Časovni potek koncentracije $\mathrm{CO}_2$ matematično opišemo kot funkcijo
koncentracije v odvisnosti od časa

```math
\begin{equation}
  y=\mathrm{CO}_2(t).
\end{equation}
```

Model, ki dobro opisuje spremembe $\mathrm{CO}_2$ lahko sestavimo iz
kvadratne funcije, ki opisuje naraščanje letnih povprečij in
periodičnega dela, ki opiše nihanja med letom:

```math
\begin{equation}
  \label{eq:model}
\mathrm{CO}_2(t)= p_1 + p_2 t +p_3t^2+p_4\sin(2\pi t)+p_5\cos(2\pi t).
\end{equation}
```

Čas $t$ naj bo podan v letih. Predoločeni sistem (\ref{eq:sistem}), ki
ga dobimo za naš model ima $n\times 5$ matriko sistema

```math
A = \begin{bmatrix}
1 & t_1 & t_1^2 & \sin(2\pi t_1) & \cos(2\pi t_1)\\
1 & t_2 & t_2^2 & \sin(2\pi t_2) & \cos(2\pi t_2)\\
\vdots & \vdots & \vdots &\vdots &\vdots\\
1 & t_n & t_n^2 & \sin(2\pi t_n) & \cos(2\pi t_n)\\
\end{bmatrix}
```
desne strani pa so vrednosti koncentracij. 

### Normalni sistem

Po metodi najmanjših kvadratov iščemo vrednosti parametrov $p$ modela, pri katerih bo vsota kvadratov razlik med napovedjo modela in izmerjenimi vrednostmi najmanjša. Zapišimo vsoto kvadratov kot evklidsko normo razlike med vektorjem napovedi modela $Ap$ in vektorjem izmerjenih vrednosti $y$. Iščemo torej vektor parametrov $p$, pri katerem  bo

```math
\|Ap-y\|^2
```

najmanjša. Iščemo torej pravokotno projekcijo vektorja $y$ na stolpčni prostor matrike $A$, katere stolpci so podani kot vrednosti baznih funkcij, ki nastopajo v modelu.

```math
\begin{eqnarray}
Ap-y \perp C(A)\cr
A^T(Ap-y) = 0\cr
A^TAp=A^Ty
\end{eqnarray}
```
Tako dobimo normalni sistem $A^TAp=A^Ty$, ki je kvadraten in je vedno rešljiv, če so le bazne funkcije modela linearno neodvisne (izračunane v izmerjenih vrednostih neodvisne spremenljivke).

```@example co2
using LinearAlgebra
A = hcat(ones(size(t)), t, t.^2, cos.(2pi*t), sin.(2pi*t))
N = A'*A # hide
b = A'*co2 # hide
p = N\b # hide
norm(A*p-co2)
```

Problem normalnega sistema je, da je zelo občutljiv

```@example co2
cond(N), cond(A)
```
Pravzaprav je že sama matrika $A$ zelo občutljiva. Razlog je v izbiri baznih funkcij. Če narišemo normirane stolpce $A$ kot funkcije, vidimo, da so zelo podobni.

```@example co2
plot([A[:,1]/norm(A[:,1]), A[:,2]/norm(A[:,2]), A[:,3]/norm(A[:,3])], ylims=[0,0.025], title="Normirani stolpci matrike A")
```

Težavo lahko omilimo tako, da časa ne štejemo od začetka našega štetja, pač pa od sredine podatkov.

```@example co2
τ = sum(t)/length(t) # hide
A = hcat(ones(size(t)), t.-τ, (t.-τ).^2, cos.(2pi*t), sin.(2pi*t)) # hide
cond(A)
```

Matrika $A$ je sedaj precej dlje od singularne matrike in posledično je tudi normalni sistem manj občutljiv.

### QR razcep

Normalni sistem se redko uporablja v praksi. Standarden postopek za iskanje rešitve predoločenega sistema z metodo najmanjših kvadratov je s QR razcepom. Če je $QR=A$ QR razcep matrike $A$, so stolpci matrike $Q$ ortonormirana baza stolpčnega prostora matrike $A$, matrika $R$ vsebuje koeficiente v razvoju stolpcev matrike $A$ po ortonormirani bazi določeni s $Q$. Projekcija na stolpčni prostor ortogonalne matrike še lažje izračunamo, saj lahko koeficiente izračunamo s skalarnim produktom s stolpci $Q$. Matrično skalarni produkt s stolpci matrike pomeni množenje z transponirano matriko.

```math
\begin{eqnarray*}
A = QR
Rp = Q^Ty
\end{eqnarray*}
```

```@example co2
F = qr(A) # hide
Q = Matrix(F.Q) # hide
p = F.R\(Q'*co2) # hide
norm(A*p-co2)
```

Na isti način deluje tudi vgrajen operator `\`, če je matrika dimenzij $n\times k$ in $k < n$.

```@example co2
p = A\co2
norm(A*p-co2) 
```

## Kaj pa CO2?

Koncentracije CO2 se vztrajno povečuje. Kot kaže naš model, je naraščanje kvadratično in ne le linearno. To pomeni, da ne le, da se vsako leto poveča koncentracija, pač pa se vsako leto poveča za večjo vrednost.

```@example co2
p
```

Koeficient $p_1$ pove povprečno koncentracijo na sredini merilnega obdobja. Medtem ko odvod $p_2+2p_3(t-\tau)$ pove za koliko se v povprečju spremeni koncentracija v enem letu.

```@example co2
plot(t, p[2].+2*p[3]*(t.-τ), title="Letne spremembe CO2")
```

Lahko poskusimo tudi napovedati prihodnost:

```@example co2
model(t) =  p[1]+ p[2]*(t-τ) + p[3]*(t-τ)^2 + p[4]*cos(2*pi*t) + p[5]*sin(2*pi*t)
model.([2020, 2030, 2050])
```

!!! tip "Kaj smo se naučili"

    * Linearni model je opis, pri katerem **parametri nastopajo linearno**
    * Parametre modela poiščemo z **metodo najmanjših kvadratov**
    * Za iskanje parametrov po metodi najmanjših kvadratov je numerično najbolj primeren 
      **QR-razcep**.
    * koncentracija CO2 prav zares narašča