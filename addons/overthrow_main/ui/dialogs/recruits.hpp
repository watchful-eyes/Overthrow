// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
class OT_dialog_recruits {
    idd = 8004;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1199: RscOverthrowStructuredText {
            idc = 1199;
            x = "0.242187 * safeZoneW + safeZoneX";
            y = "0.214 * safeZoneH + safeZoneY";
            w = "0.654844 * safeZoneW";
            h = "0.572 * safeZoneH";
            colorBackground[] = {0.025, 0.04, 0.055, 0.97};
            colorActive[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Viwapa)
        ////////////////////////////////////////////////////////

        class RscListbox_1500: RscOverthrowListBox {
            idc = 1500;
            x = "0.206094 * safeZoneW + safeZoneX";
            y = "0.258 * safeZoneH + safeZoneY";
            w = "0.360937 * safeZoneW";
            h = "0.418 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.5};
            onLBSelChanged = "_this call recruitSelected";
        };
        class RscStructuredText_1100: RscOverthrowStructuredText {
            idc = 1100;
            x = "0.572187 * safeZoneW + safeZoneX";
            y = "0.258 * safeZoneH + safeZoneY";
            w = "0.221719 * safeZoneW";
            h = "0.33 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.5};
        };
        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            text = "Dismiss"; //--- ToDo: Localize;
            x = "0.711406 * safeZoneW + safeZoneX";
            y = "0.599 * safeZoneH + safeZoneY";
            w = "0.0825 * safeZoneW";
            h = "0.077 * safeZoneH";
            colorBackground[] = {0.5, 0, 0, 1};
            colorActive[] = {0.6, 0, 0, 1};
            action = "_this call dismissRecruit;";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////

    };
};
