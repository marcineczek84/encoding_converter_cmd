@echo off
 
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 
rem conversion.bat - my second script written in Windows Batch Scripting. It converts polish diacritical signs between UTF-8, Windows 1250, ISO-8859-2
rem Create by: Marcineczek1984
rem License type: MIT


rem The MIT License (MIT)
rem Copyright (c) 2016 marcineczek84
 
rem Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
rem files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
rem modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
rem is furnished to do so, subject to the following conditions:
 
rem The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
rem THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
rem OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
rem LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
rem IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 
REM TBD - variables naming convention unification

SETLOCAL EnableDelayedExpansion
chcp 852 2>&1>nul

REM Global tables intialization. We set three tables contains grup of sings encoded in Windows 1250(!!!) which are counterparts
REM of polish diacritic signs in iso-8859-2 and utf-8

REM UTF-8 table
SET /A i=0
FOR %%A IN (â€ž â€ť â€” â€“ Ä… Ä‡ Ä™ Ĺ‚ Ĺ„ Ăł Ĺ› Ĺş ĹĽ Ä„ Ĺą Ä Ĺ Ĺ Ă“ Ĺš Ĺ» Ä† ) DO (
SET utf[!i!]=%%A
SET /A i=i+1
)
     
REM Windows-1250 table	 
SET /A i=0
FOR %%A IN („ ” — – ą ć ę ł ń ó ś ź ż Ą Ź Ę Ł Ń Ó Ś Ż Ć) DO (
SET w1250[!i!]=%%A
SET /A i=i+1
)
 
REM ISO-8859-2
SET /A i=0
FOR %%A IN ( """" """" - - ± ć ę ł ń ó ¶ Ľ ż ˇ ¬ Ę Ł Ń Ó ¦ Ż Ć) DO (
SET iso[!i!]=%%A
SET /A i=i+1
)
 
REM main function diplays welcome message and them it's call three functions to set initial settings. Finally it calls flowdecision function

REM void main(void)
:main
SETLOCAL
REM Good morning!
ECHO Dzieä dobry^^!

SET "_filename="
CALL :setfilename _filename

ECHO.
ECHO.

SET "_orignfileformat="
CALL :setorignfileformat _orignfileformat

ECHO.
ECHO.
 
SET "_finalfileformat="
CALL :setfinalfileformat _finalfileformat

ECHO.
ECHO.

echo %_orignfileformat% %_finalfileformat% %_filename%
 
CALL :flowdecision %_orignfileformat% %_finalfileformat% %_filename%

ENDLOCAL 
GOTO:EOF

REM Displays prompt to enter filename, if filename is not correct it will call itself, until you provide a correct name.

REM String setfilename(void) 
:setfilename

SETLOCAL

REM enter filename to convert
SET /P "_file=Wpisz nazw© pliku do konwersji: "

CALL :filecheck "%_file%"
	
REM catch 
(ENDLOCAL
IF ERRORLEVEL 0 SET "%~1=%_file%"
IF ERRORLEVEL 1 GOTO :setfilename
)
GOTO:EOF

REM Displays prompt to enter input file encoding, if encoding is not correct it will call itself, until you provide a correct encoding.

REM String setorignfileformat(void)
:setorignfileformat
SETLOCAL
REM choose an input file encoding.
ECHO Wybierz jaki format ma oryginalny plik:
ECHO 1. WINDOWS 1250
ECHO 2. ISO 8859-2
ECHO 3. UTF-8

SET "_orignfileformat="
SET /P _orignfileformat=Wybierz przycisk 1, 2 lub 3 a nast©pnie wcinij ENTER: 
 
CALL :check "%_orignfileformat%" 1 3

REM catch
(ENDLOCAL 
IF ERRORLEVEL 0 SET %~1=%_orignfileformat%
IF ERRORLEVEL 1 GOTO :setorignfileformat
)
GOTO:EOF

REM Displays prompt to enter output file encoding, if encoding is not correct it will call itself, until you provide a correct encoding.

REM String setfinalfileformat(void)
:setfinalfileformat
SETLOCAL
REM choose an output file encoding.
ECHO Wybierz na jaki format ma zosta† przetworzony oryginalny plik:
ECHO 1. WINDOWS 1250
ECHO 2. ISO 8859-2
ECHO 3. UTF-8

SET "_finalfileformat="
SET /P _finalfileformat=Wybierz przycisk 1, 2 lub 3 a nast©pnie wcinij ENTER: 
 
CALL :check "%_finalfileformat%" 1 3

REM catch
(ENDLOCAL
  IF ERRORLEVEL 0 SET %1=%_finalfileformat%
  IF ERRORLEVEL 1 GOTO :setfinalfileformat
)
GOTO:EOF

REM This function first set all needed arguments for check function and calls it. 

REM flowdecision(String inputenc, String outputenc, String filename)
:flowdecision

REM Nonsens! Ther is no sense to convert file to this same encoding
IF "%~1" equ "%~2" ECHO Bez sensu! Nie ma sensu robi† konwersji z jednego formatu na taki sam. & EXIT /B 1
 
IF %~1==1 SET _org=w1250
IF %~1==2 SET _org=iso
IF %~1==3 SET _org=utf
 
IF %~2==1 SET _fin=w1250
IF %~2==2 SET _fin=iso
IF %~2==3 SET _fin=utf


CALL :convert %_org% %_fin% %~3
GOTO:EOF
 
REM this function checks is provided number is in the range and is it intiger

REM void check(int provided, int lowerbound, int upperboud) throws IllegalArgumentException
:check
SETLOCAL
REM you did't provide number
IF "%~1" equ "" ECHO Nie wprowadzono liczby & ENDLOCAL & EXIT /B 1

REM pseudo-cast
SET /a "_val=%~1" 2> nul
REM Wrong format! You didnt provide intiger. instead it looks like String
IF "%~1" neq "%_val%" ECHO B©dny format! Gdzie wpisae liter© & ENDLOCAL & EXIT /B 2
REM number to small
IF %~1 lss %~2  ECHO Za maa liczba  & ENDLOCAL & EXIT /B 3
REM number to big
IF %~1 gtr %~3  ECHO Za duľa liczba & ENDLOCAL & EXIT /B 4
ENDLOCAL
EXIT /B 0
 

GOTO:EOF

REM checking is file name correct and is accesible.

REM void filecheck(String) throws Filenotfoundexception, IOException
:filecheck

REM you provide null
IF "%~1" EQU "" ECHO nic nie wprowadzono & EXIT /B 1
REM no such file in folder
IF NOT EXIST %~f1 ECHO Plik o nazwie %~1 nie istnieje w folderze %CD% & EXIT /B 2
rem file is 0 byte size
IF %~z1 EQU 0 ECHO Plik ma zerowĄ wielko† & EXIT /B 3

EXIT /B 0
GOTO:EOF

REM convert - the main part of script. It converts encoding and write the oupput to new file named after input file with an "_reult" suffix

REM void convert(Sting inputenc, String outputenc, String filename)
:convert
SETLOCAL
SET "org=%~1"
SET "fin=%~2"

REM first we create emtpy file
copy nul %~n3_result.txt 2>&1>nul

REM second we iterate throught file line by line (the carret ^ sign is used to break)
FOR /F "tokens=*" %%A IN ('findstr /n "^" "%~3"') DO (
 
REM we set variable to string (line)
SET "test=%%A"
SET "test=!test:*:=!"
 
REM there are exactly 21 letters to convert. So each line must be 21 times checked
FOR /L %%A IN (0,1,21) DO (
 
REM convert in separate funciton
CALL:stringrepleace test "!test!" !%org%[%%A]! !%fin%[%%A]!
)

REM add a convert line to output file
ECHO.!test!>>%~n3_result.txt
)
REM work is saved in ...
ECHO Zapisano do %~n3_result.txt
ENDLOCAL
GOTO:EOF
 
 REM String stringrepleace(String oldstring, String from, String to)
:stringrepleace
SETLOCAL
SET "oldstring=%~2"
SET "from=%~3"
SET "to=%~4"
 
 REM if not empty line then replace
IF NOT "%oldstring%"=="" set "newstring=!oldstring:%from%=%to%!"
 
REM We used %~1 argument becouse it's the way to return value in CMD
REM return
ENDLOCAL & SET "%~1=%newstring%"
GOTO:EOF
