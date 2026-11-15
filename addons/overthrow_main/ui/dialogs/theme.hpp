// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
// Shared tactical palette; all legacy dialogs inherit the updated base widgets.
class RscOTPanel: RscOverthrowText {
    colorBackground[] = {0.025, 0.04, 0.055, 0.97};
};
class RscOTHeading: RscOverthrowText {
    font = "PuristaSemibold";
    colorText[] = {0.88, 0.96, 0.98, 1};
    sizeEx = "0.034 * safeZoneH";
    shadow = 0;
};
class RscOTPrimaryButton: RscOverthrowButton {
    colorBackground[] = {0.10, 0.42, 0.31, 1};
    colorBackgroundActive[] = {0.16, 0.59, 0.42, 1};
    colorFocused[] = {0.13, 0.50, 0.36, 1};
    colorText[] = {0.92, 1, 0.96, 1};
    font = "PuristaSemibold";
};
