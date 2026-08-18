PROGRAM Main
(* Heated surge tank: pump holds level by hysteresis, a PI loop holds
   temperature. VAR_EXTERNAL tags are bound by the runtime each scan —
   field inputs written before, outputs collected after. VAR is retained. *)
VAR_EXTERNAL
    (* field inputs *)
    LevelPct       : REAL;
    TempC          : REAL;
    ScanDtS        : REAL;
    (* operator setpoints *)
    TempSP         : REAL;
    Kp             : REAL;
    Ki             : REAL;
    PumpStartLevel : REAL;
    PumpStopLevel  : REAL;
    (* high temperature alarm *)
    HiTempSP       : REAL;
    HiTempClrSP    : REAL;
    HiTempAlm      : BOOL;
    (* field outputs *)
    PumpRun        : BOOL;
    Heater         : REAL;
END_VAR
VAR
    integral : REAL;
    err      : REAL;
END_VAR

(* P-101: level hysteresis latch *)
IF LevelPct <= PumpStartLevel THEN
    PumpRun := TRUE;
ELSIF LevelPct >= PumpStopLevel THEN
    PumpRun := FALSE;
END_IF;

(* TIC-101: temperature PI with anti-windup clamp *)
err := TempSP - TempC;
integral := integral + Ki * err * ScanDtS;
integral := LIMIT(0.0, integral, 30.0);
Heater := LIMIT(0.0, Kp * err + integral, 100.0);
(* AH-101: high temperature alarm — a hysteresis latch, same idiom as P-101 *)
IF TempC >= HiTempSP THEN
    HiTempAlm := TRUE;
ELSIF TempC <= HiTempClrSP THEN
    HiTempAlm := FALSE;
END_IF;
END_PROGRAM
