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
    