@echo off

echo ===-------------------------------===
echo     ZIRIX V4 (0.6.4)
echo     Developed by: ZIRAFLIX
echo     Discord: discord.gg/ziraflix
echo     Contact: contato@ziraflix.com
echo ===-------------------------------===

pause
start ..\artifacts\FXServer.exe +set onesync on +set onesync_population false +exec config/config.cfg +set sv_enforceGameBuild tuner
exit