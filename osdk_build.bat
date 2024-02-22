@ECHO OFF


::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%OSDK%"=="" GOTO ErCfg


::
:: Set the build paremeters
::
CALL osdk_config.bat


::
:: Launch the compilation of files
::
CALL %OSDK%\bin\make.bat %OSDKFILE%

::
:: Assemble the music player
::
ECHO Assembling music player
%osdk%\bin\xa akyplayer.s -o build\akyplayer.o
%OSDK%\bin\header -h1 -a0 build\akyplayer.o build\akyplayer.tap $6500


::
:: Convert musics
:: ym1.mym -> 8699 bytes
:: ym2.mym -> 7293 bytes
:: ym3.mym -> 7956 bytes
::
:: HIRES last usable memory area is $9800 / 38912
:: - 8657 -> $762f / 30255
:: Round to -> $7600 / 30208 this gives us $2200 / 8704 bytes for the music
::
:: TEXT last usable memory area is $B400 / 46080
:: $B400-$7600  gives us $3E00 / 15872 bytes for the music
::
:: So we make each music load in $7600
::
:: The depacking buffer for the music requires 256 bytes per register, so 256*14 bytes = $e00 / 3584 bytes
:: If we place the buffer just before the music file, it will start at the location $7600-$e00 = $6800 / 26624
::
:: And just before that we put the music player binary file, which will start by two JMP:
:: - (+0) JMP StartMusic
:: - (+3) JMP StopMusic
::
:: The music player itself is less than 512 bytes without counting the IRQ installation and what nots so could start in $6600, say $6500 for security
::
echo %osdk%
::echo on
SET HEADER=%osdk%\Bin\header.exe -a0 -h1

%HEADER% "data\AsianAgent.aky" build\AsianAgent.tap $7000
%HEADER% "data\SteppingOut.aky" build\SteppingOut.tap $7000
%HEADER% "data\SpaceRivals.aky" build\SpaceRivals.tap $7000
%HEADER% "data\JustAddCream.aky" build\JustAddCream.tap $7000
%HEADER% "data\HarmlessGrenade.aky" build\HarmlessGrenade.tap $7000
%HEADER% "data\HocusPocus.aky" build\HocusPocus.tap $7000
%HEADER% "data\Morons.aky" build\Morons.tap $7000
%HEADER% "data\BoulesEtBits.aky" build\BoulesEtBits.tap $7000
%HEADER% "data\KellyOn.aky" build\KellyOn.tap $7000
%HEADER% "data\RenegadeMix.aky" build\RenegadeMix.tap $7000

::
:: Rename files so they have friendly names on the disk
::
%OSDK%\bin\taptap ren build\%OSDKNAME%.tap "Test" 0
%OSDK%\bin\taptap ren build\akyplayer.tap "akyplayer" 0
%OSDK%\bin\taptap ren build\AsianAgent.tap "Music1" 0
%OSDK%\bin\taptap ren build\SteppingOut.tap "Music2" 0
%OSDK%\bin\taptap ren build\SpaceRivals.tap "Music3" 0
%OSDK%\bin\taptap ren build\JustAddCream.tap "Music4" 0
%OSDK%\bin\taptap ren build\HarmlessGrenade.tap "Music5" 0
%OSDK%\bin\taptap ren build\HocusPocus.tap "Music6" 0
%OSDK%\bin\taptap ren build\Morons.tap "Music7" 0
%OSDK%\bin\taptap ren build\BoulesEtBits.tap "Music8" 0
%OSDK%\bin\taptap ren build\KellyOn.tap "Music9" 0
%OSDK%\bin\taptap ren build\RenegadeMix.tap "Music0" 0

ECHO Building DSK file
%OSDK%\bin\tap2dsk -iCLS:TEST build\%OSDKNAME%.TAP build\akyplayer.tap build\AsianAgent.tap build\SteppingOut.tap build\SpaceRivals.tap build\JustAddCream.tap build\HarmlessGrenade.tap build\HocusPocus.tap build\Morons.tap build\BoulesEtBits.tap build\KellyOn.tap build\RenegadeMix.tap build\%OSDKNAME%.dsk
%OSDK%\bin\old2mfm build\%OSDKNAME%.dsk

GOTO End


::
:: Outputs an error message
::
:ErCfg
ECHO == ERROR ==
ECHO The Oric SDK was not configured properly
ECHO You should have a OSDK environment variable setted to the location of the SDK
IF "%OSDKBRIEF%"=="" PAUSE
GOTO End


:End
