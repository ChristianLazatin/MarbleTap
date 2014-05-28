//
//  GameScreenViewController.m
//  MarbleTap01
//
//  Created by Christian Ramir Lazain on 5/26/14.
//  Copyright (c) 2014 klab. All rights reserved.
//

#import "GameScreenViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GameScreenViewController ()
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;

@property (nonatomic, strong) UIView *orangeBall;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong) UIPushBehavior *pushBehavior;

@property (nonatomic) BOOL isFirstTap;
@property (nonatomic) int numberOfTap;

@end

@implementation GameScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isFirstTap = TRUE;
        // _randomYCoordinates = [[NSMutableArray alloc] init];
        _numberOfTap = 0;
        self.score.text = [NSString stringWithFormat:@"%i",_numberOfTap];
        
        // Changes to issue04
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.pauseButton.hidden = YES;
    self.pauseButton.enabled = NO;

}



@end
