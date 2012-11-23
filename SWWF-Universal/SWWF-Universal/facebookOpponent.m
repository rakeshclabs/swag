//
//  facebookOpponent.m
//  SWWF-Universal
//
//  Created by Samar on 21/11/12.
//
//

#import "facebookOpponent.h"
#import "FacebookManager.h"
#import "SVProgressHUD.h"
#import "ViewController.h"

@interface facebookOpponent ()

@end

@implementation facebookOpponent
@synthesize fbFriends,gameMode,oppName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    imageArray=[[NSMutableArray alloc]init];
    NSSortDescriptor *lastDescriptor =[[NSSortDescriptor alloc] initWithKey:@"name"
                                                                  ascending:YES
                                                                   selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *descriptors = [NSArray arrayWithObjects:lastDescriptor, nil];
    if(!(fbFriends ==(id)[NSNull null]))
    {
        
        fbFriends=[fbFriends sortedArrayUsingDescriptors:descriptors];
    }

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return fbFriends.count;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    else {
        AsyncImageView* oldImage = (AsyncImageView*)
        [cell.contentView viewWithTag:999];
        [oldImage removeFromSuperview];
    }
    /* cellLabel = nil;
     cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(78, 17, 68, 25)];
     [cellLabel setFont:[UIFont boldSystemFontOfSize:20]];
     cellLabel.text = @"";
     [cell addSubview:cellLabel];
     */
    
        cell.textLabel.text = [NSString stringWithFormat:@"            %@", [[fbFriends objectAtIndex:indexPath.row] objectForKey:@"name"]];
    UIImageView *pic=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 60, 60)];
    pic.image=[UIImage imageNamed:@"Frame.png"];
        asyncImageView = [[AsyncImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        [asyncImageView setTag:999];
         if([imageArray count] >=indexPath.row+1) {
            asyncImageView = [imageArray objectAtIndex:indexPath.row];
        }
        else {
            NSLog(@"else");
            [asyncImageView loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", [[fbFriends objectAtIndex:indexPath.row] objectForKey:@"id"]]]];
            [imageArray addObject:asyncImageView];
        }
    
    [pic addSubview:asyncImageView];
    [cell.contentView addSubview:pic];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundView =[[UIImageView alloc] init];
    ((UIImageView *)cell.backgroundView).image=[UIImage imageNamed:@"fbCell.png"];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self ShowActivityIndicatorWithTitle:@"Loading..."];
    [[FacebookManager facebookConnect]Post_To_Friend_Wall_WithMsg:@"You have been challenged on 'Guess That Celebrity' . Play it" Friend_FBID:[[fbFriends objectAtIndex:indexPath.row] objectForKey:@"id"] WithLink:nil];
    
    
    
    [self PostForUsernameOrEmail:[[fbFriends objectAtIndex:indexPath.row] objectForKey:@"id"]];
}

- (void)PostForUsernameOrEmail:(NSString *)fbid
{
    
    // [[FacebookManager facebookConnect]Post_To_Friend_Wall_WithMsg:@"Hello I am playing GTC . It's an awesome game . Try it" Friend_FBID:fbid WithLink:nil];
    
    NSString *post =[NSString stringWithFormat:@"random=0&access_token=%@&fbid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"], fbid];
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
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error1];
    if (data)
    {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error1];
        NSLog(@"%@",json);
        [self HideActivityIndicator];
        if([json objectForKey:@"error"]) {
            UIAlertView *a=[[UIAlertView alloc]initWithTitle:@"" message:[json valueForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [a show];
            [self HideActivityIndicator];
        }
        else
        {
            NSDictionary *Char=[json objectForKey:@"character_data"];
            NSDictionary *gameData=[json objectForKey:@"game_data"];
            charArray=[Char valueForKey:@"name"];
            charPointArray=[Char valueForKey:@"coins"];
            self.oppName=[gameData valueForKey:@"user_name"];
            gameId=[gameData valueForKey:@"game_id"];
            NSLog(@"CharArray=%@",charArray);
            NSLog(@"CharPointArray=%@",charPointArray);
            [self performSegueWithIdentifier:@"game" sender:self];
        }
        
      /*  else if([json objectForKey:@"first_celeb"])
       
        {
            opponent_name=[json objectForKey:@"opponent_name"];
            NSLog(@"%@",opponent_name);
            
            
            opponent_image=[json valueForKey:@"opponent_image"];
            NSLog(@"%@",opponent_image);
            
            us1_image=[json objectForKey:@"user_image"];
            NSDictionary *info1 = [json objectForKey:@"first_celeb"];
            
            audio=[info1 objectForKey:@"audio"];
            NSLog(@"value is %@", audio);
            namecel=[info1 objectForKey:@"name"];
            NSLog(@"value is %@",namecel);
            pixelated_image=[info1 objectForKey:@"pixelated_image"];
            original_image1=[info1 objectForKey:@"original_image"];
            NSLog(@"value is %@",pixelated_image);
            NSArray *options=[info1 objectForKey:@"options"];
            option1=[options objectAtIndex:0];
            NSLog(@"option1: %@",option1);
            option2=[options objectAtIndex:1];
            NSLog(@"option2: %@",option2);
            
            option3=[options objectAtIndex:2];
            NSLog(@"option3: %@",option3);
            
            option4=[options objectAtIndex:3];
            NSLog(@"option4: %@",option4);
            
            imageid1=[info1 objectForKey:@"id"];
            
            
            NSDictionary *info2 = [json objectForKey:@"second_celeb"];
            audio2=[info2 objectForKey:@"audio"];
            
            name2=[info2 objectForKey:@"name"];
            
            pixelated_image2=[info2 objectForKey:@"pixelated_image"];
            original_image2=[info2 objectForKey:@"original_image"];
            NSArray *options2=[info2 objectForKey:@"options"];
            option21=[options2 objectAtIndex:0];
            option22=[options2 objectAtIndex:1];
            option23=[options2 objectAtIndex:2];
            option24=[options2 objectAtIndex:3];
            imageid2=[info2 objectForKey:@"id"];
            
            
            
            
            
            
            NSDictionary *info3 = [json objectForKey:@"third_celeb"];
            audioc=[info3 objectForKey:@"audio"];
            
            namec=[info3 objectForKey:@"name"];
            
            pixelated_imagec=[info3 objectForKey:@"pixelated_image"];
            original_image3=[info3 objectForKey:@"original_image"];
            NSArray *options3=[info3 objectForKey:@"options"];
            option21c=[options3 objectAtIndex:0];
            option22c=[options3 objectAtIndex:1];
            option23c=[options3 objectAtIndex:2];
            option24c=[options3 objectAtIndex:3];
            
            imageid3=[info3 objectForKey:@"id"];
            
            
            
            
            NSDictionary *info4 = [json objectForKey:@"fourth_celeb"];
            audio4=[info4 objectForKey:@"audio"];
            
            name4=[info4 objectForKey:@"name"];
            
            pixelated_image4=[info4 objectForKey:@"pixelated_image"];
            original_image4=[info4 objectForKey:@"original_image"];
            NSArray *options4=[info4 objectForKey:@"options"];
            option41=[options4 objectAtIndex:0];
            option42=[options4 objectAtIndex:1];
            option43=[options4 objectAtIndex:2];
            option44=[options4 objectAtIndex:3];
            
            imageid4=[info4 objectForKey:@"id"];
            
            
            NSDictionary *info5 = [json objectForKey:@"fifth_celeb"];
            audio5=[info5 objectForKey:@"audio"];
            
            name5=[info5 objectForKey:@"name"];
            
            pixelated_image5=[info5 objectForKey:@"pixelated_image"];
            original_image5=[info5 objectForKey:@"original_image"];
            NSArray *options5=[info5 objectForKey:@"options"];
            option51=[options5 objectAtIndex:0];
            option52=[options5 objectAtIndex:1];
            option53=[options5 objectAtIndex:2];
            option54=[options5 objectAtIndex:3];
            
            imageid5=[info5 objectForKey:@"id"];
            
            
            game_id=[json valueForKey:@"game_id"];
            
            
            [[NSUserDefaults standardUserDefaults]setBool:FALSE forKey:@"Facebook_post"];
            NSString *fbuname = [[NSUserDefaults standardUserDefaults]valueForKey:@"login"];
            NSString *fbid=[[NSUserDefaults standardUserDefaults]valueForKey:@"fbid"];
            NSLog(@"fbuname=%@",fbuname);
            if([fbuname isEqualToString:@"fb"])
            {
                NSLog(@"fbid=%@",fbid);
                if(fbid.intValue!=0)
                {
                    [[FacebookManager facebookConnect]Call_FB];
                    [[FacebookManager facebookConnect]Post_To_Friend_Wall_WithMsg:[NSString stringWithFormat:@"I just created a game with %@ on the guess that celebrity iPhone app!",opponent_name]Friend_FBID:fbid WithLink:nil];
                }
            }
            
            
            
            [self SaveData];
            
            [self performSelector:@selector(callSegue) withObject:nil afterDelay:3.0];
            
            // [self performSegueWithIdentifier:@"fbGame" sender:nil];
            
            
            
        }*/
    }
    else {
        UIAlertView *a=[[UIAlertView alloc]initWithTitle:@"" message:@"no internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [a show];
        [self HideActivityIndicator];
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

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)settings:(id)sender
{
    [self performSegueWithIdentifier:@"setting" sender:self];
}
@end
