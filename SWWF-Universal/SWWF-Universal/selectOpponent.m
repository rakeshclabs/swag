//
//  selectOpponent.m
//  swwf
//
//  Created by Samar on 27/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "selectOpponent.h"
#import "subOpponent.h"
#import "ViewController.h"
#import "SVProgressHUD.h"
#import "FacebookManager.h"
#import "facebookOpponent.h"

@interface selectOpponent ()

@end

@implementation selectOpponent

@synthesize gameMode,oppName;
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self HideActivityIndicator];
    if([segue.identifier isEqualToString:@"faceOppScreen"])
    {
        subOpponent *so=[segue destinationViewController];
        so.image=image;
        so.gameMode=self.gameMode;
        
    }
    else if([segue.identifier isEqualToString:@"game"])
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
    else if([segue.identifier isEqualToString:@"facebookPage"])
    {
        facebookOpponent *fc=[segue destinationViewController];
        fc.fbFriends=fbFriends;
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
    charArray=[[NSMutableArray alloc]init];
    charPointArray=[[NSMutableArray alloc]init];
    
    
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
    [self ShowActivityIndicatorWithTitle:@"Loading..."];
    [self performSegueWithIdentifier:@"settings" sender:self];
}

- (IBAction)facebookButton:(id)sender
{
    [self ShowActivityIndicatorWithTitle:@"Loading..."];
    image=@"facebookBox.png";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FBAccessTokenKey"])
        [self facebookFriend];
    
    else  [[FacebookManager facebookConnect]Call_FB];
    [self HideActivityIndicator];
}

- (IBAction)user:(id)sender
{
    [self ShowActivityIndicatorWithTitle:@"Loading..."];
    image=@"usernameBox.png";
    [self performSegueWithIdentifier:@"faceOppScreen" sender:self];
    
}

- (IBAction)random:(id)sender
{
    [self ShowActivityIndicatorWithTitle:@"Loading..."];
    NSString *post =[NSString stringWithFormat:@"random=1&access_token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]];
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
        if([json objectForKey:@"error"]) {
            UIAlertView *a=[[UIAlertView alloc]initWithTitle:@"" message:[json valueForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [a show];
            [self HideActivityIndicator];
        }
        NSString *nouser=[json valueForKey:@"nouser"];
        
        if(nouser)
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
}

-(void)facebookFriend
{
    
    NSString *FB_Token= [[NSUserDefaults standardUserDefaults] objectForKey:@"FBAccessTokenKey"];
    NSLog(@"access_token: %@   \n id: %@", FB_Token,  [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]);
    NSLog(@"Fb id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"fbid"]);
    NSString* post=[NSString stringWithFormat:@"access_token=%@&fb_access_token=%@&fbid=%@", @"fllb4etvd46utf1hm4e7ug1137"/*[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]*/, FB_Token, [[NSUserDefaults standardUserDefaults] objectForKey:@"fbid"]];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:@"http://guessthatcelebrity.com/fbfriends.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSError *error = nil;
    NSURLResponse *response = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    if (data)
    {
        NSLog(@"string: %@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);

        fbFriends = [[NSMutableArray alloc]init];
        NSDictionary *jsonFB = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"json :%@", jsonFB);
        
        if([jsonFB objectForKey:@"error"])
        {
            UIAlertView* a=[[UIAlertView alloc]initWithTitle:@"" message:@"error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [a show];
            [self HideActivityIndicator];
        }
        else
        {
            if([jsonFB objectForKey:@"registered"]!=(id)[NSNull null]) {
                fbFriends=[NSMutableArray arrayWithArray:[jsonFB objectForKey:@"not registered"]];
            }
            
            NSLog(@"%@", fbFriends);
            [self HideActivityIndicator];
            [self performSegueWithIdentifier:@"facebookPage" sender:nil];
        }
    }

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
