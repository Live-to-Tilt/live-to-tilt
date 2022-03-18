# Live to Tilt

# Developer Guide
## Powerups
To add a new Powerup to the game,
1. Add a case to the `PowerupType` enum.
2. Create a new component encapsulating the special properties and behaviour of the powerup. 
For an example, see `NukePowerupComponent`.
3. Modify `PowerupSystem#updateActivePowerups()` to call a new private function that defines what the powerup should 
do at every timestep if it is active. For an example, see `PowerupSystem#updateNukeComponent()`. 
The `PowerupSystem` manages all powerups by orchestrating amongst `PowerupComponent`, special powerup components 
such as `NukePowerupComponent`, and other components that may interact with the powerup components.
