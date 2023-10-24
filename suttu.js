// Joukko
// Joukko voidaan luoda vakioksi, koska itse joukkoa ei muuteta, ainoastaan sen alkioita

// const nerds = new Set(); // Luodaan joukko Set-luokan avulla
// nerds.add('Jonne'); // Lisätään alkio joukkoon
// nerds.add('Jakke');
// nerds.add('Calle');
// nerds.add('Jonne'); // Jonnea ei lisätä, koska hän on jo joukossa
// console.log(nerds); // Set(3) { 'Jonne', 'Jakke', 'Calle' }
// nerds.delete('Calle'); // Poistetaan Calle

// // Luodaan funktio, jolla käsitellään joukon jäsentä
// // Funktio tarvitsee kaksi argumenttia, indeksin ja joukon
// function callNames(index) {
//   console.log('You bloody nerd', index); // Haukutaan yksittäistä alkiota
// }

// // Käytetään joukon forEach-metodia, jolle annetaan argumentiksi callback-funtio
// nerds.forEach(callNames); // Nimitellään kaikkia joukon jäseniä vuorotellen
// nerds.clear(); // Tyhjennetään joukko
// console.log(nerds); // Set(0) {}

// Avain-arvo-parit eli sanakirjat luodaan Map-luokasta
const contactInfo = new Map();
contactInfo.set('givenname', 'Jonne'); // Asetetaan avain ja arvo
contactInfo.set('surname', 'Janttari');
contactInfo.set('age', 17);

console.log(contactInfo); //Map(3) { 'givenname' => 'Jonne', 'surname' => 'Janttari', 'age' => 17 }

// Haetaan tietoja avainten perusteella
console.log(
  contactInfo.get('givenname'),
  'is',
  contactInfo.get('age'),
  'years old'
);
