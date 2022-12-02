@ECHO OFF
chcp 65001
PUSHD %~DP0 &TITLE 綠化程式
Md "%WinDir%\System32\test_permissions" 2>NUL||(Echo.&Echo 請使用右鍵“以管理員身份運行”&&Pause >NUL&&Exit)
Rd "%WinDir%\System32\test_permissions" 2>NUL
SetLocal EnableDelayedExpansion

:Menu
Echo.&Echo  1.綠化
Echo.&Echo  2.移除
Echo.&Echo  3.添加IE右鍵下載菜單 ( 自選 )
Echo.&Echo  4.移除IE右鍵下載菜單 ( 默認 )
Echo.&Echo  5.啟用邊下邊播功能 ( 自選 )
Echo.&Echo  6.禁用邊下邊播功能 ( 默認 )
Echo.&Echo  7.啟用谷歌瀏覽器擴展支持 ( 自選 )
Echo.&Echo  8.禁用谷歌瀏覽器擴展支持 ( 默認 )
Echo.&Echo  +.創建桌面極速迅雷快捷方式
Echo.&Echo.
set /p a=請輸入選項：
If Not "%a%"=="" Set a=%a:~0,1%
If "%a%"=="1" Goto install
If "%a%"=="2" Goto Uninstall
If "%a%"=="3" Goto MenuExt
If "%a%"=="4" Goto DelMenuExt
If "%a%"=="5" Goto AddXmp
If "%a%"=="6" Goto DelXmp
If "%a%"=="7" Goto BhoChrome
If "%a%"=="8" Goto DBhoChrome
if "%a%"=="+" Goto DesktopLnk
Echo.&Echo 輸入無效，請重新輸入！
PAUSE >NUL & CLS & GOTO Menu

:install
::安裝前結束相關進程並清理注冊表
taskkill /f /im Thunder* >NUL 2>NUL
Regedit /s Program\DelTdsp.reg
Regsvr32 /s /u Bho\ThunderAgent.dll
If "%PROCESSOR_ARCHITECTURE%"=="AMD64" Regsvr32 /s /u Bho\ThunderAgent64.dll
Regsvr32 /s /u Bho\Platform\np_tdieplat.dll
Program\Thunder.exe -unassociate:td -unassociate:torrent -unassociate:downlist -unassociate:thunderskin -unassociate:thunderaddin -unassociate:all -unregprotocol:ed2k -unregprotocol:magnet -unregprotocol:thunder -unregprotocol:xlapplink
Reg Delete "HKCR\Xunlei.ThunderSkin.6" /f >nul 2>nul
Reg Delete "HKCU\Software\Thunder Network" /f >nul 2>nul
Reg Delete "HKLM\Software\Thunder Network" /f >nul 2>nul
Reg Delete "HKLM\Software\Wow6432Node\Thunder Network" /f >nul 2>nul
Reg Delete "HKLM\Software\Google\Chrome\NativeMessagingHosts" /f >nul 2>nul
Reg Delete "HKCU\Software\Microsoft\Internet Explorer\MenuExt\使用迅雷下載" /f >nul 2>nul
Reg Delete "HKCU\Software\Microsoft\Internet Explorer\MenuExt\使用迅雷下載全部連結" /f >nul 2>nul
Reg Delete "HKCU\Software\Microsoft\Internet Explorer\MenuExt\使用迅雷離線下載" /f >nul 2>nul

::清理後臺相關殘留資料為安裝做準備
Rd /s /q "%TMP%\Xunlei" >nul 2>nul
Rd /s /q "%TMP%\Thunder Network" >nul 2>nul
Rd /s /q "Program\SpeedHistory" >nul 2>nul
If Exist "%PUBLIC%" Rd /s /q "%PUBLIC%\Thunder Network" >nul 2>nul
Del /f /q "%AppData%\Microsoft\Windows\Libraries\迅雷下載.library-ms" 2>nul
Rd /s /q "%AllUsersProfile%\Application Data\Thunder Network" >nul 2>nul
Rd /s /q "%UserProfile%\Local Settings\Application Data\Thunder Network" 2>NUL
Rd /s /q "%UserProfile%\AppData\LocalLow\Thunder Network" >nul 2>nul

::開始安裝（注冊瀏覽器插件、創建基本關聯）
Regsvr32 /s Bho\ThunderAgent.dll
If "%PROCESSOR_ARCHITECTURE%"=="AMD64" Regsvr32 /s Bho\ThunderAgent64.dll
Regsvr32 /s Bho\Platform\np_tdieplat.dll >nul 2>nul
Program\Thunder.exe -install -associate:all   >nul 2>nul

if "%PROCESSOR_ARCHITECTURE%"=="x86" Reg Add "HKLM\Software\Thunder Network\ThunderOem\thunder_backwnd" /v dir /d "%~dp0" >nul 2>nul
if "%PROCESSOR_ARCHITECTURE%"=="x86" Reg Add "HKLM\Software\Thunder Network\ThunderOem\thunder_backwnd" /v Path /d "%~dp0Program\Thunder.exe" >NUL 2>nul 
if "%PROCESSOR_ARCHITECTURE%"=="x86" Reg Add "HKLM\Software\Thunder Network\ThunderOem\thunder_backwnd" /v instdir /d "%~dp0" >nul 2>nul
if "%PROCESSOR_ARCHITECTURE%"=="x86" Reg Add "HKLM\Software\Thunder Network\ThunderOem\thunder_backwnd" /v Version /d "7.10.35.366" >nul 2>nul
If "%PROCESSOR_ARCHITECTURE%"=="AMD64" Reg Add "HKLM\Software\Wow6432Node\Thunder Network\ThunderOem\thunder_backwnd" /v dir /d "%~dp0" >nul 2>nul
If "%PROCESSOR_ARCHITECTURE%"=="AMD64" Reg Add "HKLM\Software\Wow6432Node\Thunder Network\ThunderOem\thunder_backwnd" /v Path /d "%~dp0Program\Thunder.exe" >NUL 2>nul
If "%PROCESSOR_ARCHITECTURE%"=="AMD64" Reg Add "HKLM\Software\Wow6432Node\Thunder Network\ThunderOem\thunder_backwnd" /v instdir /d "%~dp0" >nul 2>nul
If "%PROCESSOR_ARCHITECTURE%"=="AMD64" Reg Add "HKLM\Software\Wow6432Node\Thunder Network\ThunderOem\thunder_backwnd" /v Version /d "7.10.35.366" >nul 2>nul
Echo.&Echo 綠化完成，按任意鍵返回！&PAUSE >NUL 2>NUL & CLS & GOTO MENU

::添加/移除IE右鍵菜單 (預設不添加)
:MenuExt
Reg Add "HKCU\Software\Microsoft\Internet Explorer\MenuExt\使用迅雷下載" /ve /d "%~dp0BHO\geturl.htm" /f >nul
Reg Add "HKCU\Software\Microsoft\Internet Explorer\MenuExt\使用迅雷下載" /v "Contexts" /t REG_DWORD /d "0x00000022" /f >nul
Reg Add "HKCU\Software\Microsoft\Internet Explorer\MenuExt\使用迅雷下載全部連結" /ve /d "%~dp0BHO\getAllurl.htm" /f >nul
Reg Add "HKCU\Software\Microsoft\Internet Explorer\MenuExt\使用迅雷下載全部連結" /v "Contexts" /t REG_DWORD /d "0x000000f3" /f >nul
Echo.&Echo IE右鍵下載菜單已添加，按任意鍵返回！&PAUSE >NUL 2>NUL & CLS & GOTO MENU

:DelMenuExt
Reg Delete "HKCU\Software\Microsoft\Internet Explorer\MenuExt\使用迅雷下載" /f >nul 2>nul
Reg Delete "HKCU\Software\Microsoft\Internet Explorer\MenuExt\使用迅雷下載全部連結" /f >nul 2>nul
Echo.&Echo IE右鍵下載菜單已移除，按任意鍵返回！&PAUSE >NUL 2>NUL & CLS & GOTO MENU

::邊下邊播啟用/禁用開關（只支援POT,預設不啟用） 
:AddXmp
taskkill /f /im Thunder* >NUL 2>NUL
ren Program\stream.dl_ stream.dll >NUL 2>NUL
start Program\Xmp.ini
CLS & GOTO MENU

:DelXmp
taskkill /f /im Thunder* >NUL 2>NUL
ren Program\stream.dll stream.dl_ >NUL 2>NUL
Regedit /s Program\DelTdsp.reg
Echo.&Echo 已禁用邊下邊播，按任意鍵返回！&PAUSE >NUL 2>NUL & CLS & GOTO MENU

::谷歌瀏覽器擴展支持（默認不啟用）
:BhoChrome
Reg Add "HKLM\Software\Google\Chrome\NativeMessagingHosts\com.xunlei.thunder" /f /ve /d "%~dp0Bho\Chrome\com.xunlei.thunder.json" >NUL 2>nul
Echo.&Echo 已啟用擴展支持，您需從谷歌網上應用店安裝官方擴展，方可正常使用！
Echo.&Echo 如已安裝官方擴展，可忽略上述提示，按任意鍵返回！&PAUSE >NUL 2>NUL & CLS & GOTO MENU

:DBhoChrome
Reg Delete "HKLM\Software\Google\Chrome\NativeMessagingHosts" /f >nul 2>nul
Echo.&Echo 已禁用擴展支持，按任意鍵返回！&PAUSE >NUL 2>NUL & CLS & GOTO MENU

:DesktopLnk
mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\極速迅雷.lnk""):b.TargetPath=""%~dp0Program\Thunder.exe"":b.WorkingDirectory=""%~dp0Program\"":b.Save:close")
Echo.&Echo 已創建桌面快捷方式，按任意鍵返回！&PAUSE >NUL 2>NUL & CLS & GOTO MENU

:Uninstall
taskkill /f /im Thunder* >NUL 2>NUL
Regedit /s Program\DelTdsp.reg
Regsvr32 /s /u Bho\ThunderAgent.dll
If "%PROCESSOR_ARCHITECTURE%"=="AMD64" Regsvr32 /s /u Bho\ThunderAgent64.dll
Regsvr32 /s /u Bho\Platform\np_tdieplat.dll
Program\Thunder.exe -unassociate:td -unassociate:torrent -unassociate:downlist -unassociate:thunderskin -unassociate:thunderaddin -unassociate:all -unregprotocol:ed2k -unregprotocol:magnet -unregprotocol:thunder -unregprotocol:xlapplink
Reg Delete "HKCR\Xunlei.ThunderSkin.6" /f >nul 2>nul
Reg Delete "HKCU\Software\Thunder Network" /f >nul 2>nul
Reg Delete "HKLM\Software\Thunder Network" /f >nul 2>nul
Reg Delete "HKLM\Software\Wow6432Node\Thunder Network" /f >nul 2>nul
Reg Delete "HKLM\Software\Google\Chrome\NativeMessagingHosts" /f >nul 2>nul
Reg Delete "HKCU\Software\Microsoft\Internet Explorer\MenuExt\使用迅雷下載" /f >nul 2>nul
Reg Delete "HKCU\Software\Microsoft\Internet Explorer\MenuExt\使用迅雷下載全部連結" /f >nul 2>nul

Rd /s /q "%TMP%\Xunlei" >nul 2>nul
Rd /s /q "%TMP%\Thunder Network" >nul 2>nul
Rd /s /q "Program\SpeedHistory" >nul 2>nul
If Exist "%PUBLIC%" Rd /s /q "%PUBLIC%\Thunder Network" >nul 2>nul
Del /f /q "%AppData%\Microsoft\Windows\Libraries\迅雷下載.library-ms" 2>nul
Rd /s /q "%AllUsersProfile%\Application Data\Thunder Network" >nul 2>nul
Rd /s /q "%UserProfile%\Local Settings\Application Data\Thunder Network" 2>NUL
Rd /s /q "%UserProfile%\AppData\LocalLow\Thunder Network" >nul 2>nul
Echo.&Echo 已移除完成，按任意鍵返回！&PAUSE >NUL 2>NUL & CLS & GOTO MENU
