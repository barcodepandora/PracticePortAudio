//
//  ViewController.m
//  PracticePortAudio
//
//  Created by Juan Manuel Moreno on 21/08/24.
//

#import "ViewController.h"
#import "PortAudioPlayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [playButton setTitle:@"Allez >" forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(played) forControlEvents:UIControlEventTouchUpInside];
    
    // Set the button's frame to center it on the screen
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGFloat buttonWidth = 200;
    CGFloat buttonHeight = 44;
    CGFloat x = (screenWidth - buttonWidth) / 2;
    CGFloat y = (screenHeight - buttonHeight) / 2;
    playButton.frame = CGRectMake(x, y, buttonWidth, buttonHeight);

    [self.view addSubview:playButton];
}

- (void)played {
    NSLog(@"PLayed");
    PortAudioPlayer *player = [[PortAudioPlayer alloc] init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Disclaimer01" ofType:@"wav"];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Space Goofs" ofType:@"mp3"];
    [player play:filePath];
    
    // Keep the main run loop alive to hear the audio
    [[NSRunLoop currentRunLoop] run];
}


@end
