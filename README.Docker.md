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

