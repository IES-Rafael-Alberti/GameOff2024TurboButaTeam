
@echo off
REM #push build to itch.io using butler / refinery

REM ### fill out config settings ####

set pathToBuild="C:\Users\javil\Desktop\GameOff2024TurboButaTeam\builds\Web"
set butlerName=turbobutateam/extinct-spirit:web
@echo on
@echo %pathToBuild%
@echo %butlerName%
@echo off
pause

REM ###run####


cd %pathToBuild%


REM #send file to itch.io via Butler:
butler push %pathToBuild%\ %butlerName%


pause