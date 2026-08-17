PROGRAM Interlocks
(* The annunciator as LADDER — a third language on the same tag store,
   its own 200 ms task. The alarm itself lives in program.st (AH-101);
   this task only decides what to do about it. *)
VAR_EXTERNAL
    HiTempAlm  : BOOL;
    TempLowAlm : BOOL;
    HornAck    : BOOL;
    Horn       : BOOL;
END_VAR
VAR
    InSecs : TIME; (* how long an alarm has been in — captured via => *)
END_VAR
LD
  RUNG horn (* either alarm, held 2 s, sounds the horn until the operator acks *)
    [ HiTempAlm | TempLowAlm ] t1:TON(PT := T#2S, ET => InSecs) /HornAck ( Horn )

  RUNG ackclear (* the ack releases itself once both alarms clear *)
    /HiTempAlm /TempLowAlm ( R HornAck )
END_LD
END_PROGRAM
