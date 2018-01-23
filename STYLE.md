# Styleguide

### Comments
- Bovenaan elke file je naam en de copyright
- Geef bovenaan elke functie een korte omschrijving wat de functie doet

### Code
- Classes worden PascalCase geschreven
- Methods en variabelen zijn camelCase geschreven
- Bij elke `if`-statement/`for`-loop of andere methode moeten de openingsbrackets op dezelfde regels geschreven worden.
- Niet meer dan 100 tekens op één regel
- Gebruik altijd het `self`-object bij gebruik van variabelen en methods binnen een class voor extra duidelijkheid
- Maak niet teveel geneste `if` statements. Gebruik `guard` waar nodig.
- Vermijdt rondehaken zoveel als mogelijk. In `if`-statements zijn niet verplicht.

### Structuur
- Houdt models en ViewController functionaliteiten gescheiden van elkaar. Zorg bijvoorbeeld dat je geen Firebase specifieke functies binnen de controller aanroept.
- Scheidt alle `ViewControllers`, `Models`, `Entities`, `Views` en `Application` files gescheiden van elkaar in losse folders.
