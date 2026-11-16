// Added 16 November 2026 for the unofficial community fork. GNU GPL v2.
if (!hasInterface) exitWith {};
params ["_speaker", "_message"];
if (!isNull _speaker) then { _speaker globalChat (_message call OT_fnc_localizeText) };
