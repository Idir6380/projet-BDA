-- Supprimer l'utilisateur SQL3
DROP USER SQL3 CASCADE;

-- Supprimer le tablespace SQL3_TBS
DROP TABLESPACE SQL3_TBS INCLUDING CONTENTS AND DATAFILES; 

-- Supprimer le tablespace temporaire SQL3_TempTBS
DROP TABLESPACE SQL3_TempTBS INCLUDING CONTENTS AND DATAFILES;

------2-------
CREATE TABLESPACE SQL3_TBS DATAFILE 'C:/Users/idirb/OneDrive/Bureau/table_space/sql3_TBS.dat' SIZE 100M AUTOEXTEND ON;


CREATE TEMPORARY TABLESPACE SQL3_TempTBS TEMPFILE 'C:/Users/idirb/OneDrive/Bureau/table_space/sql3_temp_TBS.dat' SIZE 100M AUTOEXTEND ON;

------3-------
CREATE USER SQL3 IDENTIFIED BY 6380 DEFAULT TABLESPACE SQL3_TBS TEMPORARY TABLESPACE SQL3_TempTBS;

------4-------
GRANT ALL PRIVILEGES TO SQL3;

CONNECT SQL3/6380;

SHOW USER;
