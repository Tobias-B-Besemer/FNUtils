// Tobi`s F+N-Utilities

#INCLUDE "BOX.CH"
#INCLUDE "INKEY.CH"
#INCLUDE "FILEIO.CH"

SET DATE FORMAT "dd.mm.yyyy"

//PROCEDURE FNUtil
//PROCEDURE zum Aufruf der anderen Proceduren

ColorAlt := SETCOLOR() //Farbeinstellungen vor dem Start des Programmes
CMenueEinst()
EinstellE()
HMenue()

//****************************************************************************

PROCEDURE F02PROC
//PROCEDURE zur Funktionsumleitung der F2-Taste
//Version := "1.00.00"    //Versionsnummer des Programmes
//PDatum  := "07.05.1997" //Erstellungsdatum des Programmes

KEYBOARD CHR(K_CTRL_W)

//****************************************************************************

PROCEDURE F10PROC
//PROCEDURE zur Funktionsumleitung der F10-Taste
//Version := "1.00.00"    //Versionsnummer des Programmes
//PDatum  := "07.05.1997" //Erstellungsdatum des Programmes

KEYBOARD CHR(K_ESC)

//****************************************************************************

PROCEDURE EinstellE
//PROCEDURE zum einlesen der Einstellungen aus den Dateien FNUEinst.DBF

//Version := "1.03.00"             //Versionsnummer des Programmes
//PDatum  := "18.08.1999"          //Erstellungsdatum des Programmes
PUBLIC FNUVersion := "1.04.00"     //Versionsnummer der F+N Utilities
PUBLIC Datum      := "01.09.1999"  //Stand des Programmes
PUBLIC Copyright  := "1997-1999"   //Copyright seit ...
                // "Gert Besemer ˘ Elektroservice ˘ D-72622 NÅrtingen-Reudern"
                // "!!! BETA !!! ˘ BEWO ˘ Herr Kugler ˘ zum Testen"
                // Lizenz + "˘ !!! BETA !!!"
                // "BEWO ˘ Herr Kugler ˘ zum Testen"
                // "F+N ComSys GmbH ˘ Pfleghofstra·e 43 ˘ D-72555 Metzingen"
PUBLIC Lizenz   := "BEWO ˘ Herr Hummel ˘ zum Testen"
                                   //Lizenziert fÅr ...
PUBLIC TDay      := DTOC(DATE())   //Datum als Zeichenfolge
PUBLIC HDatei    := " "            //Pfad der Hilfe-Dateien
PUBLIC ADatei    := " "            //Pfad und Name der Artikel-Datei
PUBLIC D4Datei   := " "            //Pfad und Name der Datanorm4-Datei
PUBLIC D4EUW     := "N"            //Datanorm4 Einser-Umwandlung
PUBLIC D4EBV     := "Y"            //Einkaufsp. Brutto = Verkaufsp.
PUBLIC D4EBEN    := "N"            //Einkaufsp. Brutto = Einkaufsp. N
PUBLIC D4AL      := "N"            //Artikel zum lîschen markieren
PUBLIC D4DUE     := "Y"            //Datum aus der D4-Datei Åbernehmen
PUBLIC AEGDatei  := " "            //Pfad der AEG-Dateien
PUBLIC BloDatei  := " "            //Pfad der Blomberg-Dateien
PUBLIC BloAAnr   := "+BLO-"        //AnzufÅgende Artikelnummer bei
                                   //Blomberg-Dateien
PUBLIC IDatei    := " "            //Pfad und Name der Imperial-Datei
PUBLIC IAAnr     := "+IMP-"        //AnzufÅgende Artikelnummer bei
                                   //Imperial-Dateien
PUBLIC IAra      := 0              //Rabatt der Firma Imperial
PUBLIC LDatei    := " "            //Pfad und Name der Liebherr-Datei
PUBLIC LAAnr     := "+LIE-"        //AnzufÅgende Artikelnummer bei
                                   //Liebherr-Dateien
PUBLIC LAra      := 0              //Rabatt der Firma Liebherr
PUBLIC FNMFarben := "N"            //F+N-Manager Farben Y/N
PUBLIC ErrorFile := 0              //DOS-Handles-Nummer der Datei FNUError.TXT
PUBLIC ExFehler  := "REDX-SIM.COM" //Name des externen Programmes zur Fehler-
                                   //meldung

SET KEY  -1 TO F02Proc
SET KEY  -9 TO F10Proc
SET KEY 278 TO FNUVI

IF .NOT. FILE("FNUEinst.DBF")
   Fehler("Die Einstellungen-Datei FNUEINST.DBF wurde nicht gefunden!")
ENDIF

IF FILE("FNUEinst.DBF")=.T.
   SELE 1
   USE FNUEinst alias FNUE SHARED
   HDatei    := RTRIM(FNUE->HDa)
   ADatei    := FNUE->ADa
   D4Datei   := FNUE->D4D
   D4EUW     := FNUE->D4EU
   D4EBV     := FNUE->D4EBV
   D4EBEN    := FNUE->D4EBEN
   D4AL      := FNUE->D4AL
   D4DUE     := FNUE->D4DUE
   AEGDatei  := FNUE->AEGD
   BloDatei  := FNUE->BloD
   BloAAnr   := FNUE->BloAAnr
   IDatei    := FNUE->IDa
   IAAnr     := FNUE->IAAnr
   IAra      := FNUE->IAr
   LDatei    := FNUE->LDa
   LAAnr     := FNUE->LAAnr
   LAra      := FNUE->LAr
   FNMFarben := FNUE->FNMF
   ExFehler  := FNUE->ExFl
   USE
ENDIF

errorfile := FCREATE(hdatei + "FNUError.TXT", FC_NORMAL)

IF errorfile = -1
   Fehler("Die Error-Datei FNUError.TXT konnte nicht geîffnet werden!")
   DOSFlError()
ENDIF

thelp := TDay + " " + TIME() + " "
thelp := thelp + "FNUtil gestartet"
ErrorDatei(thelp)

YPARE()

//****************************************************************************

PROCEDURE YPARE
//PROCEDURE zum einlesen der Einstellungen aus der YPAR.DBF-Datei

//Version      := "1.00.00"    //Versionsnummer des Programmes
//PDatum       := "10.12.1997" //Erstellungsdatum des Programmes
PUBLIC FarbeTi := "B /BG"      //Titel und Hilfe
PUBLIC FarbeSS := "W /B "      //Standardschrift
PUBLIC FarbeUS := "W+/R "      //öberschriften
PUBLIC FarbeMZ := "N /W "      //MenÅzeiger
PUBLIC FarbeMP := "W+/B "      //MenÅpunkte
PUBLIC FarbeHG := "B /R "      //Hintergrund
PUBLIC FarbeTF := "N /W "      //Textfenster
PUBLIC FarbeRa := "BG/B "      //Rahmen
PUBLIC FarbeFe := "BG/R "      //Fenster-/Fehlerfarben

IF .NOT. FILE("YPAR.DBF")
   Fehler("Die Datei YPAR.DBF wurde nicht gefunden!")
ENDIF

IF FILE("YPAR.DBF")=.T. .AND. FNMFarben="Y"
   SELE 1
   USE YPar ALIAS YP SHARED
   IF NETERR() = .T.
      Fehler("Fehler beim îffnen der Einstellungs-Datei YPAR.DBF !")
      RETURN
   ENDIF
   PUBLIC FarbeTi := YP->Y00
   PUBLIC FarbeSS := YP->YB0
   PUBLIC FarbeUS := YP->YB1
   PUBLIC FarbeMZ := YP->YB4
   PUBLIC FarbeMP := YP->YB5
   PUBLIC FarbeHG := YP->YB6
   PUBLIC FarbeTF := YP->YB7
   PUBLIC FarbeRa := YP->YB8
   PUBLIC FarbeFe := YP->YB9
   USE
ENDIF

//****************************************************************************

PROCEDURE DatumsZ
//PROCEDURE zum anzeigen des Datums

//Version := "1.02.00"    //Versionsnummer des Programmes
//PDatum  := "22.05.1998" //Erstellungsdatum des Programmes
ColorHelp := SETCOLOR()   //Farbeinstellungen vor dem Start des Programmes
TDay      := DTOC(DATE()) //Datum als Zeichenfolge
THelp     := " "          //TemporÑre Hilfsvariable
THelp3    := " "          //TemporÑre Hilfsvariable

SETCOLOR(FarbeTi)
@ 00,00 SAY SPACE(80)
thelp := CDOW(DATE())
DO CASE
   CASE thelp = "Monday"
      thelp := "Montag"
   CASE thelp = "Tuesday"
      thelp := "Dienstag"
   CASE thelp = "Wednesday"
      thelp := "Mittwoch"
   CASE thelp = "Thursday"
      thelp := "Donnerstag"
   CASE thelp = "Friday"
      thelp := "Freitag"
   CASE thelp = "Saturday"
      thelp := "Samstag"
   CASE thelp = "Sunday"
      thelp := "Sonntag"
ENDCASE
thelp3 := SUBSTR(TDay,1,2)
DO CASE
   CASE thelp3 = "01"
      thelp3 := "1"
   CASE thelp3 = "02"
      thelp3 := "2"
   CASE thelp3 = "03"
      thelp3 := "3"
   CASE thelp3 = "04"
      thelp3 := "4"
   CASE thelp3 = "05"
      thelp3 := "5"
   CASE thelp3 = "06"
      thelp3 := "6"
   CASE thelp3 = "07"
      thelp3 := "7"
   CASE thelp3 = "08"
      thelp3 := "8"
   CASE thelp3 = "09"
      thelp3 := "9"
ENDCASE
thelp := thelp + ", " + thelp3 + ". "
thelp3 := SUBSTR(TDay,4,2)
DO CASE
   CASE thelp3 = "01"
      thelp3 := "Januar"
   CASE thelp3 = "02"
      thelp3 := "Februar"
   CASE thelp3 = "03"
      thelp3 := "MÑrz"
   CASE thelp3 = "04"
      thelp3 := "April"
   CASE thelp3 = "05"
      thelp3 := "Mai"
   CASE thelp3 = "06"
      thelp3 := "Juni"
   CASE thelp3 = "07"
      thelp3 := "Juli"
   CASE thelp3 = "08"
      thelp3 := "August"
   CASE thelp3 = "09"
      thelp3 := "September"
   CASE thelp3 = "10"
      thelp3 := "Oktober"
   CASE thelp3 = "11"
      thelp3 := "November"
   CASE thelp3 = "12"
      thelp3 := "Dezember"
ENDCASE
thelp := thelp + thelp3 + " " + SUBSTR(TDay,7,4)
@ 00,02 SAY thelp
SETCOLOR(ColorHelp)

//****************************************************************************

PROCEDURE InfoK
//PROCEDURE zum anzeigen der F+N-Utilities-Daten und der PROCEDURE-Daten

//Version := "1.00.01"    //Versionsnummer des Programmes
//PDatum  := "07.03.1998" //Erstellungsdatum des Programmes
ColorHelp := SETCOLOR()   //Farbeinstellungen vor dem Start des Programmes
//PName   := " "          //Programm-Name

SETCOLOR(FarbeTi)
@ 01,00 SAY SPACE(80)
thelp := "Tobi's F+N Utilities ˘ Version: " + FNUVersion + " ˘ Stand: "
thelp := thelp + Datum + " ˘ (c) " + Copyright
@ 01,02 SAY thelp
SETCOLOR(FarbeUS)
@ 02,00 SAY SPACE(80)
@ 03,00 SAY SPACE(80)
@ 02,02 SAY PName
@ 03,02 SAY "Version: " + Version + " ˘ Stand: " + PDatum
SETCOLOR(ColorHelp)

//****************************************************************************

PROCEDURE Fuss
//PROCEDURE zum anzeigen der Fu·zeilen mit den Funktionstasten

//Version := "1.00.00"    //Versionsnummer des Programmes
//PDatum  := "13.05.1997" //Erstellungsdatum des Programmes
ColorHelp := SETCOLOR()   //Farbeinstellungen vor dem Start des Programmes

SETCOLOR(FarbeTi)
@ 23,00 SAY SPACE(80)
@ 24,00 SAY SPACE(80)
@ 23,02 SAY "[F1] = Hilfe   [Einfg] = Zeichen einfÅgen AN/AUS   [Entf]  = Zeichen lîschen"
@ 24,02 SAY "[Enter]/[F2] = Eingabe beenden              [ESC]/[F10] = Programm abbrechen"
SETCOLOR(ColorHelp)

//****************************************************************************

PROCEDURE Help
//PROCEDURE zum anzeigen der Hilfe mit F1

Version   := "1.02.01"    //Versionsnummer des Programmes
PDatum    := "29.08.1999" //Erstellungsdatum des Programmes
MenueBH99 := SAVESCREEN(00,00,24,79)
                          //MenÅbild vor dem Start der Procedure
//Hilfe   := ""           //gibt an fÅr was eine Hilfe benîtigt wird

IF hilfe = "Versions-Info" //Ex-Insider
   SETCOLOR("N/N") //setzt Farbe auf schwarz fÅr den "Schatten"
   @ 02,08 CLEAR TO 23,72 //erzeugt "Schatten"
   SETCOLOR("W+/RB") //setzt Farbe auf hell-wei· auf rot-blauem Grund
   @ 01,07 CLEAR TO 22,71 //erzeugt "Schreib-Unterlage"
   DISPBOX(01,07,22,71,B_DOUBLE) //erzeugt Rahmen au·enherum

   @ 02,09 SAY "  Dieses Programm wurde gewidmet:                  17.08.1999"
   @ 03,09 SAY " =================================                           "
   @ 04,09 SAY "- Nora (meinem ehemaligen Hund) fÅr die wohl beste Freund-   "
   @ 05,09 SAY "  schaft die es zwischen einem Tier und einem Menschen geben "
   @ 06,09 SAY "  kann. Auch wenn ich leider nicht immer fÅr sie Zeit hatte. "
   @ 07,09 SAY "- Gabi (auch G-Punkt genannt) fÅr die wohl schînste Zeit die "
   @ 08,09 SAY "  ich je hatte - auch wenn sie sehr schmerzhaft zu Ende ging."
   @ 09,09 SAY "- Katja dafÅr das sie sich mit mir abgibt.                   "
   @ 10,09 SAY "- Herrn Ernst fÅr seine MÅhe mir BASIC auf dem CPC beizu-    "
   @ 11,09 SAY "  bringen.                                                   "
   @ 12,09 SAY "- Herrn Auernhammer fÅr seine MÅhe mich in die Geheimnisse   "
   @ 13,09 SAY "  von DOS einzufÅhren.                                       "
   @ 14,09 SAY "- Herrn Kugler fÅr seine Problemme die er mit mir hatte - und"
   @ 15,09 SAY "  noch haben wird.                                           "
   @ 16,09 SAY "- Herrn Fritsch fÅr die Lehrstelle und seine kurzen Einwei-  "
   @ 17,09 SAY "  sungen in CLIPPER (und fÅr die Unwissenheit die er von mir "
   @ 18,09 SAY "  ertragen mu·te).                                           "
   @ 19,09 SAY "- meiner Familie fÅr alles das Gute, da· sie mir in meinem   "
   @ 20,09 SAY "  Leben widerfahren lie·.                                    "
   @ 21,09 SAY "- Schredder und Tochter (dem wohl coolsten Lehrer den ich je "

   SET CURSOR OFF //schaltet den Cursor aus
   INKEY(0)       //und wartet auf beliebige Taste.
   SET CURSOR ON  //schaltet den Cursor an

   @ 04,09 SAY "  hatte) fÅr seine Hilfe und BemÅhungen mir all das beizu-   "
   @ 05,09 SAY "  bringen, da· mich so sehr interessierte.                   "
   @ 06,09 SAY "- David, Thomas, Joachim, RÅdiger, Frank Sch., Sascha,       "
   @ 07,09 SAY "  Frank S. - meinen ehemaligen besten Freunden. Was ist blo· "
   @ 08,09 SAY "  mit uns passiert, da· wir uns nicht mehr so gut verstehen  "
   @ 09,09 SAY "  wie frÅher?                                                "
   @ 10,09 SAY "- meinen Freunden wie Sascha, Joa, Data, Reuel, Arro, Miao,  "
   @ 11,09 SAY "  MAMA, usw. die immer dann, wenn ich sie brauche, fÅr mich  "
   @ 12,09 SAY "  da sind.                                                   "
   @ 13,09 SAY "- Herrn Wenz fÅr sein VerstÑndnis bei meinen nÑchtlichen     "
   @ 14,09 SAY "  Programmier-Sessions.                                      "
   @ 15,09 SAY "- und den ganzen anderen Personen die ich hier aus Platz-    "
   @ 16,09 SAY "  grÅnden nicht aufgefÅhrt habe, denen ich aber trotzdem sehr"
   @ 17,09 SAY "  dankbar bin.                                               "
   @ 18,09 SAY "- und na klar Tessi. :)))                                    "
   @ 19,09 SAY "                                                             "
   @ 20,09 SAY "                                                             "
   @ 21,09 SAY "                                                             "
   //Die letzten leeren Zeilen sollen den alten Bildschirminhalt
   //Åberschreiben. Hier wurden leere Zeilen verwendet, damit spÑter noch
   //Platz fÅr ErgÑnzungen ist.

   SET CURSOR OFF //schaltet den Cursor aus
   INKEY(0)       //und wartet auf beliebige Taste.
   SET CURSOR ON  //schaltet den Cursor an

   SETCOLOR(FarbeSS) //setzt die Farbe wieder auf die Standard-Farbe
   RESTSCREEN(00,00,24,79,MenueBH99) //stellt alten Bildschirminh. wieder her
   RETURN //kehrt zum "Start-Punkt" zurÅck
ENDIF

IF .NOT. FILE("FNUHilfe.DBF")
   Fehler("Die Hilfe-Datei FNUHilfe.DBF wurde nicht gefunden!")
   RESTSCREEN(00,00,24,79,MenueBH99)
   RETURN
ENDIF

SELE 99
USE FNUHilfe alias FNUH SHARED
GO TOP
IF LEN(READVAR()) > 0
   hilfe := READVAR()
ENDIF
LOCATE FOR name = hilfe

IF FOUND() = .F.
   thelp := "Sorry !!!;FÅr diesen Programmpunkt ist noch keine Hilfe"
   thelp := thelp + " vorhanden.;Bitte melden Sie diesen Fehler dem Autor.;"
   thelp := thelp + "(Bitte angeben: Fehler aufgetreten bei " + hilfe + " )"
   Fehler(thelp)
ENDIF

IF FOUND() = .T.
   thelp := ""
   DO WHILE name=hilfe
      thelp := RTRIM(thelp) + hilf
      SKIP
   ENDDO
   ALERT(RTRIM(thelp))
ENDIF

USE
RESTSCREEN(00,00,24,79,MenueBH99)

//****************************************************************************

PROCEDURE Fenster
//PROCEDURE zum Fensteraufbau

Version   := "1.00.00"    //Versionsnummer der Procedure
PDatum    := "02.07.1997" //Erstellungsdatum der Procedure
ColorHelp := SETCOLOR()   //Farbeinstellungen vor dem Start der Procedure
//Text    := "Test"       //Text des Fensters

SETCOLOR("N/N")
@ 11,(40-(LEN(text)/2)-2) CLEAR TO 15,(40+(LEN(text)/2)+3)
//Schwarzer Schatten

SETCOLOR(FarbeFe)
@ 10,(40-(LEN(text)/2)-3) CLEAR TO 14,(40+(LEN(text)/2)+2) //Farbige Box
DISPBOX(10,(40-(LEN(text)/2)-3),14,(40+(LEN(text)/2)+2),B_SINGLE) //Rahmen
@ 12,(40-(LEN(text)/2)) SAY text //Ausgabe Text

SETCOLOR(ColorHelp)

//****************************************************************************

PROCEDURE NextProc(Zeichen)
//PROCEDURE zum finden des nexten Zeichens

//Version := "1.00.00"    //Versionsnummer der Procedure
//PDatum  := "20.04.1998" //Erstellungsdatum der Procedure
//Zeichen := " "          //Zeichen das gesucht werden soll
//nStelle := 0            //Bestimmt die Position des nexten Zeichens
                          //in TZeile
//THelp   := " "          //TemporÑre Hilfsvariable
//TZeile  := " "          //TemporÑre Zeile ab Zeichen
//TZeile2 := " "          //TemporÑre Zeile bis Zeichen

nStelle := AT(Zeichen, TZeile)              //Bestimmt die Position des nexten
                                            //Zeichens in TZeile
thelp   := SUBS(TZeile,1,nStelle-1)         //Nimmt Text bis zum nÑchsten
                                            //Zeichen auf
TZeile2 := TZeile2 + SUBS(TZeile,1,nStelle) //speichert alles bis zum
                                            //einschlie·lich nÑchsten Zeichen
TZeile  := SUBS(TZeile,nStelle+1)           //enthÑlt alles ab dem nÑchsten
                                            //Zeichen

//****************************************************************************

PROCEDURE Version
//PROCEDURE zum anzeigen der Versions-Info

PName     := "Tobi's Programm zum anzeigen der Versions-Info"
                                     //Programm-Name
Version   := "1.03.00"               //Versionsnummer des Programmes
PDatum    := "01.09.1999"            //Erstellungsdatum des Programmes
MenueBH01 := SAVESCREEN(00,00,24,79) //MenÅbild vor dem Start der Procedure
Hilfe     := "Versions-Info"         //gibt an fÅr was eine Hilfe benîtigt
                                     //wird
BZeile    := 4                       //Zeilennummer
Fertig    := 0                       //1 wenn fertig

SETCOLOR(FarbeSS)
CLS
Datumsz()
InfoK()
Fuss()

IF .NOT. FILE("FNUVersi.DBF")
   Fehler("Die Versions-Datei FNUVersi.DBF wurde nicht gefunden!")
   RESTSCREEN(00,00,24,79,MenueBH01)
   RETURN
ENDIF

IF .NOT. FILE(HDatei + "FNUHelp.DBF")
   thelp := "Hilfsdatei FNUHelp.DBF nicht gefunden!;Entweder nicht"
   thelp := thelp + "vorhanden,;oder falscher Pfad eingestellt!"
   Fehler(thelp)
   RESTSCREEN(00,00,24,79,MenueBH01)
   RETURN
ENDIF

SELE 1
USE FNUVersi ALIAS FNUV SHARED
GO TOP

IF RECCOUNT() < 20 //Falls nicht gescrollt werden muss.
   FNUProc := ""
   FNUVers := ""
   FNUDatu := ""
   FNUText := ""
   FNUProc := FNUV->FNUP
   FNUVers := FNUV->FNUV
   FNUDatu := FNUV->FNUD
   FNUText := FNUV->FNUT
   IF FNUProc <> " "
      @ bzeile, 02 SAY "Proc/Func:"
      @ bzeile, 13 SAY FNUProc
      @ bzeile, 28 SAY "Version:"
      @ bzeile, 37 SAY FNUVers
      @ bzeile, 47 SAY "Stand:"
      @ bzeile, 54 SAY FNUDatu
      bzeile := bzeile + 1
      @ bzeile, 13 SAY FNUText
   ENDIF
   bzeile := bzeile + 2

   DO WHILE EOF() = .T.
      SET CURSOR OFF //schaltet den Cursor aus
      INKEY(0)       //und wartet auf beliebige Taste
      SET CURSOR ON  //schaltet den Cursor an
      DO CASE
         CASE LASTKEY() = K_F1
            help()
            LOOP
         OTHERWISE
            USE
            EXIT
      ENDCASE
   ENDDO
ELSE
   DO WHILE .T.
      @ 04,00 CLEAR TO 22,80
      bzeile := 4
      DO WHILE bzeile < 21
         FNUProc := ""
         FNUVers := ""
         FNUDatu := ""
         FNUText := ""
         FNUProc := FNUV->FNUP
         FNUVers := FNUV->FNUV
         FNUDatu := FNUV->FNUD
         FNUText := FNUV->FNUT
         IF FNUProc <> " "
            @ bzeile, 02 SAY "Proc/Func:"
            @ bzeile, 13 SAY FNUProc
            @ bzeile, 28 SAY "Version:"
            @ bzeile, 37 SAY FNUVers
            @ bzeile, 47 SAY "Stand:"
            @ bzeile, 54 SAY FNUDatu
            bzeile := bzeile + 1
            @ bzeile, 13 SAY FNUText
         ENDIF
         bzeile := bzeile + 2

         IF EOF() = .T. .AND. bzeile < 22
            bzeile := 4
            SKIP -5 //Letzte Zeile minus die Anzahl der Zeilen, die benoetigt
                    //werden, um die Zeilen 4-22 zu fuellen (/3).
         ENDIF
      ENDDO
      fertig := 0
      DO WHILE fertig = 0
         SET CURSOR OFF //schaltet den Cursor aus
         INKEY(0)       //und wartet auf beliebige Taste
         SET CURSOR ON  //schaltet den Cursor an
         fertig := 1
         DO CASE
            CASE LASTKEY() = K_F1
               help()
               fertig := 0
               SELECT th
            CASE LASTKEY() = K_F10
               USE
               EXIT
            CASE LASTKEY() = K_ESC
               USE
               EXIT
            CASE LASTKEY() = K_HOME
               GO TOP
            CASE LASTKEY() = K_PGUP
               SKIP -12
         CASE LASTKEY() = K_UP
            SKIP -6
         CASE LASTKEY() = K_DOWN
            SKIP -5
         CASE LASTKEY() = K_PGDN
            SKIP -00
         CASE LASTKEY() = K_END
            GO BOTTOM
            SKIP -5
         ENDCASE
      ENDDO
   ENDDO
   USE
ENDIF

ShowFile("Versions-Info", "FNUVersi.TXT")

RESTSCREEN(00,00,24,79,MenueBH01)

//****************************************************************************

PROCEDURE Einst
//PROCEDURE zum einstellen der F+N-Utilities

PName              := "Tobi's Programm zum einstellen der F+N-Utilities"
                                   //Programm-Name
Version            := "1.02.00"    //Versionsnummer des Programmes
PDatum             := "18.08.1999" //Erstellungsdatum des Programmes
MenueBH01          := SAVESCREEN(00,00,24,79)
                                   //MenÅbild vor dem Start der Procedure
Hilfe              := " "          //gibt an fÅr was eine Hilfe benîtigt wird
//PUBLIC HDatei    := " "          //Pfad der Hilfe-Dateien
//PUBLIC ADatei    := " "          //Pfad und Name der Artikel-Datei
//PUBLIC D4Datei   := " "          //Pfad und Name der Datanorm4-Datei
//PUBLIC D4EUW     := "N"          //Datanorm4 Einser-Umwandlung
//PUBLIC D4EBV     := "Y"          //Einkaufsp. Brutto = Verkaufsp.
//PUBLIC D4EBEN    := "N"          //Einkaufsp. Brutto = Einkaufsp. N
//PUBLIC D4AL      := "N"          //Artikel zum lîschen markieren
//PUBLIC D4DUE     := "Y"          //Datum aus der D4-Datei Åbernehmen
//PUBLIC AEGDatei  := " "          //Pfad der AEG-Dateien
//PUBLIC BloDatei  := " "          //Pfad der Blomberg-Dateien
//PUBLIC BloAAnr   := "+BLO-"      //AnzufÅgende Artikelnummer bei
                                   //Blomberg-Dateien
//PUBLIC IDatei    := " "          //Pfad und Name der Imperial-Datei
//PUBLIC IAAnr     := "+IMP-"      //AnzufÅgende Artikelnummer bei
                                   //Imperial-Dateien
//PUBLIC IAra      := 0            //Rabatt der Firma Imperial
//PUBLIC LDatei    := " "          //Pfad und Name der Liebherr-Datei
//PUBLIC LAAnr     := "+LIE-"      //AnzufÅgende Artikelnummer bei
                                   //Liebherr-Dateien
//PUBLIC LAra      := 0            //Rabatt der Firma Liebherr
//PUBLIC FNMFarben := "N"          //F+N-Manager Farben Y/N

SETCOLOR(FarbeSS)
CLS
Datumsz()
Fuss()
InfoK()

IF .NOT. FILE("FNUEinst.DBF")
   Fehler("Die Einstellungen-Datei FNUEINST.DBF wurde nicht gefunden!")
   RESTSCREEN(00,00,24,79,MenueBH01)
   RETURN
ENDIF

SELE 1
USE FNUEinst alias FNUE
HDatei    := FNUE->HDa
ADatei    := FNUE->ADa
D4Datei   := FNUE->D4D
D4EUW     := FNUE->D4EU
D4EBV     := FNUE->D4EBV
D4EBEN    := FNUE->D4EBEN
D4AL      := FNUE->D4AL
D4DUE     := FNUE->D4DUE
AEGDatei  := FNUE->AEGD
BloDatei  := FNUE->BloD
BloAAnr   := FNUE->BloAAnr
IDatei    := FNUE->IDa
IAAnr     := FNUE->IAAnr
IAra      := FNUE->IAr
LDatei    := FNUE->LDa
LAAnr     := FNUE->LAAnr
LAra      := FNUE->LAr
FNMFarben := FNUE->FNMF
ExFehler  := FNUE->ExFl
HDatei    := HDatei   + SPACE(40 - LEN(HDatei  ))
ADatei    := ADatei   + SPACE(40 - LEN(ADatei  ))
D4Datei   := D4Datei  + SPACE(40 - LEN(D4Datei ))
AEGDatei  := AEGDatei + SPACE(40 - LEN(AEGDatei))
BloDatei  := BloDatei + SPACE(40 - LEN(BloDatei))
BloAAnr   := BloAAnr  + SPACE( 9 - LEN(BloAAnr ))
IDatei    := IDatei   + SPACE(40 - LEN(IDatei  ))
IAAnr     := IAAnr    + SPACE(11 - LEN(IAAnr   ))
LDatei    := LDatei   + SPACE(40 - LEN(LDatei  ))
LAAnr     := LAAnr    + SPACE(10 - LEN(LAAnr   ))
ExFehler  := ExFehler + SPACE(40 - LEN(ExFehler))
@ 04,02 SAY "Pfad der Hilfe-Dateien            :" GET HDatei   PICTURE "@!"
@ 05,02 SAY "Pfad und Name der Artikel-Datei   :" GET ADatei   PICTURE "@!"
@ 06,02 SAY "Pfad und Name der Datanorm4-Datei :" GET D4Datei  PICTURE "@!"
@ 07,02 SAY "Datanorm4 Einser-Umwandlung       :" GET D4EUW    PICTURE "Y"
@ 08,02 SAY "Einkaufsp. Brutto = Verkaufsp.    :" GET D4EBV    PICTURE "Y"
@ 09,02 SAY "Einkaufsp. Brutto = Einkaufsp. N. :" GET D4EBEN   PICTURE "Y"
@ 10,02 SAY "Artikel zum lîschen markieren     :" GET D4AL     PICTURE "Y"
@ 11,02 SAY "Datum aus der D4-Datei Åbernehmen :" GET D4DUE    PICTURE "Y"
@ 12,02 SAY "Pfad der AEG-Dateien              :" GET AEGDatei PICTURE "@!"
@ 13,02 SAY "Pfad der Blomberg-Dateien         :" GET BloDatei PICTURE "@!"
@ 14,02 SAY "AnzufÅgende Art.-Nr. bei Blom.-D. :" GET BloAAnr  PICTURE "@!"
@ 15,02 SAY "Pfad und Name der Imperial-Datei  :" GET IDatei   PICTURE "@!"
@ 16,02 SAY "AnzufÅgende Art.-Nr. bei Impe.-D. :" GET IAAnr    PICTURE "@!"
@ 17,02 SAY "Rabatt der Firma Imperial         :" GET IAra     PICTURE "99.99"
@ 18,02 SAY "Pfad und Name der Liebherr-Datei  :" GET LDatei   PICTURE "@!"
@ 19,02 SAY "AnzufÅgende Art.-Nr. bei Lieb.-D. :" GET LAAnr    PICTURE "@!"
@ 20,02 SAY "Rabatt der Firma Liebherr         :" GET LAra     PICTURE "99.99"
@ 21,02 SAY "F+N-Manager Farben verwenden      :" GET FNMFarben PICTURE "Y"
@ 22,02 SAY "Name des ex. Progr. zur Fehlerm.  :" GET ExFehler PICTURE "@!"
READ
HDatei := RTRIM(HDatei)
IF LASTKEY() = K_ESC
   SELECT FNUE
   USE
   RESTSCREEN(00,00,24,79,MenueBH01)
   RETURN
ENDIF
SELECT FNUE
REPLACE FNUE->HDa     WITH HDatei
REPLACE FNUE->ADa     WITH ADatei
REPLACE FNUE->D4D     WITH D4Datei
REPLACE FNUE->D4EU    WITH D4EUW
REPLACE FNUE->D4EBV   WITH D4EBV
REPLACE FNUE->D4EBEN  WITH D4EBEN
REPLACE FNUE->D4AL    WITH D4AL
REPLACE FNUE->D4DUE   WITH D4DUE
REPLACE FNUE->AEGD    WITH AEGDatei
REPLACE FNUE->BloD    WITH BloDatei
REPLACE FNUE->BloAAnr WITH BloAAnr
REPLACE FNUE->IDa     WITH IDatei
REPLACE FNUE->IAAnr   WITH IAAnr
REPLACE FNUE->IAr     WITH IAra
REPLACE FNUE->LDa     WITH LDatei
REPLACE FNUE->LAAnr   WITH LAAnr
REPLACE FNUE->LAr     WITH LAra
REPLACE FNUE->FNMF    WITH FNMFarben
REPLACE FNUE->ExFl    WITH ExFehler
USE
YPARE()
RESTSCREEN(00,00,24,79,MenueBH01)

//****************************************************************************

PROCEDURE DOSFlError
//PROCEDURE zum ermitteln des DOS-Fehlers beim bearbeiten einer BinÑr-Datei

//Version   := "1.01.01"    //Versionsnummer der Procedure
//PDatum    := "31.08.1999" //Erstellungsdatum der Procedure
//ErrorFile := 0            //DOS-Handles-Nummer der Datei FNUError.TXT
THelp       := " "          //TemporÑre Hilfsvariable

thelp := tday + " " + TIME() + " "

DO CASE
   CASE FERROR() = 0
      //Alles in Ordnung !!! :)))
      RETURN
   CASE FERROR() = 2
      thelp := thelp + "Datei nicht gefunden!"
   CASE FERROR() = 3
      thelp := thelp + "Verzeichnis nicht gefunden!"
   CASE FERROR() = 4
      thelp := thelp + "Zu viele geîffnete Dateien!"
   CASE FERROR() = 5
      thelp := thelp + "Zugriff verweigert !"
   CASE FERROR() = 6
      thelp := thelp + "UngÅltiger DOS-Handle!"
   CASE FERROR() = 8
      thelp := thelp + "Kein Speicher mehr vorhanden!"
   CASE FERROR() = 15
      thelp := thelp + "UngÅltige Laufwerksangabe!"
   CASE FERROR() = 19
      thelp := thelp + "Versuch, auf eine schreibgeschÅtzte Diskette zu schreiben!"
   CASE FERROR() = 21
      thelp := thelp + "Laufwerk nicht bereit!"
   CASE FERROR() = 23
      thelp := thelp + "CRC Datenfehler (Checksumme fehlerhaft)!"
   CASE FERROR() = 29
      thelp := thelp + "Schreibfehler!"
   CASE FERROR() = 30
      thelp := thelp + "Lesefehler!"
   CASE FERROR() = 32
      thelp := thelp + "UngÅltiger Mehrfachzugriff!"
   CASE FERROR() = 33
      thelp := thelp + "Mehrfachzugriff gesperrt!"
   OTHERWISE
      thelp := thelp + "DOS-Fehler: " + STR(FERROR())
ENDCASE

Fehler(thelp)

//****************************************************************************

PROCEDURE ARTIOpen
//PROCEDURE zum îffnen der Artikeldatei

//Version     := "1.01.00"    //Versionsnummer der Procedure
//PDatum      := "10.12.1997" //Erstellungsdatum der Procedure
THelp         := " "          //TemporÑre Hilfsvariable
PUBLIC Fehler := 0            //RÅckgabewert

thelp := tday + " " + TIME() + " "

IF .NOT. FILE("ARTI.DBF")
   thelp := thelp + "Die Artikel-Datei ARTI.DBF wurde nicht gefunden!"
   Fehler(thelp)
   fehler := 1
   RETURN
ENDIF

IF .NOT. FILE("ARTI.DBT")
   thelp := thelp + "Die Artikel-Langtext-Datei ARTI.DBT wurde nicht"
   thelp := thelp + " gefunden!"
   Fehler(thelp)
   fehler := 1
   RETURN
ENDIF

IF .NOT. FILE("ANUM.NTX")
   thelp := thelp + "Die Artikelnummer-Index-Datei ANUM.NTX wurde nicht"
   thelp := thelp + " gefunden!"
   Fehler(thelp)
   fehler := 1
   RETURN
ENDIF

IF .NOT. FILE("ASBG.NTX")
   thelp := thelp + "Die Suchbegriff-Index-Datei ASBG.NTX wurde nicht!"
   thelp := thelp + " gefunden!"
   Fehler(thelp)
   fehler := 1
   RETURN
ENDIF

IF .NOT. FILE("AEAN.NTX")
   thelp := thelp + "Die EAN-Index-Datei AEAN.NTX wurde nicht gefunden!"
   Fehler(thelp)
   fehler := 1
   RETURN
ENDIF

SELE 1
USE Arti ALIAS ad SHARED
IF NETERR() = .T.
   thelp := "Fehler beim îffnen der Artikel-Datei ARTI.DBF !"
   Fehler(thelp)
   fehler := 1
   RETURN
ENDIF
SET INDEX TO anum, asbg, aean

//****************************************************************************

PROCEDURE Fehler(Fehlermeldung)
//PROCEDURE zum aufruf eines externen Programmes zur Fehlermeldung

//Version  := "1.01.00"      //Versionsnummer des Programmes
//PDatum   := "31.08.1999"   //Erstellungsdatum des Programmes
MenueBH99  := SAVESCREEN(00,00,24,79)
                             //MenÅbild vor dem Start der Procedure
//ExFehler := "REDX-SIM.COM" //Name des externen Programmes zur Fehlermeldung

ExFehler := RTRIM(ExFehler)

IF LEN(ExFehler) > 0
   IF FILE(ExFehler)=.T.
      RUN (ExFehler)
      RESTSCREEN(00,00,24,79,MenueBH99)
   ENDIF

   IF FILE(ExFehler)=.F.
      thelp := "Eingestellte, externe Datei zur Fehlermeldung nicht gefunden!"
      Fehler(thelp)
   ENDIF
ENDIF

ALERT(Fehlermeldung)
Errordatei(Fehlermeldung)

//****************************************************************************

PROCEDURE FNUVI
//PROCEDURE zur Tastenzuordnung zur kurzen F+N-Utilities-Versionsinfo
//Version := "1.00.00"    //Versionsnummer des Programmes
//PDatum  := "05.03.1998" //Erstellungsdatum des Programmes

thelp := "Sie verwenden Tobi's F+N Utilities der Version: " + FNUVersion
thelp := thelp + ";vom " + Datum + " ˘ (c) " + Copyright + " Tobias Besemer;"
thelp := thelp + "Diese Version ist lizenziert fÅr:;" + Lizenz + " "
ALERT(thelp)

//****************************************************************************

PROCEDURE LDPruefen
//PROCEDURE zum ÅberprÅfen der Langtext-Datei

PName     := "Tobi's Programm zum ÅberprÅfen der Langtext-Datei"
                                     //Programm-Name
Version   := "1.00.00"               //Versionsnummer des Programmes
PDatum    := "13.01.1998"            //Erstellungsdatum des Programmes
MenueBH01 := SAVESCREEN(00,00,24,79) //MenÅbild vor dem Start der Procedure
LTDatei   := " "                     //Pfad und Name der 2. Langtext-Datei
SZeit     := SECONDS()               //Startzeit der öberprÅfung
MZeit     := 0                       //Momentanzeit der öberprÅfung
VMin      := 0                       //Verbleibende Minuten
VSec      := 0                       //Verbleibende Sekunden
ZeileNr   := 0                       //Zeilenummer ( = Zeilenummer + 1 )
Zeilevn   := 0                       //Gesamte Zeilenzahl (RecCount)
Forts     := 0                       //Bearbeitungsfortschritt in %
Abbruch   := 0                       //Wird 1 wenn mit ESC abgebrochen wird
LDFehler  := 0                       //LangText-Datei-Fehler
                                     //Wird 1 wenn ein Fehler in einer LD
                                     //gefunden wird
THelp     := " "                     //TemporÑre Hilfsvariable
THelp3    := " "                     //TemporÑre Hilfsvariable
nStelle   := 0                       //Legt fest welches Zeichen der LD
                                     //verglichen wird

SETCOLOR(FarbeSS)
CLS
DatumsZ()
Fuss()
InfoK()

DO WHILE .T.
   LTDatei := TRIM(LTDatei)
   LTDatei := LTDatei + SPACE(41 - LEN(LTDatei))
   //Pfad und Name der Langtext-Datei
   SETCOLOR(FarbeSS)
   @ 04,02 SAY "Pfad und Name der 2. Langtext-D. :" GET LTDatei PICTURE "@!"
   READ

   IF LASTKEY() = K_ESC
      EXIT
   ENDIF

   IF LTDatei = " "
      EXIT
   ENDIF

   LTDatei := TRIM(LTDatei)

   IF .NOT. FILE(LTDatei + ".DBF")
      thelp := tday + " " + TIME() + " "
      thelp := thelp + "Es existiert keine Langtext-Datei mit dem Namen: "
      thelp := thelp + LTDatei + ".DBF "
      Fehler(thelp)
      LOOP
   ENDIF

   IF .NOT. FILE(LTDatei + ".DBT")
      thelp := tday + " " + TIME() + " "
      thelp := thelp + "Es existiert keine Langtext-Datei mit dem Namen: "
      thelp := thelp + LTDatei + ".DBT "
      Fehler(thelp)
      LOOP
   ENDIF

   ARTIOpen()
   IF fehler = 1
      EXIT
   ENDIF

   SELE 2
   USE (LTDatei) ALIAS LD
   thelp := HDatei + "ZANR.NTX"
   INDEX ON ANR TO thelp

   @ 06,02 SAY "Artikel / von  :"
   @ 08,02 SAY "Bearbeitet (%) :"
   @ 10,02 SAY "Verbleib. Zeit :   0 min 00 s"

   szeit   := SECONDS()
   zeilenr := 0

   SELECT ld
   GO TOP
   SELECT ad
   GO TOP

   DO WHILE .NOT. EOF()
      zeilenr := zeilenr + 1
      zeilevn := RECCOUNT()
      @ 06,19 SAY STR(zeilenr,6) + "/" + STR(zeilevn,6)
      forts := zeilenr / zeilevn * 100
      @ 08,19 SAY forts PICTURE "999.99"
      mzeit := SECONDS()
      IF mzeit < szeit
         mzeit := 86399 + mzeit
      ENDIF
      vsec := ((((mzeit - szeit) / zeilenr) * zeilevn) + szeit) - mzeit
      vmin := (vsec / 60) - 0.49
      vmin := ROUND(vmin,0)
      vsec := vsec - (vmin * 60)
      @ 10,19 SAY vmin PICTURE "999"
      @ 10,27 SAY vsec PICTURE "99"

      IF NEXTKEY() = K_ESC
         Fehler("öberprÅfen der Langtext-Datei abgebrochen!")
         Abbruch := 1
         EXIT
      ENDIF

      IF ad->anr < ld->anr
         LDFehler := 1
         thelp := tday + " " + TIME() + " "
         thelp := thelp + "Artikel: " + ad->anr + " in der Langtext-Datei"
         thelp := thelp + " nicht vorhanden!"
         ErrorDatei(thelp)
         SELECT ad
         SKIP
         LOOP
      ENDIF

      IF ad->anr > ld->anr
         LDFehler := 1
         thelp := tday + " " + TIME() + " "
         thelp := thelp + "Artikel: " + ld->anr + " in der Artikel-Datei"
         thelp := thelp + " nicht vorhanden!"
         ErrorDatei(thelp)
         SELECT ld
         SKIP
         SELECT ad
         LOOP
      ENDIF

      thelp  := RTRIM(ad->amd)
      thelp3 := RTRIM(ld->amd)

      IF LEN(thelp) <> LEN(thelp3)
         LDFehler := 1
         thelp := tday + " " + TIME()
         thelp := thelp + " Artikel: " + ad->anr + " Unterschiedlich langer"
         thelp := thelp + " Langtext!" + CHR(13) + CHR(10)
         thelp := thelp + "AD: " + CHR(13) + CHR(10) + ad->amd
         thelp := thelp + CHR(13) + CHR(10)
         thelp := thelp + "LD: " + CHR(13) + CHR(10) + ld->amd
         ErrorDatei(thelp)
         SELECT ld
         SKIP
         SELECT ad
         SKIP
         LOOP
      ENDIF

      nStelle := 0

      DO WHILE .NOT. nStelle = LEN(thelp)
         nStelle := nStelle + 1
         IF VAL(SUBS(thelp,nStelle,1)) <> VAL(SUBS(thelp3,nStelle,1))
            LDFehler := 1
            thelp := tday + " " + TIME()
            thelp := thelp + " Artikel: " + ad->anr + " Unterschiedlicher"
            thelp := thelp + " Langtext!" + CHR(13) + CHR(10)
            thelp := thelp + "AD: " + CHR(13) + CHR(10) + ad->amd
            thelp := thelp + CHR(13) + CHR(10)
            thelp := thelp + "LD: " + CHR(13) + CHR(10) + ld->amd
            ErrorDatei(thelp)
            SELECT ld
            SKIP
            SELECT ad
            SKIP
            EXIT
         ENDIF
      ENDDO

      SELECT ld
      SKIP
      SELECT ad
      SKIP
   ENDDO

   SELECT ld
   MenueBH99 := SAVESCREEN(00,00,24,79)
   Text := "VervollstÑndige Protokoll-Datei."
   Fenster()

   DO WHILE .NOT. EOF() .AND. Abbruch = 0
      LDFehler := 1
      thelp := tday + " " + TIME() + " "
      thelp := thelp + "Artikel: " + ld->anr + " in der Artikel-Datei"
      thelp := thelp + " nicht vorhanden!"
      ErrorDatei(thelp)
      SKIP
   ENDDO

   RESTSCREEN(00,00,24,79,MenueBH99)

   IF .NOT. Abbruch = 1 .AND. LDFehler = 0
      ALERT("Langtext-Datei ÅberprÅft.;Keine Fehler gefunden.")
   ENDIF

   IF .NOT. Abbruch = 1 .AND. LDFehler = 1
      thelp := "Langtext-Datei ÅberprÅft.;Fehler gefunden !!!;Bitte lesen Sie"
      thelp := thelp + " die Protokoll-Datei durch."
      ALERT(thelp)
   ENDIF

   SELECT ad
   USE
   SELECT ld
   USE
   thelp := HDatei + "ZANR.NTX"
   FERASE(thelp)
   Abbruch := 0

ENDDO
RESTSCREEN(00,00,24,79,MenueBH01)

//****************************************************************************

PROCEDURE EinserUmwan
//PROCEDURE um jede kleinste Packungsgrî·e auf 1 zu setzen und zum umwandeln
//          des zugehîrigen Preises

PName     := "Tobi's Programm zur Einser-Umwandlung"
                          //Programm-Name
Version   := "1.00.00"    //Versionsnummer des Programmes
PDatum    := "22.05.1998" //Erstellungsdatum des Programmes
MenueBH01 := SAVESCREEN(00,00,24,79)
                          //MenÅbild vor dem Start der Procedure
Hilfe     := " "          //gibt an fÅr was eine Hilfe benîtigt wird
Frage     := "N"          //Sicher ?
THelp2    := 0            //TemporÑre Hilfsvariable

thelp :=         "Dieser Programmpunkt kann nicht rÅckgÑngig gemacht werden.;"
thelp := thelp + "Er sollte daher nur von erfahrenen Benutzern verwendet "
thelp := thelp + "werden!"
ALERT(thelp)
SETCOLOR(FarbeSS)
CLS
Datumsz()
Fuss()
InfoK()
SETCOLOR("N/N")
@ 10,16 CLEAR TO 16,67
SETCOLOR(FarbeFe)
@ 09,15 CLEAR TO 15,66
DISPBOX(09,15,15,66,B_DOUBLE)
@ 11,25 SAY "Sind Sie Sich sicher das Sie die"
@ 12,25 SAY "Einser-Umwandlung durchfÅhren   "
@ 13,25 SAY "mîchten ?                  J/N ?"
SETCOLOR("BG/BG")
@ 13,58 GET Frage
READ

IF .NOT. LASTKEY() = K_ESC
   IF Frage="Y" .OR. Frage="y" .OR. Frage="J" .OR. Frage="j"
      ARTIOpen()
      IF fehler <> 1

         SETCOLOR(FarbeSS)
         @ 09,15 CLEAR TO 15,66
         @ 06,02 SAY "Artikel / von  :"
         @ 08,02 SAY "Bearbeitet (%) :"
         @ 10,02 SAY "Verbleib. Zeit :   0 min 00 s"
         szeit   := SECONDS()
         zeilenr := 0

         DO WHILE .NOT. EOF()
            zeilenr := zeilenr + 1
            zeilevn := RECCOUNT()
            @ 06,19 SAY STR(zeilenr,6) + "/" + STR(zeilevn,6)
            forts := zeilenr / zeilevn * 100
            @ 08,19 SAY forts PICTURE "999.99"
            mzeit := SECONDS()
            IF mzeit < szeit
               mzeit := 86399 + mzeit
            ENDIF
            vsec := ((((mzeit - szeit) / zeilenr) * zeilevn) + szeit) - mzeit
            vmin := (vsec / 60) - 0.49
            vmin := ROUND(vmin,0)
            vsec := vsec - (vmin * 60)
            @ 10,19 SAY vmin PICTURE "999"
            @ 10,27 SAY vsec PICTURE "99"

            IF NEXTKEY() = K_ESC
               Fehler("Einser-Umwandlung abgebrochen!")
               Abbruch := 1
               EXIT
            ENDIF

            IF ape <> 1
               thelp2 := avk / ape
               REPLACE avk WITH thelp2

               thelp2 := aev / ape
               REPLACE aev WITH thelp2

               thelp2 := aek / ape
               REPLACE aek WITH thelp2

               REPLACE ape WITH 1
            ENDIF
            SKIP

         ENDDO

         IF .NOT. Abbruch = 1
            ALERT("Die Einser-Umwandlung wurde erfolgreich abgeschlossen!")
         ENDIF

         USE
      ENDIF
   ENDIF
ENDIF

RESTSCREEN(00,00,24,79,MenueBH01)

//****************************************************************************

PROCEDURE ShowFile(Name, FName)
//PROCEDURE zum anzeigen einer Datei

//Name    := "Data4Infos"            //Name des Programmes und der Hilfe
PName     := "Tobi's Programm zum anzeigen der " + Name + "-Datei"
                                     //Programm-Name
Version   := "1.01.00"               //Versionsnummer des Programmes
PDatum    := "31.08.1999"            //Erstellungsdatum des Programmes
MenueBH02 := SAVESCREEN(00,00,24,79) //MenÅbild vor dem Start der Procedure
Hilfe     := Name                    //gibt an fÅr was eine Hilfe benîtigt
                                     //wird
BZeile    := 4                       //Zeilennummer
Fertig    := 0                       //1 wenn fertig

SETCOLOR(FarbeSS)
CLS
Datumsz()
InfoK()
Fuss()

IF .NOT. FILE(FName)
   thelp := "Die " + Name + "-Datei " + FName + " wurde nicht gefunden!"
   Fehler(thelp)
   RESTSCREEN(00,00,24,79,MenueBH02)
   RETURN
ENDIF

IF .NOT. FILE(HDatei + "FNUHelp.DBF")
   thelp := "Hilfsdatei FNUHelp.DBF nicht gefunden!;Entweder nicht"
   thelp := thelp + "vorhanden,;oder falscher Pfad eingestellt!"
   Fehler(thelp)
   RESTSCREEN(00,00,24,79,MenueBH02)
   RETURN
ENDIF

SELE 1
temp := HDatei + "FNUHelp.DBF"
USE (temp) ALIAS TH
ZAP
APPEND FROM (FName) SDF
GO TOP

IF RECCOUNT() < 20 //Falls nicht gescrollt werden muss.
   thelp := TH->ZEILE
   @ bzeile, 02 SAY thelp
   bzeile := bzeile + 1
   SKIP
   DO WHILE EOF() = .T.
      SET CURSOR OFF //schaltet den Cursor aus
      INKEY(0)       //und wartet auf beliebige Taste
      SET CURSOR ON  //schaltet den Cursor an
      DO CASE
         CASE LASTKEY() = K_F1
            help()
            LOOP
         OTHERWISE
            USE
            RESTSCREEN(00,00,24,79,MenueBH02)
            RETURN
      ENDCASE
   ENDDO
ENDIF

DO WHILE .T.
   @ 04,00 CLEAR TO 22,80
   bzeile := 4
   DO WHILE bzeile <= 22
      thelp := TH->ZEILE
      @ bzeile, 02 SAY thelp
      bzeile := bzeile + 1
      SKIP

      IF EOF() = .T. .AND. bzeile < 22
         bzeile := 4
         SKIP -18 //Letzte Zeile minus die Anzahl der Zeilen, die benoetigt
                  //werden, um die Zeilen 4-22 zu fuellen.
      ENDIF

   ENDDO
   fertig := 0
   DO WHILE fertig = 0
      SET CURSOR OFF //schaltet den Cursor aus
      INKEY(0)       //und wartet auf beliebige Taste
      SET CURSOR ON  //schaltet den Cursor an
      fertig := 1
      DO CASE
         CASE LASTKEY() = K_F1
            help()
            fertig := 0
            SELECT th
         CASE LASTKEY() = K_F10
            USE
            RESTSCREEN(00,00,24,79,MenueBH02)
            RETURN
         CASE LASTKEY() = K_ESC
            USE
            RESTSCREEN(00,00,24,79,MenueBH02)
            RETURN
         CASE LASTKEY() = K_HOME
            GO TOP
         CASE LASTKEY() = K_PGUP
            SKIP -38
         CASE LASTKEY() = K_UP
            SKIP -20
         CASE LASTKEY() = K_DOWN
            SKIP -18
         CASE LASTKEY() = K_PGDN
            SKIP -00
         CASE LASTKEY() = K_END
            GO BOTTOM
            SKIP -17
      ENDCASE
   ENDDO
ENDDO
ZAP
USE
RESTSCREEN(00,00,24,79,MenueBH02)

//****************************************************************************

PROCEDURE ADneuErstel
//PROCEDURE zum erstellen einer komplett neuen Artikeldatei

PName     := "Tobi's Programm zum erstellen einer komplett neuen Artikeldatei"
                                     //Programm-Name
Version   := "1.00.00"               //Versionsnummer des Programmes
PDatum    := "30.08.1999"            //Erstellungsdatum des Programmes
MenueBH01 := SAVESCREEN(00,00,24,79) //MenÅbild vor dem Start der Procedure
Frage     := "N"                     //Sicher ?

SETCOLOR(FarbeSS)
CLS
Datumsz()
Fuss()
InfoK()
SETCOLOR("N/N")
@ 09,11 CLEAR TO 17,70
SETCOLOR(FarbeFe)
@ 08,10 CLEAR TO 16,69
DISPBOX(08,10,16,69,B_DOUBLE)
@ 10,12 SAY "Dieses Programm erstellt Ihre Artikeldatei komplett neu."
@ 11,12 SAY "Dieser Vorgang kann unter UmstÑnden mehrere Minuten oder"
@ 12,12 SAY "Stunden dauern.                                         "
@ 13,12 SAY "Sind Sie Sich sicher, da· Sie die Artikeldatei komplett "
@ 14,12 SAY "neu erstellen mîchten ?              J/N ?              "
SETCOLOR("BG/BG")
@ 14,55 GET Frage
READ

IF .NOT. LASTKEY() = K_ESC
   IF Frage="Y" .OR. Frage="y" .OR. Frage="J" .OR. Frage="j"
      SETCOLOR(FarbeSS)
      @ 04,00 CLEAR TO 22,80
      SETCOLOR("N/N")
      @ 11,22 CLEAR TO 15,58
      SETCOLOR(FarbeFe)
      @ 10,21 CLEAR TO 14,57
      DISPBOX(10,21,14,57,B_DOUBLE)
      IF FILE("FNUArti.DBF")
         @ 12,23 SAY "Alte temporÑre DBF-Datei lîschen."
         FERASE("FNUArti.DBF")
      ENDIF
      IF FILE("FNUArti.DBT")
         @ 12,23 SAY "Alte temporÑre DBT-Datei lîschen."
         FERASE("FNUArti.DBT")
      ENDIF
      @ 12,23 SAY "Aktuelle Artikeldatei îffnen.    "
      ARTIOpen()
      IF fehler = 1
         RESTSCREEN(00,00,24,79,MenueBH01)
         RETURN
      ENDIF
      @ 12,23 SAY "Neue Artikeldatei wird erstellt. "
      COPY ALL TO FNUArti
      USE
      IF FILE("ARTI.DBF")
         @ 12,23 SAY "Alte Artikeldatei lîschen (DBF). "
         FERASE("ARTI.DBF")
      ENDIF
      IF FILE("ARTI.DBT")
         @ 12,23 SAY "Alte Artikeldatei lîschen (DBT). "
         FERASE("ARTI.DBT")
      ENDIF
      IF FILE("ANUM.NTX")
         @ 12,23 SAY "Alter Artikelnr.-Index lîschen.  "
         FERASE("ANUM.NTX")
      ENDIF
      IF FILE("ASBG.NTX")
         @ 12,23 SAY "Alter Suchbegriff-Index lîschen. "
         FERASE("ASBG.NTX")
      ENDIF
      IF FILE("AEAN.NTX")
         @ 12,23 SAY "Alter EAN-Index lîschen.         "
         FERASE("AEAN.NTX")
      ENDIF
      @ 12,23 SAY "Neue Artikel-D. umbenennen (DBF)."
      FRENAME("FNUArti.DBF", "ARTI.DBF")
      DOSFlError()
      @ 12,23 SAY "Neue Artikel-D. umbenennen (DBT)."
      FRENAME("FNUArti.DBT", "ARTI.DBT")
      DOSFlError()
      USE ARTI
      @ 12,23 SAY "Neuer Index wird erstellt.       "
      INDEX ON anr TO anum; INDEX ON asb TO asbg; INDEX ON AEA TO aean
      USE
      @ 12,23 SAY "            Fertig !             "
      ALERT("Die Artikeldatei wurde komplett neu erstellt !")
   ENDIF
ENDIF

RESTSCREEN(00,00,24,79,MenueBH01)

//****************************************************************************

PROCEDURE FNUErrorl
//PROCEDURE zum lîschen der FNUError-Datei

PName     := "Tobi's Programm zum lîschen der FNUError-Datei"
                                     //Programm-Name
Version   := "1.00.00"               //Versionsnummer des Programmes
PDatum    := "31.08.1999"            //Erstellungsdatum des Programmes
MenueBH01 := SAVESCREEN(00,00,24,79) //MenÅbild vor dem Start der Procedure
Frage     := "N"                     //Sicher ?

SETCOLOR(FarbeSS)
CLS
Datumsz()
Fuss()
InfoK()
SETCOLOR("N/N")
@ 10,17 CLEAR TO 16,63
SETCOLOR(FarbeFe)
@ 09,16 CLEAR TO 15,62
DISPBOX(09,16,15,62,B_DOUBLE)
@ 11,18 SAY "Dieses Programm lîscht Ihre FNUError-Datei."
@ 12,18 SAY "Sind Sie Sich sicher, da· Sie die FNUError-"
@ 13,18 SAY "Datei lîschen mîchten ?       J/N ?        "
SETCOLOR("BG/BG")
@ 13,54 GET Frage
READ

IF .NOT. LASTKEY() = K_ESC
   IF Frage="Y" .OR. Frage="y" .OR. Frage="J" .OR. Frage="j"
      SETCOLOR(FarbeSS)
      @ 04,00 CLEAR TO 22,80
      SETCOLOR("N/N")
      @ 11,22 CLEAR TO 15,58
      SETCOLOR(FarbeFe)
      @ 10,21 CLEAR TO 14,57
      DISPBOX(10,21,14,57,B_DOUBLE)
      IF FILE(hdatei + "FNUError.TXT")
         @ 12,23 SAY "FNUError-Datei wird gelîscht.    "
         FERASE(hdatei + "FNUError.TXT")
         DOSFlError()
      ENDIF
      @ 12,23 SAY "            Fertig !             "
      ALERT("FNUError-Datei wurde gelîscht.")
   ENDIF
ENDIF

RESTSCREEN(00,00,24,79,MenueBH01)

//****************************************************************************

PROCEDURE ErrorDatei(Fehlermeldung)
//PROCEDURE zum protokollieren von Fehlermeldungen

//Version          := "1.00.00"    //Versionsnummer des Programmes
//PDatum           := "31.08.1999" //Erstellungsdatum des Programmes
//PUBLIC ErrorFile := 0            //DOS-Handles-Nummer der Datei FNUError.TXT
nStelle            := 1            //Bestimmt die Position des nexten Zeichens
                                   //in Fehlermeldung
//THelp            := " "          //TemporÑre Hilfsvariable

// In PROCEDURE EinstellE :
// errorfile := FCREATE(hdatei + "FNUError.TXT", FC_NORMAL)

//Format:
//thelp := tday + " " + TIME() + " "
//thelp := thelp + "Blubber"

IF .NOT. errorfile = -1
   DO WHILE nStelle <> 0  //WHILE-Schleife zum finden der ";" :
      nStelle := AT(";", Fehlermeldung)
         //Bestimmt die Position des nexten ";" in Fehlermeldung
      IF nStelle <> 0
         thelp := SUBS(Fehlermeldung,1,nStelle-1)
            //Nimmt Text bis zum nÑchsten ";" auf
         thelp := thelp + CHR(13) + CHR(10)
            //Zeilenumbruch + Pos1
         thelp := thelp + SPACE(20)
            //Vorschub nach Datum + Zeit
         thelp := thelp + SUBS(Fehlermeldung,nStelle+1)
            //+ alles ab dem nÑchsten ";"
         Fehlermeldung := thelp
      ENDIF
   ENDDO
   FWRITE(errorfile,Fehlermeldung + CHR(13) + CHR(10))
ENDIF
