// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
class OT_dialog_main {
    idd = 8001; movingEnable = 0; enableSimulation = 1;
    class controlsBackground {
        class Backdrop: RscOTPanel {
            idc = -1; text = "";
            x = "safeZoneX + 0.035 * safeZoneW"; y = "safeZoneY + 0.095 * safeZoneH";
            w = "0.94 * safeZoneW"; h = "0.8 * safeZoneH";
        };
        class Accent: RscOverthrowText {
            idc = -1; text = "";
            x = "safeZoneX + 0.035 * safeZoneW"; y = "safeZoneY + 0.095 * safeZoneH";
            w = "0.94 * safeZoneW"; h = "0.004 * safeZoneH";
            colorBackground[] = {0.27,0.86,0.63,1};
        };
        class NavigationCard: RscOTPanel {
            idc = 1103; text = "";
            x = "safeZoneX + 0.045 * safeZoneW"; y = "safeZoneY + 0.115 * safeZoneH";
            w = "0.21 * safeZoneW"; h = "0.76 * safeZoneH";
        };
        class ContextCard: RscOTPanel {
            idc = 1104; text = "";
            x = "safeZoneX + 0.735 * safeZoneW"; y = "safeZoneY + 0.115 * safeZoneH";
            w = "0.225 * safeZoneW"; h = "0.76 * safeZoneH";
        };
    };
    class controls {
        class Brand: RscOTHeading {
            idc = -1; text = "OVERTHROW / OPERATIONS CENTER";
            x = "safeZoneX + 0.055 * safeZoneW"; y = "safeZoneY + 0.035 * safeZoneH";
            w = "0.55 * safeZoneW"; h = "0.05 * safeZoneH";
        };
        class Wallet: RscOverthrowStructuredText {
            idc = 1106; text = "";
            x = "safeZoneX + 0.73 * safeZoneW"; y = "safeZoneY + 0.035 * safeZoneH";
            w = "0.23 * safeZoneW"; h = "0.05 * safeZoneH";
        };
        class Navigation: RscOverthrowText {
            idc = -1; text = "OPERATIONS";
            x = "safeZoneX + 0.06 * safeZoneW"; y = "safeZoneY + 0.135 * safeZoneH";
            w = "0.18 * safeZoneW"; h = "0.04 * safeZoneH";
        };
        class Nav1699: RscOverthrowButton {
            idc = 1699; text = "Map intelligence";
            x = "safeZoneX + 0.055 * safeZoneW"; y = "safeZoneY + 0.205 * safeZoneH";
            w = "0.19 * safeZoneW"; h = "0.048 * safeZoneH";
            action = "closeDialog 0; [] spawn OT_fnc_mapInfoDialog";
        };
        class Nav1600: RscOverthrowButton {
            idc = 1600; text = "Fast travel";
            x = "safeZoneX + 0.055 * safeZoneW"; y = "safeZoneY + 0.271 * safeZoneH";
            w = "0.19 * safeZoneW"; h = "0.048 * safeZoneH";
            action = "closeDialog 0; [] spawn OT_fnc_fastTravel";
        };
        class Nav1613: RscOverthrowButton {
            idc = 1613; text = "Resistance management";
            x = "safeZoneX + 0.055 * safeZoneW"; y = "safeZoneY + 0.33699999999999997 * safeZoneH";
            w = "0.19 * safeZoneW"; h = "0.048 * safeZoneH";
            action = "closeDialog 0; [] spawn OT_fnc_resistanceDialog";
        };
        class Nav1614: RscOverthrowButton {
            idc = 1614; text = "Tasks";
            x = "safeZoneX + 0.055 * safeZoneW"; y = "safeZoneY + 0.403 * safeZoneH";
            w = "0.19 * safeZoneW"; h = "0.048 * safeZoneH";
            action = "closeDialog 0; [] spawn OT_fnc_jobsDialog";
        };
        class Nav1601: RscOverthrowButton {
            idc = 1601; text = "Place items";
            x = "safeZoneX + 0.055 * safeZoneW"; y = "safeZoneY + 0.469 * safeZoneH";
            w = "0.19 * safeZoneW"; h = "0.048 * safeZoneH";
            action = "closeDialog 0; createDialog 'OT_dialog_place'";
        };
        class Nav1602: RscOverthrowButton {
            idc = 1602; text = "Build and infrastructure";
            x = "safeZoneX + 0.055 * safeZoneW"; y = "safeZoneY + 0.535 * safeZoneH";
            w = "0.19 * safeZoneW"; h = "0.048 * safeZoneH";
            action = "closeDialog 0; [] spawn OT_fnc_build";
        };
        class Nav1603: RscOverthrowButton {
            idc = 1603; text = "Manage troops";
            x = "safeZoneX + 0.055 * safeZoneW"; y = "safeZoneY + 0.601 * safeZoneH";
            w = "0.19 * safeZoneW"; h = "0.048 * safeZoneH";
            action = "[] spawn OT_fnc_manageRecruitsDialog;";
        };
        class Nav1611: RscOverthrowButton {
            idc = 1611; text = "Character";
            x = "safeZoneX + 0.055 * safeZoneW"; y = "safeZoneY + 0.667 * safeZoneH";
            w = "0.19 * safeZoneW"; h = "0.048 * safeZoneH";
            action = "[] spawn OT_fnc_characterSheetDialog;";
        };
        class Nav1612: RscOverthrowButton {
            idc = 1612; text = "Settings and saves";
            x = "safeZoneX + 0.055 * safeZoneW"; y = "safeZoneY + 0.733 * safeZoneH";
            w = "0.19 * safeZoneW"; h = "0.048 * safeZoneH";
            action = "call OT_fnc_optionsDialog";
        };
        class StatusTitle: RscOverthrowText {
            idc = -1; text = "SITUATION REPORT";
            x = "safeZoneX + 0.29 * safeZoneW"; y = "safeZoneY + 0.135 * safeZoneH";
            w = "0.4 * safeZoneW"; h = "0.04 * safeZoneH";
        };
        class Status: RscOverthrowStructuredText {
            idc = 1100; text = "";
            x = "safeZoneX + 0.29 * safeZoneW"; y = "safeZoneY + 0.195 * safeZoneH";
            w = "0.4 * safeZoneW"; h = "0.22 * safeZoneH";
        };
        class TacticalMap: RscMapControl {
            idc = 51; text = "";
            x = "safeZoneX + 0.29 * safeZoneW"; y = "safeZoneY + 0.44 * safeZoneH";
            w = "0.41 * safeZoneW"; h = "0.34 * safeZoneH";
            onDraw = "_this call OT_fnc_drawCommandMap";
        };
        class Hint: RscOverthrowStructuredText {
            idc = 1150; text = "";
            x = "safeZoneX + 0.29 * safeZoneW"; y = "safeZoneY + 0.81 * safeZoneH";
            w = "0.41 * safeZoneW"; h = "0.08 * safeZoneH";
        };
        class ContextTitle: RscOverthrowText {
            idc = -1; text = "AREA AND PROPERTY";
            x = "safeZoneX + 0.755 * safeZoneW"; y = "safeZoneY + 0.135 * safeZoneH";
            w = "0.19 * safeZoneW"; h = "0.04 * safeZoneH";
        };
        class Location: RscOverthrowStructuredText {
            idc = 1101; text = "";
            x = "safeZoneX + 0.755 * safeZoneW"; y = "safeZoneY + 0.19 * safeZoneH";
            w = "0.19 * safeZoneW"; h = "0.09 * safeZoneH";
        };
        class PropertyImage: RscOverthrowPicture {
            idc = 1201; text = "#(argb,8,8,3)color(0,0,0,0)";
            x = "safeZoneX + 0.755 * safeZoneW"; y = "safeZoneY + 0.3 * safeZoneH";
            w = "0.19 * safeZoneW"; h = "0.13 * safeZoneH";
        };
        class Property: RscOverthrowStructuredText {
            idc = 1102; text = "";
            x = "safeZoneX + 0.755 * safeZoneW"; y = "safeZoneY + 0.46 * safeZoneH";
            w = "0.19 * safeZoneW"; h = "0.15 * safeZoneH";
        };
        class Context1630: RscOverthrowButton {
            idc = 1630; text = "Vehicles";
            x = "safeZoneX + 0.755 * safeZoneW"; y = "safeZoneY + 0.625 * safeZoneH";
            w = "0.19 * safeZoneW"; h = "0.045 * safeZoneH";
            action = "closeDialog 0; [] call OT_fnc_logisticsDialog";
        };
        class Context1620: RscOverthrowButton {
            idc = 1620; text = "Procurement";
            x = "safeZoneX + 0.755 * safeZoneW"; y = "safeZoneY + 0.685 * safeZoneH";
            w = "0.09 * safeZoneW"; h = "0.045 * safeZoneH";
            action = "closeDialog 0; [] spawn OT_fnc_manageArea";
        };
        class Context1621: RscOverthrowButton {
            idc = 1621; text = "Garrison";
            x = "safeZoneX + 0.855 * safeZoneW"; y = "safeZoneY + 0.685 * safeZoneH";
            w = "0.09 * safeZoneW"; h = "0.045 * safeZoneH";
            action = "closeDialog 0; [] call OT_fnc_garrisonDialog";
        };
        class Context1608: RscOverthrowButton {
            idc = 1608; text = "Buy";
            x = "safeZoneX + 0.755 * safeZoneW"; y = "safeZoneY + 0.745 * safeZoneH";
            w = "0.19 * safeZoneW"; h = "0.045 * safeZoneH";
            action = "closeDialog 0; [] call OT_fnc_buyBuilding";
        };
        class Context1609: RscOverthrowButton {
            idc = 1609; text = "Lease";
            x = "safeZoneX + 0.755 * safeZoneW"; y = "safeZoneY + 0.805 * safeZoneH";
            w = "0.09 * safeZoneW"; h = "0.045 * safeZoneH";
            action = "closeDialog 0; [] call OT_fnc_leaseBuilding";
        };
        class Context1610: RscOverthrowButton {
            idc = 1610; text = "Set home";
            x = "safeZoneX + 0.855 * safeZoneW"; y = "safeZoneY + 0.805 * safeZoneH";
            w = "0.09 * safeZoneW"; h = "0.045 * safeZoneH";
            action = "closeDialog 0; [] call OT_fnc_setHome";
        };
        class Close: RscOverthrowButton {
            idc = 1900; text = "CLOSE";
            x = "safeZoneX + 0.825 * safeZoneW"; y = "safeZoneY + 0.92 * safeZoneH";
            w = "0.12 * safeZoneW"; h = "0.035 * safeZoneH";
            action = "closeDialog 0";
        };
    };
};

