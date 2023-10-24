class Ohjelmoija {
    constructor(nimi, kieli, suuntautuminen, tietokanta, arvosanat) {
        this.nimi = nimi;
        this.kieli = kieli;
        this.suuntautuminen = suuntautuminen;
        this.tietokanta = tietokanta;
        this.arvosanat = arvosanat || []; // Oletuksena tyhjä lista, voit antaa sen luodessa tai myöhemmin
    }

    // Lisää arvosana arvosanojen listaan
    lisaaArvosana(arvosana) {
        this.arvosanat.push(arvosana);
    }

    // Laske arvosanojen keskiarvo
    laskeKeskiarvo() {
        if (this.arvosanat.length === 0) {
            return 0; // Palauta 0, jos arvosanoja ei ole
        }

        const summa = this.arvosanat.reduce((acc, arvosana) => acc + arvosana, 0);
        const keskiarvo = summa / this.arvosanat.length;
        return keskiarvo;
    }
}

// Luodaan ohjelmoijia
const ohjelmoija1 = new Ohjelmoija("John Doe", "JavaScript", "full stack", "MongoDB", [4, 5, 3]);
const ohjelmoija2 = new Ohjelmoija("Jane Smith", "Python", "backend", "PostgreSQL");

// Lisätään arvosanoja
ohjelmoija1.lisaaArvosana(5);
ohjelmoija2.lisaaArvosana(4);
ohjelmoija2.lisaaArvosana(3);
ohjelmoija1.lisaaArvosana(2);
ohjelmoija2.lisaaArvosana(5);

// Lasketaan ja tulostetaan keskiarvot
console.log(ohjelmoija1.nimi + " keskiarvo: " + ohjelmoija1.laskeKeskiarvo());
console.log(ohjelmoija2.nimi + " keskiarvo: " + ohjelmoija2.laskeKeskiarvo());