// Localized 16 November 2026. Original author notices apply (GNU GPL v2).
closeDialog 0;
createDialog "OT_dialog_jobs";

{
    _x params ["_id", "_job"];
    _job params ["_info"];
    _info params ["_title"];

    private _idx = lbAdd [1500, (format ["%1", _title] call OT_fnc_localizeText)];
    lbSetData [1500, _idx, _id];
} forEach (spawner getVariable ["OT_activeJobs", []]);
