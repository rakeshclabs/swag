//
//  selectOpponent.m
//  swwf
//
//  Created by Samar on 27/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "selectOpponent.h"
#import "subOpponent.h"

@interface selectOpponent ()

@end

@implementation selectOpponent


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"faceOppScreen"])
    {
        subOpponent *so=[segue destinationViewController];
        so.image=image;
    }
}
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
    bg = nil;
    facebookButton = nil;
    usernameButton = nil;
    randomButton = nil;
    passButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)backButton:(id)sender 
{
    [self.navigationController popViewControllerAnimated:YES];
}

    

- (IBAction)passAndPlay:(id)sender {
}
- (IBAction)settings:(id)sender 
{
    [self performSegueWithIdentifier:@"settings" sender:self];
}

- (IBAction)facebookButton:(id)sender
{
    image=@"facebookBox.png";
    [self performSegueWithIdentifier:@"faceOppScreen" sender:self];
}

- (IBAction)user:(id)sender
{
   
    image=@"usernameBox.png";
    [self performSegueWithIdentifier:@"faceOppScreen" sender:self];
    
}

- (IBAction)random:(id)sender
{
    [self performSegueWithIdentifier:@"game" sender:self];
}
@end
