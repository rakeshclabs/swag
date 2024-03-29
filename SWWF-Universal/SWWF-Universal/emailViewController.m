//
//  emailViewController.m
//  swwf
//
//  Created by Samar on 26/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "emailViewController.h"
#import "UsernameViewController.h"
#import "gameSummary.h"
#import "SVProgressHUD.h"
#define kOFFSET_FOR_KEYBOARD 172.0


@interface emailViewController ()

@end

@implementation emailViewController
@synthesize accessToken,userName,userImage;
@synthesize gameIdArray,userStatusArray,userTurnArray,gameStatusArray,userTurnDataArray,oppImageArray,oppNameArray,dateCreatedArray;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"connect"])
    {
        UsernameViewController *un=[segue destinationViewController];
        un.emailId=idField.text;
        
    }
    
    else if([segue.identifier isEqualToString:@"gameSummary"])
    {
        gameSummary *gs=[segue destinationViewController];
        gs.numberOfGames=numberOfGames;
        gs.gameStatusArray=self.gameStatusArray;
        gs.gameIdArray=self.gameIdArray;
        gs.userTurnArray=self.userTurnArray;
        gs.userStatusArray=self.userStatusArray;
        gs.userTurnDataArray=self.userTurnDataArray;
        gs.oppNameArray=self.oppNameArray;
        gs.oppImageArray=self.oppImageArray;
        gs.dateCreatedArray=self.dateCreatedArray;
        gs.accessToken=self.accessToken;
        gs.userName=self.userName;
        gs.userImage=self.userImage;
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
    gameIdArray=[[NSMutableArray alloc]init];
    userStatusArray=[[NSMutableArray alloc]init];
    userTurnArray=[[NSMutableArray alloc]init];
    userTurnDataArray=[[NSMutableArray alloc]init];
    oppImageArray=[[NSMutableArray alloc]init];
    oppNameArray=[[NSMutableArray alloc]init];
    dateCreatedArray=[[NSMutableArray alloc]init];
    gameStatusArray=[[NSMutableArray alloc]init];

	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    idField = nil;
    cancelButton = nil;
    connectButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


/*-------------------- login via emailID-----------------------------------*/

- (IBAction)connectButton:(id)sender
{
    [self ShowActivityIndicatorWithTitle:@"Loading..."];
    [idField resignFirstResponder];
   
    NSLog(@"emailId=%@",idField.text);
    NSString *emailid = idField.text;
    [[NSUserDefaults standardUserDefaults]setValue:emailid forKey:@"emailId"];
    // Checking email address is valid or not
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL myStringMatchesRegEx=[emailTest evaluateWithObject:emailid];
    if(!myStringMatchesRegEx)//Not valid 
    {
        UIAlertView *alertView1 = [[UIAlertView alloc]initWithTitle:@"Invalid email format" message:@""  delegate:self cancelButtonTitle:@"   Cancel   " otherButtonTitles:nil, nil ];
        [alertView1 show];
        [self HideActivityIndicator];
    }
    else //Valid
    {
        NSString *post =[[NSString alloc] initWithFormat:@"email=%@&device_token=%@",emailid,[[NSUserDefaults standardUserDefaults]objectForKey:@"device_token"]];
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
            NSDictionary *maindata=[json objectForKey:@"maindata"];
            NSDictionary *personalData=[json objectForKey:@"personal_data"];
            dateCreatedArray=[maindata valueForKey:@"date_created"];
            gameIdArray=[maindata valueForKey:@"game_id"];
            gameStatusArray=[maindata valueForKey:@"game_status"];
            oppImageArray=[maindata valueForKey:@"opponent_image"];
            oppNameArray=[maindata valueForKey:@"opponent_name"];
            userStatusArray=[maindata valueForKey:@"user_status"];
            userTurnArray=[maindata valueForKey:@"user_turn"];
            userTurnDataArray=[maindata valueForKey:@"user_turn_data"];
            numberOfGames=[personalData valueForKey:@"no of games"];
            userName=[personalData valueForKey:@"user_name"];
            [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"userName"];
            userImage=[personalData valueForKey:@"user_image"];
            newreg=[json valueForKey:@"error"];
            if(newreg)  //if First Time Login with emailID and
            {
                [self HideActivityIndicator];
                [self performSegueWithIdentifier:@"connect" sender:self];
            }
           else         //Already account created via email Id
            {
                accessToken=[personalData valueForKey:@"access_token"];
                NSLog(@"Access token=%@",accessToken);
                [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"access_token"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self HideActivityIndicator];
                [self performSegueWithIdentifier:@"gameSummary" sender:self];
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
}

/*---------------Cancel Button------------------*/

- (IBAction)cancelButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [idField resignFirstResponder];
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
/*---------------- Activity Indicator -------------------------------------*/
-(void)ShowActivityIndicatorWithTitle:(NSString *)Title{
    
    [SVProgressHUD showWithStatus:Title maskType:SVProgressHUDMaskTypeGradient];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    
}

-(void)HideActivityIndicator{
    [SVProgressHUD dismiss];
}
@end
