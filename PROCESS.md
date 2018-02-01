# Process:
### Weekend:
Besloten om niet automatisch ingrediënten toe te voegen, maar handmatig, omdat dit fijn is voor de gebruiker voor mee controle. Kost wel een extra scherm.

### Day 3:
Selecteer huishouden werkend gekregen.
Keuze gemaakt om currentHousehold op device op te slaan ipv in Firebase. Geen callback, dus minder latency/complexity.

### Day 4:
Planner toegevoegd

### Day 5:
-

### Day 6:
Besloten om een EventEmitter te implementeren om de change in de currentHousehold bij te houden. Mooi pattern om dit soort dingen mee te checken binnen het complete systeem. (Handig bij planner/boodschappenlijstje voor weergeven huidige huishouden)

### Day 7:
Keuze gemaakt om bij het opruimen van je boodschappenlijstje de items ook direct te verwijderen. Dit is niet aan te raden als het gaat om databehoud en analyse, maar in dit geval maakt dat het een stuk eenvoudiger en sneller als je later veel boodschappen aan je lijstje hebt toegevoegd. Dit is vooral handig, omdat op dit moment de done/undone direct via firebase wordt gedaan. Dus als er veel data moet worden opgehaald is de done/undone traag en dat willen we niet. Ik heb dit op deze manier gedaan omdat dit op dit moment een stukje makkelijker is. :)

### Day 8:
Besloten om het delen van huishoudens heel simpel te houden. Als iemand vanuit een huishouden een gebruiker toevoegt, dan wordt deze automatisch aan de gebruikers huishoudens toegevoegd. Zonder accepteren. Dit kan later altijd worden toegevoegd, maar voor nu is dit oke.

### Day 10:
Veel aan UI gedaan. Vooral in de planner en favoriete recepten. Waarbij ik heb besloten om toch voor een duidelijke button met tekst te gaan om aan de planner of de boodschappenlijst toe te voegen. Deze is nu duidelijk klikbaar.
