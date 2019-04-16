:: Programmed by hXR16F
:: hXR16F.ar@gmail.com

@echo off
if not exist "data.db" exit
setlocal EnableDelayedExpansion
reg add "HKCU\Console" /V "ForceV2" /T "REG_DWORD" /D "0x00000000" /F > nul
reg add "HKCU\Console" /V "FullScreen" /T "REG_DWORD" /D "0x00000000" /F > nul
call :fchk_ 1 & call :sort_ 1 & call :clnn_ 1 & call :debg_ 1
consetbuffer.dll 67 300 & mode 67,55 & title Artificial Intelligence & color 07
call :clsc_

:loop
	set /p "text=YOU: "
	call :syntaxModule_
	
	:next
	if exist "data.db" (
		for /f "tokens=1,* delims=@" %%i in (data.db) do (
			if /i "%text%" EQU "%%i" (
				if not "%%j" EQU "" (
					batbox.dll /c 0x08 /d "!displayData!*** " /c 0x0C /d "%%j" /c 0x07 && echo. & echo.
					goto loop
				)
			)
		)
	)
	set lines2=0
	if exist "temp.txt" (
		for /f "tokens=*" %%i in (temp.txt) do (
			set /A lines2+=1
			set "data!lines2!=%%i"
		)
		if !lines2! GEQ 10 (
			del /F /Q "temp.txt" > nul
		)
	)
	echo %text%>> "temp.txt"
	set lines=0
	if exist "temp.txt" (
		for /f "tokens=*" %%i in (temp.txt) do (
			set /A lines+=1
			set "data!lines!=%%i"
		)
	)
	set /A lines2=%lines%-1
	call :random_ 1 %lines2% el
	if not "!data%el%!" EQU "" (
		set minlines=0
		if exist "temp.txt" (
			for /f "tokens=*" %%i in (temp.txt) do (
				set /A minlines+=1
			)
		)
		if !minlines! GTR 2 (
			call :random_ 1 2 el3
			if "%el3%" EQU "1" (
				batbox.dll /c 0x08 /d "!displayTemp!*** " /c 0x0C /d "!data%el%!" /c 0x07 && echo. & echo.
				set answer=1
			) else (
				call :randomDataPick_
			)
		) else (
			call :randomDataPick_
		)
	) else (
		batbox.dll /c 0x08 /d "FAIL *** " /c 0x0C /d "Not enough messages." /c 0x07 && echo. & echo.
		goto loop
	)
	set /p "text=YOU: "
	call :syntaxModule_
	if not "!data%el%!" EQU "" (
		set "found=0"
		if exist "data.db" (
			for /f "tokens=1,* delims=@" %%i in (data.db) do (
				if /i "!data%el%!" EQU "%%i" (
					set found=1
				)
			)
		)
		if "!found!" EQU "0" (
			if "%answer%" EQU "1" (
				echo !data%el%!@%text%>> "data.db"
			)
			set answer=0
		)
		set "add=1"
	)
	goto next
	
	:: -=-=- Functions below -=-=- ::
	
:syntaxModule_
	if "%text:~0,1%" EQU "=" (
		if /I "%text:~1,4%" EQU "exit" (
			call :clnn_ 1
			call :sort_ 1
			exit
		) else (
			if /I "%text:~1,4%" EQU "time" (
				call :time_
			) else (
				if /I "%text:~1,4%" EQU "sort" (
					call :sort_ 0
				) else (
					if /I "%text:~1,4%" EQU "clnn" (
						call :clnn_ 0
					) else (
						if /I "%text:~1,4%" EQU "ping" (
							call :ping_
						) else (
							if /I "%text:~1,4%" EQU "clsc" (
								call :clsc_
							) else (
								if /I "%text:~1,4%" EQU "rset" (
									call :clnn_ 1
									call :sort_ 1
									call :clsc_
								) else (
									if /I "%text:~1,4%" EQU "winv" (
										call :winv_
									) else (
										if /I "%text:~1,4%" EQU "fchk" (
											call :fchk_
										) else (
											call :calc_
										)
									)
								)
							)
						)
					)
				)
			)
		)
		goto loop
	) else (
		exit /B
	)
	exit /B
	
:randomDataPick_
	if exist "data.db" (
		set "llines=0" & rem (-1) because of empty line at the end of data.db
		for /f %%i in (data.db) do (
			set /A llines+=1
		)
	)
	call :random_ 1 %llines% el2
	set llines2=0
	for /f "tokens=1,* delims=@" %%i in (data.db) do (
		set /A llines2+=1
		if "!llines2!" EQU "!el2!" (
			batbox.dll /c 0x08 /d "!displayNull!*** " /c 0x0C /d "%%i" /c 0x07 && echo. & echo.
		)
	)
	exit /B
	
:random_
	set "name=%3"
	set /A !name!=%random% * (%2 - %1 + 1) / 32768 + %1 >nul 2>&1 || (
		rem batbox.dll /c 0x08 /d "FAIL *** " /c 0x0C /d "Calculating error." /c 0x07 && echo. & echo.
		call :randomDataPick_
		goto loop
	)
	exit /B
	
:calc_
	echo %text:~1,128% | bc.dll -l > "calc.tmp"
	for /F "tokens=1*" %%i in (calc.tmp) do (
		set "elc=%%i"
	)
	del /F /Q "calc.tmp" >nul 2>&1
	batbox.dll /c 0x08 /d "CALC *** " /c 0x0C /d "%elc%" /c 0x07 && echo. & echo.
	exit /B
	
:time_
	batbox.dll /c 0x08 /d "TIME *** " /c 0x0C /d "%date%, %time:~0,8%" /c 0x07 && echo. & echo.
	exit /B
	
:sort_ %1
	if exist "data.db" (
		sort data.db > data2.txt
		del /F /Q data.db >nul 2>&1
		ren data2.txt data.db >nul 2>&1
	)
	if not "%1" EQU "1" (
		batbox.dll /c 0x08 /d "SORT *** " /c 0x0C /d "Sorted 'data.db'." /c 0x07 && echo. & echo.
	)
	exit /B
	
:clnn_ %1
	if exist "temp.txt" (
		del /F /Q "temp.txt" >nul 2>&1
	)
	if not "%1" EQU "1" (
		batbox.dll /c 0x08 /d "CLNN *** " /c 0x0C /d "Cleaned temporary sentences." /c 0x07 && echo. & echo.
	)
	exit /B
	
:ping_
	set pingScore=0
	ping www.google.com -l 8 -n 1 -w 500 >nul 2>&1 && set /A pingScore+=1
	ping www.wikipedia.com -l 8 -n 1 -w 500 >nul 2>&1 && set /A pingScore+=1
	ping www.ovh.com -l 8 -n 1 -w 500 >nul 2>&1 && set /A pingScore+=1
	ping www.nasa.gov -l 8 -n 1 -w 500 >nul 2>&1 && set /A pingScore+=1
	ping www.microsoft.com -l 8 -n 1 -w 500 >nul 2>&1 && set /A pingScore+=1
	if %pingScore% EQU 5 (
		set "pingStatus=Good"
	) else (
		if %pingScore% EQU 4 (
			set "pingStatus=Ok"
		) else (
			if %pingScore% EQU 3 (
				set "pingStatus=Ok"
			) else (
				if %pingScore% EQU 2 (
					set "pingStatus=Bad"
				) else (
					if %pingScore% EQU 1 (
						set "pingStatus=Bad"
					) else (
						if %pingScore% EQU 0 (
							set "pingStatus=No connection"
						)
					)
				)
			)
		)
	)
	batbox.dll /c 0x08 /d "PING *** " /c 0x0C /d "Score: %pingScore%/5 (%pingStatus%)" /c 0x07 && echo. & echo.
	exit /B
	
:clsc_
	cls
	echo.
	batbox.dll /c 0x07 /d "  Informations:" /c 0x08
	(
		echo.
		echo     Programmed by hXR16F
		echo     Debug mode: !dbg! ^| Missing files: !missingFiles!
		echo.
	)
	batbox.dll /c 0x07 /d "  Debug informations:" /c 0x08
	(
		echo.
		echo     DATA - AI found an answer, you can ask another question.
		echo     TEMP - You must answer AI's 'question' based on only 1 line.
		echo     NULL - AI can't find an answer, you can ask another question.
		echo     FAIL - Error occured.
		echo.
	)
	batbox.dll /c 0x07 /d "  Modules (usage: '=module_name'):" /c 0x08
	(
		echo.
		echo     CALC - Calculation program, ex: '=2+2'.
		echo     TIME - Shows date and time.
		echo     SORT - Sorts database.
		echo     CLNN - Cleans temporary sentences.
		echo     PING - Pings multiple sites to check internet connection.
		echo     CLSC - Cleans screen.
		echo     RSET - Restarts AI without closing the window.
		echo     WINV - Gets Windows version.
		echo     FCHK - File checker.
		echo     EXIT - Exits the program.
		echo.
	)
	batbox.dll /c 0x07
	exit /B
	
:winv_
	for /f "tokens=4-7 delims=[.] " %%i in ('ver') do @(
		if "%%i" EQU "Version" (
			if "%%j.%%k" EQU "10.0" (set "winv=Windows 10") else (
				if "%%j.%%k" EQU "6.3" (set "winv=Windows 8.1 / Server 2012") else (
					if "%%j.%%k" EQU "6.2" (set "winv=Windows 8") else (
						if "%%j.%%k" EQU "6.1" (set "winv=Windows 7") else (
							if "%%j.%%k" EQU "6.0" (set "winv=Windows Vista") else (
								if "%%j.%%k" EQU "5.2" (set "winv=Windows XP") else (
									if "%%j.%%k" EQU "5.1" (set "winv=Windows XP") else (
										if "%%j.%%k" EQU "5.0" (set "winv=Windows 2000")
									)
								)
							)
						)
					)
				)
			)		
			batbox.dll /c 0x08 /d "WINV *** " /c 0x0C /d "%%j.%%k.%%l.%%m (!winv!)" /c 0x07 && echo. & echo.
		) else (
			if "%%i.%%j" EQU "10.0" (set "winv=Windows 10") else (
				if "%%i.%%j" EQU "6.3" (set "winv=Windows 8.1 / Server 2012") else (
					if "%%i.%%j" EQU "6.2" (set "winv=Windows 8") else (
						if "%%i.%%j" EQU "6.1" (set "winv=Windows 7") else (
							if "%%i.%%j" EQU "6.0" (set "winv=Windows Vista") else (
								if "%%i.%%j" EQU "5.2" (set "winv=Windows XP") else (
									if "%%i.%%j" EQU "5.1" (set "winv=Windows XP") else (
										if "%%i.%%j" EQU "5.0" (set "winv=Windows 2000")
									)
								)
							)
						)
					)
				)
			)	
			batbox.dll /c 0x08 /d "WINV *** " /c 0x0C /d "%%i.%%j.%%k.%%l (!winv!)" /c 0x07 && echo. & echo.
		)
	)
	exit /B
	
:debg_ %1
	if "%1" EQU "1" (
		set "displayTemp=TEMP "
		set "displayData=DATA "
		set "displayNull=NULL "
		set "dbg=True"
	) else (
		set "displayTemp="
		set "displayData="
		set "displayNull="
		set "dbg=False"
	)
	exit /B
	
:fchk_ %1
	set missingFiles=0
	for %%n in (
		"batbox.dll"	"bc.dll"	"consetbuffer.dll"	"data.db"	"readline4.dll"
	) do (
		if not exist "%%n" (
			set /A missingFiles+=1
		)
	)
	if not "%1" EQU "1" (
		batbox.dll /c 0x08 /d "FCHK *** " /c 0x0C /d "Missing files: !missingFiles!" /c 0x07 && echo. & echo.
	)
	exit /B
	