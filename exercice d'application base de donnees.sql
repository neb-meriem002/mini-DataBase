DROP TABLE ETUDIANTUNITE
/
DROP TABLE UNITE
/
DROP TABLE ETUDIANT
/
DROP TABLE ENSEIGNANT
/
create table etudiant 
(
Mat_Etu int PRIMARY key, 
nom_etu varchar2(10), 
prenom_etu varchar2(10), 
date_naissance date, 
Adresse varchar2(20)
)
/
CREATE TABLE ENSEIGNANT 
(
	MATRICULE_ENS number(8) PRIMARY KEY,
	NOM_ENS VARCHAR2(20),
	PRENOM_ENS VARCHAR2(20)
)    
/
CREATE TABLE UNITE (
	CODE_UNITE VARCHAR2(10) PRIMARY KEY,
	LIBELLE VARCHAR2(20) ,
	NBR_HEURES number(3) ,
	MATRICULE_ENS number(10) ,
    CONSTRAINT FK_UNITE_ENSEIGNANT FOREIGN KEY (MATRICULE_ENS) REFERENCES ENSEIGNANT (MATRICULE_ENS)
)
/
CREATE TABLE ETUDIANTUNITE 
(
	MAT_ETU number(7) ,
	CODE_UNITE VARCHAR2(10) ,
	NOTE_CC number(4,2) ,
	NOTE_TP number(4,2) ,
	NOTE_EXAMEN number(4,2) ,
    CONSTRAINT PK_ETUDIANTUNITE PRIMARY KEY (MAT_ETU,CODE_UNITE),
	CONSTRAINT FK_ETUDIANTUNITE_ETUDIANT FOREIGN KEY (MAT_ETU) REFERENCES ETUDIANT (MAT_ETU) ON DELETE CASCADE,
	CONSTRAINT FK_ETUDIANTUNITE_UNITE FOREIGN KEY (CODE_UNITE) REFERENCES UNITE (CODE_UNITE )ON DELETE CASCADE
)
/
INSERT INTO Etudiant VALUES (202101,'BOUSSAI','MOHAMED','12/01/2003','Alger')
/
INSERT INTO Etudiant VALUES (202102,'CHAID','LAMIA', '01/10/2002','Batna')
/
INSERT INTO Etudiant VALUES (202103,'BRAHIMI','SOUAD','18/11/2003','Setif')
/
INSERT INTO Etudiant VALUES (202104,'LAMA','SAID','23/05/2003','Oran')
/
INSERT INTO Etudiant VALUES (202105,'SMAILI','ISLAM','09/09/2002','Annaba')
/
INSERT INTO Etudiant VALUES (202106,'SAOU','MERIEM','10/12/2004','Chlef')
/
-- table enseignant 
INSERT INTO Enseignant VALUES (200001,'HAROUNI','AMINE')
/
INSERT INTO Enseignant VALUES (200002,'FATHI','OMAR')
/
INSERT INTO Enseignant VALUES (200003,'BOUZIDANE','FARAH')
/
INSERT INTO Enseignant VALUES (200004,'ARABI','ZOUBIDA')
/
-- table unite
INSERT INTO Unite VALUES ( 'U01','POO',6,200001)
/
INSERT INTO Unite VALUES ('U02','BDD',6,200002)
/
INSERT INTO Unite VALUES ('U03','RESEAU',3,200004)
/
INSERT INTO Unite VALUES ('U04','SYSTEME',6,200003)
/
-- table EtudiantUnite
INSERT INTO EtudiantUnite VALUES (202101,'U01',10,15,9)
/
INSERT INTO EtudiantUnite VALUES (202102,'U01',20,13,10)
/
INSERT INTO EtudiantUnite VALUES (202104,'U01',13,17,16)
/
INSERT INTO EtudiantUnite VALUES (202106,'U01',12,14,16)
/
INSERT INTO EtudiantUnite VALUES (202102,'U02',10,16,17)
/
INSERT INTO EtudiantUnite VALUES (202103,'U02',9,8,15)
/
INSERT INTO EtudiantUnite VALUES (202104,'U02',15,9,20)
/
INSERT INTO EtudiantUnite VALUES (202105,'U03',11,12,13)
/
INSERT INTO EtudiantUnite VALUES (202101,'U04',15,12,20)
/
INSERT INTO EtudiantUnite VALUES (202102,'U04',12,18,14)
/
INSERT INTO EtudiantUnite VALUES (202103,'U04',17,12,15)
/
INSERT INTO EtudiantUnite VALUES (202104,'U04',12,13,20)
/
-- validation et sauvegarde:
COMMIT
/
select * from etudiant
/
select * from enseignant
/
select * from etudiantunite
/
--questions
--1
Select nom_etu,prenom_etu from etudiant order by nom_etu asc
/
--2
select u.libelle,count (e.CODE_UNITE) from unite u,etudiantunite e where u.CODE_UNITE=e.CODE_UNITE group by u.libelle
/
--3
SELECT CODE_UNITE,e.NOM_ETU,e.PRENOM_ETU FROM ETUDIANT e,ETUDIANTUNITE e1 WHERE e1.MAT_ETU=e.MAT_ETU AND (e1.CODE_UNITE,(e1.NOTE_CC+e1.NOTE_TP+e1.NOTE_EXAMEN*2)/4) IN (SELECT e1.CODE_UNITE,MAX((e2.NOTE_CC+e2.NOTE_TP+e2.NOTE_EXAMEN*2)/4) FROM ETUDIANTUNITE e2 GROUP BY e2.CODE_UNITE)
/
--4
select u.libelle from unite u where (SELECT COUNT(mat_etu) FROM etudiant)=(SELECT COUNT(e.mat_etu) FROM ETUDIANTUNITE e WHERE e.CODE_UNITE=u.CODE_UNITE GROUP BY u.CODE_UNITE)
/
--5
SELECT * FROM ETUDIANT e WHERE NOT EXISTS (SELECT e1.mat_etu FROM ETUDIANTUNITE e1 WHERE e1.MAT_ETU=e.MAT_ETU AND e1.NOTE_EXAMEN<15)
/
--6
SELECT e.nom_etu,e.prenom_etu FROM ETUDIANT e,unite u where e.mat_etu in (select e1.mat_etu from etudiantunite e1 group by e1.mat_etu having count(e1.NOTE_EXAMEN)=(select count(libelle) from unite ));
/
--7
SELECT e.nom_etu,e.prenom_etu FROM ETUDIANT e,unite u where e.mat_etu in (select e1.mat_etu from etudiantunite e1 group by e1.mat_etu having count(e1.NOTE_EXAMEN)=(select count(libelle) from unite )) and e.Mat_Etu not in (select e1.mat_etu from etudiantunite e1,unite u where e1.CODE_UNITE =u.CODE_UNITE and u.libelle='SYSTEME')
/
--8
SELECT * from etudiant e where e.mat_etu in (select e1.mat_etu from etudiantunite e1,unite u where e1.CODE_UNITE =u.CODE_UNITE and u.libelle='SYSTEME') and e.mat_etu in  (select e1.mat_etu from etudiantunite e1,unite u where e1.CODE_UNITE =u.CODE_UNITE and u.libelle='BDD')
/
--9
select * from etudiant e where e.mat_etu in (select e1.mat_etu from etudiantunite e1,unite u where e1.CODE_UNITE =u.CODE_UNITE and u.libelle='POO') and e.mat_etu not in (select e1.mat_etu from etudiantunite e1,unite u where e1.CODE_UNITE =u.CODE_UNITE and u.libelle!='POO')
/