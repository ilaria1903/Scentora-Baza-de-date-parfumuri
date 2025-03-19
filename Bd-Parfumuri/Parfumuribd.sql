-- Crearea bazei de date
CREATE DATABASE p;
USE p;

-- 1. Tabelul Branduri
CREATE TABLE Branduri (
    ID_Brand INT AUTO_INCREMENT PRIMARY KEY,
    NUME_BRAND VARCHAR(50) UNIQUE NOT NULL,
    TIP_BRAND VARCHAR(50),
    TARA_ORIGINE VARCHAR(50),
    DATA_INFIINTARE DATE
);

-- 2. Tabelul Specialiști
CREATE TABLE Specialisti (
    ID_Specialist INT AUTO_INCREMENT PRIMARY KEY,
    ID_Brand INT NOT NULL,
    NUME_Specialist VARCHAR(50) NOT NULL,
    PRENUME_Specialist VARCHAR(50) NOT NULL,
    EMAIL VARCHAR(100) UNIQUE NOT NULL,
    PHONE VARCHAR(20) UNIQUE,
    EXPERIENTA INT CHECK (EXPERIENTA >= 0),
    FOREIGN KEY (ID_Brand) REFERENCES Branduri(ID_Brand) ON DELETE CASCADE
);

-- 3. Tabelul Utilizatori
CREATE TABLE Utilizatori (
    ID_Utilizator INT AUTO_INCREMENT PRIMARY KEY,
    NUME_Utilizator VARCHAR(50) NOT NULL,
    PRENUME_Utilizator VARCHAR(50) NOT NULL,
    EMAIL VARCHAR(100) UNIQUE NOT NULL,
    PHONE VARCHAR(20) UNIQUE,
    PAROLA VARCHAR(64) NOT NULL CHECK (LENGTH(PAROLA) >= 8),
    DATA_INREGISTRARE DATE NOT NULL DEFAULT (CURDATE())
);

-- 4. Tabelul Parfumuri
CREATE TABLE Parfumuri (
    ID_Parfum INT AUTO_INCREMENT PRIMARY KEY,
    NUME_PARFUM VARCHAR(50) UNIQUE NOT NULL,
    DATA_LANSARE DATE NOT NULL,
    GEN VARCHAR(50),
    DESCRIERE VARCHAR(255),
    ID_Brand INT NOT NULL,
    FOREIGN KEY (ID_Brand) REFERENCES Branduri(ID_Brand) ON DELETE CASCADE
);

-- 5. Tabelul Ingrediente
CREATE TABLE Ingrediente (
    ID_Ingredient INT AUTO_INCREMENT PRIMARY KEY,
    NUME_INGREDIENT VARCHAR(50) NOT NULL,
    ORIGINE VARCHAR(50),
    CATEGORIE VARCHAR(50),
    ALERGENI VARCHAR(255)
);

-- 6. Tabelul Parfumuri_Ingrediente (relație M:N)
CREATE TABLE Parfumuri_Ingrediente (
    ID_Parfum INT,
    ID_Ingredient INT,
    PRIMARY KEY (ID_Parfum, ID_Ingredient),
    FOREIGN KEY (ID_Parfum) REFERENCES Parfumuri(ID_Parfum) ON DELETE CASCADE,
    FOREIGN KEY (ID_Ingredient) REFERENCES Ingrediente(ID_Ingredient) ON DELETE CASCADE
);

-- 7. Tabelul NoteParfumuri
CREATE TABLE NoteParfumuri (
    ID_Nota INT AUTO_INCREMENT PRIMARY KEY,
    NUME_NOTA VARCHAR(50) NOT NULL,
    CATEGORIE_NOTA VARCHAR(50) NOT NULL,
    LONGEVITATE INT CHECK (LONGEVITATE BETWEEN 1 AND 5),
    INTENSITATE VARCHAR(10) NOT NULL CHECK (INTENSITATE IN ('Slabă', 'Medie', 'Puternică'))
);

-- 8. Tabelul Parfumuri_Note (relație M:N)
CREATE TABLE Parfumuri_Note (
    ID_Parfum INT,
    ID_Nota INT,
    PRIMARY KEY (ID_Parfum, ID_Nota),
    FOREIGN KEY (ID_Parfum) REFERENCES Parfumuri(ID_Parfum) ON DELETE CASCADE,
    FOREIGN KEY (ID_Nota) REFERENCES NoteParfumuri(ID_Nota) ON DELETE CASCADE
);

-- 9. Tabelul Concursuri
-- Tabelul Concursuri fără constrângerea CHECK care validează relația dintre date
CREATE TABLE Concursuri (
    ID_Concurs INT AUTO_INCREMENT PRIMARY KEY,
    NUME_CONCURS VARCHAR(50) NOT NULL,
    DATA_INCEPERE DATE NOT NULL,
    DATA_SFARSIT DATE NOT NULL,
    PREMIU VARCHAR(100)
);

-- 10. Tabelul Concursuri_Parfumuri (relație M:N)
CREATE TABLE Concursuri_Parfumuri (
    ID_Concurs INT,
    ID_Parfum INT,
    LOC_CASTIGAT INT CHECK (LOC_CASTIGAT > 0),
    DATA_PARTICIPARE DATE NOT NULL,
    PRIMARY KEY (ID_Concurs, ID_Parfum),
    FOREIGN KEY (ID_Concurs) REFERENCES Concursuri(ID_Concurs) ON DELETE CASCADE,
    FOREIGN KEY (ID_Parfum) REFERENCES Parfumuri(ID_Parfum) ON DELETE CASCADE
);

-- 11. Tabelul MagazineParfumuri
CREATE TABLE MagazineParfumuri (
    ID_Magazin INT AUTO_INCREMENT PRIMARY KEY,
    NUME_MAGAZIN VARCHAR(50) NOT NULL,
    ADRESA VARCHAR(255),
    ORAS VARCHAR(50),
    TARA VARCHAR(50),
    STOC_DISPONIBIL INT CHECK (STOC_DISPONIBIL >= 0)
);

-- 12. Tabelul Parfumuri_MagazineStoc (relație M:N)
CREATE TABLE Parfumuri_MagazineStoc (
    ID_Parfum INT,
    ID_Magazin INT,
    STOC_DISPONIBIL INT CHECK (STOC_DISPONIBIL > 0),
    PRIMARY KEY (ID_Parfum, ID_Magazin),
    FOREIGN KEY (ID_Parfum) REFERENCES Parfumuri(ID_Parfum) ON DELETE CASCADE,
    FOREIGN KEY (ID_Magazin) REFERENCES MagazineParfumuri(ID_Magazin) ON DELETE CASCADE
);

-- 13. Tabelul Recenzii
CREATE TABLE Recenzii (
    ID_Rating INT AUTO_INCREMENT PRIMARY KEY,
    ID_Utilizator INT,
    ID_Parfum INT,
    NR_STELE INT CHECK (NR_STELE BETWEEN 1 AND 5),
    DATA_RATING DATE NOT NULL,
    FOREIGN KEY (ID_Utilizator) REFERENCES Utilizatori(ID_Utilizator) ON DELETE CASCADE,
    FOREIGN KEY (ID_Parfum) REFERENCES Parfumuri(ID_Parfum) ON DELETE CASCADE,
    UNIQUE (ID_Utilizator, ID_Parfum)
);



DELIMITER //

-- Procedură pentru validarea și inserarea unui rating
CREATE PROCEDURE ValidateAndInsertRating(
    IN v_ID_Rating INT,
    IN v_ID_Utilizator INT,
    IN v_ID_Parfum INT,
    IN v_NR_STELE INT,
    IN v_DATA_RATING DATE
)
BEGIN
    DECLARE v_User_Exists INT;
    DECLARE v_Parfum_Exists INT;

    -- Verifică dacă utilizatorul există
    SELECT COUNT(*) INTO v_User_Exists
    FROM Utilizatori
    WHERE ID_Utilizator = v_ID_Utilizator;

    -- Verifică dacă parfumul există
    SELECT COUNT(*) INTO v_Parfum_Exists
    FROM Parfumuri
    WHERE ID_Parfum = v_ID_Parfum;

    -- Trimite eroare dacă utilizatorul nu există
    IF v_User_Exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Utilizatorul specificat nu există.';
    END IF;

    -- Trimite eroare dacă parfumul nu există
    IF v_Parfum_Exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Parfumul specificat nu există.';
    END IF;

    -- Inserează ratingul dacă validările au trecut
    INSERT INTO Recenzii (ID_Rating, ID_Utilizator, ID_Parfum, NR_STELE, DATA_RATING)
    VALUES (v_ID_Rating, v_ID_Utilizator, v_ID_Parfum, v_NR_STELE, COALESCE(v_DATA_RATING, CURDATE()));
END;
//
DELIMITER ;


DELIMITER //


-- Procedură pentru validarea datei de participare în cadrul unui concurs
CREATE PROCEDURE ValidateDataParticipare(
    IN v_ID_Concurs INT,
    IN v_DATA_PARTICIPARE DATE
)
BEGIN
    DECLARE v_DATA_INCEPERE DATE;
    DECLARE v_DATA_SFARSIT DATE;

    SELECT DATA_INCEPERE, DATA_SFARSIT INTO v_DATA_INCEPERE, v_DATA_SFARSIT
    FROM Concursuri
    WHERE ID_Concurs = v_ID_Concurs;

    IF v_DATA_PARTICIPARE < v_DATA_INCEPERE OR v_DATA_PARTICIPARE > v_DATA_SFARSIT THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: DATA_PARTICIPARE trebuie să fie între DATA_INCEPERE și DATA_SFARSIT.';
    END IF;
END;
//

-- Procedură pentru validarea și inserarea unui concurs-parfum
CREATE PROCEDURE ValidateAndInsertConcursParfum(
    IN v_ID_Concurs INT,
    IN v_ID_Parfum INT,
    IN v_LOC_CASTIGAT INT,
    IN v_DATA_PARTICIPARE DATE
)
BEGIN
    DECLARE v_DATA_INCEPERE DATE;
    DECLARE v_DATA_SFARSIT DATE;

    SELECT DATA_INCEPERE, DATA_SFARSIT INTO v_DATA_INCEPERE, v_DATA_SFARSIT
    FROM Concursuri
    WHERE ID_Concurs = v_ID_Concurs;

    IF v_DATA_PARTICIPARE < v_DATA_INCEPERE OR v_DATA_PARTICIPARE > v_DATA_SFARSIT THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: DATA_PARTICIPARE trebuie să fie între DATA_INCEPERE și DATA_SFARSIT.';
    END IF;

    IF v_LOC_CASTIGAT <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: LOC_CASTIGAT trebuie să fie mai mare decât 0.';
    END IF;

    INSERT INTO Concursuri_Parfumuri (ID_Concurs, ID_Parfum, LOC_CASTIGAT, DATA_PARTICIPARE)
    VALUES (v_ID_Concurs, v_ID_Parfum, v_LOC_CASTIGAT, v_DATA_PARTICIPARE);
END;
//

-- Procedură pentru validarea și inserarea unui parfum
CREATE PROCEDURE ValidateAndInsertParfum(
    IN v_ID_Parfum INT,
    IN v_NUME_PARFUM VARCHAR(50),
    IN v_DATA_LANSARE DATE,
    IN v_GEN VARCHAR(50),
    IN v_DESCRIERE VARCHAR(255),
    IN v_ID_Brand INT
)
BEGIN
    DECLARE v_Brand_Exists INT;

    SELECT COUNT(*) INTO v_Brand_Exists
    FROM Branduri
    WHERE ID_Brand = v_ID_Brand;

    IF v_Brand_Exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Brandul specificat nu există.';
    END IF;

    IF v_DATA_LANSARE > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: DATA_LANSARE nu poate fi în viitor.';
    END IF;

    INSERT INTO Parfumuri (ID_Parfum, NUME_PARFUM, DATA_LANSARE, GEN, DESCRIERE, ID_Brand)
    VALUES (v_ID_Parfum, v_NUME_PARFUM, v_DATA_LANSARE, v_GEN, v_DESCRIERE, v_ID_Brand);
END;
//

DELIMITER ;



ALTER TABLE Parfumuri_Note
ADD CONSTRAINT fk_parfumuri_note
FOREIGN KEY (ID_Parfum) REFERENCES Parfumuri(ID_Parfum)
ON DELETE CASCADE;

ALTER TABLE Parfumuri_Ingrediente
ADD CONSTRAINT fk_parfumuri_ingrediente
FOREIGN KEY (ID_Parfum) REFERENCES Parfumuri(ID_Parfum)
ON DELETE CASCADE;


DELIMITER //

CREATE PROCEDURE ValidateParfumIngredients(
    IN v_ID_Parfum INT
)
BEGIN
    DECLARE v_Count INT;
    DECLARE v_Apa_Count INT;
    DECLARE v_Alcool_Count INT;

  IF EXISTS (SELECT 1 FROM Parfumuri WHERE ID_Parfum = v_ID_Parfum) THEN
    SELECT COUNT(*) INTO v_Count
    FROM Parfumuri_Ingrediente
    WHERE ID_Parfum = v_ID_Parfum;

    IF v_Count < 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Un parfum trebuie să aibă cel puțin 3 ingrediente.';
    END IF;
END IF;

    SELECT COUNT(*) INTO v_Apa_Count
    FROM Parfumuri_Ingrediente PI
    JOIN Ingrediente I ON PI.ID_Ingredient = I.ID_Ingredient
    WHERE PI.ID_Parfum = v_ID_Parfum AND LOWER(I.NUME_INGREDIENT) = 'apă';

    SELECT COUNT(*) INTO v_Alcool_Count
    FROM Parfumuri_Ingrediente PI
    JOIN Ingrediente I ON PI.ID_Ingredient = I.ID_Ingredient
    WHERE PI.ID_Parfum = v_ID_Parfum AND LOWER(I.NUME_INGREDIENT) = 'alcool';

    IF v_Apa_Count = 0 OR v_Alcool_Count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Un parfum trebuie să conțină obligatoriu ingredientele "apă" și "alcool".';
    END IF;
END //

DELIMITER ;








update ID_brand from branduri  set ID_Brand=ID_brand+10  where lower(tara_origine)='Franţa' ;




cardinalitate gresite la bradn specialisti si 2 minimalitati inversaye

