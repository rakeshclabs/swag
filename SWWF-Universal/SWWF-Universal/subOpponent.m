//
//  subOpponent.m
//  SWWF-Universal
//
//  Created by Samar on 09/11/12.
//
//

#import "subOpponent.h"
#import "ViewController.h"
#import "SVProgressHUD.h"
#define kOFFSET_FOR_KEYBOARD 122.0

@interface subOpponent ()

@end

@implementation subOpponent
@synthesize image,imageBox,gameMode,oppName;


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self HideActivityIndicator];
    if([segue.identifier isEqualToString:@"game"])
    {
        ViewController *vc=[segue destinationViewController];
        vc.remainingLettersString=@"90";
        vc.opponentNameString=self.oppName;
        vc.userScoreString=@"00";
        vc.opponentScoreString=@"00";
        vc.gameId=gameId;
        vc.charArray=charArray;
        vc.charPointArray=charPointArray;
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
    nameField = nil;
    [super viewDidUnload];
}
- (IBAction)startButton:(id)sender
{
    [self ShowActivityIndicatorWithTitle:@"Loading..."];
    if([self.image isEqualToString:@"usernameBox.png"])
    {
        [nameField resignFirstResponder];
        if(![nameField.text isEqualToString:@""])
        {
            NSString *uname=nameField.text;
            NSString *post =[NSString stringWithFormat:@"random=0&access_token=%@&uname=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],uname];
            NSLog(@"AccessToken=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]);
    
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    
            [request setURL:[NSURL URLWithString:@"http://23.23.78.187/swwf/create_game.php"]];
    
            [request setHTTPMethod:@"POST"];
    
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
            [request setHTTPBody:postData];
    
            NSError *error1 = nil;
    
            NSURLResponse *response = nil;
    
            NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error1];
    
            if (data)
            {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error1];
                NSLog(@"%@",json);
                NSString *nouser=[json valueForKey:@"nouser"];
                if([json objectForKey:@"error"])
                {
                    UIAlertView *a=[[UIAlertView alloc]initWithTitle:@"" message:[json valueForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [a show];
                    nameField.text=@"";
                    [self HideActivityIndicator];
                }
                else if(nouser)
                {
                    UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"" message:nouser delegate:@"nil" cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [Alert show];
                    [self HideActivityIndicator];
                }
                else
                {
                    NSDictionary *Char=[json objectForKey:@"character_data"];
                    NSDictionary *gameData=[json objectForKey:@"game_data"];
                    charArray=[Char valueForKey:@"name"];
                    charPointArray=[Char valueForKey:@"coins"];
                    self.oppName=[gameData valueForKey:@"opponent_name"];
                    gameId=[gameData valueForKey:@"game_id"];
                    NSLog(@"CharArray=%@",charArray);
                    NSLog(@"CharPointArray=%@",charPointArray);
                    [self performSegueWithIdentifier:@"game" sender:self];
                }
            }
            else
            {
                UIAlertView *a=[[UIAlertView alloc]initWithTitle:@"" message:@"no internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [a show];
                [self HideActivityIndicator];
            }
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Username" message:@"Please enter opponent name"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self HideActivityIndicator];
        }
    }
    else if([self.image isEqualToString:@"facebookBox.png"])
    {
        
    }
}

- (IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)settingButton:(id)sender
{
    [self performSegueWithIdentifier:@"setting" sender:self];
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
    [nameField resignFirstResponder];
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
