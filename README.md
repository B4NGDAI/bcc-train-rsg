# bcc-train
> This is the best, fully fledged train script for RedM! A multitude of features like built in track switching, train inventories, ownership and more!

# Features
- Track Switching
- Multiple train stations
- Job locked
- Purchasable trains which are stored in a database
- Each train has thier own inventory
- Config option to allow cruise control
- Configurable train speeds
- Trains need fuel to run
- Maintain the train to keep it functional
- Station blips
- Webhooks
- Bacchus Bridge explodable
- Exports for developers to use

# Modified 

- use ox_lib callback
- delivery option will be available when the train spawned
- remove ui using ox_lib showtextui for train fuel and condition

# How to use
- To refuel/repair train hold right click while near the driver seat follow prompt
- Buy a train from a station spawn it and have fun!

## Api
### Check if train spawned! (Server Side Use only)
- To check if a train has been spawned/is in-use (This is useful as only 1 train should be spawned at a time on a server typically)
```Lua
local retval = exports['bcc-train']:CheckIfTrainIsSpawned()
```
- Returns true if a train has been spawned false if no train is spawned/in-use

### Get Train Entity (Server Side Use Only)
- To get the train entity (returned entity is meant to be used on the client side, this export should only be used if the check if train spawned export returns true if the train does not exist this export will always return false)
```Lua
local retval = exports['bcc-train']:GetTrainEntity()
```
- If a  train exists this returns the train entity to be used on the client side, returns false if no train is spawned/in-use

### Check if Bacchus Bridge Destroyed (Server Side Use Only)
- To check if Bacchus Bridge is destroyed or not
```Lua
local retval = exports['bcc-train']:BacchusBridgeDestroyed()
```
- Returns true if the bridge is destroyed false if not

# Side Notes
- All imagery was provided by Lady Grey our in house designer
- Thanks sav for the nui
- Images for items can be found under the imgs/itemImages folder

# Preview 

- ![image](https://github.com/B4NGDAI/bcc-train-rsg/assets/89564598/218e61d3-6094-4a0a-84b3-fdd409598f84)


- ![image](https://github.com/B4NGDAI/bcc-train-rsg/assets/89564598/74559023-f06b-46a7-ac36-51b46fd98d5c)


- ![image](https://github.com/B4NGDAI/bcc-train-rsg/assets/89564598/c0fb9999-273d-4857-b01d-16ef2ab4aa07)

