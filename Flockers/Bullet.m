//
//  Bullet.m
//  Flockers
//
//  Created by Rob Blackwood on 9/27/13.
//  Copyright (c) 2013 Tinybop. All rights reserved.
//

#import "Bullet.h"
#import "contants.h"
#import "Enemy.h"

@interface Bullet()
{
}
@end

@implementation Bullet

//Cameron added this
//I may regret making this static later but it seems more efficient this way
static NSMutableArray* _enemies;

+(id) bulletWithSpaceManager:(SpaceManager*)spaceManager
{
    return [[[self alloc] initWithSpaceManager:spaceManager] autorelease];
}

-(id) initWithSpaceManager:(SpaceManager*)spaceManager
{

    
    if ((self = [super initWithFile:@"bullet.png"]))
    {
        // Setup physics piece
        self.shape = [spaceManager addCircleAt:cpvzero mass:5 radius:3];
        self.spaceManager = spaceManager;
        
        // Set our collision type
        self.shape->collision_type = kBulletCollisionType;
        
        // Automatically cleanup physics when this sprite goes away
        self.autoFreeShapeAndBody = YES;
        
        // Velocity function
        self.body->velocity_func = gravityVelocityFunc;
        
        // Limit the speed
        cpBodySetVelLimit(self.body, 700);
        
        //Cameron wrote this
        // Start our update loop
        [self scheduleUpdate];
        
     
        // Run an action that will explode and kill this sprite off
        
        //Cameron edited this bit
        //basically the homing is on during the first delay
        //and off during the second delay.
        //I experienced an assertion error if you attempt to unschedule immediately before
        //you explode/kill, so the second delay is necessary for now. I think it has something to
        //do with removing the bullet but the scheduler thinking the bullet still exists
        id first_delay = [CCDelayTime actionWithDuration:2.5];
        id second_delay = [CCDelayTime actionWithDuration:1.5];
        id unschedule = [CCCallFunc actionWithTarget:self selector:@selector(unscheduleUpdate)];
        id explode = [CCCallFunc actionWithTarget:self selector:@selector(explosion)];
        id kill = [CCCallFunc actionWithTarget:self selector:@selector(removeFromParent)];
        
        [self runAction:[CCSequence actions: first_delay, unschedule, second_delay, explode, kill, nil]];
    }
    
    return self;
}

-(void) explosion
{
    [self.spaceManager applyLinearExplosionAt:self.position radius:100 maxForce:1100];
}

//Cameron added this
+(void) setEnemies:(NSMutableArray*)enemies
{
    if(!_enemies)
    {
        _enemies = enemies;
    }
}

-(void) update:(ccTime)dt
{
    [self applyHeatSeekingForce];
}

//adds a slight heatseeking force that pushes bullets towards the closest
//enemy within a specified range
-(void) applyHeatSeekingForce
{

    //Cameron added this
    
    if(_enemies)
    {
        //goes through all of the enemies and finds the one that is closest
        //to this bullet. if it's close enough, it applies a small implulse
        //that pushes the bullet towards the enemy
        Enemy * closest;
        float smallest_disance_sq = INFINITY;
        for(Enemy * e in _enemies)
        {
            CGPoint e_pt = e.position;
            CGPoint this_pt = self.position;
            float this_distance = cpvdistsq(e_pt, this_pt);
            
            if(this_distance < smallest_disance_sq)
            {
                smallest_disance_sq = this_distance;
                closest = e;
            }
        }
        
        CGPoint dir = ccpNormalize(ccpSub(closest.position, self.position));
        
        if(smallest_disance_sq < 8000)
        {
            cpBodyApplyImpulse(self.body, ccpMult(dir, 200), cpvzero);
        }

        //         NSLog(@"closest point is %@", NSStringFromCGPoint(closest.position));
    }
}


@end
