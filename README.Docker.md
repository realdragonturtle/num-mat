# Vodič za pripravo Docker okolja

Docker omogoča pripravo virtualnega sistema, ki ga je mogoče enostavno deliti in prenašati med razičnimi računalniki. V tem repozitoriju je tudi Dockerfile, ki opisuje okolje za delo z julio in paketom NumMat.

## Priprava Docker okolja

Da zgradimo Docker posnetek (Docker image), poženemo ukaz v imeniku, kjer je datoteka `Dockerfile`

```
docker build .
```

Nato lahko program julia poženemo v pripravljenem okolju (Docker image) z ukazom

```
docker run 

```

## Priprava Docker slike za Gitlab CI

Da skrajšamo pripravo okolja za testiranje in generiranje dokumentacije na [Gitlab CI](https://docs.gitlab.com/ee/ci/), je dobro pripraviti docker sliko z nameščenimi knjižnicami in jo objaviti v
[Gitlab Docker registry](https://docs.gitlab.com/ee/user/packages/container_registry/).

Sliko lahko pripravimo z ukazom

```
docker build -t registry.gitlab.com/nummat/vaje-nummat:latest .
```

in jo nato potisnemo na [Gitlabov imenik slik](https://docs.gitlab.com/ee/user/packages/container_registry/)

```
docker push registry.gitlab.com/nummat/vaje-nummat:latest
```

### Prijava v Gitlab Docker Registry

Preden sliko potisnemo na Gitlabov imenik, se moramo prijaviti. Najprej si ustvarimo [osebni žeton za dostop](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html). Nato pa se prijavimo v imenik

```
docker login
```