// Added 16 November 2026 for the community fork. GNU GPL v2.
// Pure queue/state updates; UI controls are owned by the renderer.
params ["_state", "_message", "_kind", "_now", ["_duration", -1], ["_sound", ""]];
if !(_kind in ["minor", "big", "good", "bad"]) then { _kind = "minor" };
private _priority = [0, 1, 1, 2] # (["minor", "big", "good", "bad"] find _kind);
private _lifetime = (([4.5, 6, 5, 6] # (["minor", "big", "good", "bad"] find _kind)) + count _message / 45) min 14;
if (_duration isEqualType 0 && { finite _duration } && { _duration >= 0 }) then { _lifetime = (_duration max 0.5) min 60 };
private _pending = _state get "pending";
private _active = _state get "active";
private _entry = createHashMap;
{
    if ((_x get "message") isEqualTo _message && { (_x get "kind") isEqualTo _kind } && { (_x getOrDefault ["phase", "new"]) isNotEqualTo "exit" } && { _now - (_x getOrDefault ["born", _now]) < 30 }) exitWith { _entry = _x };
} forEach (_active + _pending);
if (count _entry > 0) exitWith {
    _entry set ["repeats", 1 + (_entry get "repeats")];
    _entry set ["revision", 1 + (_entry get "revision")];
    if (!isNil { _entry get "born" }) then {
        _entry set ["expires", (_now + (_entry get "duration")) min ((_entry get "born") + 30)];
    };
};
_entry = createHashMapFromArray [
    ["message", _message], ["kind", _kind], ["repeats", 1], ["revision", 0],
    ["priority", _priority], ["duration", _lifetime], ["sound", _sound], ["phase", "new"]
];
private _index = _pending findIf { (_x get "priority") < _priority };
if (_index < 0) then { _pending pushBack _entry } else { _pending insert [_index, [_entry]] };
if (count _pending > 16) then {
    // Discard the oldest lowest-priority message, preserving recent alerts.
    private _lowest = (_pending # (count _pending - 1)) get "priority";
    _pending deleteAt (_pending findIf { (_x get "priority") isEqualTo _lowest });
};
