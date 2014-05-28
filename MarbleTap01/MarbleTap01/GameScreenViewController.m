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
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;

@property (nonatomic) BOOL isFirstTap;
@property (nonatomic) int numberOfTap;

@end

@implementation GameScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isFirstTap = TRUE;
        self.collisionBehavior = [[UICollisionBehavior alloc] init];
        self.numberOfTap = 0;
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
    
    [self drawBall];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.orangeBall]];
    
}

- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    CGPoint point = [aTouch locationInView:self.view];
    
    if (self.isFirstTap) {
        [self addBallBehavior];
        [self.animator addBehavior:_gravityBehavior];
        [self addBoundaries];
        [self generateCoordinates];
        [self roofAndBottomLimits];
        [self checkCollision];
        self.isFirstTap = FALSE;
    }
    
    [self findSide:point];
}

- (BOOL)isColliding
{
    CGPoint tiki = self.myImageView.center;
    CGPoint ball = self.orangeBall.center;
    CGFloat distance = sqrt(pow((ball.x - tiki.x),2) + pow((ball.y - tiki.y),2));
    
    if(distance < (self.myImageView.bounds.size.width/2.0 + self.orangeBall.bounds.size.width/2.0)){
        NSLog(@"collide");
        return YES;
    }
    return NO;
}

- (void)roofAndBottomLimits
{
    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.orangeBall]];

    CGPoint a = CGPointMake(0, self.view.bounds.size.height);
    CGPoint b = CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height);
    [self.collisionBehavior addBoundaryWithIdentifier:@"bottom" fromPoint:a toPoint:b];
    [self.animator addBehavior:self.collisionBehavior];
    self.collisionBehavior.collisionDelegate = (id)self;
    
    a = CGPointMake(0 ,0);
    b = CGPointMake(self.view.bounds.size.height, 0);
    [self.collisionBehavior addBoundaryWithIdentifier:@"roof" fromPoint:a toPoint:b];
    [self.animator addBehavior:self.collisionBehavior];
    self.collisionBehavior.collisionDelegate = (id)self;
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id)item withBoundaryIdentifier:(id)identifier atPoint:(CGPoint)p{
    
    if ([identifier  isEqual: @"bottom"]) {
        NSLog(@"Touched bottom");
    }
    
    if ([identifier isEqual:@"roof"]) {
        NSLog(@"Touched roof");
    }
    
    if([identifier isEqual:@"to the left"] || [identifier isEqual:@"to the right"])
    {
        NSLog(@"Tiki");
    }
}

- (void)addBallBehavior
{
    UIDynamicItemBehavior *ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.orangeBall]];
    ballBehavior.elasticity = 0.40;
    [self.animator addBehavior:ballBehavior];
}

- (void)addBoundaries
{
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.orangeBall]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    [self.animator addBehavior:collisionBehavior];
}

- (void)findSide:(CGPoint)point
{
    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.orangeBall] mode:UIPushBehaviorModeInstantaneous];
    if (point.x > self.view.window.bounds.size.width/2) {
        [pushBehavior setAngle:-1.2217 magnitude:1.5]; //angle = 70 degrees
    } else{
        [pushBehavior setAngle:-1.9199 magnitude:1.5]; //angle = 110 degrees
    }
    [self.animator addBehavior:pushBehavior];
    [self displayScore];
}

- (void)displayScore
{
    _numberOfTap++;
    self.score.text = [NSString stringWithFormat:@"%i",_numberOfTap];
}

- (void)generateCoordinates
{
    __unused NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                               target:self
                                                             selector:@selector(generate)
                                                             userInfo:nil
                                                              repeats:YES];
}

- (void)checkCollision
{
    __unused NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                               target:self
                                                             selector:@selector(isColliding)
                                                             userInfo:nil
                                                              repeats:YES];
}

- (void)drawBall
{
    self.orangeBall = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    self.orangeBall.backgroundColor = [UIColor orangeColor];
    self.orangeBall.layer.cornerRadius = 25.0;
    self.orangeBall.layer.borderColor = [UIColor blackColor].CGColor;
    self.orangeBall.layer.borderWidth = 0.0;
    [self.view addSubview:self.orangeBall];
    self.orangeBall.center = CGPointMake(self.view.center.x,self.view.center.y);
}

- (void)generate
{
    
    float yCoordinate = 0;
    //for (int i = 0; i < 4; i++)//assuming 4 tiki only
   // {
        yCoordinate = (float)(arc4random()%(int)(self.view.window.bounds.size.height));
        if (yCoordinate < self.view.window.bounds.size.height/2){//i
            [self drawTiki:0 yCoordinate:yCoordinate + 40];
        }
        else{
            [self drawTiki:self.view.window.bounds.size.width-100 yCoordinate:yCoordinate - 40];
        }
    //NSLog(@"%hhd",[self isColliding]);
   // }
}

- (void)drawTiki:(float)xCoordinate  yCoordinate:(float)yCoordinate
{
    self.myImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tiki.png"]];
    [self.view addSubview:self.myImageView];
    
    if (xCoordinate == 0) {
        [self.myImageView setFrame:CGRectMake(-100, yCoordinate, 100, 20)];
        
        CGRect newFrame = self.myImageView.frame;
        newFrame.origin.x += 100;    // shift right by 100pts
        CGRect backFrame = self.myImageView.frame;
        backFrame.origin.x -= 100;  // shift left by 100pts
        
        [UIView animateWithDuration:1.0
                         animations:^{
                             self.myImageView.frame = newFrame;
                             
                         }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:1.0
                                              animations:^{
                                                  self.myImageView.frame = backFrame;
                                                  
                                              }
                                              completion:^(BOOL finished){  
                                                  [self.myImageView removeFromSuperview];
                                              }];
                         }];
        /*CGPoint a = CGPointMake(0, yCoordinate);
        CGPoint b = CGPointMake(xCoordinate+100, yCoordinate);
        [self.collisionBehavior addBoundaryWithIdentifier:@"to the left" fromPoint:a toPoint:b];
        [self.animator addBehavior:self.collisionBehavior];
        self.collisionBehavior.collisionDelegate = (id)self;
        self.behaviorIndex = [self.animator.behaviors count];*/
    }
    
    if(xCoordinate == self.view.window.bounds.size.width-100){
        [self.myImageView setFrame:CGRectMake(xCoordinate + 100, yCoordinate, 100, 20)];
        
        CGRect newFrame = self.myImageView.frame;
        newFrame.origin.x -= 100;    // shift left by 100pts
        CGRect backFrame = self.myImageView.frame;
        backFrame.origin.x += 100;  // shift left by 100pts
        
        [UIView animateWithDuration:1.0
                         animations:^{
                             self.myImageView.frame = newFrame;
                             
                         }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:1.0
                                              animations:^{
                                                  self.myImageView.frame = backFrame;
                                                  
                                              }
                                              completion:^(BOOL finished){
                                                  [self.myImageView removeFromSuperview];
                                              }];
                         }];
        /*CGPoint a = CGPointMake(xCoordinate, yCoordinate);
        CGPoint b = CGPointMake(self.view.bounds.size.width, yCoordinate);
        [self.collisionBehavior addBoundaryWithIdentifier:@"to the right" fromPoint:a toPoint:b];
        [self.animator addBehavior:self.collisionBehavior];
        self.collisionBehavior.collisionDelegate = (id)self;*/
    }

    [UIView commitAnimations];

}

@end