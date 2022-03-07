# # Linearni sistemi enačb
# 
# Rešujemo linearni sistem enačb $A x = b$ z LU razcepom
# ```math
#   x + y -2z = 1
#   x -y + z = 2
#   2x -2z = 3
# ```
#
# Za reševanje sistema z računalnikom, je najbolje prikladno, če sistem prevedemo v matrično 
# obliko:
# ```math
#   Ax = b,
# ```
# kjer je $A$ matrika sistema, $b$ je vektor desnih strani, $x$ pa vektor spremenljivk, ki jih 
# iščemo

A = [1 1  -2; 1 -1 1; 2 0 -2] 

# Numerično lahko poiščemo rešitev sistema na različne načine:
# 
# * z gaussovo eliminacijo razširjene matrike in obratnim vstavljanjem
# * z LU razcepom in nato z direktnim in obratnim vstavljanjem
# * z množenjem z inverzno matriko (ni priporočljivo)
# * z iterativnimi metodami
# * ...
#
# !!! note "LU razcep lahko uporabimo namesto inverza!"
#       
#       Z LU razcepom lahko povsem nadomestimo potrebo po računanju inverzne matrike. 
#       Faktorja $L$ in $U$ iz razcepa lahko uporabimo, da učinkovito implementiramo
#       operacije, ki jih sicer formalno zapišemo z inverzom matrike. Najbolj uporabna je 
#       operacija množenja z inverzno matriko. Računanje produkta $x = A^{-1}b$ je ekvivalentno
#       iskanju rešitve sistema $Ax = b$. Če poznamo LU razcep matrike $A$, lahko enako učinkovito 
#       rešimo sistem $Ax = LUx = b$, kot če bi poznali inverz matrike $A^{-1}$ in računali produkt 
#       inverzne matrike z vektorjem.
#
# !!! note "Oprator deljenja z leve"
#       Rešitev sistema $Ax = b$ lahko formalno zapišemo kot $x = A^{-1}b$. 
#       Množenje z inverzom je ekvivalentno deljenju s številom (formalno deljenje definiramo kot 
#       množenje z inverznim elementom). Ker pa matrično množenje ni komutativno (v splošnem $AB \not= BA$),
#       moramo razlikovati med množenjem z inverzom z leve strani in množenjem z inverzom z desne 
#       strani. Tako lahko definiramo dve operaciji matričnega deljenja. Deljenje z matriko z desne
#       deljenje z matriko z leve. Za deljenje z leve uporabimo operator `\`:
#       ```math
#           A\b := A^{-1}b.        
#       ```
#
# Poglejmo si, kako uporabimo LU razcep za reševanje sistema linearnih enačb.
# V programskem jeziku *julia* je LU implementiran v knjižnici
using LinearAlgebra

# LU razcep izračunamo s funkcijo `lu`:
L, U, p = lu(A)

# !!! note "Podakovni tip za LU razcep matrike"
#       Julia pozna poseben podatkovni tip za LU razcep matrike, ki shrani razcep v kompaktni obliki
#       in ga lahko uporabimo z operatorjem `\` za reševanje sistema.
#
# Da bi rešili sistem, definiramo še vektor desnih strani linearnih enačb:
b = [1, 2, 3] 

# rešimo sistem
x = U \ (L \ b[p])

# Preverimo rezultat
A*x - b

# Če uporabimo rezultat LU razcepa v kompaktni obliki (kot vrednost tipa LU), lahko uporabimo
# operator `\` direktno z vektorjem desnih strani, saj *julia* uporabi specializirano metodo 
# prilagojeno prav za podatkovni tip `LU`. 
F = lu(A)

x = F\b

# Preverimo, če je dobljena rešitev zadošča prvotnemu sistemu enačb
A*x - b

# ## Razlika med `A\b` in `F\b` (oziroma `U\(L\b[p])`?

x = A\b
A*x - b

# Razlika med A\b in F\b je v časovni zahtevnosti. Reševanje splošnega sistema je o(n^3), 
# medtem, ko je reševanje sistema, če poznamo LU razcep le o(n^2).
