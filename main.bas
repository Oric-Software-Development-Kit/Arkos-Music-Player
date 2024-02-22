10 REM Simple music player:
20 REM - Music files are loaded in $7000
40 REM - Player binary code is about 1800 bytes loaded at $6500
50 REM Oric 1 compatible version
60 REM
70 HIMEM #6000 
80 TEXT:PAPER4:INK6:CLS
100 PRINT "Loading music player"
110 LOAD"AKYPLAYER.BIN"
120 CLS:GOSUB 1000:PRINT:PRINT"Number:Select music    Space:Quit"
130 GET A$
140 IF A$=" " THEN END
145 IF (A$>="0" AND A$<="9") OR (A$="A") THEN GOTO 200
150 GOTO 120
160 REM
170 REM Loading music
180 REM
200 PRINT "Loading "+A$
210 LOAD"MUSIC"+A$+".BIN"
215 PRINT "Currently playing music "+A$
220 CALL#6500
230 PRINT"Press a key to continue"
240 GET A$
250 CALL#6503
270 GOTO 120
1000 REM
1001 REM MENU
1002 REM
1010 PRINT"WELCOME TO THE ORIC ARKOS MUSIC DEMO"
1030 PRINT
1040 PRINT"CHOOSE THE MUSIC:"
1050 PRINT"1-Asian Agent (Mr.Lou)"
1060 PRINT"2-Stepping Out (Mr.Lou)"
1070 PRINT"3-Space Rivals (Mr.Lou)"
1080 PRINT"4-Just add cream (XiA)"
1090 PRINT"5-A harmless grenade (Targhan)"
1100 PRINT"6-Hocus Pocus (Targhan)"
1110 PRINT"7-Morons (UltraSyd)"
1120 PRINT"8-Boules Et Bits (Tom&Jerry)"
1130 PRINT"9-KellyOn (FenyxKell)"
1140 PRINT"0-Renegade Mix (PulkoMandy)"

1500 RETURN

