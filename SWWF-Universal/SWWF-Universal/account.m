//
//  account.m
//  swwf
//
//  Created by Samar on 27/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "account.h"
#import "FacebookManager.h"
#define kOFFSET_FOR_KEYBOARD 152.0

@interface account ()

@end

@implementation account

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
    userNameField.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"];
    if([[NSUserDefaults standardUserDefaults]valueForKey:@"emailId"])
    {
        emailField.text= [[NSUserDefaults standardUserDefaults]valueForKey:@"emailId"];
    }
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    userNameField = nil;
    emailField = nil;
    newPassword = nil;
    retypePassword = nil;
    [self setLogout:nil];
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

- (IBAction)logout:(id)sender
{
    [[FacebookManager facebookConnect]FB_LogOut];
    
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"fbid"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"fbuname"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"FBAccessTokenKey"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"emailId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (IBAction)saveclose:(id)sender
{
   /* if([newPassword.text isEqualToString:retypePassword.text])
    {
        NSString*  post =[NSString stringWithFormat:@"access_token=%@&username=%@&pass=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token" ],userNameField.text,newPassword.text];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
        
        [request setURL:[NSURL URLWithString:@"http://guessthatcelebrity.com/reset_password.php"]];
        
        [request setHTTPMethod:@"POST"];
        
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:postData];
        
        NSError *error = nil;
        
        NSURLResponse *response1 = nil;
        
        NSData *data1= [NSURLConnection sendSynchronousRequest:request
                        
                                             returningResponse:&response1
                        
                                                         error:&error];
        
        if (data1){
            
            NSDictionary *json1 = [NSJSONSerialization JSONObjectWithData:data1 options:kNilOptions error:&error];
            
            NSLog(@"Pass response =%@",json1);
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Password Updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
            
        }
        else {
            NSString *output = [error description];
            NSLog(@"\n\n Error to get json=%@",output);
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Unable to connect to server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        
    }
    
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Passwords are not matching. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        newPassword.text=@"";
        retypePassword.text=@"";
    }*/
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
    [newPassword resignFirstResponder];
    [retypePassword resignFirstResponder];
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
/*------------------------------------------------------------------------*/

@end
