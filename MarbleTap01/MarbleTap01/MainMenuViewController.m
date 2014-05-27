//
//  MainMenuViewController.m
//  MarbleTap01
//
//  Created by Christian Ramir Lazain on 5/26/14.
//  Copyright (c) 2014 klab. All rights reserved.
//

#import "MainMenuViewController.h"
#import "GameScreenViewController.h"
#import "HighScoreViewController.h"

@interface MainMenuViewController ()

- (IBAction)toGameScreen:(id)sender;
- (IBAction)toHighScoreScreen:(id)sender;

@end

@implementation MainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)toGameScreen:(id)sender
{
    GameScreenViewController *gameScreen = [[GameScreenViewController alloc] init];
    [self presentViewController:gameScreen animated:YES completion:nil];
}

- (IBAction)toHighScoreScreen:(id)sender
{
    HighScoreViewController *highScoreScreen = [[HighScoreViewController alloc] init];
    [self presentViewController:highScoreScreen animated:YES completion:nil];
}
@end

