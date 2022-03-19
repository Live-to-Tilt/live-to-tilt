# Live to Tilt

# Developer Guide
## Powerups
To add a new Powerup to the game,
1. Create a new class encapsulating the effect of the powerup. This class should conform to `PowerupEffect` protocol. 
The `update()` method in this class should define what the effect should do at every timestep when it is active. 
For an example, see `NukeEffect`. 
2. Modify `Nexus+Extensions#createPowerup()` to append the effect to the array of possible effects a powerup can have.
