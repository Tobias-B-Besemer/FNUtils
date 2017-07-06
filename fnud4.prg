#INCLUDE "INKEY.CH"
#INCLUDE "FILEIO.CH"

PROCEDURE Data4
//PROCEDURE zur Artikeldatenpflege Åber Datanorm 4-Dateien

SET DATE FORMAT "dd.mm.yyyy"

PName     := "Tobi's Programm zur Artikeldatenpflege Åber Datanorm 4-Dateien"
                                     //Programm-Name
Version   := "1.04.03"               //Versionsnummer des Programmes
PDatum    := "10.09.1999"            //Erstellungsdatum des Programmes
MenueBH01 := SAVESCREEN(00,00,24,79) //MenÅbild vor dem Start der Procedure
//D4Datei := " "                     //Pfad und Name der Input-Datei
OFile     := " "                     //Pfad und Name der Output-Datei
WRGFile   := " "                     //Pfad und Name der Warengruppen-Datei
AAnr      := " "                     //AnzufÅgende Artikelnummer
FAt       := "Y"                     //Artikelbezeichnungen Åberschreiben ?
//D4EUW   := "N"                     //Einser-Umwandlung
FRab      := "N"                     //Rabatt berÅcksichtigen ?
//D4EBV   := "Y"                     //Einkaufsp. Brutto = Verkaufsp.
//D4EBEN  := "N"                     //Einkaufsp. Brutto = Einkaufsp. N.
//D4AL    := "N"                     //Artikel zum lîschen markieren
//D4DUE   := "Y"                     //Datum aus der D4-Datei Åbernehmen
//ArtiS   := "Y"                     //Artikeldatei komplett sperren
TAks      := " "                     //Einzusetzende Katalogseite
TAdp      := Date()                  //Datum der letzten énderung der
                                     //Artikeldaten
THelp     := " "                     //TemporÑre Hilfsvariable
THelp2    := 0                       //TemporÑre Hilfsvariable
THelp3    := " "                     //TemporÑre Hilfsvariable
THelp4    := " "                     //TemporÑre Hilfsvariable
SZeit     := SECONDS()               //Startzeit der Datenpflege
MZeit     := 0                       //Momentanzeit der Datenpflege
VMin      := 0                       //Verbleibende Minuten
VSec      := 0                       //Verbleibende Sekunden
VKz       := " "                     //Verarbeitungskennzeichen
TZeile    := " "                     //TemporÑre Zeile ab ;
TZeile2   := " "                     //TemporÑre Zeile bis ;
ZeileNr   := 0                       //Zeilenummer (RecNo)
Zeilevn   := 0                       //Gesamte Zeilenzahl (RecCount)
Forts     := 0                       //Bearbeitungsfortschritt in %
Lieferer  := ""                      //Name des Lieferanten ( aus: "V;" )
nStelle   := 0                       //Bestimmt nexten ; in TZeile
TAnr      := " "                     //TemporÑre Artikelnummer
TAnr2     := " "                     //TemporÑre Artikelnummer 2
Neu       := 0                       //Wird 1 wenn der Artikel neu
                                     //angelegt wird
VAt       := 0                       //Anzahl schon vorhandener Artikel
NAt       := 0                       //Anzahl neu angelegter Artikel
GAt       := 0                       //Anzahl bearbeiteter Artikel
                                     //(GAt := VAt + NAt)
Tk1       := " "                     //Inhalt des Textkennzeichens 1
Tk2       := " "                     //Inhalt des Textkennzeichens 2
Pkz       := " "                     //Inhalt des Preiskennzeichens
Abbruch   := 0                       //Wird 1 wenn mit ESC abgebrochen wird

SETCOLOR(FarbeSS)
CLS
DatumsZ()
Fuss()
InfoK()

DO WHILE .T.
   D4Datei := TRIM(D4Datei)
   D4Datei := D4Datei + SPACE(39 - LEN(D4Datei)) //Pfad und Name
                                                 //der Input-Datei
   OFile   := OFile   + SPACE(39 - LEN(OFile  )) //Pfad und Name
                                                 //der Output-Datei
   WRGFile := WRGFile + SPACE(39 - LEN(WRGFile)) //Pfad und Name
                                                 //der Warengruppen-Datei
   AAnr    := AAnr    + SPACE(19 - LEN(AAnr   )) //AnzufÅgende
                                                 //Artikelnummer
   TAks    := TAks    + SPACE(04 - LEN(TAks   )) //Einzusetzende
                                                 //Katalogseite
   SETCOLOR(FarbeSS)
   @ 04,01 CLEAR TO 17,78
   @ 04,02 SAY "Pfad und Name der Datanorm 4-Datei :" GET D4Datei PICTURE "@!"
   @ 05,02 SAY "Pfad und Name der Output-Datei     :" GET OFile   PICTURE "@!"
   @ 06,02 SAY "Pfad und Name der Warengruppen-D.  :" GET WRGFile PICTURE "@!"
   @ 07,02 SAY "AnzufÅgende Artikelnummer          :" GET AAnr    PICTURE "@!"
   @ 08,02 SAY "Artikelbezeichnungen Åberschreiben :" GET FAt     PICTURE "Y"
   @ 09,02 SAY "Einser-Umwandlung                  :" GET D4EUW   PICTURE "Y"
   @ 10,02 SAY "Rabatt berÅcksichtigen             :" GET FRab    PICTURE "Y"
   @ 11,02 SAY "Einkaufsp. Brutto = Verkaufsp.     :" GET D4EBV   PICTURE "Y"
   @ 12,02 SAY "Einkaufsp. Brutto = Einkaufsp. N.  :" GET D4EBEN  PICTURE "Y"
   @ 13,02 SAY "Einzusetzende Katalogseite         :" GET TAks
   @ 14,02 SAY "Artikel zum lîschen markieren      :" GET D4AL    PICTURE "Y"
   @ 15,02 SAY "Datum aus der D4-Datei Åbernehmen  :" GET D4DUE   PICTURE "Y"
   @ 16,02 SAY "Artikeldatei komplett sperren      :" GET ArtiS   PICTURE "Y"
   @ 17,02 SAY "Stand der Daten                    :" GET TAdp    PICTURE "@D"
   READ

   IF LASTKEY() = K_ESC
      EXIT
   ENDIF

   IF D4Datei = " "
      EXIT
   ENDIF

   D4Datei :=  TRIM(D4Datei)
   OFile   :=  TRIM(OFile)
   WRGFile :=  TRIM(WRGFile)
   AAnr    :=  TRIM(AAnr)    //AnzufÅgende Artikelnummer
   TAks    := RTRIM(TAks)    //Einzusetzende Katalogseite

   IF .NOT. FILE(D4Datei)
      thelp := tday + " " + TIME() + " "
      thelp := thelp + "Es existiert keine Datanorm 4-Datei mit dem Namen:;"
      thelp := thelp + D4Datei
      Fehler(thelp)
      LOOP
   ENDIF

   IF LEN(OFile)>0 .AND. FILE(OFILE)=.T.
      thelp := tday + " " + TIME() + " "
      thelp := thelp + "Es existiert bereits eine Datei mit dem Namen:;"
      thelp := thelp + OFile
      Fehler(thelp)
      LOOP
   ENDIF

   IF LEN(WRGFile)>0 .AND. FILE(WRGFILE)=.F.
      thelp := tday + " " + TIME() + " "
      thelp := thelp + "Es existiert keine Warengruppen-Datei mit dem Namen:;"
      thelp := thelp + WRGFile
      Fehler(thelp)
      LOOP
   ENDIF

   IF .NOT. FILE(HDatei + "FNUHelp.DBF")
      thelp := tday + " " + TIME() + " "
      thelp := thelp + "Hilfsdatei FNUHelp.DBF nicht gefunden!;"
      thelp := thelp + "Entweder nicht vorhanden,;"
      thelp := thelp + "oder falscher Pfad eingestellt!"
      Fehler(thelp)
      LOOP
   ENDIF

   IF .NOT. FILE(HDatei + "FNUWrg.DBF")
      thelp := tday + " " + TIME() + " "
      thelp := thelp + "Hilfsdatei FNUWrg.DBF nicht gefunden!;"
      thelp := thelp + "Entweder nicht vorhanden,;"
      thelp := thelp + "oder falscher Pfad eingestellt!"
      Fehler(thelp)
      LOOP
   ENDIF

   IF .NOT. FILE(HDatei + "FNUArti.DBF")
      thelp := tday + " " + TIME() + " "
      thelp := thelp + "Hilfsdatei FNUArti.DBF nicht gefunden!;"
      thelp := thelp + "Entweder nicht vorhanden,;"
      thelp := thelp + "oder falscher Pfad eingestellt!"
      Fehler(thelp)
      LOOP
   ENDIF

   IF .NOT. FILE(HDatei + "FNUArti.DBT")
      thelp := tday + " " + TIME() + " "
      thelp := thelp + "Hilfsdatei FNUArti.DBT nicht gefunden!"
      Fehler(thelp)
      LOOP
   ENDIF

   IF .NOT. FILE("DISC.DBF")
      thelp := tday + " " + TIME() + " "
      thelp := thelp + "Die Rabatt-Datei DISC.DBF wurde nicht gefunden!"
      Fehler(thelp)
      LOOP
   ENDIF

   IF .NOT. FILE("DNUM.NTX")
      thelp := tday + " " + TIME() + " "
      thelp := thelp + "Die Rabatt-Index-Datei DNUM.NTX wurde nicht gefunden!"
      Fehler(thelp)
      LOOP
   ENDIF

   ARTIOpen()
   IF fehler = 1
      EXIT
   ENDIF
   IF ArtiS = "Y"
      FLOCK()
      IF FLOCK() = .F.
         thelp := tday + " " + TIME() + " Artikeldatei "
         thelp := thelp + "konnte nicht exklusiv geîffnet werden !"
         Fehler(thelp)
         LOOP
      ENDIF
   ENDIF

   SELE 2
   thelp := HDatei + "FNUHelp.DBF"
   USE (thelp) ALIAS hd

   SELE 3
   USE Disc ALIAS rd SHARED
   IF NETERR() = .T.
      Fehler("Fehler beim îffnen der Rabatt-Datei DISC.DBF !")
      EXIT
   ENDIF
   SET INDEX TO dnum

   SELE 4
   USE FNUAVE.DBF ALIAS me SHARED
   IF NETERR() = .T.
      Fehler("Fehler beim îffnen der Mengeneinheiten-Datei FNUAVE.DBF !")
      EXIT
   ENDIF

   SELE 5
   thelp := HDatei + "FNUWrg.DBF"
   USE (thelp) ALIAS wrgd
   ZAP

   SELE 6
   thelp := HDatei + "FNUArti.DBF"
   USE (thelp) ALIAS ta
   GO TOP

   MenueBH99 := SAVESCREEN(00,00,24,79)
   text := "Erstelle Hilfsdateien."
   Fenster()
   SELECT hd
   ZAP

   IF LEN(WRGFile)>0
      thelp := HDatei + "Data4.TXT"
      COPY FILE &WRGFile TO (thelp)
      APPEND FROM (thelp) SDF
      GO TOP
      DO WHILE .NOT. EOF()
         tzeile  := zeile
         tzeile2 := ""
         IF SUBS(tzeile,1,2)="S;" //Hauptwarengruppen- / Warengruppensatz
            NextProc(";") //S;<- frei;->
            NextProc(";") //frei;<- Hauptwarengruppe;->
            NextProc(";") //Hauptwarengruppe;<-
                          //Hauptwarengruppen-Bezeichnung;->
            IF LEN(thelp)>0
               SELECT wrgd
               GO TOP
               LOCATE FOR wrg = thelp
               IF FOUND() = .F.
                  APPEND BLANK
                  REPLACE wrgd->wrg WITH thelp
               ENDIF
               SELECT hd
            ENDIF
            NextProc(";") //Hauptwarengruppen-Bezeichnung;<- Warengruppe;->
            NextProc(";") //Warengruppe;<- Warengruppen-Bezeichnung;->
            NextProc(";") //Warengruppen-Bezeichnung;<-
         ENDIF
         SKIP
      ENDDO
      ZAP
   ENDIF

   thelp := HDatei + "Data4.TXT"
   COPY FILE &D4Datei TO (thelp)
   APPEND FROM (thelp) SDF
   GO TOP
   RESTSCREEN(00,00,24,79,MenueBH99)

   @ 11,01 CLEAR TO 22,78
   @ 12,02 SAY "Datei vom   : 00.00.00"
   @ 12,26 SAY "WÑhrungskennzeichen:"
   @ 13,02 SAY "Info-Text 1 :"
   @ 14,02 SAY "Info-Text 2 :"
   @ 15,02 SAY "Info-Text 3 :"
   @ 16,47 SAY "Artikel im Sys.:"
   @ 17,02 SAY "Bearbeite Artikel     :                      Zeile / von    :"
   @ 19,02 SAY "Vorhandene Artikel    :          0           Bearbeitet (%) :"
   @ 20,02 SAY "Neu angelegte Artikel :          0"
   @ 21,02 SAY "----------------------------------"
   @ 21,47 SAY "Verbleib. Zeit :    0 min 00 s"
   @ 22,02 SAY "Bearbeitete Artikel   :          0"
   lieferer := " "
   VAt      := 0
   NAt      := 0
   GAt      := 0
   szeit    := SECONDS()

   DO WHILE .NOT. EOF()
      tzeile  := Zeile
      tzeile2 := ""
      neu     := 0
      zeilenr := RECNO()
      zeilevn := RECCOUNT()
      @ 17,64 SAY STR(zeilenr,6) + "/" + STR(zeilevn,6)
      forts   := zeilenr / zeilevn * 100
      @ 19,64 SAY forts PICTURE "999.99"
      mzeit := SECONDS()
      IF mzeit < szeit
         mzeit := 86399 + mzeit
      ENDIF
      vsec  := ((((mzeit - szeit) / zeilenr) * zeilevn) + szeit) - mzeit
      vmin  := (vsec / 60) - 0.49
      vmin  := ROUND(vmin,0)
      vsec  := vsec - (vmin * 60)
      @ 21,64 SAY vmin PICTURE "9999"
      @ 21,73 SAY vsec PICTURE "99"
      SELECT ad
      @ 16,67 SAY RECCOUNT()
      SELECT hd

      IF NEXTKEY() = K_ESC
         Abbruch := 1
         EXIT

      ELSEIF SUBS(hd->Zeile,1,2)="V " //Vorlaufsatz
         @ 12,16 SAY SUBS(TZeile,003,02) //Tag
         @ 12,19 SAY SUBS(TZeile,005,02) //Monat
         @ 12,22 SAY SUBS(TZeile,007,02) //Jahr
         IF D4DUE = "Y" //Datum aus der D4-Datei Åbernehmen
            THelp := SUBS(TZeile,003,02) + "." + SUBS(TZeile,005,02) + "."
            THelp := THelp + SUBS(TZeile,007,02)
            TAdp  := CTOD(THelp)
         ENDIF
         Lieferer := SUBS(TZeile,009,40) //Info-Text 1
         @ 13,16 SAY lieferer            //Info-Text 1
         @ 14,16 SAY SUBS(TZeile,049,40) //Info-Text 2
         @ 15,16 SAY SUBS(TZeile,089,35) //Info-Text 3
         @ 12,47 SAY SUBS(TZeile,126,03) //WÑhrungskennzeichen

      ELSEIF SUBS(hd->Zeile,1,4)="A;N;" .OR. SUBS(hd->Zeile,1,4)="A;A;"
         IF SUBS(hd->Zeile,1,4)="A;N;"
         //Hauptsatz - Neuanlage: Ausgabe des ganzen Satzes
            vkz := "N"
         ELSE
         //IF SUBS(hd->Zeile,1,4)="A;A;"
         //Hauptsatz - énderung: Ausgabe nur der geÑnderten Felder
            vkz := "A"
         ENDIF

         NextProc(";") //A;<- N;->
         NextProc(";") //N;<- ANr;->
         TZeile := AAnr + TZeile //hÑngt anzufÅgende Artikelnummer vorne an
         NextProc(";") //ANr;<- Textkennzeichen;->
         TAnr := thelp + SPACE(19 - LEN(thelp))
         @ 17,26 SAY TAnr
         SELECT ad
         SEEK tanr
         GAt := GAt + 1
         @ 22,26 SAY GAt
         IF .NOT. EOF()
            VAt := VAt + 1
            @ 19,26 SAY VAt
            IF ArtiS = "N"
               DBRLOCK()
            ENDIF
         ENDIF
         IF EOF() .AND. vkz="N"
            IF LEN(WRGFile)>0
               nStelle := AT(";", TZeile)
               TZeile3 := SUBS(TZeile,nStelle+1) //Textkennzeichen;->
               nStelle := AT(";", TZeile3)
               TZeile3 := SUBS(TZeile3,nStelle+1) //Kurztextzeile 1;->
               nStelle := AT(";", TZeile3)
               TZeile3 := SUBS(TZeile3,nStelle+1) //Kurztextzeile 2;->
               nStelle := AT(";", TZeile3)
               TZeile3 := SUBS(TZeile3,nStelle+1) //Preiskennzeichen;->
               nStelle := AT(";", TZeile3)
               TZeile3 := SUBS(TZeile3,nStelle+1) //Preiseinheit;->
               nStelle := AT(";", TZeile3)
               TZeile3 := SUBS(TZeile3,nStelle+1) //Mengeneinheit;->
               nStelle := AT(";", TZeile3)
               TZeile3 := SUBS(TZeile3,nStelle+1) //Preis;->
               nStelle := AT(";", TZeile3)
               TZeile3 := SUBS(TZeile3,nStelle+1) //Rabattgruppe;->
               nStelle := AT(";", TZeile3)
               TZeile3 := SUBS(TZeile3,nStelle+1) //Waren-, Hauptgruppe;->
               nStelle := AT(";", TZeile3)
               thelp   := SUBS(TZeile3,1,nStelle-1)
               IF LEN(thelp)>0
                  SELECT wrgd
                  GO TOP
                  LOCATE FOR wrg = thelp
                  IF FOUND() = .F.
                     SELECT hd
                     REPLACE zeile WITH tzeile2 + tzeile
                     SKIP
                     LOOP
                  ENDIF
               ENDIF
               SELECT ad
            ENDIF
            APPEND BLANK
            IF NETERR() = .T.
               DO WHILE NETERR() = .T.
                  APPEND BLANK
               ENDDO
            ENDIF
            IF ArtiS = "N"
               DBRLOCK()
            ENDIF
            REPLACE anr WITH tanr
            NAt := NAt + 1
            @ 20,26 SAY NAt
            neu := 1
         ENDIF
         IF EOF() .AND. vkz="A"
            SELECT hd
            REPLACE zeile WITH tzeile2 + tzeile
            SKIP
            LOOP
         ENDIF
         Tk1 := SUBS(TZeile,1,1) //Inhalt des Textkennzeichens 1
         Tk2 := SUBS(TZeile,2,1) //Inhalt des Textkennzeichens 2
         IF tk1 >= "0" .AND. tk1 <= "6"
            //Wird momentan noch nicht unterstÅtzt!
         ENDIF
         IF tk1 < "0" .OR. tk1 > "6"
            Tk2 := "0"
         ENDIF
         NextProc(";") //Textkennzeichen;<- Kurztextzeile 1;->
         NextProc(";") //Kurztextzeile 1;<- Kurztextzeile 2;->
         IF .NOT. LEN(thelp)=0 .AND. .NOT. vkz="A"
            IF fat="Y" .OR. neu=1
               REPLACE at1 WITH SUBS(thelp,1,40)
            ENDIF
         ENDIF
         NextProc(";") //Kurztextzeile 2;<- Preiskennzeichen;->
         IF neu=1 .AND. tk2="0"
            REPLACE at2 WITH SUBS(thelp,1,40)
         ENDIF
         IF fat="Y" .AND. tk2="0"
            IF vkz="N" .OR. LEN(thelp)>0
               REPLACE at2 WITH SUBS(thelp,1,40)
            ENDIF
         ENDIF
         pkz := "9" //setzt das Preiskennzeichen auf 9, damit alte EintrÑge
                    //gelîscht werden
         NextProc(";") //Preiskennzeichen;<- Preiseinheit;->
         IF LEN(thelp)>0
            pkz := thelp
               //ÅbertrÑgt das Preiskennzeichen aus der temporÑren Variable
               ///"THelp" in die Variable "PKZ"
         ENDIF
         NextProc(";") //Preiseinheit;<- Mengeneinheit;->
         IF LEN(thelp)>0
            DO CASE
               CASE thelp = "0"
                  REPLACE ape WITH 1
               CASE thelp = "1"
                  REPLACE ape WITH 10
               CASE thelp = "2"
                  REPLACE ape WITH 100
               CASE thelp = "3"
                  REPLACE ape WITH 1000
            ENDCASE
         ENDIF
         NextProc(";") //Mengeneinheit;<- Preis;->
         IF LEN(thelp)>0
            SELECT me
            LOCATE FOR ave1 = thelp

            IF FOUND() = .T.
               thelp := me->ave2
            ENDIF

            SELECT ad
            REPLACE ave WITH SUBS(thelp,1,3)
         ENDIF
         NextProc(";") //Preis;<- Rabattgruppe;->
         IF LEN(thelp)>0 //wenn Preis Åbergeben wird
            thelp  := "  " + thelp
            //"  " anhÑngen, damit der Preis Åber den Dezimalpunkt herauskommt
            //"  " statt 00, damit die Zahl nicht zuviele Stelle bekommt

            thelp3 := SUBS(thelp,1,LEN(thelp)-2) + "."
            //thelp3 enthÑlt nun die Einer und den Dezimalpunkt

            thelp  := thelp3 + SUBS(thelp,LEN(thelp)-1)
            //thelp enthÑlt nun thelp3 + Nachkommastellen

            thelp2 := VAL(thelp)
            //der String thelp wird nun in die Zahl thelp2 umgewandelt

            IF D4EUW="Y" //wenn Einser-Umwandlung aktiv ist
               thelp2 := thelp2 / ad->ape
               //Preis geteilt durch Preiseinheit
               REPLACE ad->ape WITH 1
               //Preiseinheit wird auf 1 gesetzt
            ENDIF

            thelp  := STR(thelp2)
            //die Zahl thelp2 wird nun in den String thelp umgewandelt

            thelp2 := AT(".", thelp)
            //der Dezimalpunkt wird nun in thelp gesucht

            thelp3 := LTRIM(SUBS(thelp,1,thelp2))
            //thelp3 enthÑlt nun die Einer und den Dezimalpunkt

            IF LEN(thelp3) > 9
            //wenn thelp3 grî·er als 9 Stellen ist und so nicht mehr in die
            //Datenbank passt

               thelp3 := SUBS(thelp3,LEN(thelp3)-6)
               //thelp3 wird auf 5 Vorkommastellen gekÅrzt

               thelp4 := tday + " " + TIME() + " "
               thelp4 := thelp4 + "Preis bei Artikel: " + tanr + " zu lang !"
               ErrorDatei(thelp4)
               //Fehlermeldung wird in das Errorfile geschrieben

            ENDIF

            thelp  := thelp3 + SUBS(thelp,thelp2+1)
            //thelp enthÑlt nun den kompletten Preis als String

            thelp2 := VAL(thelp)
            //thelp2 enthÑlt nun den kompletten Preis als Zahl

            DO CASE
               CASE pkz = "1" //Bruttopreis (Empfohlener Verkaufspreis)
                              //(Verkaufspreis)
                  REPLACE avk WITH thelp2
                  IF D4EBV = "Y" //Einkaufsp. Brutto = Verkaufsp.
                     REPLACE aev WITH thelp2
                  ENDIF
               CASE pkz = "2" //Nettopreis (Einkaufspreis)
                              //(Einkaufspreis Netto)
                  REPLACE aek WITH thelp2
                  IF D4EBEN = "Y" //Einkaufsp. Brutto = Einkaufsp. N.
                     REPLACE aev WITH thelp2
                  ENDIF
               CASE pkz = "3" //Werkspreis (Kalkulierter Verkaufspreis)
                              //(Einkaufspreis Brutto)
                  REPLACE aev WITH thelp2
            ENDCASE
         ENDIF
         NextProc(";") //Rabattgruppe;<- Waren-, Hauptgruppe;->
         IF LEN(thelp)>0
            REPLACE apg WITH thelp
            IF frab = "Y" .AND. pkz = "1"
               SELECT rd
               GO TOP
               SEEK thelp
               IF EOF()
                  APPEND BLANK
                  IF NETERR() = .T.
                     DO WHILE NETERR() = .T.
                        APPEND BLANK
                     ENDDO
                  ENDIF
                  IF ArtiS = "N"
                     DBRLOCK()
                  ENDIF
                  REPLACE dnr WITH thelp
               ENDIF
               thelp2 := dra
               SELECT ad
               REPLACE aek WITH aev * (1-(thelp2/100))
            ENDIF
         ENDIF
         NextProc(";") //Waren-, Hauptgruppe;<- LangtextschlÅssel->
         IF LEN(thelp)>0
            REPLACE awg WITH SUBS(thelp,1,3)
         ENDIF
         NextProc(";") //LangtextschlÅssel<-
         //Wird momentan noch nicht unterstÅtzt!

         //Berechnen des Rabatts auf VK
         //(Einkaufsrabatt auf den empfohlenen Verkaufspreis)
         thelp2 := (1 - (aek / avk)) * 100
         IF thelp2 < 0
            thelp2 := 0
            thelp3 := tday + " " + TIME() + " "
            thelp3 := thelp3 + "Errechneter Rabatt auf VK beim Artikel: "
            thelp3 := thelp3 + tanr + " zu klein !"
            ErrorDatei(thelp3)
         ENDIF
         REPLACE ara WITH thelp2 //einsetzen des Rabatts auf VK

         //Berechnen des Rabatts auf EK-Brutto
         //(Kalkulierte Zuschlag auf Einkaufspreis)
         thelp2 := aek / aev * 100
         IF thelp2 > 99.99
            thelp2 := 99.99
            thelp3 := tday + " " + TIME() + " "
            thelp3 := thelp3 + "Errechneter Rabatt auf EK-Brutto beim "
            thelp3 := thelp3 + "Artikel: " + tanr + " zu gross !"
            ErrorDatei(thelp3)
         ENDIF
         REPLACE aim WITH thelp2 //einsetzen des Rabatts auf EK-Brutto

         REPLACE adp WITH tadp //Datum der letzten énderung der Artikeldaten
         REPLACE Ams WITH 1 //SteuerschlÅssel
         IF ArtiS = "N"
            DBRUNLOCK()
         ENDIF

      ELSEIF SUBS(hd->Zeile,1,4)="A;L;" //Hauptsatz-Lîschung
                                        //Langtext bleibt erhalten
         IF D4AL = "N" //Artikel zum lîschen markieren ?
            SELECT hd
            REPLACE zeile WITH tzeile2 + tzeile
            SKIP
            LOOP
         ENDIF
         NextProc(";") //A;<- L;->
         NextProc(";") //L;<- ANr;->
         TZeile := AAnr + TZeile //hÑngt anzufÅgende Artikelnummer vorne an
         NextProc(";") //ANr;<- ???;->
         TAnr := thelp + SPACE(19 - LEN(thelp))
         @ 17,26 SAY TAnr
         SELECT ad
         SEEK tanr
         IF .NOT. EOF()
            DELETE
            SELECT ta
            APPEND BLANK
            REPLACE anr WITH "*Geloescht"
            REPLACE amd WITH ad->amd //Langtext wird gesichert
            SELECT ad
            SEEK "*Geloescht"
            IF EOF()
               APPEND BLANK
               IF NETERR() = .T.
                  DO WHILE NETERR() = .T.
                     APPEND BLANK
                  ENDDO
               ENDIF
               IF ArtiS = "N"
                  DBRLOCK()
               ENDIF
               REPLACE anr WITH "*Geloescht"
            ENDIF
            REPLACE amd WITH amd + ta->amd //Langtext wird angehÑngt
            SELECT ta
            ZAP
            VAt := VAt + 1
            @ 19,26 SAY VAt
         ENDIF
         GAt := GAt + 1
         @ 22,26 SAY GAt
         IF ArtiS = "N"
            DBRUNLOCK()
         ENDIF

      ELSEIF SUBS(hd->Zeile,1,4)="A;X;" //Hauptsatz - ArtikelnummernÑnderung
         NextProc(";") //A;<- X;->
         NextProc(";") //X;<- ANr;->
         TZeile := AAnr + TZeile //hÑngt anzufÅgende Artikelnummer vorne an
         NextProc(";") //ANr;<- frei (Blank);->
         TAnr := thelp + SPACE(19 - LEN(thelp))
         @ 17,26 SAY TAnr
         GAt := GAt + 1
         @ 22,26 SAY GAt
         NextProc(";") //frei (Blank);<- TANr2;->
         TZeile := AAnr + TZeile //hÑngt anzufÅgende Artikelnummer vorne an
         NextProc(";") //TANr2;<- ???;->
         tanr2 := thelp
         SELECT ad
         SEEK tanr
         IF EOF()
            SELECT hd
            REPLACE zeile WITH tzeile2 + tzeile
            SKIP
            LOOP
         ENDIF
         VAt := VAt + 1
         @ 19,26 SAY VAt
         REPLACE ad->adp WITH tadp
         //Datum der letzten énderung der Artikeldaten
         COPY NEXT 1 TO ta
         REPLACE ta->anr WITH tanr2
         thelp := "Artikel wurde ersetzt durch: " + tanr2
         IF ArtiS = "N"
            DBRLOCK()
         ENDIF
         REPLACE ad->at1 WITH thelp
         SEEK tanr2
         IF EOF()
            APPEND BLANK
            IF NETERR() = .T.
               DO WHILE NETERR() = .T.
                  APPEND BLANK
               ENDDO
            ENDIF
            IF ArtiS = "N"
               DBRLOCK()
            ENDIF
            REPLACE anr WITH ta->anr
            REPLACE at1 WITH ta->at1
            REPLACE alb WITH ta->alb
            REPLACE aek WITH ta->aek
            REPLACE asb WITH ta->asb
            REPLACE afn WITH ta->afn
            REPLACE at2 WITH ta->at2
            REPLACE amg WITH ta->amg
            REPLACE aev WITH ta->aev
            REPLACE avk WITH ta->avk
            REPLACE apg WITH ta->apg
            REPLACE ara WITH ta->ara
            REPLACE ast WITH ta->ast
            REPLACE aba WITH ta->aba
            REPLACE ama WITH ta->ama
            REPLACE aam WITH ta->aam
            REPLACE amb WITH ta->amb
            REPLACE ahb WITH ta->ahb
            REPLACE ape WITH ta->ape
            REPLACE ave WITH ta->ave
            REPLACE awg WITH ta->awg
            REPLACE aum WITH ta->aum
            REPLACE aim WITH ta->aim
            REPLACE amd WITH ta->amd
            REPLACE ams WITH ta->ams
            REPLACE aea WITH ta->aea
            REPLACE aab WITH ta->aab
            REPLACE abb WITH ta->abb
            REPLACE aks WITH ta->aks
            REPLACE agv WITH ta->agv
            REPLACE aul WITH ta->aul
            REPLACE apr WITH ta->apr
            REPLACE akr WITH ta->akr
            REPLACE ars WITH ta->ars
            REPLACE asn WITH ta->asn
            REPLACE adp WITH ta->adp
            REPLACE adu WITH ta->adu
            NAt := NAt + 1
            @ 20,26 SAY NAt
         ENDIF
         SELECT ta
         ZAP
         IF ArtiS = "N"
            DBRUNLOCK()
         ENDIF

      ELSEIF SUBS(hd->Zeile,1,4)="B;N;" .OR. SUBS(hd->Zeile,1,4)="B;A;"
         IF SUBS(hd->Zeile,1,4)="B;N;"
         //Hauptsatz 2 - Neuanlage: Ausgabe des ganzen Satzes
            vkz := "N"
         ELSE
         //IF SUBS(hd->Zeile,1,4)="B;A;"
         //Hauptsatz 2 - énderung: Ausgabe nur der geÑnderten Felder
            vkz := "A"
         ENDIF

         NextProc(";") //B;<- N;->
         NextProc(";") //N;<- ANr;->
         TZeile := AAnr + TZeile //hÑngt anzufÅgende Artikelnummer vorne an
         NextProc(";") //ANr;<- Matchcode;->
         TAnr := thelp + SPACE(19 - LEN(thelp))
         @ 17,26 SAY TAnr
         GAt := GAt + 1
         @ 22,26 SAY GAt
         SELECT ad
         SEEK tanr
         IF EOF()
            SELECT hd
            REPLACE zeile WITH tzeile2 + tzeile
            SKIP
            LOOP
         ENDIF
         VAt := VAt + 1
         @ 19,26 SAY VAt
         IF ArtiS = "N"
            DBRLOCK()
         ENDIF
         NextProc(";") //Matchcode;<-
                       //Alternativ-Artikelnummer (Hersteller-Nr.);->
         IF LEN(thelp)>0
            REPLACE asb WITH thelp
         ENDIF
         NextProc(";") //Alternativ-Artikelnummer (Hersteller-Nr.);<-
                       //Katalog-Seite;->
         IF LEN(thelp)>0
            REPLACE afn WITH thelp
         ENDIF
         //Hier wird nicht NextProc verwendet, da die Katalog-Seite evt.
         //ersetzt werden soll
         nStelle := AT(";", TZeile) //Suche nach ;
         thelp   := SUBS(TZeile,1,nStelle-1) //Katalog-Seite
         IF LEN(taks)>0 //Einzusetzende Katalogseite
            thelp := taks
         ENDIF
         TZeile2 := TZeile2 + thelp + ";" //Katalog-Seite;<-
         TZeile  := SUBS(TZeile,nStelle+1) //CU-Gewichtsmerker;->
         IF LEN(thelp)>0
            REPLACE aks WITH thelp
         ENDIF
         NextProc(";") //CU-Gewichtsmerker;<- CU-Kennzahl;->
         IF LEN(thelp)>0
            REPLACE ama WITH VAL(thelp)
         ENDIF
         NextProc(";") //CU-Kennzahl;<- CU-Gewicht;->
         IF LEN(thelp)>0
            REPLACE aba WITH VAL(thelp)
         ENDIF
         NextProc(";") //CU-Gewicht;<- ???;->
         IF LEN(thelp)>0
            thelp  := "00" + thelp
            thelp3 := SUBS(thelp,1,LEN(thelp)-2) + "."
            IF LEN(thelp3) > 8
               thelp3 := SUBS(thelp3,LEN(thelp3)-5)
               thelp4 := tday + " " + TIME() + " "
               thelp4 := thelp4 + "CU-Gewicht bei Artikel: " + tanr
               thelp4 := thelp4 + " zu lang !"
               ErrorDatei(thelp4)
            ENDIF
            thelp := thelp3 + SUBS(thelp,(LEN(thelp)-(LEN(thelp)-2)))
            REPLACE amg WITH VAL(TZeile)
         ENDIF
         REPLACE adp WITH tadp //Datum der letzten énderung der Artikeldaten
         IF ArtiS = "N"
            DBRUNLOCK()
         ENDIF

      ELSEIF SUBS(hd->Zeile,1,2)="C;" //Leistungssatz C
         //Wird momentan noch nicht unterstÅtzt!

      ELSEIF SUBS(hd->Zeile,1,2)="D;" //Dimensionssatz
         //Wird momentan noch nicht unterstÅtzt!

      ELSEIF SUBS(hd->Zeile,1,2)="T;" //Langtextsatz T
         //Wird momentan noch nicht unterstÅtzt!

      ELSEIF SUBS(hd->Zeile,1,2)="E;" //Langtextsatz E
         //Wird momentan noch nicht unterstÅtzt!

      ELSEIF SUBS(hd->Zeile,1,2)="S;" //Warengruppensatz
         //Wird momentan noch nicht unterstÅtzt!

      ELSEIF SUBS(hd->Zeile,1,2)="R;" //Rabattsatz
         NextProc(";") //R;<- frei (Blank);->
         NextProc(";") //frei (Blank);<- Rabatt-Gruppe;->
         NextProc(";") //Rabatt-Gruppe;<- Rabattkennzeichen;->
         @ 17,02 SAY "Bearbeite Rabatt-Gru. :"
         thelp := thelp + SPACE(19 - LEN(thelp))
         @ 17,26 SAY thelp
         SELECT rd
         GO TOP
         SEEK thelp
         IF .NOT. EOF()
            IF ArtiS = "N"
               DBRLOCK()
            ENDIF
         ELSE
            APPEND BLANK
            IF NETERR() = .T.
               DO WHILE NETERR() = .T.
                  APPEND BLANK
               ENDDO
            ENDIF
            IF ArtiS = "N"
               DBRLOCK()
            ENDIF
            REPLACE dnr WITH thelp
         ENDIF
         NextProc(";") //Rabattkennzeichen;<- Rabatt / Multi;->
                       // 1 = Rabattsatz
                       // 2 = Multi
         thelp2 := VAL(thelp)
         NextProc(";") //Rabatt / Multi;<- Rabattgruppen-Bezeichnung
                       // 2/2 N Rabatt
                       // 1/3 N Multi
         IF thelp2 = 1
            thelp3 := "0" + SUBS(thelp,1,LEN(thelp)-2) + "."
            thelp := thelp3 + SUBS(thelp,(LEN(thelp)-(LEN(thelp)-2)))
            REPLACE dra WITH VAL(thelp)
         ENDIF
         IF thelp2 = 2
            //Wird momentan noch nicht unterstÅtzt!
         ENDIF
         IF LEN(TZeile)>0
            REPLACE dhn WITH TZeile
         ENDIF
         REPLACE dln WITH lieferer
         IF ArtiS = "N"
            DBRUNLOCK()
         ENDIF

      ELSEIF SUBS(hd->Zeile,1,2)="P;" //PreisÑnderungssatz
         NextProc(";") //P;<- A;->
         NextProc(";") //A;<- ANr;->
         DO WHILE .T.
            nStelle := AT(";", TZeile)
            IF nStelle=0
               EXIT
            ENDIF
            TZeile := AAnr + TZeile //hÑngt anzufÅgende Artikelnummer vorne an
            NextProc(";") //ANr;<- //Preiskennzeichen;->
            TAnr := thelp + SPACE(19 - LEN(thelp))
            @ 17,26 SAY TAnr
            GAt := GAt + 1
            @ 22,26 SAY GAt
            SELECT ad
            SEEK tanr
            IF .NOT. EOF()
               VAt := VAt + 1
               @ 19,26 SAY VAt
               IF ArtiS = "N"
                  DBRLOCK()
               ENDIF
               NextProc(";") //Preiskennzeichen;<- Preis;->
               pkz   := "9"
               IF LEN(thelp)>0
                  pkz := thelp
               ENDIF
               NextProc(";") //Preis;<- Rabattkennzeichen;->
               IF LEN(thelp)>0 //wenn Preis Åbergeben wird
                  thelp  := "  " + thelp
                  //"  " anhÑngen, damit der Preis Åber den Dezimalpunkt
                  //herauskommt
                  //"  " statt 00, damit die Zahl nicht zuviele Stelle bekommt

                  thelp3 := SUBS(thelp,1,LEN(thelp)-2) + "."
                  //thelp3 enthÑlt nun die Einer und den Dezimalpunkt

                  thelp  := thelp3 + SUBS(thelp,LEN(thelp)-1)
                  //thelp enthÑlt nun thelp3 + Nachkommastellen

                  thelp2 := VAL(thelp)
                  //der String thelp wird nun in die Zahl thelp2 umgewandelt

                  IF D4EUW="Y" //wenn Einser-Umwandlung aktiv ist
                     thelp2 := thelp2 / ad->ape
                     //Preis geteilt durch Preiseinheit
                     REPLACE ad->ape WITH 1
                     //Preiseinheit wird auf 1 gesetzt
                  ENDIF

                  thelp  := STR(thelp2)
                  //die Zahl thelp2 wird nun in den String thelp umgewandelt

                  thelp2 := AT(".", thelp)
                  //der Dezimalpunkt wird nun in thelp gesucht

                  thelp3 := LTRIM(SUBS(thelp,1,thelp2))
                  //thelp3 enthÑlt nun die Einer und den Dezimalpunkt

                  IF LEN(thelp3) > 9
                  //wenn thelp3 grî·er als 9 Stellen ist und so nicht mehr in die
                  //Datenbank passt

                     thelp3 := SUBS(thelp3,LEN(thelp3)-6)
                     //thelp3 wird auf 5 Vorkommastellen gekÅrzt

                     thelp4 := tday + " " + TIME() + " "
                     thelp4 := thelp4 + "Preis bei Artikel: " + tanr + " zu lang !"
                     ErrorDatei(thelp4)
                     //Fehlermeldung wird in das Errorfile geschrieben

                  ENDIF

                  thelp  := thelp3 + SUBS(thelp,thelp2+1)
                  //thelp enthÑlt nun den kompletten Preis als String

                  thelp2 := VAL(thelp)
                  //thelp2 enthÑlt nun den kompletten Preis als Zahl

                  DO CASE
                     CASE pkz = "1" //Bruttopreis (Empfohlener Verkaufspreis)
                                    //(Verkaufspreis)
                        REPLACE avk WITH thelp2
                        IF D4EBV = "Y" //Einkaufsp. Brutto = Verkaufsp.
                           REPLACE aev WITH thelp2
                        ENDIF
                     CASE pkz = "2" //Nettopreis (Einkaufspreis)
                                    //(Einkaufspreis Netto)
                        REPLACE aek WITH thelp2
                        IF D4EBEN = "Y" //Einkaufsp. Brutto = Einkaufsp. N.
                           REPLACE aev WITH thelp2
                        ENDIF
                     CASE pkz = "3" //Werkspreis (Kalkulierter Verkaufspreis)
                                    //(Einkaufspreis Brutto)
                        REPLACE aev WITH thelp2
                  ENDCASE
               ENDIF
               NextProc(";") //Rabattkennzeichen;<- //Rabatt / Multi;->
               //Wird momentan noch nicht unterstÅtzt!
               NextProc(";") //Rabatt / Multi;<- Rabattkennzeichen;->
               //Wird momentan noch nicht unterstÅtzt!
               NextProc(";") //Rabattkennzeichen;<- Rabatt / Multi;->
               //Wird momentan noch nicht unterstÅtzt!
               NextProc(";") //Rabatt / Multi;<- Rabattkennzeichen;->
               //Wird momentan noch nicht unterstÅtzt!
               NextProc(";") //Rabattkennzeichen;<- Rabatt / Multi;->
               //Wird momentan noch nicht unterstÅtzt!
               NextProc(";") //Rabatt / Multi;<- //???->
               //Wird momentan noch nicht unterstÅtzt!

               //Berechnen des Rabatts auf VK
               //(Einkaufsrabatt auf den empfohlenen Verkaufspreis)
               thelp2 := (1 - (aek / avk)) * 100
               IF thelp2 < 0
                  thelp2 := 0
                  thelp3 := tday + " " + TIME() + " "
                  thelp3 := thelp3 + "Errechneter Rabatt auf VK beim Artikel:"
                  thelp3 := thelp3 + " " + tanr + " zu klein !"
                  ErrorDatei(thelp3)
               ENDIF
               REPLACE ara WITH thelp2 //einsetzen des Rabatts auf VK

               //Berechnen des Rabatts auf EK-Brutto
               //(Kalkulierte Zuschlag auf Einkaufspreis)
               thelp2 := aek / aev * 100
               IF thelp2 > 99.99
                  thelp2 := 99.99
                  thelp3 := tday + " " + TIME() + " "
                  thelp3 := thelp3 + "Errechneter Rabatt auf EK-Brutto beim "
                  thelp3 := thelp3 + "Artikel: " + tanr + " zu gross !"
                  ErrorDatei(thelp3)
               ENDIF
               REPLACE aim WITH thelp2 //einsetzen des Rabatts auf EK-Brutto

               REPLACE adp WITH tadp
               //Datum der letzten énderung der Artikeldaten
            ELSE
               NextProc(";") //Preiskennzeichen;<- Preis;->
               NextProc(";") //Preis;<- Rabattkennzeichen;->
               NextProc(";") //Rabattkennzeichen;<- Rabatt / Multi;->
               NextProc(";") //Rabatt / Multi;<- Rabattkennzeichen;->
               NextProc(";") //Rabattkennzeichen;<- Rabatt / Multi;->
               NextProc(";") //Rabatt / Multi;<- Rabattkennzeichen;->
               NextProc(";") //Rabattkennzeichen;<- Rabatt / Multi;->
               NextProc(";") //Rabatt / Multi;<- ???->
            ENDIF
         ENDDO
         IF ArtiS = "N"
            DBRUNLOCK()
         ENDIF

      ELSE
         //Falls der Datensatz nicht erkannt wird
         thelp := tday + " " + TIME() + " "
         thelp := thelp + "Der Datensatz " + STR(zeilenr,1)
         thelp := thelp + " wurde nicht erkannt!"
         ErrorDatei(thelp)
         ErrorDatei(zeile)
      ENDIF

      SELECT hd
      REPLACE zeile WITH tzeile2 + tzeile
      SKIP

   ENDDO

   @ 21,47 SAY "Bearbeitungsz. :    0 min 00 s"
   mzeit := SECONDS()
   IF mzeit < szeit
      mzeit := 86399 + mzeit
   ENDIF
   vsec  := mzeit - szeit
   vmin  := (vsec / 60) - 0.49
   vmin  := ROUND(vmin,0)
   vsec  := vsec - (vmin * 60)
   @ 21,64 SAY vmin PICTURE "9999"
   @ 21,73 SAY vsec PICTURE "99"

   IF .NOT. Abbruch = 1
      IF LEN(OFile) > 0
         MenueBH99 := SAVESCREEN(00,00,24,79)
         text := "Erstelle Ausgabedatei."
         Fenster()
         thelp := HDatei + "Data4.TXT"
         COPY TO (thelp) SDF
         COPY FILE (thelp) TO &OFile
         RESTSCREEN(00,00,24,79,MenueBH99)
         ALERT("D4-Datei umgeschrieben.")
      ENDIF
      ALERT("D4-Datei eingelesen.")
   ELSE
      thelp := tday + " " + TIME() + " "
      thelp := thelp + "Einlesen der Datanorm 4-Datei abgebrochen!"
      Fehler(thelp)
   ENDIF

   SELECT ad
   IF ArtiS = "Y"
      UNLOCK
   ENDIF
   USE
   SELECT hd
   ZAP
   USE
   SELECT rd
   USE
   SELECT me
   USE
   SELECT wrgd
   ZAP
   USE
   SELECT ta
   ZAP
   USE
   thelp := HDatei + "Data4.TXT"
   FERASE(thelp)
   Abbruch := 0

ENDDO
RESTSCREEN(00,00,24,79,MenueBH01)
