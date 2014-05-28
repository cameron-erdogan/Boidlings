Boidlings: The Cameron Fork
=========

A mini-game demonstrating the use of applying simple physics to make your game dynamic and intriguing

WARNING: The included level editor (zipped) saves out sprite file references with the full path... So if you try and open level1.mbml it will just crash because it can't resolve the files. You need to manually fix this by editing the mbml file yourself (just once) and correcting the paths. Someday soon this will be fixed.


Added by Cameron:

I made the bullets into heat-seeking bullets. Basically, each bullet finds the closest enemy to itself, and, if the enemy is within a certain distance, applies a force on itself towards that enemy. This required adding a static array of enemies currently in the scene to the Bullet, Player, and Game classes (it's constructed in Game as an instance variable, then passed into the Player class as a static var, which again passes it to the Bullet class as a static var). 

All the things I added are prefaced with an "added by Cameron" comment, so you can just ctrl + F "Cameron" to quickly find all of the changes I made. The only edited classes are Player.h/m, Bullet.h/m, and Game.m. 
