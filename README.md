# It's Pizza Time

## Overview
**It's Pizza Time** is a 3D puzzle platformer game with action elements. Players control a Pizza Guy climbing the Empire State Building to deliver pizza to the top floor, while avoiding bad pizza ingredients and solving puzzles.

### Genre
Singleplayer, Puzzle, Platformer

### Platforms
WebGL ([itch.io](https://dughiboogie.itch.io/))  **TODO: Change to Organization's itch page**

### Playtime
~10 minutes. It's possible to extend the playtime with more puzzles/levels.

### Target
Platformer and Puzzle enthusiasts. No age restriction.

### Planned Release
End of February 2024

## Unique Selling Points
- **Vertical 3D world**
- **Mix of action, platform and puzzle solving elements**
- **Funny and light-hearted**
### *Team Selling Points*
- *FPS mechanics in a 3D environment*
- *Interacting with World Elements*
- *Puzzle and Level Design*

## Story
One day Pizza Guy gets a weird request for large amounts of pizza to be delivered to the top of the Empire State Building ASAP.<br>
Inside the building he finds a twisted, messed up platform world, full of ingredients that might ruin his delivery. Nasty pineapples are notoriously among those ingredients.<br>
To get to the top safely, Pizza Guy will have to throw Pizza Frisbees to defeat the evil ingredients and solve puzzles.<br>
At the top Pizza Guy will meet very disappointed clients because he will have no more pizza to give them, having used all of it as ammunition to get there.

## Mechanics
- **Climb up**: There are multiple means of climbing (e.g. jumping between platforms, ladders, etc.).
- **Combat**: Enemies will chase Pizza Guy around, sometimes throwing him things people don't want on their pizza. Pizza Guy can defeat them by attacking with Pizza Slaps (melee attack) or by throwing them Pizza Frisbee (ranged attack).
- **Puzzle Solving**: Pizza Guy interacts with the environment around him by hitting switches, using ropes, etc. This can be done either from a distance (throwing Pizza Frisbees) or directly near a reachable interactable element.

### *Future Mechanics Ideas*
- *Speed*: The time it takes for Pizza Guy to reach the top floor will determine the satisfaction of the clients.
- *Limited Ammunition*: Each use of Pizza Frisbees or Pizza Slaps will count as used ammunition. The amount of pizza that Pizza Guy will have when he reaches the top floor will determine the satisfaction of the clients.

## Controls
- **Keyboard and Mouse**: 
  - WASD: Move character
  - SHIFT (hold): Sprint
  - Left Mouse Button: Attack/Throw
  - E: Interact
  - R: Restart
  - ESC: Exit game

## Objectives
- Climb up to the top floor of the building.
- Create a viable path by solving puzzles.
- Avoid or defeat enemies attacks to save the pizza.

<!--
## Art References
- [Link to concept art folder]
- [Link to character designs]
- [Link to environment sketches]

## Known Issues and Bugs
- Issue: Character may become stuck in certain terrain types.
- Bug: Occasionally, sound effects may not play during combat sequences.
-->

## Team Workflow Setup
To properly set up the team workflow, follow these steps:

### Initial Setup

1. **Clone the Repository**: Clone the game repository to your local machine using the following command or by using a git versioning software:
```
git clone https://github.com/ThePressedGames/pizza-time.git
```

2. **Symlink the Commit Message Git Hook**: Symlink the commit-msg hook to the local repository's `.git/hooks` directory to enforce commit message conventions.<br>
You can do this by navigating to the repository's root directory, opening a terminal and running the following instruction:
```
ln -s $(pwd)/hooks/commit-msg .git/hooks/commit-msg
```

### New Features and Commits

1. **Creating Branches**: When working on new features or fixes, create a new branch from the `development` branch using a descriptive name that reflects the purpose of your changes. For example:
```
git checkout -b new-feature-name development
```

2. **Committing Changes**: Commit your changes with clear and descriptive messages following the established conventions.

3. **Pushing Changes**: Once your changes are ready, push your branch to the remote repository:
```
git push origin new-feature-name
```

4. **Creating Pull Requests**: When your feature is complete, create a pull request targeting the `development` branch. Ensure that your code passes all tests and adheres to the project's coding standards.

5. **Review Process**: Collaborate with team members by reviewing each other's pull requests, providing constructive feedback, and addressing any concerns before merging.

6. **Merging Changes**: After approval, merge your pull request into the `development` branch. Periodically, the `development` branch will be merged into the `main` branch for release. 
