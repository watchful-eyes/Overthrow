// Modified/added for the unofficial Garrison and Command Expansion, 14-16 November 2026.
// Original author/copyright notices are retained; see LICENSE.md (GNU GPL v2).
params ["_unit", "", "", "", "", ["_shooter", objNull, [objNull]], ["_projectile", objNull, [objNull]]];
if (isNull _unit) exitWith {};
_unit enableAI "PATH";
if !(isNull _projectile) then {
    private _shotParents = getShotParents _projectile;
    private _instigator = _shotParents param [1, objNull];
    if (!isNull _instigator) then { _shooter = _instigator };
};
if (isNull _shooter) then {
    private _aceSource = _unit getVariable ["ace_medical_lastDamageSource", objNull];
    if ((!isNull _aceSource) && { _aceSource != _unit }) then {
        _shooter = _aceSource;
    };
};
if ((typeOf _shooter) isKindOf "CAManBase") then {
    _shooter setCaptive false;
    if (!isNull objectParent _shooter) then {
        {
            _x setCaptive false;
        } forEach (crew objectParent _shooter);
    };
};
