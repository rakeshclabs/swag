//
//  subOpponent.m
//  SWWF-Universal
//
//  Created by Samar on 09/11/12.
//
//

#import "subOpponent.h"

@interface subOpponent ()

@end

@implementation subOpponent
@synthesize image,imageBox;


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
    imageBox.image=[UIImage imageNamed:self.image];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    imageBox = nil;
    [self setImageBox:nil];
    [super viewDidUnload];
}
- (IBAction)startButton:(id)sender {
}

- (IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)settingButton:(id)sender
{
    [self performSegueWithIdentifier:@"setting" sender:self];
}
@end
