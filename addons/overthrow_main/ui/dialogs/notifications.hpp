// Added 16 November 2026 for the community fork. GNU GPL v2.
class RscControlsGroupNoScrollbars;
class OT_NotificationCard: RscControlsGroupNoScrollbars {
    idc = -1;
    x = -2; y = -2;
    w = "0.27 * safeZoneW";
    h = "0.12 * safeZoneH";
    fade = 1;
    class controls {
        class Background: RscOTPanel {
            idc = 100;
            x = 0; y = 0;
            w = "0.27 * safeZoneW";
            h = "0.12 * safeZoneH";
        };
        class Accent: RscOverthrowText {
            idc = 101;
            x = 0; y = 0;
            w = "0.0025 * safeZoneW";
            h = "0.12 * safeZoneH";
        };
        class Heading: RscOverthrowText {
            idc = 102;
            x = "0.012 * safeZoneW"; y = "0.009 * safeZoneH";
            w = "0.20 * safeZoneW"; h = "0.025 * safeZoneH";
            sizeEx = "0.021 * safeZoneH";
            font = "RobotoCondensedBold";
            shadow = 0;
        };
        class Repeats: Heading {
            idc = 103;
            style = 1;
            x = "0.217 * safeZoneW";
            w = "0.04 * safeZoneW";
            colorText[] = {0.67, 0.76, 0.79, 1};
        };
        class Body: RscOverthrowStructuredText {
            idc = 104;
            x = "0.012 * safeZoneW"; y = "0.039 * safeZoneH";
            w = "0.245 * safeZoneW"; h = "0.20 * safeZoneH";
            size = "0.022 * safeZoneH";
            class Attributes {
                font = "RobotoCondensed";
                color = "#e5edf0";
                align = "left";
                shadow = 0;
            };
        };
        class Lifetime: RscOverthrowText {
            idc = 105;
            x = "0.012 * safeZoneW";
            y = "0.11 * safeZoneH";
            w = "0.245 * safeZoneW";
            h = "0.002 * safeZoneH";
        };
    };
};
