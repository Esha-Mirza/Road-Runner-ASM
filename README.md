# Road Runner ASM

An ASCII-art car racing game built entirely in x86 Assembly, using the Irvine32 library for console rendering, keyboard input, and randomization.

![Assembly](https://img.shields.io/badge/Assembly-x86%20(MASM)-informational)
![License](https://img.shields.io/badge/License-MIT-green)
![Type](https://img.shields.io/badge/Type-Console%20Game-lightgrey)

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Assembling & Running](#assembling--running)
- [Controls](#controls)
- [How the Game Works](#how-the-game-works)
- [Sample Gameplay](#sample-gameplay)
- [Project Structure](#project-structure)
- [Roadmap](#roadmap)
- [License](#license)
- [Contact](#contact)

---

## Overview

Road Runner ASM is a real-time, ASCII-rendered car dodging game written entirely in low-level x86 Assembly (MASM syntax). The player steers a car left and right along a road, avoiding falling obstacles, while the game tracks lives, score, and dynamically increases speed as the player's score grows.

The project is built around a single main game loop that handles input, updates game state, checks collisions, and redraws the screen every frame — all using direct console manipulation via the Irvine32 library.

---

## Features

- **Real-Time Gameplay** — A continuous game loop with non-blocking keyboard input
- **Obstacle Avoidance** — Randomly spawning obstacles fall down the road that the player must dodge
- **Lives System** — 3 lives displayed as hearts; lose a life on collision
- **Score Tracking** — Score increases for every obstacle successfully avoided
- **Dynamic Difficulty** — Game speed increases automatically at score thresholds (15 and 30)
- **Pause / Resume** — Pause the game at any time without losing progress
- **Game Over & Restart** — Clean game-over screen with the option to restart or quit
- **Pure Assembly** — No external game engine — rendering, input, and logic are all hand-written in x86 ASM

---

## Tech Stack

| Component | Details |
|---|---|
| **Language** | x86 Assembly (MASM syntax) |
| **Library** | Irvine32 (console I/O, random numbers, cursor positioning) |
| **Model** | Flat, stdcall (32-bit) |
| **Platform** | Windows (via MASM32 / Visual Studio with MASM support) |

---

## Prerequisites

- **Windows OS** (Irvine32 targets 32-bit Windows console applications)
- **MASM32 SDK** or **Visual Studio** with MASM (ml.exe) support
- **Irvine32 library** (`Irvine32.inc`, `Irvine32.lib`) — from Kip Irvine's *Assembly Language for x86 Processors*, available from the [Irvine32 library page](http://kipirvine.com/asm/)

---

## Assembling & Running

### Using MASM32

```bash
ml /c /coff main.asm
link /SUBSYSTEM:CONSOLE main.obj Irvine32.lib
main.exe
```

### Using Visual Studio (with MASM)

1. Create a new empty C++ project with MASM build customization enabled
2. Add `main.asm` to the project
3. Ensure `Irvine32.inc` and `Irvine32.lib` are in your include/library paths
4. Build and run (Ctrl+F5)

---

## Controls

| Key | Action |
|---|---|
| `A` / Left Arrow | Move car left |
| `D` / Right Arrow | Move car right |
| `P` | Pause / Resume |
| `Q` | Quit |
| `R` | Restart (after Game Over) |

---

## How the Game Works

```text
main (Game Loop)
    │
    ▼
HandleInput ──► Move car / Pause / Quit / Restart
    │
    ▼
UpdateObstacle ──► Spawn, move, or clear obstacle
    │
    ▼
CheckCollision ──► Detect car/obstacle overlap
    │
    ▼
DrawCar + DrawObstacle + DrawMessages
    │
    ▼
Delay (frame speed) ──► Loop back to HandleInput
```

- Obstacles spawn with a randomized chance and fall down the road one row per frame
- A collision at the car's row removes a life; running out of lives ends the game
- Successfully avoiding an obstacle increases the score by 1
- Frame delay decreases (game speeds up) once score passes 15, and again past 30

---

## Sample Gameplay

```text
              ASCII CAR RACING
Score: 12          Lives: ♥ ♥ ♥

+--------------------------------+
|                                 |
|              X                 |
|                                 |
|                                 |
|                                 |
|            [=]                 |
+--------------------------------+

A=Left D=Right P=Pause Q=Quit
```

**Game Over Screen:**

```text
        * GAME OVER! R=Restart Q=Quit *
        Press R to restart or Q to quit...
```

---

## Project Structure

```
Road-Runner-ASM/
├── main.asm      # Full game source (game loop, rendering, input, collision)
├── LICENSE
└── README.md
```

---

## Roadmap

- [ ] Add sound effects on collision and score milestones
- [ ] Add multiple obstacle types with different point values
- [ ] Add a persistent high-score file
- [ ] Add a start-menu screen with difficulty selection
- [ ] Port the concept to a cross-platform library (e.g. SDL2) for non-Windows support

---

## License

This project is open source and available under the [MIT License](LICENSE).

---

## Contact

- **GitHub:** [Esha-Mirza](https://github.com/Esha-Mirza)
- **Email:** esha101374@gmail.com
