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

- https://media.discordapp.net/attachments/1075528709072760852/1199352707513864354/image.png?ex=65c23b40&is=65afc640&hm=ac4522b914bfbbd943cb2711a6fcb34cec54592a33b1336ed6fbfacb67d1db99&=&format=webp&quality=lossless&width=811&height=671

- https://media.discordapp.net/attachments/1075528709072760852/1199352707513864354/image.png?ex=65c23b40&is=65afc640&hm=ac4522b914bfbbd943cb2711a6fcb34cec54592a33b1336ed6fbfacb67d1db99&=&format=webp&quality=lossless&width=811&height=671

- https://media.discordapp.net/attachments/1075528709072760852/1199352708096860190/image.png?ex=65c23b40&is=65afc640&hm=1875e018b1cba646040d9e64597003d32d4451de4f6a0e5c8c77e560d17194d6&=&format=webp&quality=lossless&width=1297&height=671