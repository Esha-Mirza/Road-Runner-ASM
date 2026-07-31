.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
INCLUDE Irvine32.inc

.data
    ; Game state
    gameActive BYTE 1
    gamePaused BYTE 0
    
    ; Player
    carX BYTE 15
    carSymbol BYTE "[=]"
    lives BYTE 3
    score DWORD 0
    
    ; Obstacle
    obstacleX BYTE 10
    obstacleY BYTE 5
    obstacleActive BYTE 0
    obstacleSymbol BYTE "X"
    
    ; Messages
    titleMsg BYTE "ASCII CAR RACING", 0
    scoreMsg BYTE "Score: ", 0
    livesMsg BYTE "Lives: ", 0
    controlsMsg BYTE "A=Left  D=Right  P=Pause  Q=Quit", 0
    pauseMsg BYTE "* PAUSED *", 0
    gameOverMsg BYTE "* GAME OVER! R=Restart Q=Quit *", 0
    pressAnyKeyMsg BYTE "Press R to restart or Q to quit...", 0
    
    ; Road
    topBorder BYTE "+--------------------------------+", 0
    sideBorder BYTE "|                                |", 0
    bottomBorder BYTE "+--------------------------------+", 0
    
    ; Speed
    frameDelay DWORD 100
    
    ; New variable to track if we need to update display
    needsUpdate BYTE 1
    
    ; Variable to track game over state separately
    gameOverDisplayed BYTE 0

.code
; ---------------------------------------------------------
; MAIN GAME LOOP
; ---------------------------------------------------------
main PROC
    call Randomize
    call DrawScreen
    
GameLoop:
    ; Handle input
    call HandleInput
    
    ; Skip updates if paused
    cmp gamePaused, 1
    je DrawFrame
    
    ; Skip updates if game over
    cmp gameActive, 0
    je GameOverScreen
    
    ; Update game logic
    call UpdateObstacle
    call CheckCollision
    
    ; Update display if needed
    cmp needsUpdate, 1
    jne DrawFrame
    
    call UpdateDisplay
    mov needsUpdate, 0

DrawFrame:
    ; Draw everything
    call DrawCar
    call DrawObstacle
    call DrawMessages
    
    ; Control speed
    mov eax, frameDelay
    call Delay
    
    ; Check if should exit
    cmp gameActive, 0
    je GameOverScreen
    
    jmp GameLoop

GameOverScreen:
    ; Only draw game over screen once
    cmp gameOverDisplayed, 1
    je WaitForInput
    
    ; Clear previous messages
    mov dh, 10
    mov dl, 8
    call Gotoxy
    mov ecx, 30s

ClearGameOverArea:
    mov al, ' '
    call WriteChar
    loop ClearGameOverArea
    
    ; Show game over message
    mov dh, 10
    mov dl, 8
    call Gotoxy
    mov edx, OFFSET gameOverMsg
    call WriteString
    
    ; Show instruction to press specific key
    mov dh, 12
    mov dl, 8
    call Gotoxy
    mov edx, OFFSET pressAnyKeyMsg
    call WriteString
    
    mov gameOverDisplayed, 1
    
WaitForInput:
    ; Wait specifically for R or Q
    call ReadChar
    
    cmp al, 'r'
    je RestartFromOver
    cmp al, 'R'
    je RestartFromOver
    cmp al, 'q'
    je QuitFromOver
    cmp al, 'Q'
    je QuitFromOver
    
    ; If any other key, ignore and keep waiting
    jmp WaitForInput

RestartFromOver:
    call ResetGame
    mov gameOverDisplayed, 0
    jmp GameLoop
    
QuitFromOver:
    invoke ExitProcess, 0
    
    ; Should never reach here
    invoke ExitProcess, 0
main ENDP


; ---------------------------------------------------------
; Draw static screen elements
; ---------------------------------------------------------
DrawScreen PROC
    call Clrscr
    
    ; Title
    mov dh, 1
    mov dl, 10
    call Gotoxy
    mov edx, OFFSET titleMsg
    call WriteString
    
    ; Score
    mov dh, 3
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET scoreMsg
    call WriteString
    mov eax, score
    call WriteDec
    
    ; Lives
    mov dh, 3
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET livesMsg
    call WriteString
    call DrawLivesHearts
    
    ; Road top
    mov dh, 5
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET topBorder
    call WriteString
    
    ; Road sides
    mov ecx, 10
    mov dh, 6
DrawSides:
    push ecx
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET sideBorder
    call WriteString
    inc dh
    pop ecx
    loop DrawSides
    
    ; Road bottom
    mov dh, 16
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET bottomBorder
    call WriteString
    
    ; Controls
    mov dh, 18
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET controlsMsg
    call WriteString
    
    ret
DrawScreen ENDP

; ---------------------------------------------------------
; Draw lives as hearts
; ---------------------------------------------------------
DrawLivesHearts PROC
    ; Clear the hearts area first (6 characters: 3 hearts + spaces)
    push edx
    mov dh, 3
    mov dl, 32
    call Gotoxy
    
    mov ecx, 6
ClearHearts:
    mov al, ' '
    call WriteChar
    loop ClearHearts
    
    ; Now draw hearts based on current lives
    mov dh, 3
    mov dl, 32
    call Gotoxy
    
    movzx ecx, lives
    cmp ecx, 0
    je NoLives
    
DrawHeartsLoop:
    mov al, 3      ; Heart symbol ASCII
    call WriteChar
    mov al, ' '
    call WriteChar
    loop DrawHeartsLoop
    
NoLives:
    pop edx
    ret
DrawLivesHearts ENDP

; ---------------------------------------------------------
; Draw the car
; ---------------------------------------------------------
DrawCar PROC
    mov dh, 15      ; Car row
    movzx eax, carX
    add al, 7       ; Road offset
    mov dl, al
    call Gotoxy
    
    mov ecx, 3
    mov esi, OFFSET carSymbol
DrawCarLoop:
    mov al, [esi]
    call WriteChar
    inc esi
    loop DrawCarLoop
    
    ret
DrawCar ENDP