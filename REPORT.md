# Short description
Reciper probeert gebruikers te motiveren om weekboodschappen te doen. Dit doet reciper door een receptenplanner aan te bieden, zodat je een duidelijk overzicht hebt van wat je wanneer wilt eten. Op basis daarvan kun je zeer eenvoudig een boodschappenlijstje maken.

![](docs/boodschappen.png)

# Technical design
## Componenten
In de app wordt gebruik gemaakt van verschillende soorten classes die zijn ondergebracht in verschillende mappen.
* __Application directory:__ Onder deze map staan alle storyboards van de app
* __ViewControllers:__ Elk screen in de main.storyboard bevat een custom ViewController. Hiervanuit wordt de logica tussen de database en de interface gemaakt. Ook is de map van de ViewControllers weer opgedeeld in mappen voor elke onderdeel van de app.
* __Entities:__ In deze classes wordt alle data opgeslagen die zijn ingeladen vanuit de database of opgehaald wordt vanuit de API.
* __Models:__ In deze classes staat de logica om te communiceren met de database en de API. In deze classes wordt rauwe data uit de database omzet in entities. Deze extra laag maakt de ViewControllers een stuk kleiner en helpt met DRY.
* __Views:__ Hier staat custom UI elementen in, zoals een custom TableCell of een custom UIButton.
* __Library:__ Hierin staan een aantal helper functies die herhaalde logica verwijdert uit de ViewControllers.

## Recipes
Onder de recepten tab in de App vallen de volgende ViewControllers:
* FavoritesTableViewController: De begin pagina met daarin alle favoriete recepten (In een custom FavoriteRecipeViewCell cell) bij elk recept kan men klikken op "Toevoegen aan planner". Op basis van waar de gebruiker vandaan komt gaat de gebruiker naar "AddToPlannerTableViewController" of terug naar het planner hoofdscherm. Ook is er een knop naar "RecipeResultsTableViewController". Ook kun je de recepten verwijderen door naar rechts te swipen.
* RecipeResultsTableViewController: De ViewController geeft alle resultaten van de opgehaalde API calls weer. "RecipeAPIModel". Bovenaan de pagina staat een zoekbalk en update de resultaten automatisch op basis van de gegeven zoekterm. Ook wordt "scrollViewDidScroll" gebruikt om te kijken of je onderaan de pagina bent en laadt hij automatisch nieuwe recepten van de API als dit nodig is. De recepten worden met een grote afbeelding weer en op basis van de custom RecipesResultsTableViewCell cell.
* RecipeViewController: Dit is de view van een enkel recept. Hierin worden alle ingredienten weergegeven binnen een kleine TableView en daaronder alle voorbereidingen uitgeschreven. Daarnaast is er ook een button die dezelfde functionaliteit heeft als de "Toevoegen aan planner" button van "FavoritesTableViewController". Ook staat er rechtsbovenaan een button waarmee je het recept als favoriet kunt toevoegen.

## Planner
* PlannerTableViewController: Dit is de planner view waarin alle recepten worden weergegeven die zijn toegevoegd aan de planner. Elke section is een nieuwe datum en daaronder worden alle recepten van die dag weergegeven. (Custom cell: PlannerRecipeTableViewCell) Elk recept bevat een button "Toevoegen aan boodschappen". Hiermee wordt "AddGroceriesFromRecipeTableViewController" aangeroepen. Ook is onderaan al deze recepten van de dag een button met "Recept toevoegen". Deze button leidt naar "FavoritesTableViewController", maar stelt een datum in, zodat als jij op "Toevoegen aan planner" drukt hij meteen terug gaat naar de planner en de datum gebruikt waarbij jij op "Recept toevoegen" hebt gedrukt. Ook kun je oneindig doorscrollen naar onder doordat hij steeds nieuwe sections aanmaakt, zodat je een infinite scroll krijgt. Ook kun je de recepten verwijderen door naar rechts te swipen. (Data komt van PlannerModel.allWithRecipe())
* AddToPlannerTableViewController: Als deze view wordt bereikt kom je vanaf een recept en moet hiervoor een dag worden gepland. In de tableview worden de eerst volgende 7 dagen weergegeven en daarnaast is er een 8e button "Aangepast". Als deze wordt gebruikt verschijnt er een date picker zodat je je eigen datum kunt invoeren. Als je op "Done" drukt wordt het recept toegevoegd aan de planner en verdwijnt het scherm weer.

## Groceries
* AllGroceriesTableViewController: Deze view geeft alle boodschappen van het huishouden weer. Per recept van de planner is er een sectie met ingredienten en bovenaan staat de sectie eigen boodschappen, zodat je ook eigen boodschappen kunt toeveogen. (Onderaan deze sectie staat ook een tekstveld zodat je je boodschappen kunt toevoegen. Als je op gereed klikt in het toetsenbord wordt de boodschap toegevoegd. Bij "Gereed" van een leeg tekstveld verdwijnt alleen het keyboard. Door middel van AllGroceriesTableViewController.textFieldShouldReturn()) Elke keer als een boodschap wordt aangeklikt wordt deze gedaan/niet gedaan getoggled. Als de boodschap gedaan is staat er een dikke streep door de tekst heen. Door middel van de button opruimen worden alle boodschappen die zijn gedaan verwijdert uit Firebase en hou je een leeg scherm over. (AllGroceriesTableViewController.pressedCleaning()) Daarnaast kun je ook op Huishouden drukken om tussen huishoudens te wisselen. "CurrentHouseholdTableViewController". Ook kun je de boodschappen verwijderen door naar rechts te swipen.
* AddGroceriesFromRecipeTableViewController: 

## Settings
* SettingsTableViewController: Een pagina met de optie om snel van huishouden te wisselen "CurrentHouseholdTableViewController" of om alle huishoudens te bekijken "AllHouseholdsTableViewController". Ook kun je vanaf hier op de button logout drukken zodat je uitlogt en naar het inlog scherm gaat.
* CurrentHouseholdTableViewController: Op deze pagina kan simpel worden gekozen welk huishouden geladen moet worden. Als men op een huishouden drukt wordt deze gewijzigd door middel van UserModel.setCurrentHousehold().
* NewHouseholdViewController: In deze view is alleen een eenvoudige tekstveld en een add button. Zolang de gebruiker tekst in het tekstveld heeft ingevoegd wordt deze naam gebruikt om een nieuw huishouden aan te maken.
* AllHouseholdsTableViewController: Hierop worden alle huishoudens weergegeven van de huidige gebruiker. UserModel.allHouseholds(). Als men op het huishouden klikt gaat men naar "SharedWithHouseholdTableViewController". Daarnaast is er een add knop die naar "NewHouseholdViewController" leidt.
* SharedWithHouseholdTableViewController: Hier worden alle gebruikers weergegeven die zijn toegevoegd aan het huishouden. Er staat een plus knop die leidt naar "AddUserToHouseholdViewController"
* AddUserToHouseholdViewController: Net als bij NewHouseholdViewController is er een enkel tekstveld. Hierin kun je een email adres toevoegen. Deze wordt in het database gecheckt. Als deze gevonden is verandert de controleerbutton is een toevoeg button en druk je daar op, dan wordt de gebruiker van dat email adres automatisch toegevoegd aan je huishouden.

## Login
* LoginViewController: De loginview bevat 2 knoppen naar Facebook of naar Google. Beide zorgen ervoor dat je via de desbetreffende provider kunt inloggen in Firebase. Zodra je de login hebt afgehandeld wordt via de AppDelegate.application de app weer geopend en wordt je ingelogd in Firebase. Zodra dit gebeurd schuift de view naar beneden en komt de app beschikbaar.


## Belangrijke data classes:
*All deze data classes hebben een callback en degene waarbij Firebase gemoeid is. (Alle behalve RecipeAPI) Zullen ook een parameter once? hebben om te vragen of je ze eenmalig wilt ophalen of constant wil monitoren op wijzigingen.*
#### RecipeAPI
- search(term, dishType?, tags?, maxTime?) : SearchRecipeResults
- get(api_id/SmallRecipe) : FullRecipe
- fetchImage(img_url/FullRecipe/SmallRecipe)

#### RecipeModel
*Moet dit model ook locaal recepten bijhouden voor sneller laden?*
- get(id/PlannerEntity) : SmallRecipe
- add(SmallRecipe)
- remove(id/SmallRecipe)
- getMany(idarray) : [SmallRecipe]

#### GrocceryModel
- get(id) : GrocceryEntity
- getByRecipe(id/SmallRecipe) : [GrocceryEntity]
- allCustom() : [GrocceryEntity]
- add(GrocceryEntity)
- addByRecipe(FullRecipe)
- done(GrocceryEntity)
- undone(GrocceryEntity)
- update(GrocceryEntity, options)
- remove(GrocceryEntity)

#### PlannerModel
- create(PlannerEntity)
- move(newDate, PlannerEntity)
- getByDate(date) : [PlannerEntity]
- getDateBetween(date1, date2) : [PlannerEntity]
- getInDays(inNdays) : [PlannerEntity]

#### HouseholdModel
- allWithAccess() : [HouseholdEntity]
- removeUser(HouseholdEntity, User)
- addUser(HouseholdEntity, User)
- allUsers(HouseholdEntity)
- add(HouseholdEntity)

#### UserModel
- current() : UserEntity
- searchWithEmail(email) : UserEntity
- getCurrentHousehold()
- setCurrentHousehold(Household)
- addHouseholdChanger() // add een callback die je aanroept als er een huishouden wordt gewisseld

#### FavoritesModel
- all()
- add(FavoriteEntity)
- remove(FavoriteEntity)

## Database:
*Hieronder zijn alle tabellen voor de app uitgeschreven. In de app zal ook elke tabel als entity class geschreven worden.*
#### Groceries /groceries/:household/:grocery_id (Elk recept en zijn groceries of zelf toegevoegd)
- Title
- PlannerID?
- RecipeID?
- Done

#### Recipes /recipes/:household (SmallRecipe)
*Basisinformatie van het recept, zodat niet steeds de API aangeroepen hoeft te worden*
- API_ID
- Title
- Subtitle
- DishType
- Tags
- TotalTime
- ServingsAmount
- SmallImage (URL)

#### Planners /planner/:household/:date/:planner_id
- Date
- RecipeID

#### Households /households
- Title
- Users

#### Users /users
- HouseholdIDs

#### Favorites /favorites/:user_id/:recipe_id
Voor elk recept is de value true

#### EmailCheckEntity /emails
* Op basis van deze tabel kan gezocht worden naar users om deze toe te voegen aan je huishouden.
- key: email
- value: user ID

## API's en frameworks:
Voor de synchronisatie van de planner en de boodschappenlijst gebruik ik Firebase.

Voor het ophalen van recepten gebruik ik een zelfgeschreven API. Deze API heeft alle recepten van de Alber Heijn site gehaald en bevat zo'n 16000 recepten om doorheen te zoeken. Zie [API.md](docs/API.md) voor alle details

#### SearchRecipeResultsEntity
- results (FullRecipe array)
- searched (zoekterm)
- started (Hoeveel resultaten zijn overgeslagen)

#### SmallRecipeEntity
- id
- Title
- Subtitle
- DishType
- Tags
- TotalTime
- ServingsAmount
- SmallImage (URL)

#### FullRecipe (extends SmallRecipe)
*Deze class moet alle informatie over het recept bevatten zodat de individuele pagina van het recept gevuld kan worden. Al deze informatie hoeft niet opgeslagen te worden in Firebase en kan worden opgehaald vanuit de API.*
- API_ID
- Title
- Subtitle
- DishType
- Tags
- TotalTime
- ServingsAmount
- SmallImage (URL)
- Ingredienten (FullIngredient)
- Preperations (Array)

#### FullIngredient
*Voor nu alleen simpel ingredient, maar API biedt uitgebreidere informatie over het ingredient voor bijvoorbeeld aantal porties aanpassen.*
- Titel

# Challenges
De grootste uitdaging bleek het implementeren van huishoudens. Je wilt makkelijk kunnen switchen tussen huishoudens en daarna ook de planner en de boodschappenlijst updaten op basis daarvan. Toen ik de huishoudens later heb ingebouwd bleek dat ik een soort listener in mijn ViewControllers moest aanbrengen om rekening te houden met deze aanpassing van huishouden zodat hij naar een ander path gaat luisteren.

Daarnaast bleek het ook lastig als ik van gebruiker wisselde. Bij het opstarten van de app sloeg de app standaard deze gebruiker op en crashte hij als je uitlogde. Door ook weer listeners te gebruiken of de gebruiker was ingelogd of niet kon dit alsnog worden voorkomen. Dit zelfde principe heb ik toegepast bij de boodschappenlijst aangezien deze al wordt geladen op het moment dat de gebruiker niet is ingelogd.

Een belangrijke keuze die ik gemaakt heb is dat ik in de viewOnLoad() al alle data inlaad en deze blijf observen. Dit heb ik gedaan om de snelheid van de app te bevorderen. Op dit moment is dit op een hele simpele manier gedaan en elke keer als er een wijziging is wordt de complete data herladen. Als ik hier meer tijd voor zou hebben zou ik dit anders doen en dit opdelen in losse functies als updateDeleted() en updateAdded() om losse elementen te herladen. Het voordeel hiervan is dat je bijvoorbeeld bij het toevoegen van data veel betere animaties kan doen. (Nu verdwijnt de cell zeer abrupt als je hem verwijdert) Ook dit een stuk sneller werken als je een tragere telefoon hebt of trager internet. (Aangezien er veel meer data over internet moet worden opgehaald)

Een andere keuze die ik heb gemaakt is het opsplitsen van ViewControllers en Models. Dit maakt het programmeren binnen de ViewControllers een stuk overzichtelijker en kun je de model functies veel beter hergebruiken. Zo gebruik ik vrij vaak de functie RecipeModel.getMany() om meerdere recepten op te halen.

## Important changes
* Geen automatische toevoeging aan boodschappenlijstje. Dit om de controle van gebruikers te vergroten. Gebruikers willen zelf controle hebben.
* Huidige huishouden wordt niet meer in Firebase opgeslagen, maar lokaal om snelheid van het ophalen van data te vergroten. Snelheid is belangrijk.
* Omdat Firebase niet goed in WHERE (SQL) statements is, heb ik gekozen om bij het opruimen van de boodschappenlijst, de data ook werkelijk te verwijderen. Als er meer tijd is, kan dit ook worden aangepast naar een aparte tabel met opgeruimde items.
