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

@interface selectOpponent ()

@end

@implementation selectOpponent

@synthesize gameMode,oppName;
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
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
        }
        NSString *nouser=[json valueForKey:@"nouser"];
        
        if(nouser)
        {
            UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"" message:nouser delegate:@"nil" cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [Alert show];
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
@end
