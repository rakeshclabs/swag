//
//  gameMode.m
//  swwf
//
//  Created by Samar on 27/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "gameMode.h"

@interface gameMode ()

@end

@implementation gameMode

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
    [self performSegueWithIdentifier:@"opponent" sender:self];
    
}
- (IBAction)mixedMode:(id)sender 
{
    [self performSegueWithIdentifier:@"opponent" sender:self];   
}
- (IBAction)backButton:(id)sender 
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)settings:(id)sender 
{
    [self performSegueWithIdentifier:@"settings" sender:self];
}

@end
