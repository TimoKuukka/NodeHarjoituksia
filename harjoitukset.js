// ====================================================================================
//                               JAVASCRIPT HARJOITUKSIA
// ====================================================================================

/* HARJOITUS 1 - YKSINKERTAISET TIETOTYYPIT
Tallennamme tietoja henkilöstä. Mieti, mitkä tiedot ovat muuttuvia ja mitkä pysyviä ja 
päätä sen perusteella, millä komennolla määrittelet muuttujan.
- Pituus (pysyvä)
- Paino (muuttuva)
- Syntymäaika (pysyvä)
*/

let pituus = 175; // Let, koska pituus voi muuttua
const syntymaAika = "1990-01-01"; // const, koska syntymäaika ei muutu
let paino = 70; // Let, koska paino voi muuttua

// Voit käyttää tietoja esimerkiksi tulostamalla ne konsoliin
console.log("Henkilön pituus on " + pituus + " cm");
console.log("Henkilön syntymäaika on " + syntymaAika);
console.log("Henkilön paino on nyt " + paino + " kg");

// ====================================================================================

/* HARJOITUS 2
Haluamme tallentaa ohjelmoijasta tietoja avain-arvo-pareina:
- Nimi
- Pääasiallinen ohjelmointikieli
- Suuntautuminen: front end, back end tai full stack
- Mielitietokanta
Luo rakenne ja määrittele arvot.
*/

const ohjelmoijaTiedot = new Map();
ohjelmoijaTiedot.set('nimi', 'John Doe');
ohjelmointiKieli.set('ohjelmointiKieli', 'JavaScript');
ohjelmoijaTiedot.set('suuntautuminen', 'full stack');
ohjelmoijaTiedot.set('mielitietokanta', 'MongoDB');

// Voit käyttää tietoja Mapista
console.log("Ohjelmoijan nimi: " + ohjelmoijaTiedot.get('nimi'));
console.log("Pääasiallinen ohjelmointikieli: " + ohjelmoijaTiedot.get('ohjelmointiKieli'));
console.log("Suuntautuminen: " + ohjelmoijaTiedot.get('suuntautuminen'));
console.log("Mielitietokanta: " + ohjelmoijaTiedot.get('mielitietokanta'));

// ====================================================================================

/* HARJOITUS 3
Haluamme tallentaa useamman ohjelmoijan tiedot muuttujaan.
Mitä vaihtoehtoja on käytettävissä?
Luo mielestäsi paras rakenne.
Vektori - yksinkertainen ja helposti läpikäytävissä toistorakenteissa
Joukko - estää kaksoisarvot läpikäynti forEach-metodilla (vaatii CB-funktion)
*/

// Esimerkki vektorista
let ohjelmoijat = [
    { nimi: 'Matti', kieli: 'JavaScript', suuntautuminen: 'full stack', tietokanta: 'PostgreSQL' },
    { nimi: 'Maija', kieli: 'Python', suuntautuminen: 'full stack', tietokanta: 'MongoDB' }
    ];

// Esimerkki joukosta
const ohjelmoijat = new Set();
ohjelmoijat.add({ nimi: 'Matti', kieli: 'JavaScript', suuntautuminen: 'full stack', tietokanta: 'PostgreSQL' });
ohjelmoijat.add({ nimi: 'Maija', kieli: 'Python', suuntautuminen: 'full stack', tietokanta: 'MongoDB' });

// ====================================================================================

/* HARJOITUS 4
Määrittele luokka ohjelmoijaa varten ja tee siitä olioita vektoriin
*/

class Ohjelmoija {
    constructor(nimi, kieli, suuntautuminen, tietokanta) {
        this.nimi = nimi;
        this.kieli = kieli;
        this.suuntautuminen = suuntautuminen;
        this.tietokanta = tietokanta;
    }
}

// ====================================================================================

/* HARJOITUS 5
Muokkaa luokkaa siten, että oliolle voidaan antaa lista ammatillisten tutkinnonosien
arvosanoista numeromuodossa. Tee metodi, joka laskee näiden keskiarvon ja palauttaa sen.
*/

class Ohjelmoija {
    constructor(nimi, kieli, suuntautuminen, tietokanta, arvosanat) {
        this.nimi = nimi; // Ominaisuudella ja argumentilla voi olla eri nimi
        this.kieli = kieli; // tai ne voivat olla samannimiset
        this.suuntautuminen = suuntautuminen;
        this.tietokanta = tietokanta;
        this.arvosanat = arvosanat || []; // Oletuksena tyhjä lista, voit antaa sen luodessa tai myöhemmin
    }

    // Metodi keskiarvon laskemiseksi argumenttina annetusta arvosanalistasta
    calculateAverage(array) {
        let avg = 0; // Alustetaan keskiarvoksi 0
        let sum = 0; // Alustetaan summa 0
    

    // Käydään alkiot läpi silmukassa
    for (let index = 0; index < array.length; index++) {
        const element = array[index];
        sum += element; // Lisätään alkion arvo summaan
    }

// Luodaan ohjelmoijia
const ohjelmoija1 = new Ohjelmoija("John Doe", "JavaScript", "full stack", "MongoDB", [4, 5, 3]);
const ohjelmoija2 = new Ohjelmoija("Jane Smith", "Python", "backend", "PostgreSQL");

// Lisätään arvosanoja
ohjelmoija1.lisaaArvosana(5);
ohjelmoija2.lisaaArvosana(4);
ohjelmoija2.lisaaArvosana(3);

// Lasketaan ja tulostetaan keskiarvot
console.log(ohjelmoija1.nimi + " keskiarvo: " + ohjelmoija1.laskeKeskiarvo());
console.log(ohjelmoija2.nimi + " keskiarvo: " + ohjelmoija2.laskeKeskiarvo());

// ====================================================================================

/* HARJOITUS 6
Tee edellisen tehtävän luokasta CJS kirjasto ja anna se muiden ohjelmien käyttöön export-komennolla
Luo node.js-ohjelma, jossa luokasta luodaan 5 oliota ja tallennetaan ne vektoriin.
*/

// ohjelmoija.js

class Ohjelmoija {
    constructor(nimi, kieli, suuntautuminen, tietokanta, arvosanat) {
        this.nimi = nimi;
        this.kieli = kieli;
        this.suuntautuminen = suuntautuminen;
        this.tietokanta = tietokanta;
        this.arvosanat = arvosanat || [];
    }

    lisaaArvosana(arvosana) {
        this.arvosanat.push(arvosana);
    }

    laskeKeskiarvo() {
        if (this.arvosanat.length === 0) {
            return 0;
        }

        const summa = this.arvosanat.reduce((acc, arvosana) => acc + arvosana, 0);
        const keskiarvo = summa / this.arvosanat.length;
        return keskiarvo;
    }
}

module.exports = Ohjelmoija;


// node.js -ohjelma
// index.js

const Ohjelmoija = require('./ohjelmoija'); // Tuodaan Ohjelmoija-moduuli

// Luodaan 5 Ohjelmoija-oliota ja tallennetaan ne vektoriin
const ohjelmoijat = [
    new Ohjelmoija("John Doe", "JavaScript", "full stack", "MongoDB", [4, 5, 3]),
    new Ohjelmoija("Jane Smith", "Python", "backend", "PostgreSQL"),
    new Ohjelmoija("Alice Johnson", "Java", "full stack", "MySQL", [5, 4, 5]),
    new Ohjelmoija("Bob Williams", "C#", "frontend", "SQL Server", [3, 4, 3]),
    new Ohjelmoija("Eve Brown", "Ruby", "backend", "SQLite", [4, 4, 5])
];

// Tulostetaan ohjelmoijien tiedot ja keskiarvot
ohjelmoijat.forEach((ohjelmoija, index) => {
    console.log(`Ohjelmoija ${index + 1}:`);
    console.log("Nimi: " + ohjelmoija.nimi);
    console.log("Keskiarvo: " + ohjelmoija.laskeKeskiarvo());
    console.log("--------------");
});

