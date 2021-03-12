SET SCRIPT_DIR=%~dp0
SET WORKING_DIR=%cd%

bbrusher pack "%SCRIPT_DIR%\brushes\quirks_ui.brush" "%SCRIPT_DIR%\gfx"

cd "%SCRIPT_DIR%"
7z a "%WORKING_DIR%\mod_quirks.zip" brushes gfx scripts sounds
