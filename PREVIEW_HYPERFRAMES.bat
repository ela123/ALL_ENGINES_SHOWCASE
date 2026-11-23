@echo off
cd /d %~dp0hyperframes
call npm install
npx hyperframes preview
