#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_Icon=target.ico
#AutoIt3Wrapper_Outfile=GoHunt32.exe
#AutoIt3Wrapper_Res_Description=Software für Jaeger
#AutoIt3Wrapper_Res_Fileversion=0.6.1.1
#AutoIt3Wrapper_Res_LegalCopyright=Copyright - F.Marx - www.GFMSOFT.de
#AutoIt3Wrapper_Res_Language=1031
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Tidy_Stop_OnError=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****


;~ ##############################################
;~  _____            _           _           	#
;~ |_   _|          | |         | |          	#
;~   | |  _ __   ___| |_   _  __| | ___  ___ 	#
;~   | | | '_ \ / __| | | | |/ _` |/ _ \/ __|	#
;~  _| |_| | | | (__| | |_| | (_| |  __/\__ \	#
;~ |_____|_| |_|\___|_|\__,_|\__,_|\___||___/	#
;~ ##############################################

#include <Misc.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <GuiListView.au3>
#include <ComboConstants.au3>
#include <DateTimeConstants.au3>
#include <EditConstants.au3>
#include <IE.au3>
#include <ColorConstantS.au3>

;#################################################

;Starting Loadingscreen
SplashImageOn("",@ScriptDir&"\schwein_kopf.jpg",400,500,(@DesktopWidth - 400) / 2, (@DesktopHeight - 500) / 2,3)

;#################################################

;Init für Gui's
if FileExists(@ScriptDir&"\schwein_kopf.jpg") = false Then
	FileInstall("schwein_kopf.jpg","schwein_kopf.jpg")
EndIf


;~ ##############################################
;~ __      __            						#
;~ \ \    / /            						#
;~  \ \  / /_ _ _ __ ___ 						#
;~   \ \/ / _` | '__/ __|						#
;~    \  / (_| | |  \__ \						#
;~     \/ \__,_|_|  |___/						#
;~ ##############################################

Global $trefferarray, $hGraphic, $hBrush1, $wild_Bild, $sql_status, $dbh, $version, $test
Global $id, $gender, $lastid, $kanzelanzahl
Global $bildpfad, $uebergabevar, $temparray
Global $oIE = _IECreateEmbedded()
Global $lastid


$test = False
$wild_Bild = "reh.jpg"
$version = "0.6.1.1"
$programm_name = "GoHunt"



Global $Wildartarray[50]
$Wildartarray[1] = "Schwarzwild"
$Wildartarray[2] = "Rehwild"
$Wildartarray[3] = "Damwild"
$Wildartarray[4] = "Rotwild"
$Wildartarray[5] = "Sikawild"
$Wildartarray[6] = "Gamswild"
$Wildartarray[7] = "Muffelwild"
$Wildartarray[8] = "Feldhase"
$Wildartarray[9] = "Wildkaninchen"
$Wildartarray[10] = "Fuchs"
$Wildartarray[11] = "Dachs"
$Wildartarray[12] = "Baummarder"
$Wildartarray[13] = "Steinmarder"
$Wildartarray[14] = "Waschbär"
$Wildartarray[15] = "Mink"
$Wildartarray[16] = "Marderhund"


;-----------------------------------------------



; GUI-SGEMENT - Main gui
;-----------------------------------------------
#Region ### START Koda GUI section ### Form=main_gui.kxf
$Form1 = GUICreate($programm_name & " - " & $version, 615, 438, -1, -1)

GUISetBkColor(0x7F7F7F, $Form1)

$Form1_Pic1 = GUICtrlCreatePic("", 8, 8, 161, 105)
$Form1_Button1 = GUICtrlCreateButton("Öffnen", 8, 128, 161, 41)
$Form1_List1 = GUICtrlCreateListView("ID | Wildart | Datum | Ort", 176, 128, 425, 280)

_GUICtrlListView_SetColumn($Form1_List1, 0, "ID", "30", 0)
_GUICtrlListView_SetColumn($Form1_List1, 1, "Wildart", "80", 0)
_GUICtrlListView_SetColumn($Form1_List1, 2, "Datum", "180", 0)
_GUICtrlListView_SetColumn($Form1_List1, 3, "Ort", "130", 0)

$Form1_Button2 = GUICtrlCreateButton("Neuer Eintrag", 8, 176, 161, 41)
$Form1_Button3 = GUICtrlCreateButton("Eintrag löschen", 8, 224, 161, 41)
$Form1_Button4 = GUICtrlCreateButton("Statistik", 8, 272, 161, 41)
$Form1_Button5 = GUICtrlCreateButton("Maps", 8, 320, 161, 41)
$Form1_Button6 = GUICtrlCreateButton("Beenden", 8, 368, 161, 41)
$Form1_Label1 = GUICtrlCreateLabel($programm_name & " - by - F.Marx - " & $version &" - www.GFMSoft.de", 10, 416, 272, 17)
$Form1_Pic2 = GUICtrlCreatePic("schwein_logo_final2.jpg", 415 - 25, -10, 200 + 25, 145)

$Form1_Label2 = GUICtrlCreateLabel($programm_name, 10, 10, 250, 100)
If FileExists("c:\windows\fonts\segoescb.ttf") = True Then
	GUICtrlSetFont($Form1_Label2, 25, 400, 0, "Segoe Script",$CLEARTYPE_QUALITY)
Else
	GUICtrlSetFont($Form1_Label2, 25, 400, 0, "Arial")
EndIf

$Form1_Label3 = GUICtrlCreateLabel("Dein Assistent und Jagdtagebuch.", 10, 50, 370, 30)
GUICtrlSetFont($Form1_Label3, 15, 400, 0, "Segoe Script",$CLEARTYPE_QUALITY)

#EndRegion ### END Koda GUI section ###
;---------------------------


;GUI Trefferanzeige - Eintragen
;---------------------------
#Region ### START Koda GUI section ### Form=Trefferanzeige
$Form2 = GUICreate($programm_name & " - Trefferlage einzeichnen", 640 + 100, 480, (@DesktopWidth - 640) / 2, (@DesktopHeight - 480) / 2)
GUISetBkColor(0x7F7F7F, $Form2)
$Form2_Button1 = GUICtrlCreateButton("Treffer hinzufügen", 645, 200 - 30, 90, 40)
$Form2_Button2 = GUICtrlCreateButton("Treffer entfernen", 645, 250 - 30, 90, 40)
$Form2_Button3 = GUICtrlCreateButton("Zurück", 645, 250 + 50 - 30, 90, 40)
$form2_pic1 = GUICtrlCreatePic("", 1, 1, 640, 480)
$Form2_Pic2 = GUICtrlCreatePic("schwein_kopf.jpg", 645, 10, 90, 100)
$form2_label1 = GUICtrlCreateLabel($programm_name, 655, 450,100)
If FileExists("c:\windows\fonts\segoescb.ttf") = True Then
	GUICtrlSetFont($Form2_Label1, 12, 400, 0, "Segoe Script")
Else
	GUICtrlSetFont($Form2_Label1, 12, 400, 0, "Arial")
EndIf


GUISetState(@SW_HIDE, $Form2)
#EndRegion ### END Koda GUI section ###
;---------------------------


;GUI Datenanzeige
;--------------------------------------------
#Region ### START Koda GUI section ### Form=c:\users\fm\desktop\jb projekt\datenanzeige_form.kxf
$Form3 = GUICreate($programm_name & " - Datenanzeige", 876, 579 + 15, (@DesktopWidth - 876) / 2, (@DesktopHeight - 594) / 2)
GUISetBkColor(0x7F7F7F, $Form3)

$Form3_Pic1 = GUICtrlCreatePic("bild.jpg", 386, 48, 321, 241)
$Form3_Input7 = GUICtrlCreateInput("Wildart", 128, 88, 177, 25)
$Form3_Input6 = GUICtrlCreateInput("Datum", 128, 48, 177, 21)

$Form3_Input1 = GUICtrlCreateInput("", 128, 120, 177, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
$Form3_Input2 = GUICtrlCreateInput("", 128, 168, 177, 21)
$Form3_Input3 = GUICtrlCreateInput("", 128, 200, 177, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
$Form3_Input4 = GUICtrlCreateInput("", 128, 232, 177, 21)

$Form3_Edit1 = GUICtrlCreateEdit("", 16, 344, 841, 233, $ES_WANTRETURN, $ES_MULTILINE)
GUICtrlSetData(-1, "Freitext...")

$Form3_Label1 = GUICtrlCreateLabel("Datum", 16, 48, 52, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Form3_Label2 = GUICtrlCreateLabel("Wildart", 16, 88, 53, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Form3_Label3 = GUICtrlCreateLabel("Gewicht (Kg)", 16, 120, 62 + 50, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Form3_Label4 = GUICtrlCreateLabel("Munition", 16, 168, 64, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Form3_Label5 = GUICtrlCreateLabel("Schussanzahl", 16, 200, 104, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")

$Form3_Button2 = GUICtrlCreateButton("", 315, 196, 25, 25, $BS_BITMAP)
GUICtrlSetImage(-1, "target2.bmp")
GUICtrlSetTip(-1, "Trefferlage anzeigen")

$Form3_Label6 = GUICtrlCreateLabel("Revier", 16, 232, 49, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Form3_Label7 = GUICtrlCreateLabel("Notiz - Bemerkungen", 16, 320, 153, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Form3_Input5 = GUICtrlCreateInput("Input5", 128, 264, 177, 21)
$Form3_Label8 = GUICtrlCreateLabel("Einrichtung", 16, 264, 84, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")

$Form3_Label9 = GUICtrlCreateLabel("ID: " & $id, 1, 1, 84, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")

$Form3_Graphic1 = GUICtrlCreateGraphic(-8, 24, 931, 5)
GUICtrlSetGraphic(-1, $GUI_GR_MOVE, -4, 4)
GUICtrlSetGraphic(-1, $GUI_GR_LINE, 919, 4)

GUISetState(@SW_HIDE, $Form3)

$Form3_pic_w = GUICtrlCreatePic("w.jpg", 310, 80, 25, 35)
GUICtrlSetState($Form3_pic_w, $GUI_HIDE)

$Form3_pic_m = GUICtrlCreatePic("m.jpg", 310, 80, 25, 35)
GUICtrlSetState($Form3_pic_m, $GUI_HIDE)

$Form3_Button1 = GUICtrlCreateButton("Bild ändern", 710, 200 + 15, 150, 35)
$Form3_Button3 = GUICtrlCreateButton("Bild öffnen", 710, 240 + 15, 150, 35)

$Form3_Button4 = GUICtrlCreateButton("Datensatz ändern", 710, 100, 150, 35)
$Form3_Button5 = GUICtrlCreateButton("Schließen", 710, 140, 150, 35)
$Form3_Button6 = GUICtrlCreateButton("<", 340, 88, 20, 20)
GUICtrlSetTip(-1, "Geschlecht ändern")

#EndRegion ### END Koda GUI section ###


;GUI Trefferanzeige-ANZEIGE
;---------------------------
#Region ### START Koda GUI section ### Form=Trefferanzeige

$Form4 = GUICreate("Trefferlage-Anzeigen", 640 + 100, 480, (@DesktopWidth - 640) / 2, (@DesktopHeight - 480) / 2)
GUISetBkColor(0x7F7F7F, $Form4)
$Form4_Button1 = GUICtrlCreateButton("Treffer eintragen", 645, 200 - 100, 90, 40)
$Form4_Button2 = GUICtrlCreateButton("Treffer löschen", 645, 250 - 100, 90, 40)
$Form4_Button3 = GUICtrlCreateButton("Zurück", 645, 250 + 50 - 100, 90, 40)
$form4_pic1 = GUICtrlCreatePic("", 1, 1, 640, 480)
GUISetState(@SW_HIDE, $Form4)

#EndRegion ### END Koda GUI section ###
;---------------------------


;GUI DatenEINGABE
;--------------------------------------------
#Region ### START Koda GUI section ### Form=datenanzeige_form.kxf
$Form5 = GUICreate($programm_name & " - Dateneingabe", 876, 579 + 15, (@DesktopWidth - 876) / 2, (@DesktopHeight - 594) / 2)
GUISetBkColor(0x7F7F7F, $Form5)

$Form5_Pic1 = GUICtrlCreatePic("bild.jpg", 386, 48, 321, 241)
$Form5_Combo1 = GUICtrlCreateCombo("", 128, 88, 177, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSendMsg($Form5_Combo1,$EM_SETREADONLY,false,0)

GUICtrlSetData(-1, "Schwarzwild")
GUICtrlSetData(-1, "Rehwild")
GUICtrlSetData(-1, "Damwild")
GUICtrlSetData(-1, "Rotwild")
GUICtrlSetData(-1, "Sikawild")
GUICtrlSetData(-1, "Gamswild")
GUICtrlSetData(-1, "Muffelwild")

GUICtrlSetData(-1, "-------------1")

GUICtrlSetData(-1, "Feldhase")
GUICtrlSetData(-1, "Wildkaninchen")

GUICtrlSetData(-1, "-------------2")

GUICtrlSetData(-1, "Fuchs")
GUICtrlSetData(-1, "Dachs")

GUICtrlSetData(-1, "-------------3")

GUICtrlSetData(-1, "Baummarder")
GUICtrlSetData(-1, "Steinmarder")

GUICtrlSetData(-1, "-------------4")

GUICtrlSetData(-1, "Waschbär")
GUICtrlSetData(-1, "Mink")
GUICtrlSetData(-1, "Marderhund")

$Form5_Date1 = GUICtrlCreateDate("", 128, 48, 177, 25)

$Form5_Input1 = GUICtrlCreateInput("", 128, 120, 177, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
$Form5_Input2 = GUICtrlCreateInput("", 128, 168, 177, 21)
$Form5_Input3 = GUICtrlCreateInput("", 128, 200, 177, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
$Form5_Input4 = GUICtrlCreateInput("", 128, 232, 177, 21)
$Form5_Edit1 = GUICtrlCreateEdit("", 16, 344, 841, 233, $ES_WANTRETURN, $ES_MULTILINE)

GUICtrlSetData(-1, "Freitext...")

$Form5_Label1 = GUICtrlCreateLabel("Datum", 16, 48, 52, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Form5_Label2 = GUICtrlCreateLabel("Wildart", 16, 88, 53, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Form5_Label3 = GUICtrlCreateLabel("Gewicht (Kg)", 16, 120, 62 + 50, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Form5_Label4 = GUICtrlCreateLabel("Munition", 16, 168, 64, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Form5_Label5 = GUICtrlCreateLabel("Schussanzahl", 16, 200, 104, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")

$Form5_Button2 = GUICtrlCreateButton("", 315, 196, 25, 25, $BS_BITMAP)
GUICtrlSetImage(-1, "target2.bmp")
GUICtrlSetTip(-1, "Trefferlage anzeigen")

$Form5_Label6 = GUICtrlCreateLabel("Revier", 16, 232, 49, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Form5_Label7 = GUICtrlCreateLabel("Notiz - Bemerkungen", 16, 320, 153, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")

$Form5_Input5 = GUICtrlCreateInput("", 128, 264, 177, 21)

$Form5_Label8 = GUICtrlCreateLabel("Einrichtung", 16, 264, 84, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Form5_Label9 = GUICtrlCreateLabel("Status: " & $id, 1, 1, 750, 24)
GUICtrlSetFont(-1, 12, 4 * 00, 0, "MS Sans Serif")

$Form5_Button1 = GUICtrlCreateButton("Bild auswählen", 710, 200 + 15 - 100, 150, 35, $BS_ICON)
$Form5_Button3 = GUICtrlCreateButton("Speichern", 710, 240 + 15 - 100, 150, 35)
$Form5_Button4 = GUICtrlCreateButton("Zurück", 710, 260 + 15 - 20, 150, 35)

$Form5_Graphic1 = GUICtrlCreateGraphic(-8, 24, 931, 5)
GUICtrlSetGraphic(-1, $GUI_GR_MOVE, -4, 4)
GUICtrlSetGraphic(-1, $GUI_GR_LINE, 919, 4)

GUISetState(@SW_HIDE, $Form5)

GUICtrlCreatePic("w.jpg", 310, 80, 25, 35)
$Form5_radio1 = GUICtrlCreateRadio("", 310 + 32, 85, 15, 15)
GUICtrlCreatePic("m.jpg", 310, 80 + 35, 25, 35)
$Form5_radio2 = GUICtrlCreateRadio("", 310 + 32, 85 + 35, 15, 15)

#EndRegion ### END Koda GUI section ###


;GUI - OPEN - STREET - MAP
#Region ### START Koda GUI section ### Form= Maps-Anzeige
$Form6 = GUICreate("Map - Anzeige", 1190, 742 - 45, (@DesktopWidth - 1190) / 2, (@DesktopHeight - 742) / 2)
GUISetBkColor(0x7F7F7F, $Form6)
If @DesktopHeight <= 768 Then
	WinMove($Form6, "", (@DesktopWidth - 1190) / 2, 0)
EndIf

$verschieben = 9
$form6_label1 = GUICtrlCreateLabel("Daten: ", 1190 / 2, 570 - $verschieben, 150, 20)
$form6_label2 = GUICtrlCreateLabel("Anzahl: " & $kanzelanzahl, 1190 / 2 + 170, 570 - $verschieben, 150, 20)
$Form6_List1 = GUICtrlCreateList("", 1190 / 2, 590 - $verschieben, 1190 / 2 - 10, 110)

GUICtrlCreateObj($oIE, 10, 1, 1170, 550)

$form6_Button_Anzeigen = GUICtrlCreateButton("Anzeigen", 200 - 100, 590 - $verschieben, 100, 30)
$form6_Button_Home = GUICtrlCreateButton("Übersicht", 200 - 100, 630 - $verschieben, 100, 30)

$form6_Button_add = GUICtrlCreateButton("Hinzufügen", 1190 / 2 - 120 - 100, 600 - 10 - $verschieben, 100, 30)
$form6_Button_delete = GUICtrlCreateButton("Löschen", 1190 / 2 - 120 - 100, 635 - 5 - $verschieben, 100, 30)
$form6_Button_exit = GUICtrlCreateButton("Zurück", 200 - 100, 670 - $verschieben, 100, 30)

Global $g_idError_Message = GUICtrlCreateLabel("", 100, 500, 500, 30)
GUICtrlSetColor(-1, 0xff0000)

_IENavigate($oIE, "http://www.openstreetmap.org/?mlat=51.358&mlon=10.459#map=5/51.358/10.459")
_IEAction($oIE, "stop")

GUISetState(@SW_HIDE, $Form6)
#EndRegion ### END Koda GUI section ###


;GUI - Statisik
#Region ### START Koda GUI section ### Form=Statisik
$Form7 = GUICreate("Form1", 724, 497, 607, 213)
$Form7_Label1 = GUICtrlCreateLabel("Produziertes Wildbret: ", 32, 40, 259, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Form7_Label2 = GUICtrlCreateLabel("Abgegebene Schüsse: ", 32, 40+30, 259, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUISetState(@SW_HIDE, $Form7)
#EndRegion ### END Koda GUI section ###



;Programm initialisieren
init()



If @error = True Then
	MsgBox(64, "Fehler", "Fehler beim öffnen der user32.dll"&@CRLF&"Programm mit Adminrechten starten.")
	Exit
EndIf

;Loadingscreen off
SplashOff()

; Doppelklick auf Listview prüfen
GUISetState(@SW_SHOW, $Form1)
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")


;Main-Loop
;---------------------------
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE

			If WinActive($Form1) = True Then
				Exit
			EndIf

			load_in_Listview()

			If WinActive($Form6) = True Then
				GUISetState(@SW_HIDE, $Form6)
				GUISetState(@SW_SHOW, $Form1)
			EndIf

			If WinActive($Form5) = True Then
				GUISetState(@SW_HIDE, $Form5)
				GUISetState(@SW_SHOW, $Form1)
			EndIf

			If WinActive($Form2) = True Then
				GUISetState(@SW_HIDE, $Form2)
				GUISetState(@SW_SHOW, $Form5)
			EndIf

			If WinActive($Form3) = True Then
				GUISetState(@SW_HIDE, $Form3)
				GUISetState(@SW_SHOW, $Form1)
			EndIf

			If WinActive($Form4) = True Then
				GUISetState(@SW_HIDE, $Form4)
				GUISetState(@SW_SHOW, $Form3)
			EndIf

			If WinActive($Form7) = True Then
				GUISetState(@SW_SHOW, $Form1)
				GUISetState(@SW_HIDE, $Form7)
			EndIf



		;Datenbank-Eintrag öffnen - Ansichtsmaske öffnen
		Case $Form1_Button1

			$temparray = _GUICtrlListView_GetItemTextArray($Form1_List1)
			If IsArray($temparray) = True Then
				;Hier Funktion zum laden der Datenbankdaten starten mit übergabe der ID des gewählten eintrags
				load_data_from_db($temparray[1])
			EndIf

			;Hier kommt ein Array zurück
			;Identifikation über ID
			;ID ist dann $temparray[1]

			If $temparray[1] <> 0 Then
				If FileExists(@ScriptDir & "\Bilder\" & $temparray[1] & ".jpg") = True Then
					GUICtrlSetImage($Form3_Pic1, @ScriptDir & "\Bilder\" & $temparray[1] & ".jpg")
				Else
					GUICtrlSetImage($Form3_Pic1, @ScriptDir & "\Bild.jpg")
				EndIf

				GUISetState(@SW_SHOW, $Form3)
				GUISetState(@SW_HIDE, $Form1)


			Else
				;######################################################################################################################## Hier vielleicht irgendwann suche callen
			EndIf

		;Neuen Eintrag vornehmen
		Case $Form1_Button2

			GUICtrlSetData($Form5_Input1, "")
			GUICtrlSetData($Form5_Input2, "")
			GUICtrlSetData($Form5_Input3, "")
			GUICtrlSetData($Form5_Input4, "")
			GUICtrlSetData($Form5_Input5, "")
			GUICtrlSetData($Form5_Edit1, "")

			GUICtrlSetImage($Form5_Pic1,@ScriptDir&"\bild.jpg")

			GUISetState(@SW_SHOW, $Form5)
			GUISetState(@SW_HIDE, $Form1)
			neuer_eintrag_vorbereiten()

		;Eintrag löschen lassen
		Case $Form1_Button3
			kill_db_eintrag()

		;Statistik starten
		Case $Form1_Button4
			GUICtrlSetData($Form1_Button4,"Noch nicht verfügbar!")
			Sleep(1000)
			GUICtrlSetData($Form1_Button4,"Statistik")

		;Maps öffnen
		Case $Form1_Button5
			loadmapsdata()
			GUISetState(@SW_SHOW, $Form6)
			GUISetState(@SW_HIDE, $Form1)
			$kanzelanzahl = _GUICtrlListBox_GetCount($Form6_List1)
			GUICtrlSetData($form6_label2, "Anzahl: " & $kanzelanzahl)

		;Programm beenden
		Case $Form1_Button6
			Exit

		;Neuen Eintrag erzeugen
		Case $Form5_Button3
			neuer_eintrag()

			;Bild ins Programmverzeichnis kopieren
			FileCopy($bildpfad, @ScriptDir & "\Bilder\" & $lastid & ".jpg", 9)

		; AB HIER FORM2-Buttons (Form2 - Trefferlage_GUI)
		;Trefferlage einzeichnen
		Case $Form2_Button1
			trefferlage()

		;Trefferlagen löschen
		Case $Form2_Button2
			_WinAPI_RedrawWindow($Form2)
			delete_treffer()

		Case $Form2_Button3
			GUISetState(@SW_SHOW, $Form5)
			GUISetState(@SW_HIDE, $Form2)


		;Neues Bild einpflegen
		Case $Form3_Button1
			Local $Bildpfad2
			Local $temparray = 0
			$Bildpfad2 = FileOpenDialog("Bild wählen...", @DesktopDir, "Bilder (*.jpg)", $FD_FILEMUSTEXIST)

			If IsArray($temparray) = True Then
				FileCopy($Bildpfad2, @ScriptDir & "\Bilder\" & $temparray[1] & ".jpg", 9)
				GUICtrlSetImage($Form3_Pic1, @ScriptDir & "\Bilder\" & $temparray[1] & ".jpg")
			Else
				FileCopy($Bildpfad2, @ScriptDir & "\Bilder\" & $id & ".jpg", 9)
				GUICtrlSetImage($Form3_Pic1, @ScriptDir & "\Bilder\" & $id & ".jpg")
			EndIf

		;Bild öffnen
		Case $Form3_Button3

			If FileExists(@ScriptDir & "\Bilder\" & $id & ".jpg") = True Then
				ShellExecute(@ScriptDir & "\Bilder\" & $id & ".jpg")
			Else
				MsgBox(16, "Fehler beim öffnen", "Kein Bild für diesen Datensatz gefunden!")
			EndIf


		;Alle Treffer aus der Datenbank auslesen und anzeigen
		Case $Form3_Button2

			GUICtrlSetImage($form4_pic1, @ScriptDir & "\Daten\" & GUICtrlRead($Form3_Input7) & ".jpg")

			GUISetState(@SW_SHOW, $Form4)
			GUISetState(@SW_HIDE, $Form3)
			Trefferlageladen()
			Sleep(150)

		;EIntrag editieren
		Case $Form3_Button4
			edit_eintrag()

		;Zurück zur HauptGUI
		Case $Form3_Button5
			GUISetState(@SW_SHOW, $Form1)
			GUISetState(@SW_HIDE, $Form3)

		;Geschlecht wechseln
		case $Form3_Button6
			change_gender()
			load_data_from_db($temparray)

		;Treffer nachträglich einzeichnen
		Case $Form4_Button1
			If IsArray($temparray) = True Then
				$id = $temparray[1]
			EndIf

			trefferlage2()

		;Treffer nachträglich löschen
		Case $Form4_Button2
			If IsArray($temparray) = True Then
				$delid = $temparray[1]
			Else
				$delid = $id
			EndIf

			If MsgBox(4, "Abfrage - Löschen", "Wirklich alle Treffer für diesen Datensatz löschen: " & $delid) = 6 Then
				delete_treffer2($delid)
				_WinAPI_RedrawWindow($Form4)
			EndIf


		Case $Form4_Button3
			GUISetState(@SW_SHOW, $Form3)
			GUISetState(@SW_HIDE, $Form4)

		;Neuer Datensatz GUI - Bild auswählenbutton
		Case $Form5_Button1

			If FileExists(@ScriptDir & "\Bilder") = False Then
				DirCreate(@ScriptDir & "\Bilder")
			EndIf
			$bildpfad = FileOpenDialog("Bild wählen...", @DesktopCommonDir, "Bilder (*.jpg)", $FD_FILEMUSTEXIST)

			;Fehler abfangen
			if FileExists($bildpfad) = false Then
				$bildpfad = "bild.jpg"
			EndIf
			if $bildpfad = "" Then
				$bildpfad = "bild.jpg"
			EndIf

			GUICtrlSetImage($Form5_Pic1, $bildpfad)


		Case $Form5_Button2

			if StringInStr(guictrlread($Form5_Combo1),"---1") = True or StringInStr(guictrlread($Form5_Combo1),"---2") = True Then
				MsgBox(64, "Wildart wählen!", "Bitte wählen sie erst eine Wildart aus.")
			Else
				If GUICtrlRead($Form5_Combo1) <> "" or StringInStr(guictrlread($Form5_Combo1),"---1") = True Then

					GUICtrlSetImage($form2_pic1, @ScriptDir & "\Daten\" & GUICtrlRead($Form5_Combo1) & ".jpg")
					GUISetState(@SW_SHOW, $Form2)
					GUISetState(@SW_HIDE, $Form5)

					;Prüfen ob der User Mist eingegeben hat und nun ein nicht existentes Bild eingeblendet werden soll
					if FileExists(@ScriptDir & "\Daten\" & GUICtrlRead($Form5_Combo1) & ".jpg") = false Then

						MsgBox(64,"Fehler - Bildanzeige","Fehler beim laden des Bildes für die Trefferlage."&@CRLF&"Bitte vergewissern Sie sich, dass Sie keine eigenen Texteingaben bei WILDART machen, sondern eine Auswahl über das Menü treffen."&@CRLF&@CRLF&@CRLF&"Um eine Auswahl zu treffen müssen Sie mit der Maus auf das ausklappbare Menu klicken und eine Wildart anklicken.")
						GUISetState(@SW_SHOW, $Form5)
						GUISetState(@SW_HIDE, $Form2)

					EndIf


				Else
					MsgBox(64, "Wildart wählen!", "Bitte wählen sie erst eine Wildart aus.")
				EndIf
			EndIf


		;Von Dateneingabe zurück auf Hauptmaske wechseln
		Case $Form5_Button4
			GUISetState(@SW_HIDE, $Form5)
			GUISetState(@SW_SHOW, $Form1)

		;Auf Maps-GUI Einrichtungskoordinaten aulesen und auf Karte anzeigen
		Case $form6_Button_Anzeigen
			open_koords_map()

		;Neue Einrichtung in Mapsdatenbank einfügen
		Case $form6_Button_add
			addmapsdata()
			$kanzelanzahl = _GUICtrlListView_GetItemCount($Form6_List1)
			GUICtrlSetData($form6_label2, "Anzahl: " & $kanzelanzahl)

		;Übersicht laden - Deutschalnd auf Maps-Gui laden
		Case $form6_Button_Home
			_IENavigate($oIE, "http://www.openstreetmap.org/#map=6/51.570/11.492")
			_WinAPI_RedrawWindow($Form6)
			GUISetState(@SW_HIDE, $Form6)
			GUISetState(@SW_SHOW, $Form6)
			WinActivate($Form6)

		Case $form6_Button_delete
			delmapsdata()

		Case $form6_Button_exit
			GUISetState(@SW_SHOW, $Form1)
			GUISetState(@SW_HIDE, $Form6)

	EndSwitch
WEnd
;---------------------------


;Mit dieser Funktion kann man Treffer einzeichnen
Func trefferlage()


	Local $hDLL = DllOpen("user32.dll")
	if @error = true Then
		MsgBox(16,"Fehler - user32.dll","user32.dll konnte nciht geöffnet werden. Einige Programmfunktionen stehen Ihnen nicht zur Verfügung!")
	EndIf

	_GDIPlus_Startup()
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND($Form2)
	$hBrush1 = _GDIPlus_BrushCreateSolid()

	SplashTextOn("Warte auf Eingabe", "Bitte mit Mauszeiger auf Treffpunktlage fahren und einmal linksklicken", 300, 100, (@DesktopWidth - 300) / 2, 1)

	While 1
		If _IsPressed("01", $hDLL) = True Then

			$trefferarray = GUIGetCursorInfo($Form2)

			If $trefferarray[0] < 640 Then

				;Auf Fehler prüfen und bei Fehler Funktion verlassen
				If @error = true Then
					MsgBox(16, "Fehler - Trefferlage", "Fehler beim ermitteln der Trefferlage..")
					SplashOff()
					Return
				EndIf

				_GDIPlus_BrushSetSolidColor($hBrush1, 0xFFFF0000)
				_GDIPlus_GraphicsFillRect($hGraphic, $trefferarray[0] - 5, $trefferarray[1] - 5, 10, 10, $hBrush1)

				_SQLite_Startup()
				$dbh = _SQLite_Open(@ScriptDir & "\Daten\Datenbank.db")
				If @error = True Then
					MsgBox(16, "Fehler - SQLDatenbank", "Fehlerocode: " & @error & @CRLF & "Extended: " & @extended)
				EndIf

				If $lastid = "" Then
					MsgBox(16, "Fehler bei ID-Ermittlung", "Es konnte keine ID für das Speichern in der Datenbank ermittelt werden!")
				EndIf

				$dbcheck = _SQLite_Exec($dbh, "insert into Trefferlage(ID,X,Y) values ('" & $lastid & "','" & $trefferarray[0] & "','" & $trefferarray[1] & "');")

				ExitLoop
			EndIf

		EndIf
	WEnd

	SplashOff()

	DllClose($hDLL)
	_GDIPlus_Shutdown()
	_SQLite_Close($dbh)
	_SQLite_Shutdown()

EndFunc   ;==>trefferlage

;Diese Funktion ist für das nachträgliche Einzeichnen von Treffern in die Datenbank
Func trefferlage2()

	Local $hDLL = DllOpen("user32.dll")
	if @error = true Then
		MsgBox(16,"Fehler - user32.dll","user32.dll konnte nciht geöffnet werden. Einige Programmfunktionen stehen Ihnen nicht zur Verfügung!")
	EndIf

	_GDIPlus_Startup()
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND($Form4)
	$hBrush1 = _GDIPlus_BrushCreateSolid()

	SplashTextOn("Warte auf Eingabe", "Bitte mit Mauszeiger auf Treffpunktlage fahren und einmal linksklicken", 300, 100, (@DesktopWidth - 300) / 2, 1)

	While 1
		If _IsPressed("01", $hDLL) = True Then

			$trefferarray = GUIGetCursorInfo($Form4)

			If $trefferarray[0] < 640 Then

				If @error = true Then
					MsgBox(64, "Fehler", "Fehler beim ermitteln der Trefferlage")
					SplashOff()
					Return
				EndIf

				_GDIPlus_BrushSetSolidColor($hBrush1, 0xFFFF0000)
				_GDIPlus_GraphicsFillRect($hGraphic, $trefferarray[0] - 5, $trefferarray[1] - 5, 10, 10, $hBrush1)

				_SQLite_Startup()
				$dbh = _SQLite_Open(@ScriptDir & "\Daten\Datenbank.db")
				If @error = True Then
					MsgBox(16, "Fehler - SQLDatenbank", "Fehlerocode: " & @error & @CRLF & "Extended: " & @extended)
				EndIf


				If $id = "" Then
					MsgBox(16, "Fehler bei ID-Ermittlung", "Es konnte keine ID für das Speichern in der Datenbank ermittelt werden!")
				EndIf

				$dbcheck = _SQLite_Exec($dbh, "insert into Trefferlage(ID,X,Y) values ('" & $id & "','" & $trefferarray[0] & "','" & $trefferarray[1] & "');")

				ExitLoop
			EndIf

		EndIf
	WEnd

	SplashOff()

	DllClose($hDLL)
	_GDIPlus_Shutdown()
	_SQLite_Close($dbh)
	_SQLite_Shutdown()


EndFunc   ;==>trefferlage2


;Diese Funktion initialisiert das Programm
Func init()

	Local $dbcheck

	;Sql-Engine laden
	$sql_status = _SQLite_Startup("sqlite3.dll", 1)

	;Auf Fehler prüfen
	If @error = True Then
		MsgBox(16, "Fehler - SQLITE", "Fehler beim laden der SQLite-Engine!")
		If FileExists("sqlite3.dll") = False Then
			MsgBox(16, "Fehler - SQLITE", "Es konnte keine Sqlite3.dll gefunden werden." & @CRLF & "Pfad: " & @ScriptDir & "\sqlite3.dll")
			MsgBox(64, "SQLITE - laden", "Bitte laden Sie die SQLITE3.dll herunter und legen Sie ins Programmverzeichnis!")
			Exit
		EndIf
	EndIf

	;Datenbank öffnen oder anlegen, wenn nicht vorhanden
	If FileExists(@ScriptDir & "\daten") = False Then
		DirCreate(@ScriptDir & "\daten")
	EndIf

	If FileExists(@ScriptDir & "\Daten\Datenbank.db") = False Then
		$dbh = _SQLite_Open(@ScriptDir & "\Daten\Datenbank.db")
		If @error = True Then
			MsgBox(16, "Fehler - SQLDatenbank", "Fehlerocode: " & @error & @CRLF & "Extended: " & @extended)
			Exit
		EndIf

		$dbcheck = _SQLite_Exec($dbh, "CREATE Table Daten (ID,Datum,Wildart,Gewicht,Munition,Schussanzahl,Ort,Notiz,Geschlecht,Einrichtung,gelöscht);")
		If $dbcheck = $SQLITE_OK Then
			;Hier stand ein alter Test-Wert
		Else
			MsgBox(16, "Fehler - SQL", "Table Daten konnten nicht geschrieben werden!" & @CRLF & "Fehlermeldung: " & @error)
		EndIf

		$dbcheck = _SQLite_Exec($dbh, "CREATE Table Trefferlage (ID,X,Y);")
		If $dbcheck <> $SQLITE_OK Then
			MsgBox(16, "Fehler - SQL", "Table Trefferlage - Fehler!" & @CRLF & "Fehlermeldung: " & @error)
		EndIf


		If $test = True Then
			If MsgBox(4, "Testmodus", "Sollen Testdaten in die Datenbank geschrieben werden?") = 6 Then

				Local $dbcheck
				$dbcheck = _SQLite_Exec($dbh, "insert into Daten(ID,Datum,Wildart,Gewicht,Munition,Schussanzahl,Ort,Notiz,Geschlecht,Einrichtung,gelöscht) values ('1','12.12.2012','Rehwild','20','RWS HMK','1','Musterhausen','notiz','M','Wespe','False');")

				$dbcheck = _SQLite_Exec($dbh, "insert into Daten(ID,Datum,Wildart,Gewicht,Munition,Schussanzahl,Ort,Notiz,Geschlecht,Einrichtung,gelöscht) values ('2','4.4.2012','Hase','5','RWS HMK','1','Musterhausen','notiz','W','Ksitz','False');")

				$dbcheck = _SQLite_Exec($dbh, "insert into Daten(ID,Datum,Wildart,Gewicht,Munition,Schussanzahl,Ort,Notiz,Geschlecht,Einrichtung,gelöscht) values ('3','5.10.2013','Schwarzwild','60','RWS HMK','2','Musterhausen','notiz','M','Misthaufen','False');")

				$dbcheck = _SQLite_Exec($dbh, "insert into Maps(ID,Name,Nkoord,EKoord,gelöscht) values ('1','Testkanzel','51.0263','15.0330','False');")

				If $dbcheck = $SQLITE_OK Then
					MsgBox(64, "Eintrag erfolgreich", "Die Testdaten wurden erfolgreich hinzugefügt!")
				Else
					MsgBox(16, "Fehler - SQL", "Daten konnten nicht geschrieben werden!" & @CRLF & "Fehlermeldung: " & @error)
				EndIf

			EndIf
		EndIf

;~ 		http://www.openstreetmap.org/#map=14/52.0290/14.0295

		$dbcheck = _SQLite_Exec($dbh, "CREATE Table Maps (ID,Name,Nkoord,Ekoord,gelöscht);")
		If $dbcheck <> $SQLITE_OK Then
			MsgBox(16, "Fehler - SQL", "Table Maps konnten nicht geschrieben werden!" & @CRLF & "Fehlermeldung: " & @error)
		EndIf

		_SQLite_Close($dbh)
		_SQLite_Shutdown()

	EndIf

	check_fehler()
	load_in_Listview()

	; Benötigte Daten installieren
	If FileExists("Daten\fuchs.jpg") = False Then
		FileInstall("Daten\fuchs.jpg", "Daten\fuchs.jpg")
	EndIf
	If FileExists("Daten\Rehwild.jpg") = False Then
		FileInstall("Daten\Rehwild.jpg", "Daten\Rehwild.jpg")
	EndIf
	If FileExists("Daten\schwarzwild.jpg") = False Then
		FileInstall("Daten\schwarzwild.jpg", "Daten\schwarzwild.jpg")
	EndIf
	If FileExists("bild.jpg") = False Then
		FileInstall("bild.jpg", "bild.jpg")
	EndIf
	If FileExists("sqlite3.dll") = False Then
		FileInstall("sqlite3.dll", "sqlite3.dll")
	EndIf
	If FileExists("target.bmp") = False Then
		FileInstall("target.bmp", "target.bmp")
	EndIf
	If FileExists("target2.bmp") = False Then
		FileInstall("target2.bmp", "target2.bmp")
	EndIf
	If FileExists("m.jpg") = False Then
		FileInstall("m.jpg", "m.jpg")
	EndIf
	If FileExists("w.jpg") = False Then
		FileInstall("w.jpg", "w.jpg")
	EndIf
	If FileExists("schwein_logo_final2.jpg") = False Then
		FileInstall("schwein_logo_final2.jpg", "schwein_logo_final2.jpg")
	EndIf

EndFunc   ;==>init


;Diese Funktion läd alle Datenbankeinträge ins Listview der MAINGUI
Func load_in_Listview()

	_GUICtrlListView_DeleteAllItems($Form1_List1)

	Local $query, $dbdata, $Index_listload
	$Index_listload = 0

	_SQLite_Startup()

	If FileExists(@ScriptDir & "\Daten\Datenbank.db") = True Then

		$dbh = _SQLite_Open(@ScriptDir & "\Daten\Datenbank.db")
		If @error = True Then
			MsgBox(16, "Fehler - SQLDatenbank", "Fehlerocode: " & @error & @CRLF & "Extended: " & @extended)
		EndIf

		;Alle daten der Datenbank abfragen - Hier in Table 'Daten' - Und in listview schreiben
		_SQLite_Query($dbh, "select * from Daten", $query)

		;Listview füllen

		;Beispeil zu füllen des Listviews
		;---------------------------------------------------------------
;~ 		_GUICtrlListView_AddItem($Form1_List1,"Hallo1",1)
;~ 		_GUICtrlListView_AddSubItem($Form1_List1,0,"Hallo2",1,1)
;~ 		_GUICtrlListView_AddSubItem($Form1_List1,0,"Hallo3",2,1)
		;---------------------------------------------------------------

		While _SQLite_FetchData($query, $dbdata) = $SQLITE_OK

			If $dbdata[10] = "False" Then
				_GUICtrlListView_AddItem($Form1_List1, $dbdata[0], $Index_listload)
				_GUICtrlListView_AddSubItem($Form1_List1, $Index_listload, $dbdata[2], 1, 1)
				_GUICtrlListView_AddSubItem($Form1_List1, $Index_listload, $dbdata[1], 2, 1)
				_GUICtrlListView_AddSubItem($Form1_List1, $Index_listload, $dbdata[6], 3, 1)
				$Index_listload = $Index_listload + 1
			EndIf

		WEnd

		_SQLite_QueryFinalize($query)
		_SQLite_Close($dbh)
		_SQLite_Shutdown()
	Else
		MsgBox(16, "Fehler - Datenbank", "Datenbank nicht gefunden!")
	EndIf

EndFunc   ;==>load_in_Listview


;Läd die Trefferlagen aus der Datenbank und zeichnet diese auf die GUI wenn User sie sehen will
Func Trefferlageladen()

	Local $query, $dbdata

	If $id = 0 Then
		Return 0
	EndIf

	ConsoleWrite("Lade Trefferlagen für ID: "&$id&@CRLF)

	_SQLite_Startup()
	_GDIPlus_Startup()

	$dbh = _SQLite_Open(@ScriptDir & "\Daten\Datenbank.db")
	If @error = True Then
		MsgBox(16, "Fehler - SQLDatenbank", "Fehlerocode: " & @error & @CRLF & "Extended: " & @extended)
	EndIf
	_SQLite_Query($dbh, "select * from Trefferlage where ID='" & $id & "'", $query)
	While _SQLite_FetchData($query, $dbdata) = $SQLITE_OK



;~ 		Array struktur
;~ 		Row|Col 0
;~ 		[0]|1 - id
;~ 		[1]|234 - x
;~ 		[2]|293 - y



		$hGraphic = _GDIPlus_GraphicsCreateFromHWND($Form4)
		$hBrush2 = _GDIPlus_BrushCreateSolid()
		_GDIPlus_BrushSetSolidColor($hBrush2, 0xFFFF0000)
		_GDIPlus_GraphicsFillRect($hGraphic, $dbdata[1], $dbdata[2], 10, 10, $hBrush2)


	WEnd

	_SQLite_QueryFinalize($query)
	_SQLite_Close($dbh)
	_SQLite_Shutdown()
	_GDIPlus_Shutdown()

EndFunc   ;==>Trefferlageladen



;DIese Funktion läd alle Daten aus der Bank und trägt diese in die Ansichtsmaske ein
Func load_data_from_db($temparray)

	Local $query, $dbdata

	GUICtrlSetState($Form3_pic_w, $GUI_HIDE)
	GUICtrlSetState($Form3_pic_m, $GUI_HIDE)

	If $temparray = 0 Then
		Return 0
	EndIf

	_SQLite_Startup()

	$dbh = _SQLite_Open(@ScriptDir & "\Daten\Datenbank.db")
	If @error = True Then
		MsgBox(16, "Fehler - SQLDatenbank", "Fehlerocode: " & @error & @CRLF & "Extended: " & @extended)
	EndIf

	_SQLite_Query($dbh, "select * from Daten where ID='" & $temparray & "'", $query)

	While _SQLite_FetchData($query, $dbdata) = $SQLITE_OK

		; So kommen die Daten zurück
		;~ 	Row|Col 0
		;~ 	[0]|ID
		;~ 	[1]|DATUM
		;~ 	[2]|WILDTYP
		;~ 	[3]|GEWICHT
		;~ 	[4]|MUNI
		;~ 	[5]|SCHUSSANZAHL
		;~ 	[6]|ORT
		;~ 	[7]|NOTIZ
		;~ 	[8]|GESCHLECHT
		;~ 	[9]|ANITZEINRICHTUNG
		;~ 	[10]|LÖSCHMARKIERUNG


		GUICtrlSetData($Form3_Input6, $dbdata[1])
		GUICtrlSetData($Form3_Input7, $dbdata[2])
		GUICtrlSetData($Form3_Input1, $dbdata[3])
		GUICtrlSetData($Form3_Input2, $dbdata[4])
		GUICtrlSetData($Form3_Input3, $dbdata[5])
		GUICtrlSetData($Form3_Input4, $dbdata[6])
		GUICtrlSetData($Form3_Input5, $dbdata[9])
		GUICtrlSetData($Form3_Edit1, $dbdata[7])


		;Geschlecht setzen
		If $dbdata[8] = "M" Then
			GUICtrlSetState($Form3_pic_m, $GUI_Show)
		Else
			GUICtrlSetState($Form3_pic_w, $GUI_Show)
		EndIf

		;ID Setzen für Trefferlage
		$id = $dbdata[0]
		GUICtrlSetData($Form3_Label9, "ID: " & $id)

	WEnd

	_SQLite_QueryFinalize($query)
	_SQLite_Close($dbh)
	_SQLite_Shutdown()

EndFunc   ;==>load_data_from_db




;Diese Funktion fügt einen neuen Eintrag in die Datenbank ein
Func neuer_eintrag_vorbereiten()

	;Anmerkung
	;Es muss ermittelt werden, wie viele Einträge in der Datenbank sind
	;Das Ergebnis muss mit 1 addiert werden damit keine doppelten IDs vergeben werden!

	;Abfrage = select count(*) from daten

	Local $query, $dbdata

	_SQLite_Startup()

	$dbh = _SQLite_Open(@ScriptDir & "\Daten\Datenbank.db")
	If @error = True Then
		MsgBox(16, "Fehler - SQLDatenbank", "Fehlerocode: " & @error & @CRLF & "Extended: " & @extended)
	EndIf

	_SQLite_Query($dbh, "select count(*) from daten", $query)

	While _SQLite_FetchData($query, $dbdata) = $SQLITE_OK
		$lastid = $dbdata[0] + 1
	WEnd

	_SQLite_QueryFinalize($query)
	_SQLite_Close($dbh)
	_SQLite_Shutdown()

	GUICtrlSetData($Form5_Label9, "Status: ID's in DB: " & $lastid - 1 & " - New ID: " & $lastid)

	$bildpfad = ""
	GUICtrlSetImage($Form5_Pic1,"bild.jpg")


EndFunc   ;==>neuer_eintrag_vorbereiten

;Neuen Eintrag in Datenbank schreiben
Func neuer_eintrag()


	;Auf Fehler prüfen
	If GUICtrlRead($Form5_Combo1) = "-------------1" Or GUICtrlRead($Form5_Combo1) = "-------------2" Or GUICtrlRead($Form5_Combo1) = "-------------3" Or GUICtrlRead($Form5_Combo1) = "-------------4" Then
		MsgBox(16, "Fehler bei der Auswahl! ", "Bitte korrigieren Sie die Auswahl bei Wildart.")
		Return
	EndIf
	If GUICtrlRead($Form5_Combo1) = "" Then
		MsgBox(16, "Fehler bei der Auswahl! ", "Bitte korrigieren Sie die Auswahl bei Wildart.")
		Return
	EndIf

	_ArraySearch($Wildartarray, GUICtrlRead($Form5_Combo1))
	If @error = True Then
		MsgBox(16, "Fehler bei der Auswahl! ", GUICtrlRead($Form5_Combo1) & " ist keine bekannte Wildart." & @CRLF & "Bitte korrigieren Sie die Auswahl bei Wildart.")
		Return
	EndIf

	Local $query, $dbdata, $dbcheck
	$gender = ""

	;Radio checken
	;return value 1 wenn checked
	;return value 4 wenn not checked
	If GUICtrlRead($Form5_radio1) = 1 Then
		$gender = "W"
	EndIf
	If GUICtrlRead($Form5_radio2) = 1 Then
		$gender = "M"
	EndIf

	;Prüfen ob ein Geschlecht gewählt wurde - Wenn nicht dann M festlegen
	If $gender = "" Then
		MsgBox(64, "Kein Geschlecht gewählt", "Sie haben kein Geschlecht gewählt." & @CRLF & "Es wurde Männlich gesetzt")
		$gender = "M"
	EndIf


	_SQLite_Startup()

	$dbh = _SQLite_Open(@ScriptDir & "\Daten\Datenbank.db")

	If @error = True Then
		MsgBox(16, "Fehler - SQLDatenbank", "Fehlerocode: " & @error & @CRLF & "Extended: " & @extended)
		Return 0
	EndIf

	;Prüfen ob es schon einen Eintrag gibt
	_SQLite_Query($dbh, "select ID from Daten where ID is '" & $lastid & "'", $query)

	While _SQLite_FetchData($query, $dbdata) = $SQLITE_OK

		If IsArray($dbdata) = True Then
			MsgBox(16, "Fehler - ID", "Eintrag wurde nicht geschrieben." & @CRLF & "Es exitstiert bereits ein Eintrag mit dieser ID!")

			_SQLite_QueryFinalize($query)
			_SQLite_Close($dbh)
			_SQLite_Shutdown()
			Return 0

		EndIf

	WEnd

	_SQLite_QueryFinalize($query)

	$dbcheck = _SQLite_Exec($dbh, "insert into Daten(ID,Datum,Wildart,Gewicht,Munition,Schussanzahl,Ort,Notiz,Geschlecht,Einrichtung,gelöscht) values ('" & $lastid & "','" & GUICtrlRead($Form5_Date1) & "','" & GUICtrlRead($Form5_Combo1) & "','" & GUICtrlRead($Form5_Input1) & "','" & GUICtrlRead($Form5_Input2) & "','" & GUICtrlRead($Form5_Input3) & "','" & GUICtrlRead($Form5_Input4) & "','" & GUICtrlRead($Form5_Edit1) & "','" & $gender & "','" & GUICtrlRead($Form5_Input5) & "','False');")

	If $dbcheck = $SQLITE_OK Then
		MsgBox(64, "Eintrag erfolgreich", "Eintrag gespeichert.")
	Else
		MsgBox(16, "Fehler - SQL", "Daten konnten nicht geschrieben werden!" & @CRLF & "Fehlermeldung: " & @error)
	EndIf

	_SQLite_Close($dbh)
	_SQLite_Shutdown()

	;Eingabemaske leeren
	GUICtrlSetData($Form5_Input1, "")
	GUICtrlSetData($Form5_Input2, "")
	GUICtrlSetData($Form5_Input3, "")
	GUICtrlSetData($Form5_Input4, "")
	GUICtrlSetData($Form5_Input5, "")
	GUICtrlSetData($Form5_Edit1, "")


	GUISetState(@SW_HIDE, $Form3)
	GUISetState(@SW_SHOW, $Form1)
	load_in_Listview()

	GUISetState(@SW_HIDE, $Form5)
	GUISetState(@SW_SHOW, $Form1)

EndFunc   ;==>neuer_eintrag




;Löscht bei der Veragbe eines neuen Eintrags
Func delete_treffer()
	Local $query, $dbdata
	_SQLite_Startup()
	$dbh = _SQLite_Open(@ScriptDir & "\Daten\Datenbank.db")
	If @error = True Then
		MsgBox(16, "Fehler - SQLDatenbank", "Fehlerocode: " & @error & @CRLF & "Extended: " & @extended)
	EndIf
	_SQLite_Exec($dbh, "delete from Trefferlage where ID is '" & $lastid & "'")
	_SQLite_Close($dbh)
	_SQLite_Shutdown()
EndFunc   ;==>delete_treffer

;Löscht bei der nachträglichen Korrektur
Func delete_treffer2($delid)
	_SQLite_Startup()
	$dbh = _SQLite_Open(@ScriptDir & "\Daten\Datenbank.db")
	If @error = True Then
		MsgBox(16, "Fehler - SQLDatenbank", "Fehlerocode: " & @error & @CRLF & "Extended: " & @extended)
	EndIf
	_SQLite_Exec($dbh, "delete from Trefferlage where ID is '" & $delid & "'")
	_SQLite_Close($dbh)
	_SQLite_Shutdown()
EndFunc   ;==>delete_treffer2

;Diese Funktion editiert einen Eintrag in der Datenbank
Func edit_eintrag()

	;Auf Fehler prüfen
	;----------------------------------------------------------
	Local $fehlercheckindex, $wahl_wildart, $checkerror
	$wahl_wildart = GUICtrlRead($Form3_Input7)
	$checkerror = ""
	$fehlercheckindex = 1

	$checkerror = _ArraySearch($Wildartarray, $wahl_wildart)

	;Fehlermeldungen bauen
	If @error = True Then

		;~ 1 - $aArray is not an array
		;~ 2 - $aArray is not a 1D or 2D array
		;~ 3 - $aArray is empty
		;~ 4 - $iStart is greater than $iEnd
		;~ 5 - Array not 2D and $bRow set True
		;~ 6 - $vValue was not found in array

		If @error = 6 Then
			MsgBox(16, "Fehler - Wildart", "Die eigegebene Wildart ist nicht bekannt!" & @CRLF & "Bitte Wildart korrekt auswählen.")
			If MsgBox(4, "Wildarten auflisten?", "Möchten Sie die verfügbaren Wildarten sehen?") = 6 Then
				MsgBox(64, "Wildarten", $Wildartarray[1] & @CRLF & $Wildartarray[2] & @CRLF & $Wildartarray[3] & @CRLF & $Wildartarray[4] & @CRLF & $Wildartarray[5] & @CRLF & $Wildartarray[6] & @CRLF & $Wildartarray[7] & @CRLF & $Wildartarray[8] & @CRLF & $Wildartarray[9] & @CRLF & $Wildartarray[10] & @CRLF & $Wildartarray[11] & @CRLF & $Wildartarray[12] & @CRLF & $Wildartarray[13] & @CRLF & $Wildartarray[14] & @CRLF & $Wildartarray[15] & @CRLF & $Wildartarray[16])
			EndIf
		EndIf

		If @error = True And @error <> 1 And @error <> 2 And @error <> 3 And @error <> 4 And @error <> 5 And @error <> 6 Then
			MsgBox(16, "Unbekannter Fehler!", "Unbekannter Fehler beim ändern des Datensatzes!" & @CRLF & "Errorcode: " & @error)
		EndIf

		GUISetState(@SW_SHOW, $Form1)
		GUISetState(@SW_HIDE, $Form3)
		Return
	EndIf

	If $wahl_wildart = "" Then
		MsgBox(0, "Fehler - Wildart", "Diese Wildart ist nicht bekannt!" & @CRLF & "Bitte Wildart korrekt auswählen.")
		If MsgBox(4, "Wildarten auflisten?", "Möchten Sie die verfügbaren Wildarten sehen?") = 6 Then
			_ArrayDisplay($Wildartarray)
		EndIf
		GUISetState(@SW_SHOW, $Form1)
		GUISetState(@SW_HIDE, $Form3)
		Return
	EndIf

	;----------------------------------------------------------

	If MsgBox(4, "Datensatz wirklich ändern?", "Möchten Sie den Datensatz wirklich ändern?") = 7 Then
		GUISetState(@SW_SHOW, $Form1)
		GUISetState(@SW_HIDE, $Form3)
		Return
	EndIf


	Local $dbh
	_SQLite_Startup()
	$dbh = _SQLite_Open(@ScriptDir & "\Daten\Datenbank.db")
	If @error = True Then
		MsgBox(16, "Fehler - SQLDatenbank", "Fehlerocode: " & @error & @CRLF & "Extended: " & @extended)
	EndIf


	;~ SQL-Befehl zum updaten von Daten in der Datenbank
	$dbcheck = _SQLite_Exec($dbh, "update Daten set ID='" & $id & "', Datum='" & GUICtrlRead($Form3_Input6) & "', Wildart='" & GUICtrlRead($Form3_Input7) & "',Gewicht='" & GUICtrlRead($Form3_Input1) & "',Munition='" & GUICtrlRead($Form3_Input2) & "',Schussanzahl='" & GUICtrlRead($Form3_Input3) & "',Ort='" & GUICtrlRead($Form3_Input4) & "',Notiz='" & GUICtrlRead($Form3_Edit1) & "',Einrichtung='" & GUICtrlRead($Form3_Input5) & "',gelöscht='False' where ID='" & $id & "';")

	_SQLite_Close($dbh)
	_SQLite_Shutdown()
	MsgBox(64, "Änderung erfolgreich!", "Der Eintrag wurde geändert.")

	load_in_Listview()

EndFunc   ;==>edit_eintrag

;Diese Funktion prüft auf einen Doppelklick - Wenn Doppelklick erkannt wird, dann wird der DatenbankAufruf ausgelöst
Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $String
	$hWndListView = $Form1_List1
	If Not IsHWnd($Form1_List1) Then $hWndListView = GUICtrlGetHandle($Form1_List1)
	$tNMHDR = DllStructCreate("hwnd hWndFrom;uint_ptr IDFrom;INT Code", $lParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	If $hWndFrom = $hWndListView Then
		If $iCode = -3 Then
			$String = _GUICtrlListView_GetItemTextString($hWndListView, _GUICtrlListView_GetSelectionMark($hWndListView))
			Local $stringarray
			$stringarray = StringSplit($String, "|")
			$uebergabevar = $stringarray[1]
			$lastid=$uebergabevar
			_exectute_dbcall($uebergabevar)
		EndIf
	EndIf
EndFunc   ;==>WM_NOTIFY


;Diese Funktion wird nur mit einem Doppelklick gestartet - Diese Funktion ruft die Datenansicht auf und zeigt Daten
Func _exectute_dbcall($uebergabevar)

	Local $query, $dbdata

	$temparray = _GUICtrlListView_GetItemTextArray($Form1_List1)
	If IsArray($temparray) = True Then
		;Hier Funktion zum laden der Datenbankdaten starten mit Übergabe der ID des gewählten Eintrags
		load_data_from_db($temparray[1])
	Else
		MsgBox(16,"Fehler","Fehler bei idcheck")
		Return
	EndIf
	$uebergabevar=$temparray[1]

	ConsoleWrite("Datensatz-ID: "&$uebergabevar&@CRLF)

	GUICtrlSetState($Form3_pic_w, $GUI_HIDE)
	GUICtrlSetState($Form3_pic_m, $GUI_HIDE)

	If $uebergabevar = 0 Then
		MsgBox(64, "Fehler beim Auslesen", "Fehler beim Auslesen der ID!")
		Return
	EndIf

	_SQLite_Startup()

	$dbh = _SQLite_Open(@ScriptDir & "\Daten\Datenbank.db")
	If @error = True Then
		MsgBox(16, "Fehler - SQLDatenbank", "Fehlerocode: " & @error & @CRLF & "Extended: " & @extended)
		Return
	EndIf

	_SQLite_Query($dbh, "select * from Daten where ID='" & $uebergabevar & "'", $query)
	While _SQLite_FetchData($query, $dbdata) = $SQLITE_OK

		GUICtrlSetData($Form3_Input6, $dbdata[1])
		GUICtrlSetData($Form3_Input7, $dbdata[2])
		GUICtrlSetData($Form3_Input1, $dbdata[3])
		GUICtrlSetData($Form3_Input2, $dbdata[4])
		GUICtrlSetData($Form3_Input3, $dbdata[5])
		GUICtrlSetData($Form3_Input4, $dbdata[6])
		GUICtrlSetData($Form3_Input5, $dbdata[9])
		GUICtrlSetData($Form3_Edit1, $dbdata[7])


		;Geschlecht setzen
		If $dbdata[8] = "M" Then
			GUICtrlSetState($Form3_pic_m, $GUI_Show)
		Else
			GUICtrlSetState($Form3_pic_w, $GUI_Show)
		EndIf

		;Bild setzen
		If FileExists(@ScriptDir & "\Bilder\" & $uebergabevar & ".jpg") = True Then
			GUICtrlSetImage($Form3_Pic1, @ScriptDir & "\Bilder\" & $uebergabevar & ".jpg")
		Else
			GUICtrlSetImage($Form3_Pic1, @ScriptDir & "\Bild.jpg")
		EndIf

		;ID Setzen für Trefferlage
		$id = $dbdata[0]
		GUICtrlSetData($Form3_Label9, "ID: " & $id)
	WEnd

	_SQLite_QueryFinalize($query)
	_SQLite_Close($dbh)
	_SQLite_Shutdown()


	GUISetState(@SW_SHOW, $Form3)
	GUISetState(@SW_HIDE, $Form1)

EndFunc   ;==>_exectute_dbcall

;Diese Funktion löscht einen Eintrag in der Datenbank
Func kill_db_eintrag()

	Local $stringarray, $String, $dbh

	;ID ermitteln
	$String = _GUICtrlListView_GetItemTextString($Form1_List1, _GUICtrlListView_GetSelectionMark($Form1_List1))

	If $String = "" Or $String = "|||" Then
		MsgBox(64, "Fehler beim löschen!", "Sie müssen einen Datensatz auswählen.")
		Return
	EndIf

	$stringarray = StringSplit($String, "|")
	$id = $stringarray[1]

	If MsgBox(4, "Eintrag löschen?", "Möchten Sie den Ausgewählten Eintrag wirklich löschen?") = 6 Then
		MsgBox(64, "Eintrag löschen", "Eintrag wurde gelöscht!")

		_SQLite_Startup()
		$dbh = _SQLite_Open(@ScriptDir & "\Daten\Datenbank.db")
		If @error = True Then
			MsgBox(16, "Fehler - SQLDatenbank", "Fehlerocode: " & @error & @CRLF & "Extended: " & @extended)
		EndIf
		$dbcheck = _SQLite_Exec($dbh, "update Daten set gelöscht='True' where ID='" & $id & "';")

		If @error = True Then
			;~ -1 - SQLite reported an error (Check return value)
			;~ 1 - Error calling SQLite API 'sqlite3_exec'
			;~ 2 - Call prevented by SafeMode
			;~ 3 - Error Processing Callback from within _SQLite_GetTable2d()
			;~ 4 - Error while converting SQL statement to UTF-8
			MsgBox(16, "Fehler beim Löschen!", "Fehlercode: " & @error & @CRLF & "-1 - SQLite reported an error (Check return value)" & @CRLF & "1 - Error calling SQLite API 'sqlite3_exec'" & @CRLF & "2 - Call prevented by SafeMode" & @CRLF & "3 - Error Processing Callback from within _SQLite_GetTable2d()" & @CRLF & "4 - Error while converting SQL statement to UTF-8")
		EndIf

		_SQLite_Close($dbh)
		_SQLite_Shutdown()
	Else
		MsgBox(64, "Eintrag nicht löschen", "Eintrag wurde NICHT gelöscht!")
		Return
	EndIf

	load_in_Listview()

EndFunc   ;==>kill_db_eintrag


;Diese Funktion prüft auf Fehler
Func check_fehler()

;~ Was muss alles geprüft werden? - Kurze Liste
	; 1. Daten die erwartet werden müssen auf exisitenz geprüfen werden
;~ 	- Bilder
;~ 	- Datenbank (optional)
;~ 	- dlls 		(optional)



EndFunc   ;==>check_fehler


;Diese Funktion öffnet die ausgewählte Jagdeinrichtung und zeigt sie auf der Karte an
Func open_koords_map()

	Local $url, $urlarray, $mlat, $mlong, $buildurl

	$url = GUICtrlRead($Form6_List1)

	If $url = "" Then
		Return
	EndIf

	$urlarray = StringSplit($url, "#")
	$url = $urlarray[$urlarray[0]]
	$url = StringReplace($url, " ", "")
	$urlarray = StringSplit($url, "/")

	$mlat = $urlarray[1]
	$mlong = $urlarray[2]


	$buildurl = "http://www.openstreetmap.org/?mlat=" & $mlat & "&mlon=" & $mlong & "#map=15/" & $url

	_IENavigate($oIE, $buildurl)
	_WinAPI_RedrawWindow($Form6)

	GUISetState(@SW_HIDE, $Form6)
	GUISetState(@SW_SHOW, $Form6)
	WinActivate($Form6)


EndFunc   ;==>open_koords_map



;Diese Funktion läd alle Daten in die Mapsübersicht LISTE
Func loadmapsdata()

	Local $dbh, $query, $dbdata
	GUICtrlSetData($Form6_List1, "")

	_SQLite_Startup()
	$dbh = _SQLite_Open(@ScriptDir & "\Daten\Datenbank.db")
	If @error = True Then
		MsgBox(16, "Fehler - SQLDatenbank", "Fehlerocode: " & @error & @CRLF & "Extended: " & @extended)
	EndIf


	_SQLite_Query($dbh, "select * from Maps", $query)
	If @error = True Then
		MsgBox(16, "Fehler - SQLDatenbank", "Fehlerocode: " & @error & @CRLF & "Extended: " & @extended)
		Return
	EndIf
	While _SQLite_FetchData($query, $dbdata) = $SQLITE_OK

		;So kommen die Daten zurück
;~ 		Row|Col 0
;~ 		[0]|1   			ID
;~ 		[1]|Kaisersitz    	NAME
;~ 		[2]|15  			NKOORD
;~ 		[3]|12 				EKOORD
;~ 		[4]|False			Löschmarker

		If $dbdata[4] = "False" Then
			GUICtrlSetData($Form6_List1, $dbdata[1] & " # " & $dbdata[2] & "/" & $dbdata[3])
		EndIf


	WEnd


	_SQLite_Close($dbh)
	_SQLite_Shutdown()

EndFunc   ;==>loadmapsdata


Func addmapsdata()

	Local $dbh, $query, $dbdata, $NKoord, $EKoord, $Pointname, $addurl
	Local $mapsaddarray, $maps_ID, $query, $namefail
	$namefail = 0

	$addurl = _IEPropertyGet($oIE, "locationurl")

	$mapsaddarray = StringSplit($addurl, "=")
	If IsArray($mapsaddarray) = True Then
		;Placeholder
	Else
		MsgBox(16, "Fehler beim erstellen des Speicherpunktes!", "Die IE Adresse konnte nicht gesplittet werden!" & @CRLF & "Errorcode: " & @error)
		Return
	EndIf

	; Die Links sind nicht immer gleich und verändern sich teilweise - Hier wird dies abgefangen
	If UBound($mapsaddarray) < 4 Then
		$mapsaddarray = StringSplit($mapsaddarray[2], "/")
	Else
		$mapsaddarray = StringSplit($mapsaddarray[4], "/")
	EndIf

	_SQLite_Startup()
	$dbh = _SQLite_Open(@ScriptDir & "\Daten\Datenbank.db")
	If @error = True Then
		MsgBox(16, "Fehler - SQLDatenbank", "Fehlerocode: " & @error & @CRLF & "Extended: " & @extended)
	EndIf

	$NKoord = $mapsaddarray[2]
	$EKoord = $mapsaddarray[3]
	$Pointname = InputBox("Einrichtungsname", "Bitte geben Sie einen Einrichtungsnamen ein:", "Kanzelname")

	If $Pointname = "" Or $Pointname = "Kanzelname" Then
		MsgBox(16, "Fehler!", "Sie müssen einen Einrichtungsnamen vergeben!")
		_SQLite_Close($dbh)
		_SQLite_Shutdown()
		Return
	EndIf


	;Prüfen ob $Pointname schon vorhanden
	;###################################################################################################
	_SQLite_Query($dbh, "select name from maps", $query)
	If @error = True Then
		MsgBox(16, "Fehler - SQLDatenbank", "Fehlerocode: " & @error & @CRLF & "Extended: " & @extended)
		Return
	EndIf
	While _SQLite_FetchData($query, $dbdata) = $SQLITE_OK

		If $Pointname = $dbdata[0] Then
			MsgBox(16, "Fehler - Einrichtungsname", "Dieser Name wurde bereits vergeben!" & @CRLF & "Bitte vergeben Sie einen anderen Namen für diese Einrichtung.")
			$namefail = 1
		EndIf

	WEnd
	If $namefail = 1 Then
		_SQLite_Close($dbh)
		_SQLite_Shutdown()
		Return
	EndIf
	;###################################################################################################


	;Erste ID ermitteln
	;###################################################################################################
	$maps_ID = ""
	;SQL-Abfrage zum Zählen aller einträge
	; select count(*) from <TABLE>
	_SQLite_Query($dbh, "select count(*) from Maps", $query)
	If @error = True Then
		MsgBox(16, "Fehler - SQLDatenbank", "Fehlerocode: " & @error & @CRLF & "Extended: " & @extended)
		_SQLite_Close($dbh)
		_SQLite_Shutdown()
		Return
	EndIf
	While _SQLite_FetchData($query, $dbdata) = $SQLITE_OK
		$maps_ID = $dbdata[0]
	WEnd
	$maps_ID = $maps_ID + 1
	;###################################################################################################


	;Daten schreiben
	$dbcheck = _SQLite_Exec($dbh, "insert into Maps(ID,Name,Nkoord,Ekoord,gelöscht) values ('" & $maps_ID & "','" & $Pointname & "','" & $NKoord & "','" & $EKoord & "','False');")
	If @error = True Then
		MsgBox(16, "Fehler - SQLDatenbank", "Fehlerocode: " & @error & @CRLF & "Extended: " & @extended & @CRLF & "Readback from SQL-Exec: " & $dbcheck)
		_SQLite_Close($dbh)
		_SQLite_Shutdown()
		Return
	EndIf


	_SQLite_Close($dbh)
	_SQLite_Shutdown()

	loadmapsdata()

EndFunc   ;==>addmapsdata

;Funktion zum Entfernen von Einträgen aus der Karten-Datenbank
Func delmapsdata()

	Local $dbh, $mapsname, $mapsnamearray

	If GUICtrlRead($Form6_List1) = "" Then
		Return
	EndIf

	$mapsnamearray = StringSplit(GUICtrlRead($Form6_List1), "#")
	If IsArray($mapsnamearray) = False Then
		MsgBox(16, "Fehler", "Unbekannter Fehler beim Ermitteln des Names.")
		Return
	EndIf
	$mapsname = $mapsnamearray[1]
	$mapsname = StringTrimRight($mapsname, 1)

	If MsgBox(4, "Eintrag löschen?", "Möchten Sie wirklich die Einrichtung <" & $mapsname & "> löschen?") = 6 Then

		_SQLite_Startup()
		$dbh = _SQLite_Open(@ScriptDir & "\Daten\Datenbank.db")
		If @error = True Then
			MsgBox(16, "Fehler - SQLDatenbank", "Fehlerocode: " & @error & @CRLF & "Extended: " & @extended)
		EndIf

		$dbcheck = _SQLite_Exec($dbh, "update Maps set gelöscht='True' where Name='" & $mapsname & "';")

		If @error = True Then
			;~ -1 - SQLite reported an error (Check return value)
			;~ 1 - Error calling SQLite API 'sqlite3_exec'
			;~ 2 - Call prevented by SafeMode
			;~ 3 - Error Processing Callback from within _SQLite_GetTable2d()
			;~ 4 - Error while converting SQL statement to UTF-8
			MsgBox(16, "Fehler beim Löschen!", "Fehlercode: " & @error & @CRLF & "-1 - SQLite reported an error (Check return value)" & @CRLF & "1 - Error calling SQLite API 'sqlite3_exec'" & @CRLF & "2 - Call prevented by SafeMode" & @CRLF & "3 - Error Processing Callback from within _SQLite_GetTable2d()" & @CRLF & "4 - Error while converting SQL statement to UTF-8")
		EndIf

		_SQLite_Close($dbh)
		_SQLite_Shutdown()
	Else
		MsgBox(64, "Eintrag nicht löschen", "Eintrag wurde NICHT gelöscht!")
		Return
	EndIf

	loadmapsdata()
EndFunc   ;==>delmapsdata


;Geschlecht eines EIntrags Ändern
func change_gender()

	local $new_geschlecht
	$new_geschlecht=InputBox("Neues Geschlecht wählen (M / W)","Um das Geschlecht zu ändern geben Sie bitte M oder W ein.","M")

	if $new_geschlecht <> "m" and $new_geschlecht <> "W" Then
		MsgBox(16,"Fehleingabe","Sie haben nicht M oder W eingetragen!")
		Return
	EndIf

	Local $dbh
	_SQLite_Startup()
	$dbh = _SQLite_Open(@ScriptDir & "\Daten\Datenbank.db")
	If @error = True Then
		MsgBox(16, "Fehler - SQLDatenbank", "Fehlerocode: " & @error & @CRLF & "Extended: " & @extended)
	EndIf

	$dbcheck = _SQLite_Exec($dbh, "update Daten set Geschlecht='" & $new_geschlecht & "',gelöscht='False' where ID='" & $id & "';")

	_SQLite_Close($dbh)
	_SQLite_Shutdown()

	MsgBox(64, "Änderung erfolgreich!", "Der Eintrag wurde geändert.")

EndFunc



