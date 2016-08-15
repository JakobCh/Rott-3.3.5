
#SingleInstance Force

;SetKeyDelay, 50

;IfWinExist, World of Warcraft
;{
;	WinGet, wowid, List, World of Warcraft
;}


while 1
{
	IfWinActive, World of Warcraft
	{
		PixelGetColor, box1color, 8, 8, RGB
		PixelGetColor, box2color, 30, 8, RGB
		PixelGetColor, box3color, 50, 8, RGB
		
		;MsgBox %box1color%, %box2color%
		
		
		If (box1color = 0xFFFFFF)
		{
			GetKeyState, state, Ctrl
			If (state = D)
			{
				SendInput {Ctrl up}
			}
			
			SendInput {Ctrl down}
			;Sleep 200
			
			If (box2color = 0xFFFFFF){
				If (box3color = 0xFFFFFF) {
					SendInput 1
				} else If (box3color = 0xFFFF00) {
					SendInput 2
				} else If (box3color = 0xFF00FF) {
					SendInput 3
				} else if (box3color = 0x00FFFF) {
					SendInput 4
				} else if (box3color = 0xFF0000) {
					SendInput 5
				} else if (box3color = 0x0000FF) {
					SendInput 6
				} 
			} else if (box2color = 0xFFFF00) {
				if (box3color = 0xFFFFFF) {
					SendInput 7
				} else if (box3color = 0xFFFF00) {
					SendInput 8
				}else if (box3color = 0xFF00FF) {
					SendInput 9
				}else if (box3color = 0x00FFFF) {
					SendInput 0
				}else if (box3color = 0xFF0000) {
					SendInput a
				}else if (box3color = 0x0000FF) {
					SendInput b
				}
			} else if (box2color = 0xFF00FF) {
				if (box3color = 0xFFFFFF) {
					SendInput c
				} else if (box3color = 0xFFFF00) {
					SendInput d
				} else if (box3color = 0xFF00FF) {
					SendInput e
				} else if (box3color = 0x00FFFF) {
					SendInput f
				} else if (box3color = 0xFF0000) {
					SendInput g
				} else if (box3color = 0x0000FF) {
					SendInput h
				}
			
			}
			
			;Sleep 200
			SendInput {Ctrl up}
			Sleep 250
			
			
			If (box5color = 0xFFFFFF){
				SendInput {w down}
			}else if (box5color = 0xFFFF00){
				SendInput {s down}
			}else if (box5color = 0xFF00FF){
				SendInput {d down}
			}else if (box5color = 0x00FFFF){
				SendInput {a down}
			}
			
		}
		
		
		GetKeyState, state, w
		If (state = D)
		{
			SendInput {w up}
		}
		GetKeyState, state, s
		If (state = D)
		{
			SendInput {s up}
		}
		GetKeyState, state, d
		If (state = D)
		{
			SendInput {d up}
		}
		GetKeyState, state, a
		If (state = D)
		{
			SendInput {a up}
		}
	
	}

}



