//
//  gameSummary.m
//  swwf
//
//  Created by Samar on 27/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "gameSummary.h"
#import "asyncimageview.h"

@interface gameSummary ()

@end

@implementation gameSummary
@synthesize tableView;
@synthesize numberOfGames,accessToken,userName,userImage;
@synthesize gameIdArray,userStatusArray,userTurnArray,gameStatusArray,userTurnDataArray,oppImageArray,oppNameArray,dateCreatedArray;
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
    
    NSLog(@"gameidArray=%@",gameIdArray);
    [self drawViewForCell:tableView];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView  {
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section    {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; 
    }
    
    // Configure the cell...
    
    
    return cell;
}
- (void)drawViewForCell:(UITableView *)tableViewCell
{
    gamesScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,15,320, 60)];
    [gamesScroll setBackgroundColor:[UIColor clearColor]];

    if(numberOfGames.intValue==0)
    {
        h=20;
        h=h+10;
        UIButton *startGame=[UIButton buttonWithType:UIButtonTypeCustom];
        startGame.frame=CGRectMake(48, h, 224, 53);
        [startGame setImage:[UIImage imageNamed:@"Start.png"] forState:UIControlStateNormal];
        [startGame addTarget:self action:@selector(startGameAction:) forControlEvents:UIControlEventTouchUpInside];
        [gamesScroll addSubview:startGame];
        
        gamesScroll.frame = CGRectMake(0,15, 320, h+73);
        [gamesScroll setContentSize:CGSizeMake(310, h*2-200)];
        [tableViewCell addSubview:gamesScroll];
    }
    
    else
    {
        NSLog(@"userStatusArray=%@",userStatusArray);
    
    for(int i=0;i<gameIdArray.count;i++)
    {
        status=[userStatusArray objectAtIndex:i];
        if(i==0)
            lastStatus=[userStatusArray objectAtIndex:0];
        else
            lastStatus=[userStatusArray objectAtIndex:i-1];
        NSLog(@"array=%@",[userStatusArray objectAtIndex:i]);
        if(status.intValue==1)
        {
            if(i==0)
            {
                //YOUR TURN CODING
                UIButton *yourMove=[UIButton buttonWithType:UIButtonTypeCustom];
                [yourMove setImage:[UIImage imageNamed:@"your-turn.png"] forState:UIControlStateNormal];
                yourMove.frame=CGRectMake(10, 15, 120, 28);
                line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line.png"]];
                line.frame=CGRectMake(0, 43, 320, 9);
                [gamesScroll addSubview:line];
                [gamesScroll addSubview:yourMove];
                h=51;
            }
        UIButton *yourTurn=[UIButton buttonWithType:UIButtonTypeCustom];
        [yourTurn setImage:[UIImage imageNamed:@"cell.png"] forState:UIControlStateNormal];
        yourTurn.frame=CGRectMake(0, h, 320, 70);
        yourTurn.tag=i;
        [yourTurn addTarget:self action:@selector(yourTurnAction:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *pic=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 60, 60)];
        pic.image=[UIImage imageNamed:@"Frame.png"];
        AsyncImageView *imageView = [[AsyncImageView alloc]initWithFrame:CGRectMake(7, 7,46,46)];
        //[imageView setImage:[UIImage imageWithData:data5]];
        [imageView loadImageFromURL:[NSURL URLWithString:[oppImageArray objectAtIndex:i]]];
        
        [pic addSubview:imageView];
        
        UILabel *playerNames=[[UILabel alloc]initWithFrame:CGRectMake(80, 6, 200, 15)];
        playerNames.text=[NSString stringWithFormat:@"Swag with %@",[oppNameArray objectAtIndex:i]];//@"Swag with Rocky";
        playerNames.font=[UIFont boldSystemFontOfSize:14];
        playerNames.backgroundColor=[UIColor clearColor];
        
        UILabel *gameStarted=[[UILabel alloc]initWithFrame:CGRectMake(80, 22, 200, 15)];
        gameStarted.text=[NSString stringWithFormat:@"Started %@",[dateCreatedArray objectAtIndex:i]];//@"Started October 27, 10:11 AM";
        gameStarted.font=[UIFont systemFontOfSize:10];
        gameStarted.enabled=NO;
        gameStarted.backgroundColor=[UIColor clearColor];
        
        UILabel *lastWord=[[UILabel alloc]initWithFrame:CGRectMake(80, 40, 200, 15)];
        lastWord.text=@"'LOVE' played 1 hour ago";
        lastWord.font=[UIFont systemFontOfSize:12];
        lastWord.textColor=[UIColor blueColor];
        lastWord.backgroundColor=[UIColor clearColor];
        
        [yourTurn addSubview:pic];
        [yourTurn addSubview:playerNames];
        [yourTurn addSubview:gameStarted];
        [yourTurn addSubview:lastWord];
        [gamesScroll addSubview:yourTurn];
        h=h+72;
        }
        
        else if(status.intValue==0)
        {
            //THEIR TURN CODING
            if((lastStatus.intValue==1||i==0))
            {
                h=h+5;
                UIButton *theirMove=[UIButton buttonWithType:UIButtonTypeCustom];
                [theirMove setImage:[UIImage imageNamed:@"their-turn.png"] forState:UIControlStateNormal];
                theirMove.frame=CGRectMake(190, h, 120, 28);
                h=h+28;
                line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line.png"]];
                line.frame=CGRectMake(0, h, 320, 9);
                [gamesScroll addSubview:line];
                [gamesScroll addSubview:theirMove];
                h=h+8;
            }
            UIButton *theirTurn=[UIButton buttonWithType:UIButtonTypeCustom];
            [theirTurn setImage:[UIImage imageNamed:@"cell.png"] forState:UIControlStateNormal];
            
            theirTurn.frame=CGRectMake(0, h, 320, 70);
            theirTurn.tag=i;
            [theirTurn addTarget:self action:@selector(theirTurnAction:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *pic=[[UIImageView alloc]initWithFrame:CGRectMake(225, 5, 60, 60)];
            pic.image=[UIImage imageNamed:@"Frame.png"];
            AsyncImageView *imageView = [[AsyncImageView alloc]initWithFrame:CGRectMake(7, 7,46,46)];
            //[imageView setImage:[UIImage imageWithData:data5]];
            [imageView loadImageFromURL:[NSURL URLWithString:[oppImageArray objectAtIndex:i]]];
            
            [pic addSubview:imageView];
            
            UILabel *playerNames=[[UILabel alloc]initWithFrame:CGRectMake(10, 6, 200, 15)];
            playerNames.text=[NSString stringWithFormat:@"Swag with %@",[oppNameArray objectAtIndex:i]];
            playerNames.font=[UIFont boldSystemFontOfSize:14];
            playerNames.backgroundColor=[UIColor clearColor];
            
            UILabel *gameStarted=[[UILabel alloc]initWithFrame:CGRectMake(10, 22, 200, 15)];
            gameStarted.text=[NSString stringWithFormat:@"Started %@",[dateCreatedArray objectAtIndex:i]];
            gameStarted.font=[UIFont systemFontOfSize:10];
            gameStarted.enabled=NO;
            gameStarted.backgroundColor=[UIColor clearColor];
            
            UILabel *lastWord=[[UILabel alloc]initWithFrame:CGRectMake(10, 40, 200, 15)];
            lastWord.text=@"'LOVE' played 1 hour ago";
            lastWord.font=[UIFont systemFontOfSize:12];
            lastWord.textColor=[UIColor blueColor];
            lastWord.backgroundColor=[UIColor clearColor];
            
            [theirTurn addSubview:pic];
            [theirTurn addSubview:playerNames];
            [theirTurn addSubview:gameStarted];
            [theirTurn addSubview:lastWord];
            [gamesScroll addSubview:theirTurn];
            h=h+72;

        }
        else if(status.intValue==2)
        {
                //GAME OVER CODING
                NSArray *wonArray=[[NSArray alloc]initWithObjects:@"1",@"0", nil];
                if(lastStatus.intValue==1||lastStatus.intValue==0||i==0)
                {
                    h=h+5;
                    UIButton *gameOver=[UIButton buttonWithType:UIButtonTypeCustom];
                    [gameOver setImage:[UIImage imageNamed:@"game-over.png"] forState:UIControlStateNormal];
                    gameOver.frame=CGRectMake(10, h, 120, 30);
                    h=h+30;
                    line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line.png"]];
                    line.frame=CGRectMake(0, h, 320, 9);
                    [gamesScroll addSubview:gameOver];
                    [gamesScroll addSubview:line];
                    h=h+8;
                }
                  UIButton *gameData=[UIButton buttonWithType:UIButtonTypeCustom];
                  [gameData setImage:[UIImage imageNamed:@"cell.png"] forState:UIControlStateNormal];
                    gameData.frame=CGRectMake(0, h, 320, 70);
                    gameData.tag=i;
                    [gameData addTarget:self action:@selector(gameOverAction:)forControlEvents:UIControlEventTouchUpInside];
                    NSString *won=[wonArray objectAtIndex:i];
                    UIImageView *pic;
                    UILabel *playerNames;
                    UILabel *gameStarted;
                    UILabel *lastWord;
                    if(won.intValue==1)
                   {
                        pic=[[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 60, 60)];
                        pic.image=[UIImage imageNamed:@"Frame.png"];
            
                        playerNames=[[UILabel alloc]initWithFrame:CGRectMake(80, 6, 200, 15)];
                        playerNames.text=@"You Beat player1";
                        playerNames.font=[UIFont boldSystemFontOfSize:14];
                        playerNames.backgroundColor=[UIColor clearColor];
            
                        gameStarted=[[UILabel alloc]initWithFrame:CGRectMake(80, 22, 200, 15)];
                        gameStarted.text=@"Started October 27, 10:11 AM";
                        gameStarted.font=[UIFont systemFontOfSize:10];
                        gameStarted.enabled=NO;
                        gameStarted.backgroundColor=[UIColor clearColor];
            
                        lastWord=[[UILabel alloc]initWithFrame:CGRectMake(80, 40, 200, 15)];
                        lastWord.text=@"Last move 1 hour ago";
                        lastWord.font=[UIFont systemFontOfSize:12];
                        lastWord.textColor=[UIColor blueColor];
                        lastWord.backgroundColor=[UIColor clearColor];
                    }
                    else
                    {
                        pic=[[UIImageView alloc]initWithFrame:CGRectMake(225, 5, 60, 60)];
                        pic.image=[UIImage imageNamed:@"Frame.png"];
            
                        playerNames=[[UILabel alloc]initWithFrame:CGRectMake(10, 6, 200, 15)];
                        playerNames.text=@"Player2 Beat You";
                        playerNames.font=[UIFont boldSystemFontOfSize:14];
                        playerNames.backgroundColor=[UIColor clearColor];
            
                        gameStarted=[[UILabel alloc]initWithFrame:CGRectMake(10, 22, 200, 15)];
                        gameStarted.text=@"Started October 27, 10:11 AM";
                        gameStarted.font=[UIFont systemFontOfSize:10];
                        gameStarted.enabled=NO;
                        gameStarted.backgroundColor=[UIColor clearColor];
            
                        lastWord=[[UILabel alloc]initWithFrame:CGRectMake(10, 40, 200, 15)];
                        lastWord.text=@"Last move 1 hour ago";
                        lastWord.font=[UIFont systemFontOfSize:12];
                        lastWord.textColor=[UIColor blueColor];
                        lastWord.backgroundColor=[UIColor clearColor];
            
                    }
                    [gameData addSubview:pic];
                    [gameData addSubview:playerNames];
                    [gameData addSubview:gameStarted];
                    [gameData addSubview:lastWord];
                    [gamesScroll addSubview:gameData];
                    h=h+72;
        }
                
    }
    
    
   

    
    h=h+10;
    UIButton *startGame=[UIButton buttonWithType:UIButtonTypeCustom];
    startGame.frame=CGRectMake(48, h, 224, 53);
    [startGame setImage:[UIImage imageNamed:@"Start.png"] forState:UIControlStateNormal];
    [startGame addTarget:self action:@selector(startGameAction:) forControlEvents:UIControlEventTouchUpInside];
    [gamesScroll addSubview:startGame];
        h=h+53;
    gamesScroll.frame = CGRectMake(0,15, 320, h+20);
    [gamesScroll setContentSize:CGSizeMake(310, h*2-200)];
    [tableViewCell addSubview:gamesScroll];
    
    }

}

-(void)yourTurnAction:(UIButton *)sender
{
    NSLog(@"tag=%d",sender.tag);
}

-(void)theirTurnAction:(UIButton *)sender
{
    NSLog(@"tag=%d",sender.tag);
}

-(void)gameOverAction:(UIButton *)sender
{
    NSLog(@"tag=%d",sender.tag);
}

-(void)startGameAction:(UIButton *)sender
{
    NSLog(@"tag=%d",sender.tag);
    [self performSegueWithIdentifier:@"startGame" sender:self];
}
- (IBAction)settings:(id)sender 
{
    [self performSegueWithIdentifier:@"settings" sender:self];
}
@end
