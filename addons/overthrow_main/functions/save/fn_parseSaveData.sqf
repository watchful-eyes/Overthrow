// Added 16 November 2026 for the community fork. GNU GPL v2.
// parseSimpleArray can return a partially parsed array after a syntax error.
// Validate the complete data grammar first; never compile pasted save text.
params [["_text", ""]];
private _error = [false, "Invalid save text. Import cancelled; no campaign data was changed.", []];
if !(_text isEqualType "") exitWith { _error };
private _quote = toString [34];
private _string = _quote + "(?:[^" + _quote + "]|" + _quote + _quote + ")*" + _quote;
private _pattern = _string + "|[+-]?(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+)(?:[eE][+-]?[0-9]+)?|true|false|nil|\[|\]|,/g";
private _tokens = _text regexFind [_pattern];
private _cursor = 0;
private _stack = [];
private _complete = false;
private _valid = true;
{
    (_x # 0) params ["_token", "_offset"];
    if (_complete || { ((_text select [_cursor, _offset - _cursor]) regexFind ["\S"]) isNotEqualTo [] }) exitWith { _valid = false };
    private _depth = count _stack;
    private _state = if (_depth > 0) then { _stack # (_depth - 1) } else { -1 };
    // State 0: first value or empty array; 1: comma/end; 2: required value.
    switch (_token) do {
        case "[": {
            if (_state isEqualTo 1) exitWith { _valid = false };
            if (_depth > 0) then { _stack set [_depth - 1, 1] };
            _stack pushBack 0;
        };
        case "]": {
            if (_depth isEqualTo 0 || { _state isEqualTo 2 }) exitWith { _valid = false };
            _stack deleteAt (_depth - 1);
            if (_stack isEqualTo []) then { _complete = true };
        };
        case ",": {
            if (_state isNotEqualTo 1) exitWith { _valid = false };
            _stack set [_depth - 1, 2];
        };
        default {
            if (_depth isEqualTo 0 || { _state isEqualTo 1 }) exitWith { _valid = false };
            _stack set [_depth - 1, 1];
        };
    };
    if (!_valid) exitWith {};
    _cursor = _offset + count _token;
} forEach _tokens;
if (!_valid || { !_complete } || { _stack isNotEqualTo [] } || { ((_text select [_cursor]) regexFind ["\S"]) isNotEqualTo [] }) exitWith { _error };
private _data = parseSimpleArray _text;
if (_data isEqualTo [] || { _data findIf { !(_x isEqualType []) || { count _x isNotEqualTo 2 } || { isNil { _x # 0 } } || { !((_x # 0) isEqualType "") } || { isNil { _x # 1 } } } isNotEqualTo -1 }) exitWith { _error };
private _servers = _data select { (_x # 0) isEqualTo "server" };
if (count _servers isNotEqualTo 1) exitWith { _error };
private _records = (_servers # 0) # 1;
if !(_records isEqualType []) exitWith { _error };
if (_records findIf { !(_x isEqualType []) || { count _x isNotEqualTo 2 } || { isNil { _x # 0 } } || { !((_x # 0) isEqualType "") } || { isNil { _x # 1 } } } isNotEqualTo -1) exitWith { _error };
[true, "", _data]
