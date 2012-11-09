//
//  settings.m
//  swwf
//
//  Created by Samar on 27/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "settings.h"

@interface settings ()

@end

@implementation settings

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
    soundButton = nil;
    vibrationButton = nil;
    alertButton = nil;
    soundImageView = nil;
    vibrationImageView = nil;
    alertImageView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)account:(id)sender
{
    [self performSegueWithIdentifier:@"account" sender:self];
}
- (IBAction)sounds:(id)sender
{
    if(sound)
    {
        soundImageView.image=[UIImage imageNamed:@"off.png"];
        sound=FALSE;
    }
    else
    {
        soundImageView.image=[UIImage imageNamed:@"on.png"];
        sound=TRUE;
    }
}
- (IBAction)vibration:(id)sender
{
   if(vibration)
   {
       vibrationImageView.image=[UIImage imageNamed:@"off.png"];
       vibration=FALSE;
   }
   else
   {
       vibrationImageView.image=[UIImage imageNamed:@"on.png"];
       vibration=TRUE;
   }
}
- (IBAction)alerts:(id)sender
{
    if(alert)
    {
        alertImageView.image=[UIImage imageNamed:@"off.png"];
        alert=FALSE;
    }
    else
    {
        alertImageView.image=[UIImage imageNamed:@"on.png"];
        alert=TRUE;
    }
}


- (IBAction)backButton:(id)sender 
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
