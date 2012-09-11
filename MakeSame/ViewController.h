//
//  ViewController.h
//  MakeSame
//
//  Created by Onur Avun on 11.09.2012.
//  Copyright (c) 2012 Cellenity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIAlertViewDelegate>{
    int rowCount;
    int columnCount;
    int boxWidth;
    int boxHeight;
    int step;
    BOOL isGameOn;
    int leftPadding;
    int topPadding;
    int bestScore;
}

@property (nonatomic, retain) NSArray *map;

-(void)newGame;
-(void)checkNeighbours:(int)color x:(int)x y:(int)y;
- (IBAction)colorTouched:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UILabel *stepLabel;
@property (retain, nonatomic) IBOutlet UILabel *bestScoreLabel;
- (IBAction)newGameTouched:(id)sender;

@end
