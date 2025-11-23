@echo off
set DOCNAME=main

REM --- MENU ---
if "%1"=="clean" goto clean
if "%1"=="purge" goto purge
if "%1"=="watch" goto watch

REM --- BUILD (Default) ---
:build
echo Building PDF...
latexmk -lualatex -shell-escape -interaction=nonstopmode -pdf %DOCNAME%.tex
goto end

REM --- CLEAN ---
:clean
echo Cleaning temporary files...
del /s /q *.aux *.log *.out *.toc *.lot *.lof *.fls *.fdb_latexmk *.codeblk *.synctex.gz
if exist "_minted-%DOCNAME%" rmdir /s /q "_minted-%DOCNAME%"
goto end

REM --- PURGE ---
:purge
call :clean
echo Removing PDF...
del /q %DOCNAME%.pdf
goto end

REM --- WATCH ---
:watch
echo Watching for changes...
latexmk -lualatex -shell-escape -interaction=nonstopmode -pvc -pdf %DOCNAME%.tex
goto end

:end