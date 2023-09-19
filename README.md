# NodeHarjoituksia
Web-palvelinten toimintaan liittyviä esimerkkejä toteutettuna Node.js kirjaston avulla

## Tietokanta ja näkymät
Luodaan näkymä, joka laskee edellisen kuukauden hinnan keskiarvon, normaalihinnan ala- ja ylärajat keskihajonnan perusteella. Jaetaan vaatimukset tehtäviksi tyyliin:

1. Selvitä kuluva kuukausi
2. Laske, mikä on edellisen kuukauden numero
3. Tee kysely, joka laskee tarvittavat keskiarvot ja keskihajonnat
4. Määrittele rajoittava ehto kuukaudelle ja vuodelle (tämän vuoden edellinen kuukausi)
5. Muokkaa kyselyä siten, että se laskee ala- ja ylärajat(keskihinta +/- keskihajonta)
6. Muuta näkymäksi, joka hyödyntää month_lookup-taulua.

Luodaan näkymä, joka näyttää tiedot edelliseltä vuodelta, mutta kuluvalta kuukaudelta.

## Mikropalvelu datan hakemiseen ja tallentamiseen
Node.js palvelin voi tehdä ajastettuja toimintoja. Selvitä, mitä kirjastoja voisi käyttää tähän tarkoitukseen.
Luodaan palvelu, joka lukee päivittäin klo 15.30 sähkön pörssihinnat ja tallentaa ne tietokantaan. Jos ei onnistu, yritetään uudelleen tunnin kuluttua.