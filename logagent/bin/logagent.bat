@echo off

setlocal

set "LOG_AGENT_BAT_DIR=%~dp0"
set "LOG_AGENT_HOME=%LOG_AGENT_BAT_DIR%\..\"
set "LOG_AGENT_LIB=%LOG_AGENT_HOME%\lib\sp-logagent-1.0-SNAPSHOT.jar"
set "LOG_AGENT_LOG_DIR=%LOG_AGENT_HOME%\log"
set "LAST_ERROR_LOGS_SIZE=50"

if not exist "%LOG_AGENT_HOME%\bin\setenv.bat" goto checkSetenvHome
call "%LOG_AGENT_HOME%\bin\setenv.bat"
goto setenvDone
:checkSetenvHome
if exist "%LOG_AGENT_HOME%\bin\setenv.bat" call "%LOG_AGENT_HOME%\bin\setenv.bat"
:setenvDone

if not "%SA_LOG_AGENT_CONFIG_FILE%" == "" goto gotConfigFile
set "SA_LOG_AGENT_CONFIG_FILE=%LOG_AGENT_HOME%\logagent.conf"
:gotConfigFile

set "LOG_AGENT_MAIN_CLASS=com.sensorsdata.analytics.tools.logagent.LogAgentMain"
set CMD_LINE_ARGS=%*

set _EXECJAVA=java
%_EXECJAVA% -server -classpath "%LOG_AGENT_LIB%" -Dsa.root.logger=DEBUG,DRFA,console -Dsa.log.file="%LOG_AGENT_LOG_DIR%\logagent.log" -Dsa.log.last.error.size=%LAST_ERROR_LOGS_SIZE% -Dfile.encoding=UTF-8 -Xms256m -Xmx256m -Xmn176m -XX:+UseParallelGC -XX:+UseParallelOldGC -XX:ParallelGCThreads=3 %LOG_AGENT_MAIN_CLASS% %CMD_LINE_ARGS%
pause
