# Uitleg over de recepten API
De API die in deze app wordt gebruikt bevat alle recepten van de Albert Heijn website. (Zo'n 16000 recepten) Hier kun je op de volgende manier doorheen lopen.

## /search
#### Zoeken op titel:
*De parameter `q` is altijd verplicht.*
```
http://reciper.janerik.net/search?q=salade
```

#### Paginator:
*De resultaten 101-120 weergeven.*
```
http://reciper.janerik.net/search?q=salade&s=100&n=20
```

#### Filteren:
*Een voorgerecht uit de oven, met alcohol en het mag niet langer dan 65 minuten duren.*
```
http://reciper.janerik.net/search?q=&dish=voorgerecht&tags=oven,alcohol&max_timing=65
```
## /single/:id
#### Geef recept met ID:
````
http://reciper.janerik.net/single/5a547ca65c73afc96811117f
````
*Bij een niet correct gegeven ID krijg je de volgende melding:*
```JSON
{
   "error": "not valid"
}
```
*of*
```JSON
{
   "error": "not found"
}
```


## Voorbeeld recept
Op dit moment wordt in zowel `/single` als in `/search` het complete recept terug gegeven. Dit wordt nog aangepast zodat `/search` alleen de basisinformatie terug geeft en dus een stuk sneller wordt geladen bij traag internet.

```
GET http://reciper.janerik.net/single/5a547ca65c73afc96811117f
```

```
{
  "_id": "5a547ca65c73afc96811117f",
  "title": "Lauwwarme saffraanrijstsalade met rivierkreeftjes",
  "big_image": "https://static.ah.nl/static/recepten/img_001330_1600x560_JPG.jpg",
  "dish-type": "hoofdgerecht",
  "id": "10036",
  "ingredients": [
    {
      "data-additional-info": "165 g",
      "default-label": "1 zakje Risotto alla Milanese (165 g)",
      "description-plural": "",
      "description-singular": "Risotto alla Milanese",
      "quantity": "1",
      "quantity-unit-plural": "zakjes",
      "quantity-unit-singular": "zakje",
      "search-term": "Risotto alla Milanese"
    },
    ...
  ],
  "kitchenappliances": [],
  "nutrition": {
    "calories": "485 kcal",
    "carbohydrateContent": "79 g",
    "fatContent": "8 g",
    "proteinContent": "24 g"
  },
  "preperation": [
    "Let op! Je wijkt af van het aantal personen waarvoor dit recept ontwikkeld is. Bereiding, video, kook- en oventijden en keukenspullen kunnen hierdoor ook afwijken. Lees de tips"
  ],
  "serving-details": {},
  "servings": "2 personen",
  "small-image": "https://static.ah.nl/static/recepten/img_001330_445x297_JPG.jpg",
  "tags": [
    "italiaans",
    "koken"
  ],
  "timing": [
  {
    "amount": 20,
    "type": "bereiden"
  },
  {
    "amount": 30,
    "type": "oven"
  }
  ],
  "total-time": 20,
  "url": "https://ah.nl/allerhande/recept/R-R10036/lauwwarme-saffraanrijstsalade-met-rivierkreeftjes"
}
```

## ToDo
- [x] Scrappen van alle recepten
- [x] Server opzetten
- [x] Enkel resultaat teruggeven via API
- [x] Zoeken via de API
- [ ] Filteren op gerecht, tag en bereidingstijd
- [ ] BUG: Updaten van sommige gerechten die verkeerde bereidingsomschrijving geven


