# Dual-Universe Raw N Refined Screens
### Display both your ores and refined items on 2 screens, simple setup.


## INSTRUCTIONS

### Part 1
1) Simply get a programming board, plug it into the main core of the construct and 2 Screens.
2) Download / Copy [Raw-Ore-Screen.json](https://raw.githubusercontent.com/TwinFuture/Dual-Universe--Raw-Ore-Screen/main/Raw-Ore-Screen.json)
3) Right click the programming board and select Advanced -> Paste Lua Configuration From Clipboard

### Part 2
1) Name all your containers by right clicking each one with the name of each Ore.
> Ensure all containers you want to display on screen have the exact same name as the ores and only contain one item each.
EG: Container name; Bauxite, Malachite, Gold Nuggets, Thoramine, etc... -- Please use Uppercase letters properly!!
2) Right click the Programming Board and Edit Lua Parameters.
  > ***Refresh*** = How many seconds between updates.
  
  > containerProficiency is based off your skills by pressing F2 and navigating to the following below.
  
  > ***containerProficiency*** = Mining and Inventory -> Inventory Manager, Container Proficiency. the percent you have boosted eg; 30 for 3 levels/bars.
  
  > ***hubVol*** = amount of containers connected to the hub x base volume, for large = 124000 x 10, if you have 10 containers linked.
x8 if you have a maximum of 8 containers linked to your hubs, currently not configured to work with a hub and different size containers. So if you use hubs, you have to use them all on the same size container. Then the maximum amount of containers connected to the hubs, you x that by the base volume of the container. Hope that makes sense!

***The most important is just the container proficiency, you can leave the others default.***
!!!!! The above parameters need to filled in correctly for the amounts to be accurate.

### Final Step
1) Activate the Programming board and wait the amount of refresh before the screen will update with your ores.
