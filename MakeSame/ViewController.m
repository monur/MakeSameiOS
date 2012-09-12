/*
 * ViewController.m
 * MakeSame
 *
 * Created by Onur Avun.
 * Copyright 2012, Onur Avun.
 *
 *
 * MakeSame is free software; you can redistribute it and/or
 * modify it under the terms of the GNU  General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * MakeSame is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU  General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

#import "ViewController.h"
#import "Box.h"
@implementation ViewController
@synthesize stepLabel;
@synthesize bestScoreLabel;
@synthesize map;

- (void)viewDidLoad
{
    rowCount = 20;
    columnCount = 20;
    bestScore = 200;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        boxWidth = 30;
        boxHeight = 30;
        leftPadding = 80;
        topPadding = 100;
    }else{
        boxWidth = 15;
        boxHeight = 15;
        leftPadding = 10;
        topPadding = 50;
    }
    [super viewDidLoad];
    [self newGame];
}

-(void)newGame{
    NSNumber *bs = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"best"];
    if(bs){
        bestScore = [bs intValue];
    }
    [bestScoreLabel setText:[NSString stringWithFormat:@"%d", bestScore]];
    step = 0;
    [stepLabel setText:[NSString stringWithFormat:@"%d", step]];
    isGameOn = YES;
    if(self.map){
        for(int i = 0; i < rowCount * columnCount; i++){
            [(Box*)[map objectAtIndex:0] removeFromSuperview];
        }
    }
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:rowCount * columnCount];
    for(int i = 0; i < rowCount; i++){
        for(int j = 0; j < columnCount; j++){
            Box *box = [[Box alloc] initWithFrame:CGRectMake(i*boxWidth + leftPadding, j*boxHeight + topPadding, boxWidth, boxHeight)];
            [self.view addSubview:box];
            [arr addObject:box];
            [box release];
        }
    }
    [self setMap:arr];
    [arr release];
    
    [(Box*)[map objectAtIndex:0] setIsActive:YES]; 
    [self checkNeighbours:[(Box*)[map objectAtIndex:0] color] x:0 y:0];
}


-(void)checkNeighbours:(int)color x:(int)x y:(int)y{
    //NSLog(@"checking %d-%d , %d", x,y, color);
    if(x > 0){
        Box *box = (Box*)[map objectAtIndex:(x-1)*columnCount+y];
        //NSLog(@"x-1 color = %d", box.color);
        if(box.color == color){
            if(!box.isActive){
                box.isActive = YES;
                [box setNeedsDisplay];
                //NSLog(@"x-1 active");
                [self checkNeighbours:color x:x-1 y:y];
            }
        }
    }
    if(x < columnCount-1){
        Box *box = (Box*)[map objectAtIndex:(x+1)*columnCount+y];
        //NSLog(@"x+1 color = %d", box.color);
        if(box.color == color){
            if(!box.isActive){
                box.isActive = YES;
                [box setNeedsDisplay];
                //NSLog(@"x+1 active");
                [self checkNeighbours:color x:x+1 y:y];
            }
        }
    }
    if(y > 0){
        Box *box = (Box*)[map objectAtIndex:x*columnCount+(y-1)];
        //NSLog(@"y-1 color = %d", box.color);
        if(box.color == color){
            if(!box.isActive){
                box.isActive = YES;
                [box setNeedsDisplay];
                //NSLog(@"y-1 active");
                [self checkNeighbours:color x:x y:y-1];
            }
        }
    }
    if(y < rowCount-1){
        Box *box = (Box*)[map objectAtIndex:x*columnCount+(y+1)];
        //NSLog(@"y+1 color = %d", box.color);
        if(box.color == color){
            if(!box.isActive){
                box.isActive = YES;
                [box setNeedsDisplay];
                //NSLog(@"y+1 active");
                [self checkNeighbours:color x:x y:y+1];
            }
        }
    }
}

- (IBAction)colorTouched:(UIButton *)sender {
    if(isGameOn){
        int activeCount = 0;
        for(int i = 0; i < rowCount; i++){
            for(int j = 0; j < columnCount; j++){
                Box *box = (Box*)[map objectAtIndex:i*columnCount+j];
                if(box.isActive){
                    [self checkNeighbours:sender.tag x:i y:j];
                }
            }
        }
        for(int i = 0; i < rowCount; i++){
            for(int j = 0; j < columnCount; j++){
                Box *box = (Box*)[map objectAtIndex:i*columnCount+j];
                if(box.isActive){
                    box.color = sender.tag;
                    [box setNeedsDisplay];
                    activeCount++;
                }
            }
        }
        step++;
        [stepLabel setText:[NSString stringWithFormat:@"%d", step]];
        if(activeCount == rowCount*columnCount){
            if(step < bestScore){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BEST!!!" message:[NSString stringWithFormat:@"You finished the game in %d steps. This is a new personal record", step] delegate:self cancelButtonTitle:@"Again..." otherButtonTitles:nil];
                [alert show];
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:[NSNumber numberWithInt:step] forKey:@"best"];
                [ud synchronize];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:[NSString stringWithFormat:@"You finished the game in %d steps", step] delegate:self cancelButtonTitle:@"Again..." otherButtonTitles:nil];
                [alert show];
            }
        }
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self newGame];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (void)dealloc {
    [stepLabel release];
    [bestScoreLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setStepLabel:nil];
    [self setBestScoreLabel:nil];
    [super viewDidUnload];
}
- (IBAction)newGameTouched:(id)sender {
    [self newGame];
}
@end
