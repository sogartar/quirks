@echo off

SET SCRIPT_DIR=%~dp0
SET WORKING_DIR=%cd%

mkdir "%SCRIPT_DIR%\brushes"
bbrusher pack "%SCRIPT_DIR%\brushes\quirks_ui.brush" "%SCRIPT_DIR%\gfx" || goto error

cd "%SCRIPT_DIR%"
7z a "%WORKING_DIR%\mod_quirks0.1.3.zip" brushes gfx scripts sounds || goto error
exit 0

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%
