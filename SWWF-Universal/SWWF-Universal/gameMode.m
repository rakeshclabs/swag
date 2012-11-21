//
//  gameMode.m
//  swwf
//
//  Created by Samar on 27/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "gameMode.h"
#import "selectOpponent.h"
#import "SVProgressHUD.h"

@interface gameMode ()

@end

@implementation gameMode
@synthesize gameMode;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self HideActivityIndicator];
    selectOpponent *so=[segue destinationViewController];
    so.gameMode=self.gameMode;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)swagMode:(id)sender 
{
    [self ShowActivityIndicatorWithTitle:@"Loading..."];
    self.gameMode=@"swag";
    [[NSUserDefaults standardUserDefaults]setValue:self.gameMode forKey:@"gameMode"];
    [self performSegueWithIdentifier:@"opponent" sender:self];
    
}
- (IBAction)mixedMode:(id)sender 
{
    [self ShowActivityIndicatorWithTitle:@"Loading..."];
    self.gameMode=@"mixed";
    [[NSUserDefaults standardUserDefaults]setValue:self.gameMode forKey:@"gameMode"];

    [self performSegueWithIdentifier:@"opponent" sender:self];
}
- (IBAction)backButton:(id)sender 
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)settings:(id)sender 
{
    [self ShowActivityIndicatorWithTitle:@"Loading..."];
    [self performSegueWithIdentifier:@"settings" sender:self];
}

/*---------------- Activity Indicator -------------------------------------*/
-(void)ShowActivityIndicatorWithTitle:(NSString *)Title{
    
    [SVProgressHUD showWithStatus:Title maskType:SVProgressHUDMaskTypeGradient];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    
}

-(void)HideActivityIndicator{
    [SVProgressHUD dismiss];
}

@end
