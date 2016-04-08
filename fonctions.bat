@ECHO off
GOTO %1
GOTO :Eof
:: ================================================================================================
:: Fonctions utilisables dans un batch
::
:: DATE             USER    DESCRIPTION
:: 08/04/2016       GD      création
:: 08/04/2016       GD      init sur GitHub
:: ================================================================================================



:: ===== :Entete ==============================================================
:: affiche un entete avec les ***, titre et version
::
:: parametres
::      aucun
::
:: valeur de retour
::      aucun
::
:: exemple d'appel :
::      CALL fonctions :Entete
:: ============================================================================
:Entete
SET LigneBarre=%LigneBarre:"=%
ECHO %LigneBarre%
ECHO %LigneTitre%
ECHO %LigneVersion%
ECHO %LigneBarre%
ECHO:
goto :Eof



:: ===== :CheckError ==========================================================
:: affiche la fenetre en vert si %2 est = 0 sinon affiche en rouge
::
:: parametres
::      %2 : variable du nombre d'erreur (ex: %NbError%)
::
:: valeur de retour
::      aucun
::
:: exemple d'appel :
::      CALL fonctions :CheckError %NbError%
:: ============================================================================
:CheckError
ECHO Nb erreur : %2
IF %2 GTR 0 (
    color C0
) ELSE (
    color A0
)
GOTO :Eof



:: == :CopyFic ================================================================
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
::      CALL fonctions :CopyFic "%DirOrigine%" "%DirDestination%" "%FicOrigine%" "%FicDestination%"
:: ============================================================================
:CopyFic
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



:: ===== :NbChar ==============================================================
:: retourne la longueur d'une chaine
::
:: parametres
::      %2 : chaine à compter
::
:: valeur de retour
::      %longueur% : longueur de la chaine
::
:: exemple d'appel :
::      CALL fonctions :NbChar %Chaine%
:: ============================================================================
:NbChar
SET Char=%~2
:NbChar_Boucle
IF "%Char%"=="" GOTO :Eof
SET Char=%Char:~0,-1%
SET /A longueur=%longueur%+1
GOTO :NbChar_Boucle
GOTO :Eof



:: ===== :CompleteChar ========================================================
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
::      CALL fonctions :CompleteChar "**********" "Titre"
:: ============================================================================
:CompleteChar
REM taille ligne de ref
SET LigneRef=%2
SET longueur=0
CALL fonctions :NbChar %LigneRef%
SET NbCharLigneRef=%longueur%

REM :: taille ligne a complete
SET LigneModif=%3
SET longueur=0
CALL fonctions :NbChar %LigneModif%
SET NbCharLigneAModif=%longueur%

REM :: preparation de la ligne (-4 pour prendre en compte les * de debut et fin)
SET /a longueur=%NbCharLigneRef%-%NbCharLigneAModif%-4
CALL fonctions :Division %longueur% 2
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



:: ===== :Division ============================================================
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
::      CALL fonctions :Division 10 2
:: ============================================================================
:Division
SET dividende=%2
SET diviseur=%3
SET /a quotient=%dividende%/%diviseur%
SET /a reste=%dividende%-(%quotient%*%diviseur%)
GOTO :Eof



:: ===== :NomDeLaFonction ============================================================
:: description
::
:: parametres
::      aucun
::
:: valeur de retour
::      aucun
::
:: exemple d'appel :
::      CALL fonctions :NomDeLaFonction
:: ============================================================================
:NomDeLaFonction
GOTO :Eof
