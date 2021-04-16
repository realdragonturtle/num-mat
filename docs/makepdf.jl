using Documenter, DocumenterLaTeX, NumMat

makedocs(
    modules = [NumMat],
    doctest = false,
    format = LaTeX(),
    checkdocs = :exports,
    sitename = "Nummat na FRI",
    pages = [
             "Domov" => "index.md",
             "Uvod" => [
               #"vaje/1_uvod/01_koren.md",
               #"vaje/1_uvod/02_pi.md",
                       ],
             "Linearni sistemi" => [
                #"vaje/2_linearni_sistemi/02_tridiagonalni_sistemi.md",
                #"vaje/2_linearni_sistemi/03_minimalne_ploskve.md",
                #"vaje/2_linearni_sistemi/04_iteracijske_metode.md",
                #"vaje/2_linearni_sistemi/05_implicitne_ploskve.md",
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
    repo = "https://gitlab.com/nummat/vaje-nummat/blob/{commit}{path}#{line}"
)
