@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ========================================================
echo  All Engines Showcase - Full Render Pipeline
echo  Resolution: 1920x1080 @ 30 FPS
echo ========================================================

if not exist renders mkdir renders
if not exist renders\manim mkdir renders\manim
if not exist remotion\public\assets mkdir remotion\public\assets

echo.
echo [1/3] Rendering HyperFrames scene...
cd hyperframes
if not exist node_modules call npm install
call npx hyperframes lint
call npx hyperframes render --output ..\renders\hyperframes-showcase.mp4 --fps 30 --quality high --gpu
if errorlevel 1 (
    echo Notice: GPU encoding unavailable, falling back to software encoding...
    call npx hyperframes render --output ..\renders\hyperframes-showcase.mp4 --fps 30 --quality high
)
if not exist ..\renders\hyperframes-showcase.mp4 (
    echo ERROR: HyperFrames rendering failed!
    pause
    exit /b 1
)

echo.
echo [2/3] Rendering ManimGL scenes...
cd ..\manim
call manimgl scenes.py RiskAndCompounding -w -r 1920x1080 --fps 30 --video_dir ..\renders\manim --file_name manim-showcase
if errorlevel 1 goto manim_failed

call manimgl scenes.py LeverageSurface -w -r 1920x1080 --fps 30 --video_dir ..\renders\manim --file_name manim-3d-showcase
if errorlevel 1 (
    echo Warning: 3D scene failed, using 2D render as fallback...
    copy /Y ..\renders\manim\manim-showcase.mp4 ..\renders\manim\manim-3d-showcase.mp4 >nul
)

echo.
echo [3/3] Synchronizing assets and rendering Remotion Integrated Master...
cd ..
xcopy /E /I /Y assets remotion\public\assets >nul
copy /Y renders\hyperframes-showcase.mp4 remotion\public\assets\hyperframes-showcase.mp4 >nul
copy /Y renders\manim\manim-showcase.mp4 remotion\public\assets\manim-showcase.mp4 >nul
copy /Y renders\manim\manim-3d-showcase.mp4 remotion\public\assets\manim-3d-showcase.mp4 >nul

cd remotion
if not exist node_modules call npm install
call npx remotion render src/index.ts IntegratedShowcase ..\renders\integrated-showcase.mp4 --codec=h264 --crf=18
if errorlevel 1 goto remotion_failed

cd ..
echo.
echo ========================================================
echo  Render Pipeline Completed Successfully!
echo  Master file: renders\integrated-showcase.mp4
echo ========================================================
pause
exit /b 0

:manim_failed
echo ERROR: ManimGL render failed. Please check Python, OpenGL, and FFmpeg setup.
pause
exit /b 1

:remotion_failed
echo ERROR: Remotion render failed. Check npm dependencies and console logs.
pause
exit /b 1
