//
//  UsernameViewController.m
//  swwf
//
//  Created by Samar on 26/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UsernameViewController.h"
#import "SVProgressHUD.h"
#define kOFFSET_FOR_KEYBOARD 182.0

@interface UsernameViewController ()

@end

@implementation UsernameViewController
@synthesize emailId;
@synthesize accessToken,userName,userImage;
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
    userField = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)goBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)continueButton:(id)sender
{
    [userField resignFirstResponder];
    [self ShowActivityIndicatorWithTitle:@"Loading..."];
   if(![userField.text isEqualToString:@""])
   {
       NSLog(@"userName=%@",userField.text);
       NSString *username = userField.text;
       NSString *charN=@"A,B,C,D";
       NSLog(@"char=%@",charN);
       NSString *post =[[NSString alloc] initWithFormat:@"email=%@&device_token=%@&username=%@",self.emailId,[[NSUserDefaults standardUserDefaults]objectForKey:@"device_token"],username];
       NSLog(@"Before Device Token=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"device_token"]);
       NSURL *url=[NSURL URLWithString:@"http://23.23.78.187/swwf/login1.php"];
       NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
       NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
       NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
       [request setURL:url];
       [request setHTTPMethod:@"POST"];
       [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
       [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
       [request setHTTPBody:postData];
       NSError *error1 = nil;
       NSURLResponse *response = nil;
       NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error1];
       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error1];
       NSLog(@"%@",json);
       NSString *newreg;
       if (data)
        {
            NSDictionary *personalData=[json objectForKey:@"personal_data"];
            userName=[personalData valueForKey:@"user_name"];
            [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"userName"];
            userImage=[personalData valueForKey:@"user_image"];
            newreg=[personalData valueForKey:@"new_reg"];
            accessToken=[personalData valueForKey:@"access_token"];
            NSLog(@"Access token=%@",accessToken);
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"access_token"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            if([json objectForKey:@"error"])
            {
                UIAlertView *a=[[UIAlertView alloc]initWithTitle:@"" message:[json valueForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [a show];
                [self HideActivityIndicator];
            }
            else if(newreg)
            {
                [self HideActivityIndicator];
                [self performSegueWithIdentifier:@"connect" sender:self];
            }
                       
    }
    else
    {
        NSString *output = [error1 description];
        NSLog(@"\n\n Error to get json=%@",output);
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        [self HideActivityIndicator];
    }
    
   }
    else
{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Username" message:@"Please enter your swag name"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    [self HideActivityIndicator];
    
}

}

/*--------Move the View Up/Down  and Hide/Show Keyboard--------------*/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(IBAction)hideKeyboard:(id)sender
{
    [userField resignFirstResponder];
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

-(void)keyboardWillShow
{
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}


-(void)keyboardWillHide
{
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

/*--------------------------------------------------------------*/

/*---------------- Activity Indicator -------------------------------------*/
-(void)ShowActivityIndicatorWithTitle:(NSString *)Title{
    
    [SVProgressHUD showWithStatus:Title maskType:SVProgressHUDMaskTypeGradient];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    
}

-(void)HideActivityIndicator{
    [SVProgressHUD dismiss];
}

@end
