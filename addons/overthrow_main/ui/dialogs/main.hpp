// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
class OT_dialog_vehicle {
    idd = -1;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1103: RscOverthrowStructuredText {
            idc = 1103;

            text = "";
            x = "0 * safeZoneW + safeZoneX";
            y = "0 * safeZoneH + safeZoneY";
            w = "0.159844 * safeZoneW";
            h = "1 * safeZoneH";
            colorBackground[] = {0.025, 0.04, 0.055, 0.97};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Xeqozy)
        ////////////////////////////////////////////////////////
        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            action = "closeDialog 0; [] spawn OT_fnc_fastTravel;";
            tooltip = "Fast travels this vehicle and it's occupants"; //--- ToDo: Localize;

            text = "Fast Travel"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.126 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.066 * safeZoneH";
        };
        class RscButton_1614: RscOverthrowButton {
            idc = 1614;
            action = "closeDialog 0; [player] spawn OT_fnc_recover;";
            tooltip = "Loot bodies within 150m"; //--- ToDo: Localize;

            text = "Loot"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.214 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.066 * safeZoneH";
        };
        class RscButton_1613: RscOverthrowButton {
            idc = 1613;
            text = "Jobs"; //--- ToDo: Localize;
            action = "call OT_fnc_jobsDialog";

            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.302 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";

        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "Transfer From"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.478 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Transfers the contents of the closest container into this vehicle"; //--- ToDo: Localize;
            action = "closeDialog 0; [] spawn OT_fnc_transferFrom;";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "Transfer To"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.390 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Transfers the contents of this vehicle into the closest container"; //--- ToDo: Localize;
            action = "closeDialog 0; [] spawn OT_fnc_transferTo;";
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            text = "Transfer Legit"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.566 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Transfers only legal (sellable) items from the closest container into this vehicle"; //--- ToDo: Localize;
            action = "closeDialog 0; [] spawn OT_fnc_transferLegit;";
        };
        class RscButton_1604: RscOverthrowButton {
            idc = 1604;
            text = "Take Legit"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.654 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Takes legal (sellable) items from the vehicle into your inventory"; //--- ToDo: Localize;
            action = "closeDialog 0; [] spawn OT_fnc_takeLegit;";
        };
        class RscButton_1605: RscOverthrowButton {
            idc = 1605;
            text = "Lock Vehicle"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.742 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Locks this car so only you can drive it or access it's inventory"; //--- ToDo: Localize;
            action = "closeDialog 0; [] call OT_fnc_lockVehicle;";
        };
        class RscButton_1612: RscOverthrowButton {
            idc = 1612;
            action = "call OT_fnc_optionsDialog";

            text = "Options"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.885 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.066 * safeZoneH";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////

    };
};

class OT_dialog_vehiclewarehouse {
    idd = -1;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1103: RscOverthrowStructuredText {
            idc = 1103;

            text = "";
            x = "0 * safeZoneW + safeZoneX";
            y = "0 * safeZoneH + safeZoneY";
            w = "0.159844 * safeZoneW";
            h = "1 * safeZoneH";
            colorBackground[] = {0.025, 0.04, 0.055, 0.97};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Xeqozy)
        ////////////////////////////////////////////////////////

        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            text = "Fast Travel"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.39 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "closeDialog 0; [] spawn OT_fnc_fastTravel;";
            tooltip = "Fast travels this vehicle and it's occupants"; //--- ToDo: Localize;
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "Take From"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.654 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Take from the warehouse"; //--- ToDo: Localize;
            action = "closeDialog 0; createDialog 'OT_dialog_warehouse'; [] call OT_fnc_warehouseDialog;";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "Store All"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.478 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Stores the contents of this vehicle in the warehouse"; //--- ToDo: Localize;
            action = "closeDialog 0; [] spawn OT_fnc_storeAll;";
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            text = "Transfer Legit"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.566 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Takes all legal (sellable) items from the warehouse"; //--- ToDo: Localize;
            action = "closeDialog 0; [] spawn OT_fnc_transferLegit;";
        };
        class RscButton_1612: RscOverthrowButton {
            idc = 1612;
            action = "call OT_fnc_optionsDialog";

            text = "Options"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.885 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.066 * safeZoneH";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////

    };
};

class OT_dialog_vehicleport {
    idd = -1;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1103: RscOverthrowStructuredText {
            idc = 1103;

            text = "";
            x = "0 * safeZoneW + safeZoneX";
            y = "0 * safeZoneH + safeZoneY";
            w = "0.159844 * safeZoneW";
            h = "1 * safeZoneH";
            colorBackground[] = {0.025, 0.04, 0.055, 0.97};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Xeqozy)
        ////////////////////////////////////////////////////////

        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            text = "Fast Travel"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.39 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "closeDialog 0; [] spawn OT_fnc_fastTravel;";
            tooltip = "Fast travels this vehicle and it's occupants"; //--- ToDo: Localize;
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "Import"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.654 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Import items from the global market"; //--- ToDo: Localize;
            action = "closeDialog 0; createDialog 'OT_dialog_import'; [] call OT_fnc_importDialog;";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "Export All"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.566 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Exports the contents of this vehicle"; //--- ToDo: Localize;
            action = "closeDialog 0; [] spawn OT_fnc_exportAll;";
        };
        class RscButton_1612: RscOverthrowButton {
            idc = 1612;
            action = "call OT_fnc_optionsDialog";

            text = "Options"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.885 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.066 * safeZoneH";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////

    };
};

class OT_dialog_vehiclehardware {
    idd = -1;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1103: RscOverthrowStructuredText {
            idc = 1103;

            text = "";
            x = "0 * safeZoneW + safeZoneX";
            y = "0 * safeZoneH + safeZoneY";
            w = "0.159844 * safeZoneW";
            h = "1 * safeZoneH";
            colorBackground[] = {0.025, 0.04, 0.055, 0.97};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Xeqozy)
        ////////////////////////////////////////////////////////

        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            text = "Fast Travel"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.39 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "closeDialog 0; [] spawn OT_fnc_fastTravel;";
            tooltip = "Fast travels this vehicle and it's occupants"; //--- ToDo: Localize;
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "Buy"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.654 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Buy from this hardware store"; //--- ToDo: Localize;
            action = "closeDialog 0; [] call OT_fnc_buyHardwareDialog;";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "Sell"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.566 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Sell to this hardware store"; //--- ToDo: Localize;
            action = "closeDialog 0; [] call OT_fnc_sellHardwareDialog;";
        };
        class RscButton_1612: RscOverthrowButton {
            idc = 1612;
            action = "call OT_fnc_optionsDialog";

            text = "Options"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.885 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.066 * safeZoneH";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////

    };
};

class OT_dialog_vehiclestore {
    idd = -1;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1103: RscOverthrowStructuredText {
            idc = 1103;

            text = "";
            x = "0 * safeZoneW + safeZoneX";
            y = "0 * safeZoneH + safeZoneY";
            w = "0.159844 * safeZoneW";
            h = "1 * safeZoneH";
            colorBackground[] = {0.025, 0.04, 0.055, 0.97};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Xeqozy)
        ////////////////////////////////////////////////////////

        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            text = "Fast Travel"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.39 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            action = "closeDialog 0; [] spawn OT_fnc_fastTravel;";
            tooltip = "Fast travels this vehicle and it's occupants"; //--- ToDo: Localize;
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "Buy"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.654 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Buy from this store"; //--- ToDo: Localize;
            action = "closeDialog 0; [] call OT_fnc_buyDialogVehicle;";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "Sell"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.566 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Sell to this store"; //--- ToDo: Localize;
            action = "closeDialog 0; [] call OT_fnc_sellDialogVehicle;";
        };
        class RscButton_1612: RscOverthrowButton {
            idc = 1612;
            action = "call OT_fnc_optionsDialog";

            text = "Options"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.885 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.066 * safeZoneH";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////

    };
};

class OT_dialog_command {
    idd = -1;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1103: RscOverthrowStructuredText {
            idc = 1103;

            text = "";
            x = "0 * safeZoneW + safeZoneX";
            y = "0 * safeZoneH + safeZoneY";
            w = "0.159844 * safeZoneW";
            h = "1 * safeZoneH";
            colorBackground[] = {0.025, 0.04, 0.055, 0.97};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Xeqozy)
        ////////////////////////////////////////////////////////
        class RscButton_1604: RscOverthrowButton {
            idc = 1604;
            text = "Open Arsenal"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.236 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Commands first unit selected to walk to and open the closest ammobox arsenal, uses warehouse if ammobox is at a warehouse"; //--- ToDo: Localize;
            action = "closeDialog 0; [] call OT_fnc_orderOpenArsenal;";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "Loot"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.412 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Commands all selected units to loot bodies and fill closest container to them"; //--- ToDo: Localize;
            action = "closeDialog 0; [] spawn OT_fnc_orderLoot;";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "Open Inventory"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.324 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Commands first unit selected to open inventory"; //--- ToDo: Localize;
            action = "closeDialog 0; [] spawn OT_fnc_orderOpenInventory;";
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            text = "Create Squad"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.5 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Splits selected units off into a new squad"; //--- ToDo: Localize;
            action = "closeDialog 0; [] spawn OT_fnc_createSquad;";
        };
        class RscButton_1612: RscOverthrowButton {
            idc = 1612;
            action = "call OT_fnc_optionsDialog";

            text = "Options"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.885 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.066 * safeZoneH";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////

    };
};

class OT_dialog_squad {
    idd = -1;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1103: RscOverthrowStructuredText {
            idc = 1103;

            text = "";
            x = "0 * safeZoneW + safeZoneX";
            y = "0 * safeZoneH + safeZoneY";
            w = "0.159844 * safeZoneW";
            h = "1 * safeZoneH";
            colorBackground[] = {0.025, 0.04, 0.055, 0.97};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Xeqozy)
        ////////////////////////////////////////////////////////

        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "Assign Vehicle"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.324 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Assigns vehicle you are looking at to squad"; //--- ToDo: Localize;
            action = "closeDialog 0; [] call OT_fnc_squadAssignVehicle;";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "Get In"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.412 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Orders squad to board assigned vehicle"; //--- ToDo: Localize;
            action = "closeDialog 0; [] call OT_fnc_squadGetIn;";
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            text = "Get Out"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.5 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Orders squad to disembark vehicle"; //--- ToDo: Localize;
            action = "closeDialog 0; [] call OT_fnc_squadGetOut;";
        };
        class RscButton_1604: RscOverthrowButton {
            idc = 1604;
            text = "Get In My Vehicle"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.588 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.077 * safeZoneH";
            tooltip = "Orders squad to board your vehicle"; //--- ToDo: Localize;
            action = "closeDialog 0; [] call OT_fnc_squadGetInMyVehicle;";
        };
        class RscButton_1612: RscOverthrowButton {
            idc = 1612;
            action = "call OT_fnc_optionsDialog";

            text = "Options"; //--- ToDo: Localize;
            x = "0.005 * safeZoneW + safeZoneX";
            y = "0.885 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.066 * safeZoneH";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////

    };
};

class OT_dialog_upload {
    idd = 49558;
    movingenable = 0;
    onLoad = "params ['_display']; _display displayAddEventHandler ['KeyDown', { if ((_this select 1) == 1) then { true } }];";

    class controlsBackground {
        class background1: RscOverthrowText {
            idc = -1;
            text = "OVERTHROW MISSION EXPORT"; //--- ToDo: Localize;
            x = "0.29375 * safeZoneW + safeZoneX";
            y = "0.225 * safeZoneH + safeZoneY";
            w = "0.4125 * safeZoneW";
            h = "0.022 * safeZoneH";
            colorBackground[] = {
                "(profileNamespace getVariable ['GUI_BCG_RGB_R', 0.77])",
                "(profileNamespace getVariable ['GUI_BCG_RGB_G', 0.51])",
                "(profileNamespace getVariable ['GUI_BCG_RGB_B', 0.08])",
                1
            };
        };
        class background2: RscOverthrowText {
            idc = -1;
            x = "0.29375 * safeZoneW + safeZoneX";
            y = "0.247 * safeZoneH + safeZoneY";
            w = "0.4125 * safeZoneW";
            h = "0.528 * safeZoneH";
            colorBackground[] = {-1, -1, -1, 0.7};
        };
        class background3: RscOverthrowText {
            idc = -1;
            x = "0.298905 * safeZoneW + safeZoneX";
            y = "0.577 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.143 * safeZoneH";
            colorBackground[] = {-1, -1, -1, 0.5};
        };
    };
    class controls {
        class EditBox: RscEdit {
            idc = 1;
            style = 16;
            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.258 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.308 * safeZoneH";
            canModify = 0;
            font = "EtelkaMonospacePro";
            colorBackground[] = {-1, -1, -1, 0.75};
        };
        class LegalControlGroup: RscControlsGroup {
            idc = -1;
            x = "0.298905 * safeZoneW + safeZoneX";
            y = "0.577 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.143 * safeZoneH";
            class Controls {
                class LegalText: RscOverthrowStructuredText {
                    idc = 5;
                    x = "0 * safeZoneW";
                    y = "0 * safeZoneH";
                    w = "0.397031 * safeZoneW";
                    h = "0.143 * safeZoneH";
                    text = "";
                    colorBackground[] = {-1, -1, -1, 0};
                };
            };
        };
        class CancelButton: RscOverthrowStructuredText {
            idc = -1;
            text = "<t align='center' font='PuristaBold' color='#FFFFFF'>CLOSE MENU</t>"; //--- ToDo: Localize;
            onMouseButtonClick = "playSound 'click'; closeDialog 0;";
            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.731 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.033 * safeZoneH";
            onMouseEnter = "(_this select 0) ctrlSetStructuredText parseText ""<t align='center' font='PuristaBold' color='#00FF00'>CLOSE MENU</t>""; (_this select 0) ctrlCommit 0.5; ";
            onMouseExit = "(_this select 0) ctrlSetStructuredText parseText ""<t align='center' font='PuristaBold' color='#FFFFFF'>CLOSE MENU</t>""; (_this select 0) ctrlCommit 0.5; ";
            colorBackground[] = {-1, -1, -1, 0.7};
        };
    };
};

class OT_dialog_char {
    idd = 8003;
    movingenable = 0;

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Pejity)
        ////////////////////////////////////////////////////////

        class RscStructuredText_1100: RscOverthrowStructuredText {
            idc = 1100;
            text = ""; //--- ToDo: Localize;
            x = "0.273125 * safeZoneW + safeZoneX";
            y = "0.269 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.143 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.5};
            colorActive[] = {0, 0, 0, 0.5};
        };
        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            text = "Increase Level (-10 Influence)"; //--- ToDo: Localize;
            x = "0.273125 * safeZoneW + safeZoneX";
            y = "0.423 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.044 * safeZoneH";
            action = "['fitness'] call buyPerk;";
        };
        class RscStructuredText_1101: RscOverthrowStructuredText {
            idc = 1101;
            text = "Increase Level (-10 Influence)"; //--- ToDo: Localize;
            x = "0.427812 * safeZoneW + safeZoneX";
            y = "0.269 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.143 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.3};
            colorActive[] = {0, 0, 0, 0.3};
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "Increase Level (-10 Influence)"; //--- ToDo: Localize;
            x = "0.427812 * safeZoneW + safeZoneX";
            y = "0.423 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.044 * safeZoneH";
            action = "['trade'] call buyPerk;";
        };
        class RscStructuredText_1102: RscOverthrowStructuredText {
            idc = 1102;
            text = ""; //--- ToDo: Localize;
            x = "0.5825 * safeZoneW + safeZoneX";
            y = "0.269 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.143 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0.3};
            colorActive[] = {0, 0, 0, 0.3};
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "Increase Level (-10 Influence)"; //--- ToDo: Localize;
            x = "0.5825 * safeZoneW + safeZoneX";
            y = "0.423 * safeZoneH + safeZoneY";
            w = "0.149531 * safeZoneW";
            h = "0.044 * safeZoneH";
            action = "['stealth'] call buyPerk;";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////
    };
};

class OT_dialog_tute {
    idd = -1;
    movingenable = 0;

    class controlsBackground {
        class RscStructuredText_1101: RscOverthrowStructuredText {
            idc = 1101;
            x = "0.324687 * safeZoneW + safeZoneX";
            y = "0.313 * safeZoneH + safeZoneY";
            w = "0.355781 * safeZoneW";
            h = "0.198 * safeZoneH";
            colorBackground[] = {0.025, 0.04, 0.055, 0.97};
            colorActive[] = {0.1, 0.1, 0.1, 1};
        };
    };

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Kizeru)
        ////////////////////////////////////////////////////////

        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            action = "closeDialog 0; [] spawn OT_fnc_tutorial;";

            text = "Yes"; //--- ToDo: Localize;
            x = "0.340156 * safeZoneW + safeZoneX";
            y = "0.412 * safeZoneH + safeZoneY";
            w = "0.0721875 * safeZoneW";
            h = "0.088 * safeZoneH";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            action = "closeDialog 0;";

            text = "No"; //--- ToDo: Localize;
            x = "0.592812 * safeZoneW + safeZoneX";
            y = "0.412 * safeZoneH + safeZoneY";
            w = "0.0721875 * safeZoneW";
            h = "0.088 * safeZoneH";
        };
        class RscStructuredText_1100: RscOverthrowStructuredText {
            idc = 1100;

            text = "Would you like a quick tutorial? (You will receive free items)"; //--- ToDo: Localize;
            x = "0.340156 * safeZoneW + safeZoneX";
            y = "0.346 * safeZoneH + safeZoneY";
            w = "0.324844 * safeZoneW";
            h = "0.033 * safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////
    };
};

class OT_dialog_choose {
    idd = 8002;
    movingenable = 0;

    class controls {
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Humesu)
        ////////////////////////////////////////////////////////

        class RscStructuredText_1100: RscOverthrowStructuredText {
            idc = 1100;
            x = "0.29375 * safeZoneW + safeZoneX";
            y = "0.269 * safeZoneH + safeZoneY";
            w = "0.4125 * safeZoneW";
            h = "0.184 * safeZoneH";
            colorBackground[] = {0.2, 0.2, 0.2, 1};
        };

        class RscButton_1600: RscOverthrowButton {
            idc = 1600;
            text = "Lorem Ipsum dolor sit amet blah blah blah"; //--- ToDo: Localize;
            action = "closeDialog 0; 0 call OT_fnc_choiceMade;";
            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.478 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.055 * safeZoneH";
            sizeEx = "0.017 * safeZoneH";
        };
        class RscButton_1601: RscOverthrowButton {
            idc = 1601;
            text = "Lorem Ipsum dolor sit amet blah blah blah"; //--- ToDo: Localize;
            action = "closeDialog 0; 1 call OT_fnc_choiceMade;";
            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.544 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.055 * safeZoneH";
            sizeEx = "0.017 * safeZoneH";
        };
        class RscButton_1602: RscOverthrowButton {
            idc = 1602;
            text = "Lorem Ipsum dolor sit amet blah blah blah"; //--- ToDo: Localize;
            action = "closeDialog 0; 2 call OT_fnc_choiceMade;";
            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.61 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.055 * safeZoneH";
            sizeEx = "0.017 * safeZoneH";
        };
        class RscButton_1603: RscOverthrowButton {
            idc = 1603;
            text = "Lorem Ipsum dolor sit amet blah blah blah"; //--- ToDo: Localize;
            action = "closeDialog 0; 3 call OT_fnc_choiceMade;";
            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.676 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.055 * safeZoneH";
            sizeEx = "0.017 * safeZoneH";
        };
        class RscButton_1604: RscOverthrowButton {
            idc = 1604;
            text = "Lorem Ipsum dolor sit amet blah blah blah"; //--- ToDo: Localize;
            action = "closeDialog 0; 4 call OT_fnc_choiceMade;";
            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.742 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.055 * safeZoneH";
            sizeEx = "0.017 * safeZoneH";
        };
        class RscButton_1605: RscOverthrowButton {
            idc = 1605;
            text = "Lorem Ipsum dolor sit amet blah blah blah"; //--- ToDo: Localize;
            action = "closeDialog 0; 5 call OT_fnc_choiceMade;";
            x = "0.298906 * safeZoneW + safeZoneX";
            y = "0.808 * safeZoneH + safeZoneY";
            w = "0.402187 * safeZoneW";
            h = "0.055 * safeZoneH";
            sizeEx = "0.017 * safeZoneH";
        };
        ////////////////////////////////////////////////////////
        // GUI EDITOR OUTPUT END
        ////////////////////////////////////////////////////////
    };
};
