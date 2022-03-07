using Documenter, NumMat
import Literate

VAJE_JL = joinpath(@__DIR__, "..", "vaje")
VAJE_MD = joinpath(@__DIR__, "src", "vaje")
"""
      generate_markdown()

Generiraj markdown datoteke iz izvornih julia datotek z orodjem `Literate.jl`
"""
function generate_markdown()
   Literate.markdown(
      joinpath(VAJE_JL, "2_linearni_sistemi", "resevanje_lin_sistemov.jl"), 
      joinpath(VAJE_MD, "2_linearni_sistemi"), documenter = true)
end

generate_markdown()
makedocs(
    modules = [NumMat],
    doctest = false,
    format = Documenter.HTML(
        prettyurls = true,
        mathengine = Documenter.MathJax(Dict(:TeX => Dict(:equationNumbers => Dict(:autoNumber => "AMS")))),
    ),
    checkdocs = :exports,
    sitename = "Numerična matematika na FRI",
    pages = [
             "Domov" => "index.md",
             "Uvod" => [
               "vaje/1_uvod/01_koren.md",
               "vaje/1_uvod/02_pi.md",
                       ],
             "Linearni sistemi" => [
                "vaje/2_linearni_sistemi/resevanje_lin_sistemov.md",
                "vaje/2_linearni_sistemi/02_tridiagonalni_sistemi.md",
                "vaje/2_linearni_sistemi/03_minimalne_ploskve.md",
                "vaje/2_linearni_sistemi/04_iteracijske_metode.md",
                "vaje/2_linearni_sistemi/05_implicitne_ploskve.md",
             ],
             "Lastne vrednosti" => [
                "vaje/3_lastne_vrednosti/06_konj.md",
                "vaje/3_lastne_vrednosti/06_spektralno_grucenje.md",
             ],
             "Nelinearne enačbe" => [
                "vaje/4_nelinearne_enacbe/01_konvergenca.md",
                "vaje/4_nelinearne_enacbe/02_razdalja.md",
            ],
             "Interpolacija, aproksimacija" => [
                "vaje/5_interpolacija/07_zlepki.md",
                "vaje/6_aproksimacija/co2.md",
                "vaje/6_aproksimacija/08_chebfun.md",
             ],
             "Integral" => [
                "vaje/7_integral/10_quad.md",
                "vaje/7_integral/11_quadnD.md",
             ],
             "Odvod" => [
                "vaje/8_odvod/12_autodiff.md",
             ],
             "Diferencialne enačbe" => [
                "vaje/9_nde/13_lotka_volterra.md",
                "vaje/9_nde/14_perioda.md",
             ],
             "Domače naloge" => [
                "domace/1_domaca.md",
                "domace/2_domaca.md",
                "domace/3_domaca.md",
                "domace/4_domaca.md",
                "contributing.md",
                "workflow.md",
                                ],
             "Knjižnica" => [
                "lib/public.md",
                "lib/internals.md"
                            ]
            ],
    repo = "https://gitlab.com/nummat/nummat-2122/blob/{commit}{path}#{line}"
)
