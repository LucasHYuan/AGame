# My Godot Project

A 2D game developed using Godot Engine. The project includes a player character that can move in all directions, a virtual joystick for touch screen input, and a camera that follows the player.

## Table of Contents

- [Introduction](#introduction)
- [Installation](#installation)
- [Usage](#usage)
- [Code Explanation](#code-explanation)
- [Contributing](#contributing)
- [License](#license)

## Introduction

This project is a simple 2D game created using Godot Engine. The game features:
- A player character that can move up, down, left, and right.
- A virtual joystick for touch screen devices.
- A camera that follows the player and limits its movement within the boundaries of the map.

## Installation

To run this project locally, follow these steps:

1. **Clone the repository:**
    ```sh
    git clone https://github.com/your-username/your-repository.git
    ```

2. **Open the project in Godot Engine:**
    - Open Godot Engine.
    - Click on the `Import` button.
    - Navigate to the cloned repository folder and select the `project.godot` file.

## Usage

### Running the Game

1. Open the project in Godot Engine.
2. Press the `Play` button or F5 to run the game.

### Controls

- Use the virtual joystick to move the player character in all directions.

## Code Explanation

### Camera Setup

The camera is set up to follow the player and limit its movement within the boundaries of the tile map. This is achieved by calculating the used rectangle of the tile map and setting the camera limits accordingly.

### Player Movement

The player character can move up, down, left, and right using the virtual joystick. The movement speed is defined by `RUN_SPEED`. Depending on the input from the joystick, the player character's velocity is adjusted accordingly. The animation changes based on whether the player is moving or idle.

### Virtual Joystick

The virtual joystick script handles touch input to move the player character. It detects touch events and adjusts the player's movement direction and speed based on the joystick's position. When the joystick is released, the player stops moving.

## Contributing

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes.
4. Commit your changes (`git commit -am 'Add new feature'`).
5. Push to the branch (`git push origin feature-branch`).
6. Create a new Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
