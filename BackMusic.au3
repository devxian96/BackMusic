#include <Sound.au3>
#notrayicon
;; Function ;;
Global $volume=50 ,$volumetemp;����, ���� ���� ����
Local $Play, $Playtemp=0;�÷��� �ڵ�
Global $Playedlist ; �÷��̵� ���
Global $max, $j, $count;���ǰ���

MsgBox(0,"BackMusic","DevXian"&@crlf&"���� ��׶��� ���� ����� Ȱ��ȭ�� ���α׷��Դϴ�."&@crlf&"�� ���α׷��� �о� �ü� �ִ� ���� ������ .MP3Ȯ���� �Դϴ�."&@crlf&@crlf&"Alt+Z: �Ͻ�����/���"&@crlf&"Alt+X: �Ҹ� õõ�� �ø���/������ ������/������"&@crlf&"Alt+C: ���α׷� ����"&@crlf&"Alt+<: �Ҹ� ���̱�"&@crlf&"Alt+>: �Ҹ� �ø���"&@crlf&"Alt+/: ���� ���"&@crlf&"Alt+m: MP3���� ���� ã��")
SoundSetWaveVolume($volume)

;; HotKey ;;
HotKeySet("!c","_exit")
Func _Exit()
   ToolTip("���� �ʴϴ�.",0,0,"SHMusicSystem")
   _soundClose($Play)
   sleep(1500)
   Exit
EndFunc
HotKeySet("!x","_low")
Func _low()
   Global $i
   If $Playtemp==0 Then
	  ToolTip("�Ҹ� õõ�� ������ ������",0,0)
	  $Playtemp=1
	  $i=$volume
	  $volumetemp=$volume
	  While 1
		 $i-=1
		 SoundSetWaveVolume($i)
		 If $i==0 Then
			$volume=0
			_soundpause($play)
			ExitLoop
		 EndIf
		 sleep(35)
	  WEnd
   Else
	  ToolTip("�Ҹ� õõ�� �ø��� ������",0,0)
	  $Playtemp=0
	  $i=$volume
	  _soundresume($play)
	  While 1
		 $i+=1
		 SoundSetWaveVolume($i)
		 If $i==$volumetemp Then
			$volume=$i
			ExitLoop
		 EndIf
		 sleep(35)
	  WEnd
   EndIf
   ToolTip("")
EndFunc
HotKeySet("!z","Play_Stop")
Func Play_Stop()
   if $Playtemp==0 Then
	  ToolTip("�Ͻ�����",0,0)
	  $Playtemp=1
	  _soundpause($play)
   Else
	  ToolTip("���",0,0)
	  $Playtemp=0
	  If $volume==0 Then
		 $volume=$volumetemp
		 SoundSetWaveVolume($volume)
	  EndIf
	  _soundresume($play)
   EndIf
   Sleep(1000)
   ToolTip("")
EndFunc
HotKeySet("!.","_up")
Func _up()
   If $volume==100 Then
	  ToolTip("Volume: 100",0,0)
	  sleep(500)
	  ToolTip("")
   Else
	  $volume+=1
	  ToolTip("Volume: "&$volume,0,0)
	  SoundSetWaveVolume($volume)
	  sleep(500)
	  ToolTip("")
   EndIf
EndFunc
HotKeySet("!,","_down")
Func _down()
   If $volume==0 Then
	  ToolTip("Volume: 0",0,0)
	  sleep(500)
	  ToolTip("")
   Else
	  $volume-=1
	  ToolTip("Volume: "&$volume,0,0)
	  SoundSetWaveVolume($volume)
	  sleep(500)
	  ToolTip("")
   EndIf
EndFunc
HotKeySet("!/","_else")
Func _else()
   Global $temp, $pos=4
   _soundstop($play)
   _soundClose($Play)
   $temp=random(1,$max,1)
   If Not StringInStr($Playedlist,$temp) Then
	  ;MsgBox(0,FileReadLine("list.txt",$temp),$temp)
	  $play=_Soundopen(FileReadLine("list.txt",$temp))
	  _SoundPlay($play)
	  While 1
	  If Not StringInStr(StringTrimLeft(FileReadLine("list.txt",$temp),$pos),"\") Then
		 ExitLoop
	  EndIf
	  $pos+=1
	  WEnd
	  ToolTip("�뷡 ���: "&StringTrimLeft(StringTrimRight(FileReadLine("list.txt",$temp),4),$pos),0,0)
	  $Playedlist&=$temp&"/"
	  sleep(2000)
	  ToolTip("")
   Else
	  $Playedlist=""
	  $play=_Soundopen(FileReadLine("list.txt",$temp))
	  _SoundPlay($play)
	  ToolTip(FileGetLongName(FileReadLine("list.txt",$temp)),0,0)
	  $Playedlist&=$temp&"/"
	  sleep(2000)
	  ToolTip("")
   EndIf
EndFunc
HotKeySet("!m","_reset")
Func _reset()
   _soundstop($play)
   _soundClose($Play)
   FileDelete("list.txt")
   _search(StringLeft(@SystemDir,2))
   $j=1
   While 1
	  If FileReadLine("list.txt",$j)=="" Then
		 ExitLoop
	  EndIf
	  $j+=1
   WEnd
   $max=$j-1
   _else()
EndFunc
Func _search($dir)
   Local $search = FileFindFirstFile($dir&"\*.*")
   While 1
	   Local $file = FileFindNextFile($search)
	   If @error Then ExitLoop
	   _search($dir&"\"&$file)
	   $count+=1
	   If StringInStr($file,".mp3") Then
		  ToolTip($dir&"\"&$file&" �� ã�ҽ��ϴ�!",0,0)
		  FileWrite("list.txt",$dir&"\"&$file&@CRLF)
	   EndIf
   WEnd
   ToolTip("")
   FileClose($search)
EndFunc
;; Setting ;;
SplashTextOn("SHMusicSystem","���� ���α׷� ������...",-1,40)
If Not FileExists("list.txt") Then
   _search(StringLeft(@SystemDir,2))
   $j=1
   While 1
	  If FileReadLine("list.txt",$j)=="" Then
		 ExitLoop
	  EndIf
	  $j+=1
   WEnd
   $max=$j-1
Else
   $j=1
   While 1
	  If FileReadLine("list.txt",$j)=="" Then
		 ExitLoop
	  EndIf
	  $j+=1
   WEnd
   $max=$j-1
EndIf
SplashOff()
_else()
;; Main loop ;;
While 1
   sleep(_SoundLength($play, 2))
   sleep(15)
   _soundClose($Play)
   _else()
WEnd