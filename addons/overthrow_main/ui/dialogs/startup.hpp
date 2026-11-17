// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
class OT_dialog_start {
    onLoad = "[_this # 0, 'OT_dialog_start'] call OT_fnc_localizeDisplay";
    idd = 8098; movingEnable = 0; enableSimulation = 1;
    class controlsBackground {
        class Backdrop: RscOTPanel {
            idc = -1; text = "";
            x = "safeZoneX + 0.055 * safeZoneW"; y = "safeZoneY + 0.095 * safeZoneH";
            w = "0.89 * safeZoneW"; h = "0.8 * safeZoneH";
        };
        class Accent: RscOverthrowText {
            idc = -1; text = "";
            x = "safeZoneX + 0.055 * safeZoneW"; y = "safeZoneY + 0.095 * safeZoneH";
            w = "0.89 * safeZoneW"; h = "0.004 * safeZoneH";
            colorBackground[] = {0.27,0.86,0.63,1};
        };
        class ActionCard: RscOTPanel {
            idc = -1; text = "";
            x = "safeZoneX + 0.5 * safeZoneW"; y = "safeZoneY + 0.17 * safeZoneH";
            w = "0.4 * safeZoneW"; h = "0.55 * safeZoneH";
        };
    };
    class controls {
        class Brand: RscOTHeading {
            idc = -1; text = "OVERTHROW";
            x = "safeZoneX + 0.09 * safeZoneW"; y = "safeZoneY + 0.36 * safeZoneH";
            w = "0.37 * safeZoneW"; h = "0.08 * safeZoneH";
        };
        class Edition: RscOverthrowText {
            idc = -1; text = "COMMUNITY EDITION / FIGHT FOR FREEDOM";
            x = "safeZoneX + 0.09 * safeZoneW"; y = "safeZoneY + 0.45 * safeZoneH";
            w = "0.37 * safeZoneW"; h = "0.04 * safeZoneH";
        };
        class Logo: RscOverthrowPicture {
            idc = 1200; text = "\overthrow_main\ui\logo_overthrow.paa";
            x = "safeZoneX + 0.1 * safeZoneW"; y = "safeZoneY + 0.14 * safeZoneH";
            w = "0.17 * safeZoneW"; h = "0.22 * safeZoneH";
        };
        class Title: RscOTHeading {
            idc = -1; text = "START AN OPERATION";
            x = "safeZoneX + 0.53 * safeZoneW"; y = "safeZoneY + 0.24 * safeZoneH";
            w = "0.34 * safeZoneW"; h = "0.06 * safeZoneH";
        };
        class LanguageEnglish: RscOverthrowButton {
            idc = 1951; text = "English";
            x = "safeZoneX + 0.53 * safeZoneW"; y = "safeZoneY + 0.18 * safeZoneH";
            w = "0.16 * safeZoneW"; h = "0.04 * safeZoneH";
            action = "'en' call OT_fnc_setLanguage";
        };
        class LanguageTurkish: LanguageEnglish {
            idc = 1952; text = "Türkçe";
            x = "safeZoneX + 0.71 * safeZoneW";
            action = "'tr' call OT_fnc_setLanguage";
        };
        class Hint: RscOverthrowText {
            style = 16;
            idc = -1; text = "Choose your town. Build the resistance. Take back control.";
            x = "safeZoneX + 0.53 * safeZoneW"; y = "safeZoneY + 0.32 * safeZoneH";
            w = "0.33 * safeZoneW"; h = "0.1 * safeZoneH";
        };
        class New: RscOTPrimaryButton {
            idc = 1601; text = "NEW CAMPAIGN";
            x = "safeZoneX + 0.53 * safeZoneW"; y = "safeZoneY + 0.46 * safeZoneH";
            w = "0.34 * safeZoneW"; h = "0.075 * safeZoneH";
            action = "closeDialog 0; createDialog 'OT_dialog_newgame'; call OT_fnc_newGameDialog;";
        };
        class Load: RscOverthrowButton {
            idc = 1600; text = "CONTINUE CAMPAIGN";
            x = "safeZoneX + 0.53 * safeZoneW"; y = "safeZoneY + 0.56 * safeZoneH";
            w = "0.34 * safeZoneW"; h = "0.075 * safeZoneH";
            action = "closeDialog 0; createDialog 'OT_dialog_load';";
        };
        class Footer: RscOverthrowText {
            sizeEx = "0.023 * safeZoneH";
            idc = -1; text = "YOUR STORY / TOWNS • COMPANIES • REGIONAL COMMAND";
            x = "safeZoneX + 0.09 * safeZoneW"; y = "safeZoneY + 0.79 * safeZoneH";
            w = "0.78 * safeZoneW"; h = "0.04 * safeZoneH";
        };
    };
};

class OT_dialog_newgame {
    onLoad = "[_this # 0, 'OT_dialog_newgame'] call OT_fnc_localizeDisplay";
    idd = 8099; movingEnable = 0; enableSimulation = 1;
    class controlsBackground {
        class Backdrop: RscOTPanel {
            idc = -1; text = "";
            x = "safeZoneX + 0.04 * safeZoneW"; y = "safeZoneY + 0.06 * safeZoneH";
            w = "0.92 * safeZoneW"; h = "0.88 * safeZoneH";
        };
        class Accent: RscOverthrowText {
            idc = -1; text = "";
            x = "safeZoneX + 0.04 * safeZoneW"; y = "safeZoneY + 0.06 * safeZoneH";
            w = "0.92 * safeZoneW"; h = "0.004 * safeZoneH";
            colorBackground[] = {0.27,0.86,0.63,1};
        };
        class SetupCard: RscOTPanel {
            idc = -1; text = "";
            x = "safeZoneX + 0.05 * safeZoneW"; y = "safeZoneY + 0.2 * safeZoneH";
            w = "0.285 * safeZoneW"; h = "0.65 * safeZoneH";
        };
    };
    class controls {
        class Title: RscOTHeading {
            idc = -1; text = "CAMPAIGN SETUP";
            x = "safeZoneX + 0.065 * safeZoneW"; y = "safeZoneY + 0.085 * safeZoneH";
            w = "0.65 * safeZoneW"; h = "0.05 * safeZoneH";
        };
        class Subtitle: RscOverthrowText {
            idc = -1; text = "Set campaign rules and preview your starting town on the map.";
            x = "safeZoneX + 0.065 * safeZoneW"; y = "safeZoneY + 0.14 * safeZoneH";
            w = "0.78 * safeZoneW"; h = "0.035 * safeZoneH";
        };
        class Difficulty: RscOverthrowText {
            idc = 1101; text = "DIFFICULTY";
            x = "safeZoneX + 0.065 * safeZoneW"; y = "safeZoneY + 0.22 * safeZoneH";
            w = "0.25 * safeZoneW"; h = "0.035 * safeZoneH";
        };
        class Difficulty0: RscOverthrowButton {
            idc = 1600; text = "Easy";
            x = "safeZoneX + 0.065 * safeZoneW"; y = "safeZoneY + 0.265 * safeZoneH";
            w = "0.08 * safeZoneW"; h = "0.05 * safeZoneH";
            action = "['setting',[0,0]] call OT_fnc_newGameDialog";
        };
        class Difficulty1: RscOverthrowButton {
            idc = 1601; text = "Normal";
            x = "safeZoneX + 0.153 * safeZoneW"; y = "safeZoneY + 0.265 * safeZoneH";
            w = "0.08 * safeZoneW"; h = "0.05 * safeZoneH";
            action = "['setting',[0,1]] call OT_fnc_newGameDialog";
        };
        class Difficulty2: RscOverthrowButton {
            idc = 1602; text = "Hard";
            x = "safeZoneX + 0.241 * safeZoneW"; y = "safeZoneY + 0.265 * safeZoneH";
            w = "0.08 * safeZoneW"; h = "0.05 * safeZoneH";
            action = "['setting',[0,2]] call OT_fnc_newGameDialog";
        };
        class Travel: RscOverthrowText {
            idc = 1102; text = "FAST TRAVEL";
            x = "safeZoneX + 0.065 * safeZoneW"; y = "safeZoneY + 0.35 * safeZoneH";
            w = "0.25 * safeZoneW"; h = "0.035 * safeZoneH";
        };
        class Travel0: RscOverthrowButton {
            idc = 1603; text = "Free";
            x = "safeZoneX + 0.065 * safeZoneW"; y = "safeZoneY + 0.395 * safeZoneH";
            w = "0.08 * safeZoneW"; h = "0.05 * safeZoneH";
            action = "['setting',[1,0]] call OT_fnc_newGameDialog";
        };
        class Travel1: RscOverthrowButton {
            idc = 1604; text = "Paid";
            x = "safeZoneX + 0.153 * safeZoneW"; y = "safeZoneY + 0.395 * safeZoneH";
            w = "0.08 * safeZoneW"; h = "0.05 * safeZoneH";
            action = "['setting',[1,1]] call OT_fnc_newGameDialog";
        };
        class Travel2: RscOverthrowButton {
            idc = 1605; text = "Disabled";
            x = "safeZoneX + 0.241 * safeZoneW"; y = "safeZoneY + 0.395 * safeZoneH";
            w = "0.08 * safeZoneW"; h = "0.05 * safeZoneH";
            action = "['setting',[1,2]] call OT_fnc_newGameDialog";
        };
        class Rules: RscOverthrowText {
            idc = 1103; text = "TRAVEL RULES";
            x = "safeZoneX + 0.065 * safeZoneW"; y = "safeZoneY + 0.48 * safeZoneH";
            w = "0.25 * safeZoneW"; h = "0.035 * safeZoneH";
        };
        class Rules0: RscOverthrowButton {
            idc = 1607; text = "Unrestricted";
            x = "safeZoneX + 0.065 * safeZoneW"; y = "safeZoneY + 0.525 * safeZoneH";
            w = "0.08 * safeZoneW"; h = "0.05 * safeZoneH";
            action = "['setting',[2,0]] call OT_fnc_newGameDialog";
        };
        class Rules1: RscOverthrowButton {
            idc = 1608; text = "Unarmed";
            x = "safeZoneX + 0.153 * safeZoneW"; y = "safeZoneY + 0.525 * safeZoneH";
            w = "0.08 * safeZoneW"; h = "0.05 * safeZoneH";
            action = "['setting',[2,1]] call OT_fnc_newGameDialog";
        };
        class Rules2: RscOverthrowButton {
            idc = 1609; text = "Restricted";
            x = "safeZoneX + 0.241 * safeZoneW"; y = "safeZoneY + 0.525 * safeZoneH";
            w = "0.08 * safeZoneW"; h = "0.05 * safeZoneH";
            action = "['setting',[2,2]] call OT_fnc_newGameDialog";
        };
        class SpawnLabel: RscOverthrowText {
            idc = -1; text = "STARTING TOWN";
            x = "safeZoneX + 0.065 * safeZoneW"; y = "safeZoneY + 0.62 * safeZoneH";
            w = "0.25 * safeZoneW"; h = "0.035 * safeZoneH";
        };
        class SpawnTown: RscOverthrowCombo {
            idc = 2100; text = "";
            x = "safeZoneX + 0.065 * safeZoneW"; y = "safeZoneY + 0.665 * safeZoneH";
            w = "0.256 * safeZoneW"; h = "0.045 * safeZoneH";
            onLBSelChanged = "[] call OT_fnc_newGameDialog";
            tooltip = "Shared starting location for the new campaign";
        };
        class ForceLabel: RscOverthrowText {
            sizeEx = "0.025 * safeZoneH";
            idc = -1; text = "OCCUPYING FORCE";
            x = "safeZoneX + 0.065 * safeZoneW"; y = "safeZoneY + 0.735 * safeZoneH";
            w = "0.256 * safeZoneW"; h = "0.03 * safeZoneH";
        };
        class Force: RscOverthrowCombo {
            idc = 2101;
            x = "safeZoneX + 0.065 * safeZoneW"; y = "safeZoneY + 0.77 * safeZoneH";
            w = "0.256 * safeZoneW"; h = "0.045 * safeZoneH";
            tooltip = "Sets the occupying army for the new campaign. Only installed, supported forces are shown.";
        };
        class Preview: RscMapControl {
            idc = 51; text = "";
            x = "safeZoneX + 0.355 * safeZoneW"; y = "safeZoneY + 0.22 * safeZoneH";
            w = "0.58 * safeZoneW"; h = "0.58 * safeZoneH";
            onDraw = "_this call OT_fnc_drawStartSelection";
        };
        class SelectedPlace: RscOverthrowText {
            idc = 1104; text = "Starting town";
            x = "safeZoneX + 0.37 * safeZoneW"; y = "safeZoneY + 0.815 * safeZoneH";
            w = "0.55 * safeZoneW"; h = "0.04 * safeZoneH";
        };
        class Begin: RscOTPrimaryButton {
            idc = 1606; text = "START CAMPAIGN";
            x = "safeZoneX + 0.69 * safeZoneW"; y = "safeZoneY + 0.88 * safeZoneH";
            w = "0.245 * safeZoneW"; h = "0.045 * safeZoneH";
            action = "['start'] call OT_fnc_newGameDialog";
        };
        class Back: RscOverthrowButton {
            idc = 1900; text = "BACK";
            x = "safeZoneX + 0.065 * safeZoneW"; y = "safeZoneY + 0.88 * safeZoneH";
            w = "0.255 * safeZoneW"; h = "0.045 * safeZoneH";
            action = "closeDialog 0; createDialog 'OT_dialog_start'";
        };
    };
};


class OT_dialog_load {
    onLoad = "[_this # 0, 'OT_dialog_load'] call OT_fnc_localizeDisplay";
    idd = 15150; movingEnable = 0; enableSimulation = 1;
    class controlsBackground {
        class Background: RscOTPanel { x = "safeZoneX + 0.22 * safeZoneW"; y = "safeZoneY + 0.12 * safeZoneH"; w = "0.56 * safeZoneW"; h = "0.76 * safeZoneH"; };
    };
    class controls {
        class Title: RscOTHeading { idc = -1; text = "CONTINUE CAMPAIGN"; x = "safeZoneX + 0.25 * safeZoneW"; y = "safeZoneY + 0.16 * safeZoneH"; w = "0.5 * safeZoneW"; h = "0.05 * safeZoneH"; };
        class LoadNormal: RscOTPrimaryButton { idc = 1600; text = "LOAD THIS PROFILE SAVE"; x = "safeZoneX + 0.25 * safeZoneW"; y = "safeZoneY + 0.25 * safeZoneH"; w = "0.5 * safeZoneW"; h = "0.065 * safeZoneH"; action = "closeDialog 0; [] remoteExec ['OT_fnc_loadGame', 2, false]"; };
        class ImportLabel: RscOverthrowText { idc = -1; text = "OR PASTE EXPORTED SAVE DATA"; sizeEx = "0.023 * safeZoneH"; x = "safeZoneX + 0.25 * safeZoneW"; y = "safeZoneY + 0.36 * safeZoneH"; w = "0.5 * safeZoneW"; h = "0.035 * safeZoneH"; };
        class EditBox: RscOverthrowEdit { idc = 1400; style = 16; autocomplete = ""; x = "safeZoneX + 0.25 * safeZoneW"; y = "safeZoneY + 0.41 * safeZoneH"; w = "0.5 * safeZoneW"; h = "0.29 * safeZoneH"; };
        class LoadString: RscOverthrowButton { idc = 1601; text = "IMPORT SAVE"; x = "safeZoneX + 0.25 * safeZoneW"; y = "safeZoneY + 0.74 * safeZoneH"; w = "0.5 * safeZoneW"; h = "0.045 * safeZoneH"; action = "private _result = [ctrlText ((findDisplay 15150) displayCtrl 1400)] call OT_fnc_parseSaveData; if (_result # 0) then { closeDialog 0; [_result # 2] remoteExec ['OT_fnc_loadGame', 2, false] } else { (_result # 1) call OT_fnc_notifyMinor }"; };
        class Back: RscOverthrowButton { idc = 1602; text = "BACK"; x = "safeZoneX + 0.25 * safeZoneW"; y = "safeZoneY + 0.81 * safeZoneH"; w = "0.5 * safeZoneW"; h = "0.035 * safeZoneH"; action = "closeDialog 0; createDialog 'OT_dialog_start'"; };
    };
};
