# Kako sodelovati pri predmetu Numerična matematika
Martin Vuk <martin.vuk@fri.uni-lj.si>

Ta repozitorij je namenjem zbiranju gradiv in izdelavi domačih nalog 
pri predmetu Numerična matematika. Želimo si, da skupaj ustvarimo lepo urejen in 
zaokrožen repozitorij z vsemi gradivi, ki jih bomo ustvarili na vajah in z 
domačimi nalogami. Zato ste vsi študenti, ki ste vpisani na ta predmet vabljeni, 
da se pridružite temu projektu in sodelujete pri tem.

## Laboratorijske vaje
Na laboratorijskih vajah bomo iskali ravnotežje med razlago na tablo in 
programiranjem asistenta in samostojnim delom študentov. Vaje bodo 
(upam) uravnotežena mešanica:
 
 * razlage na tablo
 * programiranja na projektorju
 * nekaj samostojnega programiranja

!!! note

     Del svojih obveznosti lahko študent opravi že na vajah, če za naloge, ki 
     jih bomo reševali na vajah, izdela rešitev in poda zahtevo za združitev 
     (*merge request*).

## Domače naloge/sprotno delo

Domače naloge oziroma sprotno delo bo potekalo sodelovalno. To pomeni, da bomo 
skupaj razvijali knjižnico numeričnih funkcij v tem repozitoriju. Poleg tega 
naj bi vsak študent naredil eno nalogo v svojem repozitoriju. 

Za pozitivno oceno naj bi študent prispeval več stvari v eni od naslednjih 
oblik:

 - rešitve domačih nalog v obliki *zahteve za združitev(merge request)*
 - pregled rešitev domačih nalog svojih kolegov
 - sodelovanje na vajah
   - pisanje kode
   - pisanje dokumentacije
   - pisanje testov
 - sodelovanje preko zaznamkov (issues)

Ocena se določi na podlagi kvalitete prispevkov
 
  - na oceno vplivajo le dobri prispevki, če kdo kdaj pošlje kakšno neumnost, 
     se mu to ne šteje v minus
  - ko študent zbere dovolj prispevkov, mu asistent dodeli oceno
  - ocena se lahko le še popravi z bolj kvalitetnimi prispevki

## Kako oddati domačo nalogo
Domače naloge oddajte kot 
[zahtevo za združitev (merge request)](https://gitlab.com/help/user/project/merge_requests/index.md). 
Spodaj je zelo na kratek opis, kako to naredite. Predpostavljam, da ste vsaj malo
vešči z orodjem [git](https://git-scm.com/).

Seznam opravil za domačo nalogo:

 -  odprete zahtevek
 -  pripravite [zahtevo za združitev](https://gitlab.com/help/user/project/merge_requests/index.md)
 -  napišete kodo, teste in dokumentacijo
 -  povabite kolega za pregled
 -  ko vaš kolega potrdi vašo nalogo, povabite še asistenta za pregled
 -  asistent združi vašo vejo v master (ali pa vas pošlje na 3. korak

### Odpiranje zahtevka

### Zahteva za združitev (merge request)

### Delo z izvorno kodo z Git-om

 - najprej si na svojem računalniku ustvarite klon repozitorija

```
git clone https://gitlab.com/nummat/nummat-2122.git
cd nummat-2122
```

 - nato ustvarite novo 
 [vejo](https://gitlab.com/help/user/project/repository/branches/index.md)

```
git branch nickname-dn1
git checkout nickname-dn1
```
!!! note

    Zahtevo za združitev in vejo lahko enostavno ustvarite s klikom na gumb 
    `Create merge request`, ko ustvarite zahtevek v gitlabu. 


 - nalogo rešite in sproti spremembe z `git commit` beležite v repozitorij.
 - nalogo prenesete na strežnik z ukazom `git push`

```
git push origin nickname-dn1
```

### Merge request na Gitlab
Ko ste svojo rešitev dokončali in jo uspešno prenesli na gitlab, lahko ustvarite 
[merge request](https://gitlab.com/nummat/nummat-1718/merge_requests/new). 
Za *source* izberete svojo vejo, za *target* pa vejo `master`.

!!! note

    Bolj podroben opis načina dela z git in gitlab je opisan v 
    [dokumentu o načinu dela(workflow)](workflow.md).

## Viri

- [priporočila za Gitlab](https://docs.gitlab.com/ee/workflow/gitlab_flow.html)
  - [11 pravil za Gitlab](https://about.gitlab.com/2016/07/27/the-11-rules-of-gitlab-flow/)
- [Kako v kodo dodamo licenco](https://reuse.software/)
- [Stil pisanja kode - Octave](https://wiki.octave.org/Octave_style_guide)
- [Stil pisanja kode - julia](https://docs.julialang.org/en/v1/manual/style-guide/#Style-Guide-1)
- [Sodelovalni urejevalnik za  Markdown](https://hackmd.io)
