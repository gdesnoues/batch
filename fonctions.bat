@ECHO off
GOTO %1
GOTO :Eof
:: ================================================================================================
:: Fonctions utilisables dans un batch
::
:: DATE             USER    DESCRIPTION
:: 08/04/2016       GD      création
:: 08/04/2016       GD      init sur GitHub
:: 08/04/2016       GD      Appel par %FicFonctions% pour avoir le batch des fonctions dans un autre dossier
:: 08/04/2016       GD      Ajout du _ à la fin du nom de la fonction pour identifier une fonction
:: ================================================================================================

:: la variable %FicFonctions% doit etre initialisée dans le batch d'origine
:: avant tout appel de la fonction CALL %FicFonctions% :NomDeLaFonction
:: SET FicFonctions=C:\votredossier\fonctions.bat



:: ===== :Entete_ =============================================================
:: affiche un entete avec les ***, titre et version
::
:: parametres
::      aucun
::
:: valeur de retour
::      aucun
::
:: exemple d'appel :
::      CALL %FicFonctions% :Entete_
:: ============================================================================
:Entete_
SET LigneBarre=%LigneBarre:"=%
ECHO %LigneBarre%
ECHO %LigneTitre%
ECHO %LigneVersion%
ECHO %LigneBarre%
ECHO:
goto :Eof



:: ===== :CheckError_ =========================================================
:: affiche la fenetre en vert si %2 est = 0 sinon affiche en rouge
::
:: parametres
::      %2 : variable du nombre d'erreur (ex: %NbError%)
::
:: valeur de retour
::      aucun
::
:: exemple d'appel :
::      CALL %FicFonctions% :CheckError_ %NbError%
:: ============================================================================
:CheckError_
ECHO Nb erreur : %2
IF %2 GTR 0 (
    color C0
) ELSE (
    color A0
)
GOTO :Eof



:: == :CopyFic_ ===============================================================
:: copy un fichier d'un dossier vers un autre
::
:: parametres
::      %2 : dossier du fichier à copier
::      %3 : dossier de destination
::      %4 : nom du fichier à copier
::      %5 : nom du fichier de destination
::
:: valeur de retour
::      %NbError% : incrementé par la fonction
::
:: exemple d'appel :
::      CALL %FicFonctions% :CopyFic_ "%DirOrigine%" "%DirDestination%" "%FicOrigine%" "%FicDestination%"
:: ============================================================================
:CopyFic_
SET DirFrom=%2
SET DirTo=%3
SET FicFrom=%4
SET FicTo=%5

REM supp des "
SET DirFrom=%DirFrom:"=%
SET DirTo=%DirTo:"=%
SET FicFrom=%FicFrom:"=%
SET FicTo=%FicTo:"=%

REM copie
ECHO copie de %FicTo%
REM xcopy /q /y "%DirFrom%%FicFrom%*" "%DirTo%%FicTo%*" pas utilisé car retourne 0 au lieu de 1 quand le fichier est non trouvé
COPY /y "%DirFrom%%FicFrom%" "%DirTo%%FicTo%"
IF %errorlevel% NEQ 0 (
    SET /a NbError=%NbError%+1
)
GOTO :Eof



:: ===== :NbChar_ =============================================================
:: retourne la longueur d'une chaine
::
:: parametres
::      %2 : chaine à compter
::
:: valeur de retour
::      %longueur% : longueur de la chaine
::
:: exemple d'appel :
::      CALL %FicFonctions% :NbChar_ %Chaine%
:: ============================================================================
:NbChar_
SET Char=%~2
:NbChar_Boucle
IF "%Char%"=="" GOTO :Eof
SET Char=%Char:~0,-1%
SET /A longueur=%longueur%+1
GOTO :NbChar_Boucle
GOTO :Eof



:: ===== :CompleteChar_ =======================================================
:: complete une ligne avec des espaces à gauche et à droite selon une chaine de reference
:: centre le texte
::
:: parametres
::      %2 : ligne de référence (pour le calcul du nombres d'espace et le centrage)
::      %3 : Ligne à centrer
::
:: valeur de retour
::      %Char% : la ligne %3 modifiée et centré
::
:: exemple d'appel :
::      CALL %FicFonctions% :CompleteChar_ "**********" "Titre"
:: ============================================================================
:CompleteChar_
REM taille ligne de ref
SET LigneRef=%2
SET longueur=0
CALL %FicFonctions% :NbChar_ %LigneRef%
SET NbCharLigneRef=%longueur%

REM :: taille ligne a complete
SET LigneModif=%3
SET longueur=0
CALL %FicFonctions% :NbChar_ %LigneModif%
SET NbCharLigneAModif=%longueur%

REM :: preparation de la ligne (-4 pour prendre en compte les * de debut et fin)
SET /a longueur=%NbCharLigneRef%-%NbCharLigneAModif%-4
CALL %FicFonctions% :Division_ %longueur% 2
SET /a longeurbefore=%quotient%
SET /a longeurafter=%quotient%+%reste%
FOR /l %%X IN (0, 1, %longeurbefore%) DO (
    SET Char= !Char!
)
SET Char=!Char!%LigneModif:"=%
FOR /l %%X IN (0, 1, %longeurafter%) DO (
    SET Char=!Char! 
)
GOTO :Eof



:: ===== :Division_ ===========================================================
:: Resultat d'une division avec quotien et reste
::
:: parametres
::      %2 : dividende
::      %3 : diviseur
::
:: valeur de retour
::      %quotient% : resultat de la division
::      %reste% : reste de la division
::
:: exemple d'appel :
::      CALL %FicFonctions% :Division_ 10 2
:: ============================================================================
:Division_
SET dividende=%2
SET diviseur=%3
SET /a quotient=%dividende%/%diviseur%
SET /a reste=%dividende%-(%quotient%*%diviseur%)
GOTO :Eof



:: ===== :Date_ ===============================================================
:: retourne une date sous les formats JJMMAAAA et AAAAMMJJ
::
:: parametres
::      %2 : Date au format jj/mm/aaaa
::
:: valeur de retour
::      %DateFR% : date au format JJMMAAAA
::      %DateUS% : date au format AAAAMMJJ
::
:: exemple d'appel :
::      CALL %FicFonctions% :Date_ %DATE%
:: ============================================================================
:Date_
SET DateModif=%2
SET dateFR=%DateModif:~0,2%%DateModif:~3,2%%DateModif:~6,4%
SET dateUS=%DateModif:~6,4%%DateModif:~3,2%%DateModif:~0,2%
GOTO :Eof



:: ===== :NomDeLaFonction_ ====================================================
:: description
::
:: parametres
::      aucun
::
:: valeur de retour
::      aucun
::
:: exemple d'appel :
::      CALL %FicFonctions% :NomDeLaFonction_
:: ============================================================================
:NomDeLaFonction_
GOTO :Eof
