//
//  settings.m
//  swwf
//
//  Created by Samar on 27/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "settings.h"
#import <AudioToolbox/AudioServices.h>

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
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
   if(vibration)
   {
       [[NSUserDefaults standardUserDefaults]setBool:FALSE forKey:@"Vibration"];
       vibrationImageView.image=[UIImage imageNamed:@"off.png"];
       vibration=FALSE;
   }
   else
   {
       [[NSUserDefaults standardUserDefaults]setBool:TRUE forKey:@"Vibration"];
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
- (IBAction)feedback:(id)sender
{
    [self Email];
}

- (void)Email
{
    if ([MFMailComposeViewController canSendMail])
        
    {
        
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Feedback"];
       // NSArray *toRecipients = [NSArray arrayWithObjects:@"gtcserver@gmail.com",nil];
      //  [mailer setToRecipients:toRecipients];
                
        NSString *emailBody = nil;
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentModalViewController:mailer animated:YES];
    }
    
    else
        
    {
        
        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Failure"message:@"Your device doesn't support the composer sheet" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        
        [Alert show];
        
    }
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"mail cancelled");
            break;
        case MFMailComposeResultSent:
            NSLog(@"mail sent");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"mail saved");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"error,mail not sent");
            break;
            
        default:NSLog(@"mail not sent");
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
}



@end
