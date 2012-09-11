//
//  Box.m
//  MakeSame
//
//  Created by Onur Avun on 11.09.2012.
//  Copyright (c) 2012 Cellenity. All rights reserved.
//

#import "Box.h"

@implementation Box
@synthesize color, isActive;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        isActive = false;
        color = (arc4random() % 6);
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if(color == 0){
        [[UIColor redColor] set];
    }else if(color == 1){
        [[UIColor greenColor] set];
    }else if(color == 2){
        [[UIColor blueColor] set];
    }else if(color == 3){
        [[UIColor yellowColor] set];
    }else if(color == 4){
        [[UIColor colorWithRed:1 green:0 blue:1 alpha:1] set];
    }else if(color == 5){
        [[UIColor colorWithRed:0 green:1 blue:1 alpha:1] set];
    }
    UIRectFill(rect);
    
    if(isActive){
        [[UIColor blackColor] set];
        UIRectFill(CGRectMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height/2, rect.size.width/10, rect.size.height/10));
    }
    
    
}


@end
