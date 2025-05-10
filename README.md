# Baza de Date Parfumuri

Acesta este un proiect pentru dezvoltarea unei baze de date dedicate gestionării informațiilor despre parfumuri, similar cu platforma Fragrantica. Baza de date urmărește gestionarea detaliilor despre parfumuri, branduri, specialiști, ingrediente, note, recenzii, concursuri și stocuri în magazine.

## Funcționalități:
- **Gestionarea parfumurilor**: Stocarea informațiilor despre parfumuri, inclusiv numele, data lansării, descrierea și genul parfumului. Fiecare parfum este asociat unui singur brand.
- **Informații despre branduri**: Fiecare parfum este asociat cu un brand, iar brandurile pot avea mai multe parfumuri.
- **Ingrediente**: Fiecare parfum poate conține mai multe ingrediente. Ingrediente esențiale precum „apă” și „alcool” sunt obligatorii pentru fiecare parfum.
- **Notele parfumurilor**: Parfumurile sunt descrise prin note olfactive, care includ longevitatea și intensitatea.
- **Recenzii utilizatori**: Utilizatorii pot lăsa recenzii și pot acorda ratinguri parfumurilor.
- **Concursuri**: Parfumurile pot participa la diverse concursuri, iar baza de date salvează locurile câștigate și datele de participare.
- **Magazine și stocuri**: Se gestionează disponibilitatea parfumurilor în diverse magazine, precum și stocurile acestora.

## Descrierea entităților din baza de date

### Tabelele bazei de date:
1. **Parfumuri**: Informații despre parfumuri, inclusiv asocierea cu brandurile și ingredientele.
2. **Branduri**: Detalii despre brandurile asociate parfumurilor.
3. **Ingrediente**: Ingrediente utilizate în parfumuri, inclusiv originea și alergenii acestora.
4. **Note**: Notele olfactive ale parfumurilor, inclusiv categoria (vârf, mijloc, bază), longevitatea și intensitatea.
5. **Specialiști**: Date despre parfumierii care au contribuit la crearea parfumurilor.
6. **Concursuri**: Detalii despre concursurile de parfumuri și premiile acordate.
7. **Magazine**: Informații despre magazinele care vând parfumuri și stocurile disponibile.
8. **Utilizatori**: Informații despre utilizatori, inclusiv datele de înregistrare și parolele criptate.
9. **Recenzii**: Recenzii ale utilizatorilor pentru fiecare parfum.

### Exemple de relații între tabele:
- **Parfumuri** și **Ingrediente**: Un parfum poate conține mai multe ingrediente, iar un ingredient poate fi folosit în mai multe parfumuri (relație M:N).
- **Parfumuri** și **Concursuri**: Un parfum poate participa la mai multe concursuri (relație M:N).
- **Parfumuri** și **Magazine**: Un parfum poate fi disponibil în mai multe magazine (relație M:N).
- **Utilizatori** și **Parfumuri**: Utilizatorii pot evalua parfumurile și pot adăuga recenzii (relație M:N).

## Tehnologii utilizate
- **MySQL**: Sistem de gestionare a bazelor de date relaționale (RDBMS) folosit pentru implementarea bazei de date.
- **MySQL Workbench**: Folosit pentru crearea și administrarea bazei de date.
- **Proceduri stocate**: Implementate pentru validarea datelor și automatizarea diverselor operațiuni, cum ar fi inserarea recenziilor, validarea ingredientelor și concursurilor.


