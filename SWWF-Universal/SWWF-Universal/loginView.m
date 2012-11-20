//
//  loginView.m
//  SWWF-Universal
//
//  Created by Samar on 06/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "loginView.h"
#import "FacebookManager.h"
#import "gameSummary.h"

@interface loginView ()

@end

@implementation loginView
@synthesize accessToken,userName,userImage;
@synthesize gameIdArray,userStatusArray,userTurnArray,gameStatusArray,userTurnDataArray,oppImageArray,oppNameArray,dateCreatedArray;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"gameSummary"])
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
    NSLog(@"Access Token=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"access_token"]);
//    if([[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"])
//    {
//        BG.image=[UIImage imageNamed:@"splash.png"];
//
//        [self POST];
//    }
//    
//    else
//    {
        BG.image=[UIImage imageNamed:@"home.jpg"];
        [emailButton setImage:[UIImage imageNamed:@"login-click.png"] forState:UIControlStateNormal];
        [emailButton setImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateHighlighted];
        [facebookButton setImage:[UIImage imageNamed:@"fb-click.png"] forState:UIControlStateNormal];
        [facebookButton setImage:[UIImage imageNamed:@"fb.png"] forState:UIControlStateHighlighted];
        // Do any additional setup after loading the view.
    //}
}
- (void)viewDidUnload
{
    BG = nil;
    emailButton = nil;
    facebookButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)emailButton:(id)sender {
}

- (IBAction)facebookButton:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"emailId"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FBAccessTokenKey"]&&[[NSUserDefaults standardUserDefaults]objectForKey:@"fbuname"]){
        [self POST_FB];
        NSString *fbid =[[NSUserDefaults standardUserDefaults]valueForKey:@"fbid"];
        NSString *fbuname = [[NSUserDefaults standardUserDefaults]valueForKey:@"fbuname"];
        NSLog(@"fbid=%@",fbid);
        NSLog(@"fbname=%@",fbuname);
    }
    
    else
    {
        [[FacebookManager facebookConnect]Call_FB];
        // [self FB_Logged_In_Successfully];
    }
}

-(void)FB_Login_Request_Sent
{
    NSLog(@"Login requesting");
}
-(void)FB_Logged_In_Successfully
{
    
    //[self hideActivityIndicater];
        NSString *fbid =[[NSUserDefaults standardUserDefaults]valueForKey:@"fbid"];
        NSString *fbuname = [[NSUserDefaults standardUserDefaults]valueForKey:@"fbuname"];
        NSLog(@"fbid=%@",fbid);
        NSLog(@"fbname=%@",fbuname);
    
    NSLog(@"Loged In successful");
    // [self hideActivityIndicater];
    
    
}

//--------Send and recive data from server when login through facebook-----
-(void)POST_FB
{
    NSString *fbid =[[NSUserDefaults standardUserDefaults]valueForKey:@"fbid"];
    NSString *fbuname = [[NSUserDefaults standardUserDefaults]valueForKey:@"fbuname"];
    NSString *post =[[NSString alloc] initWithFormat:@"fbid=%@&fb_uname=%@&device_token=%@",fbid,fbuname,[[NSUserDefaults standardUserDefaults]objectForKey:@"device_token"]];
    NSURL *url=[NSURL URLWithString:@"http://23.23.78.187/swwf/fblogin.php"];
    NSLog(@"Device Token=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"device_token"]);
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
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error1];
    
    if (data)
    {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error1];
        NSLog(@"json is %@",json);
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

        accessToken=[personalData valueForKey:@"access_token"];
        NSLog(@"accessToken=%@",accessToken);
        [[NSUserDefaults standardUserDefaults] setValue:accessToken forKey:@"access_token"];
        NSString *error=[json valueForKey:@"error"];
        if(accessToken)
        {
            [self performSegueWithIdentifier:@"gameSummary" sender:self];
        }

        else if(error) {
            UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"error!" message:error delegate:@"nil" cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [Alert show];
        }
        
        
    }
    
    
    else
    {
        NSString *output = [error1 description];
        NSLog(@"\n\n Error to get json=%@",output);
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"  OK  " otherButtonTitles: nil];
        [alert show];
      //  [self hideActivityIndicater];
    }
    
}

//---------Send and receive data from server when user is already logged in-----------
-(void)POST
{
    NSString *post =[NSString stringWithFormat:@"access_token=%@&device_token=%@", [[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"],[[NSUserDefaults standardUserDefaults]objectForKey:@"device_token"]];
    NSLog(@"Device_token=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"device_token"]);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:@"http://23.23.78.187/swwf/login.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSError *error1 = nil;
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error1];
    if (data)
    {
        //NSLog(@"\ndata: %@ \nstring: %@", data, [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error1];
        NSLog(@"json is %@",json);
        NSString *error=[json valueForKey:@"error"];
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
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"])
        {
            [self performSegueWithIdentifier:@"gameSummary" sender:self];
        }
        
        else if(error) {
            UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"error!" message:error delegate:@"nil" cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [Alert show];
        }
        
        
    }
    
    
    else
    {
        NSString *output = [error1 description];
        NSLog(@"\n\n Error to get json=%@",output);
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"  OK  " otherButtonTitles: nil];
        [alert show];
        //  [self hideActivityIndicater];
    }
   
}


@end
