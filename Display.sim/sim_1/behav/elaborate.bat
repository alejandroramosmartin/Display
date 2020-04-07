@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xelab  -wto 0856fff8086d44f98a8ff22424cf1143 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip -L xpm --snapshot TB_Display_behav xil_defaultlib.TB_Display -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
