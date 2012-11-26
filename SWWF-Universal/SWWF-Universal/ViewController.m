//
//  ViewController.m
//  SWWF-Universal
//
//  Created by Samar on 06/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "SVProgressHUD.h"

@interface ViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ViewController
@synthesize buttonView;
@synthesize buttonBackroundView;
@synthesize charImage;
@synthesize opponentNameString,userScoreString,opponentScoreString,remainingLettersString,gameId;
@synthesize charArray,charPointArray;

@synthesize scrollView = _scrollView;

@synthesize imageView = _imageView;
@synthesize dropTarget;
@synthesize dragObject;
@synthesize touchOffset;
@synthesize homePosition;
@synthesize framePoint;

- (void)viewDidLoad
{
    [super viewDidLoad];
    storePoint=[[NSMutableArray alloc]init];
    buttonArray=[[NSMutableArray alloc]init];
    locArray=[[NSMutableArray alloc]init];
    xArray=[[NSMutableArray alloc]init];
    yArray=[[NSMutableArray alloc]init];
    imageLocArray=[[NSMutableArray alloc]init];
    imageCharArray=[[NSMutableArray alloc]init];
    imageCoinArray=[[NSMutableArray alloc]init];
    buttonCharArray=[[NSMutableArray alloc]init];
    buttonLocArray=[[NSMutableArray alloc]init];
    buttonCoinArray=[[NSMutableArray alloc]init];
    fixedLocArray=[[NSMutableArray alloc]init];
    fixedCharArray=[[NSMutableArray alloc]init];
    wordsArray=[[NSMutableArray alloc]init];
    prevWord=[[NSMutableString alloc]init];
    myWord=[[NSMutableString alloc]init];
    path = [[database alloc]init];
    databasePath = path.dataFilePath;
    [self DataBase];
    [self scrableBoard];
    
    // Tell the scroll view the size of the contents
    self.scrollView.contentSize = CGSizeMake(600, 600);
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
   
    
    myView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    
   // myView.backgroundColor=[UIColor blackColor];
   // myView.alpha= 0.2;

    popView=[[UIImageView alloc]init];
    popView.frame=CGRectMake(43, 160, 235, 159);
    popView.image=[UIImage imageNamed:@"popView.png"];
    popView.userInteractionEnabled=YES;
    invalidMoveLabel=[[UILabel alloc]init];
    invalidMoveLabel.frame=CGRectMake(49, 1, 137, 32);
    invalidMoveLabel.text=@"Invalid Move";
    invalidMoveLabel.textAlignment=UITextAlignmentCenter;
    invalidMoveLabel.font=[UIFont boldSystemFontOfSize:20];
    invalidMoveLabel.textColor=[UIColor yellowColor];
    invalidMoveLabel.backgroundColor=[UIColor clearColor];
    msgLabel=[[UILabel alloc]init];
    msgLabel.frame=CGRectMake(11, 33, 210, 56);
    msgLabel.text=@"Sorry, must place all tiles in one row or column.";
    msgLabel.numberOfLines=3;
    msgLabel.backgroundColor=[UIColor clearColor];
    
    okButton=[[UIButton alloc]init];
    okButton.frame=CGRectMake(83, 103, 66, 33);
    [okButton setImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
    [okButton setImage:[UIImage imageNamed:@"okClick.png"] forState:UIControlStateHighlighted];
    [okButton addTarget:self action:@selector(okButton) forControlEvents:UIControlEventTouchUpInside];
    
    yesButton=[[UIButton alloc]init];
    yesButton.frame=CGRectMake(122, 95, 74, 35);
    [yesButton setImage:[UIImage imageNamed:@"yes.png"] forState:UIControlStateNormal];
    [yesButton setImage:[UIImage imageNamed:@"yesClick.png"] forState:UIControlStateHighlighted];
    [yesButton addTarget:self action:@selector(yesButton) forControlEvents:UIControlEventTouchUpInside];

    noButton=[[UIButton alloc]init];
    noButton.frame=CGRectMake(35, 95, 74, 35);
    [noButton setImage:[UIImage imageNamed:@"no.png"] forState:UIControlStateNormal];
    [noButton setImage:[UIImage imageNamed:@"noClick.png"] forState:UIControlStateHighlighted];
    [noButton addTarget:self action:@selector(okButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    userScore.text=self.userScoreString;
    opponentScore.text=self.opponentScoreString;
    userName.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"];
    NSLog(@"oppName=%@",self.opponentNameString);
    opponentName.text=self.opponentNameString;
    remainingLetters.text=[NSString stringWithFormat:@"%@ Letters Left",remainingLettersString];
}

-(void)DataBase
{
    [imageCharArray removeAllObjects];
    [imageLocArray removeAllObjects];
    [imageCoinArray removeAllObjects];
    [buttonCharArray removeAllObjects];
    [buttonCoinArray removeAllObjects];
    [buttonLocArray removeAllObjects];
    /*------------------ using Database----------------------*/
    NSLog(@"Database Path=%@",databasePath);
    NSFileManager *filemgr = [NSFileManager defaultManager];
    sqlite3_stmt    *statement;
    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
        /*--------------Deleting Old Values in Table-----------------*/
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
        {
            NSString *insertSQL;
            insertSQL = [NSString stringWithFormat:@"DELETE FROM IMAGE"];
            const char *insert_stmt = [insertSQL UTF8String];
            
            sqlite3_prepare_v2(swagDB, insert_stmt,-1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"record deleted");
            } else
            {
                NSLog(@"Failed to delete contact");
            }
            
            insertSQL = [NSString stringWithFormat:@"DELETE FROM BUTTON"];
            insert_stmt = [insertSQL UTF8String];
            
            sqlite3_prepare_v2(swagDB, insert_stmt,-1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"record deleted");
            } else
            {
                NSLog(@"Failed to delete contact");
            }
            
            insertSQL = [NSString stringWithFormat:@"DELETE FROM FIXED"];
            insert_stmt = [insertSQL UTF8String];
            
            sqlite3_prepare_v2(swagDB, insert_stmt,-1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"record deleted");
            } else
            {
                NSLog(@"Failed to delete contact");
            }

        }
        /*----------------Creating Tables if not exist---------------------------------*/
        if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
        {
            char *errMsg;
            NSString *querySQL;
            const char *sql_stmt;
            querySQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS IMAGE(LOC TEXT, CHAR TEXT, COIN TEXT)"];
            sql_stmt = [querySQL UTF8String];
            if (sqlite3_exec(swagDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
            else
            {
                NSLog(@"IMAGE Table Created");
            }
            
            querySQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS BUTTON(LOC TEXT, CHAR TEXT, COIN TEXT)"];
            sql_stmt = [querySQL UTF8String];
            if (sqlite3_exec(swagDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
            else
            {
                NSLog(@"BUTTON Table Created");
            }
            
            querySQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS FIXED(LOC TEXT, CHAR TEXT, COIN TEXT)"];
            sql_stmt = [querySQL UTF8String];
            if (sqlite3_exec(swagDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
            else
            {
                NSLog(@"FIXED Table Created");
            }

            sqlite3_close(swagDB);
            
        } else
        {
            NSLog(@"Failed to open/create database");
        }
    }
    /*------------------ Inserting Values in Image Table -------------------------*/
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
    {
        for(int i=0;i<charArray.count;i++)
        {
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO IMAGE(LOC, CHAR, COIN) VALUES(\"%d\", \"%@\", \"%@\")",i+1,[charArray objectAtIndex:i],[charPointArray objectAtIndex:i]];
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(swagDB, insert_stmt,-1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Record added");
                
            } else {
                NSLog(@"Failed to add contact");
            }
        }
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO FIXED(LOC, CHAR, COIN) VALUES('91', 'F','5'),('92', 'A','5'),('94', 'E','5'),('106', 'B','5'),('107', 'L','5'),('124', 'O','5'),('125', 'T','5')"];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(swagDB, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Record added");
            
        } else {
            NSLog(@"Failed to add contact");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(swagDB);
    }
    /*-------------------- Fetching Values from image Table ---------------------*/
    NSString *querySQL;
    querySQL = [NSString stringWithFormat:@"SELECT * FROM IMAGE"];
    const char *query_stmt = [querySQL UTF8String];
    
    // const char *sql = "SELECT * FROM  data WHERE date=\"%@\"",currentDate;
    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare(swagDB, query_stmt, -1, &sqlStatement, NULL) != SQLITE_OK)
    {
        // NSLog(@"Problem with prepare statement:  %@", sqlite3_errmsg(db));
    }else{
        
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            [imageLocArray addObject:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,0)]];
            [imageCharArray addObject:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)]];
            [imageCoinArray addObject:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,2)]];
        }
    }
    sqlite3_finalize(sqlStatement);
    sqlite3_close(swagDB);
    
    NSLog(@"imageLocArray=%@",imageLocArray);
    NSLog(@"imageCharArray=%@",imageCharArray);
    NSLog(@"charArr=%@",self.charArray);
    NSLog(@"CharPointArr=%@",self.charPointArray);
}

-(void)scrableBoard
{
    // Set up the image we want to scroll & zoom and add it to the scroll view
    UIImage *image1 = [UIImage imageNamed:@"scrableBoard.png"];
    self.imageView = [[UIImageView alloc] initWithImage:image1];
    self.imageView.frame = CGRectMake(0, 0, 600, 600);//(CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=image.size};
    self.imageView.tag=500;
    self.imageView.userInteractionEnabled=YES;
    [self.scrollView addSubview:self.imageView];
    for (UIImageView *imageview in self.view.subviews)
    {
        if (imageview.tag==1||imageview.tag==2||imageview.tag==3||imageview.tag==4||imageview.tag==5||imageview.tag==6||imageview.tag==7)
        {
            [imageview removeFromSuperview];
        }
    }

    
    /*--------------- Adding buttons on scroll view -----------------*/
    int x=0;
    int y=0;
    int w=40;
    int h=40;
    for(int i=1;i<226;i++)
    {
        mybutton=[UIButton buttonWithType:UIButtonTypeCustom];
        mybutton.frame=CGRectMake(x, y, w, h);
        mybutton.tag=i;
        mybutton.exclusiveTouch=YES;
        [mybutton addTarget:self action:@selector(wasDragged:withEvent:)forControlEvents:UIControlEventTouchDown];
        [self.imageView addSubview:mybutton];
        if([fixedLocArray containsObject:[NSString stringWithFormat:@"%d",i]])
        {
            [mybutton removeFromSuperview];
            UIImageView *fixedChar=[[UIImageView alloc]init];
            fixedChar.frame=CGRectMake(x, y, w, h);
           
            fixedChar.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@fix.png",[fixedCharArray objectAtIndex:[fixedLocArray indexOfObject:[NSString stringWithFormat:@"%d",i]]]]];
            if(!fixedChar.image)
            {
                fixedChar.image=[UIImage imageNamed:@"Jfix.png"];
            }
            [self.imageView addSubview:fixedChar];
        }

        x=x+w;
        if(x==600)
        {
            y=y+h;
            x=0;
        }
    }
    /*--------------- Adding ImageView with images -----------------*/
    x=16;
    for (int j=1; j<8; j++)
    {
        myImage=[[UIImageView alloc]init];
        myImage.frame=CGRectMake(x, 348, 40, 40);
        myImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[charArray objectAtIndex:j-1]]];
        myImage.tag=j;
        [self.view addSubview:myImage];
        x=x+41;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set up the minimum & maximum zoom scales
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = minScale;
    
    [self centerScrollViewContents];
}


- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setButtonBackroundView:nil];
    [self setCharImage:nil];
    [self setButtonView:nil];
    userName = nil;
    opponentName = nil;
    userScore = nil;
    opponentScore = nil;
    remainingLetters = nil;
    [self setShuffle:nil];
    lowerView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    if ([touches count] == 1) {
        // one finger
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        
        for (UIImageView *iView in self.view.subviews) {
            if ([iView isMemberOfClass:[UIImageView class]]) {
                if (touchPoint.x > iView.frame.origin.x &&
                    touchPoint.x < iView.frame.origin.x + iView.frame.size.width &&
                    touchPoint.y > iView.frame.origin.y &&
                    touchPoint.y < iView.frame.origin.y + iView.frame.size.height&&iView.tag>0&&iView.tag<8)
                {
                    NSLog(@"iView.Tag=%d",iView.tag);
                    self.dragObject = iView;
                    self.framePoint=CGPointMake(iView.frame.size.width, iView.frame.size.height);
                    self.touchOffset = CGPointMake(touchPoint.x - iView.frame.origin.x, 
                                                   touchPoint.y - iView.frame.origin.y);
                    self.homePosition = CGPointMake(iView.frame.origin.x, 
                                                    iView.frame.origin.y);
                    [self.view bringSubviewToFront:self.dragObject];
                    [self animateFirstTouchAtPoint:touchPoint forView:iView];
                    
                    sqlite3_stmt    *statement;
                    const char *dbpath = [databasePath UTF8String];
                    if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
                    {
                        NSString *querySQL = [NSString stringWithFormat:@"SELECT CHAR,COIN FROM IMAGE WHERE LOC=\'%d\'",iView.tag];
                        const char *query_stmt = [querySQL UTF8String];
                        if (sqlite3_prepare_v2(swagDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
                        {
                            while(sqlite3_step(statement) == SQLITE_ROW)
                            {
                               currentChar = [[NSString alloc]
                                                      initWithUTF8String:
                                                      (const char *) sqlite3_column_text(statement, 0)];
                                currentPoint=[[NSString alloc]
                                              initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 1)];
                                NSLog(@"Current Char=%@",currentChar);
                                NSLog(@"current Point=%@",currentPoint);
                            }
                           // sqlite3_finalize(statement);
                        }
                    
                    querySQL = [NSString stringWithFormat:@"DELETE FROM IMAGE WHERE LOC=\'%d\'",iView.tag];
                    query_stmt = [querySQL UTF8String];
                        sqlite3_prepare_v2(swagDB, query_stmt,-1, &statement, NULL);
                        if (sqlite3_step(statement) != SQLITE_DONE)
                        {
                            NSLog(@"Problem with prepare statement:  %s", sqlite3_errmsg(swagDB));
                        }
                        else
                        {
                            NSLog(@"Record Deleted");
                        }
                        
                    sqlite3_finalize(statement);
                                      sqlite3_close(swagDB);
                }
                }
            }
        }
        
        NSLog(@"Current Char=%@",currentChar);
        
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    CGRect newDragObjectFrame = CGRectMake(touchPoint.x - touchOffset.x, 
                                           touchPoint.y - touchOffset.y, 
                                           self.dragObject.frame.size.width, 
                                           self.dragObject.frame.size.height);
    self.dragObject.frame = newDragObjectFrame;
    if(touchPoint.y<self.scrollView.frame.size.height)
    {
       self.imageView.userInteractionEnabled=YES;
        CGFloat newZoomScale = self.scrollView.zoomScale * 2.0f;
        newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
        [self.scrollView setZoomScale:newZoomScale animated:YES];
        zoom=TRUE;
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.dropTarget.frame=CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y
                                     , self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    NSLog(@"object remove");
    [self.dragObject removeFromSuperview];

    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    NSLog(@"contentOffset%f",self.scrollView.contentOffset.x);
    NSLog(@"Contentoffset%f",self.scrollView.contentOffset.y);
    myImage = [[UIImageView alloc]init];
    if((int)self.homePosition.x%40!=0)
    {
        NSLog(@"postiong=%f",self.homePosition.x);
    }
    myImage.frame=CGRectMake(self.homePosition.x, self.homePosition.y,
                             40, 
                             40);
    
    NSLog(@"homeposition.x=%f",self.homePosition.x);
    NSLog(@"homeposition.y=%f",self.homePosition.y);
    if(self.homePosition.x<56)
        myImage.tag=1;
    else if(self.homePosition.x<97)
        myImage.tag=2;
    else if(self.homePosition.x<138)
        myImage.tag=3;
    else if(self.homePosition.x<179)
        myImage.tag=4;
    else if(self.homePosition.x<220)
        myImage.tag=5;
    else if(self.homePosition.x<261)
        myImage.tag=6;
    else if(self.homePosition.x<302)
        myImage.tag=7;
    
    currentImage=self.dragObject.image;
    // myImage.image=currentImage;
    NSLog(@"myImage.x=%f",myImage.frame.origin.x);
   // myImage.backgroundColor=[UIColor blackColor];
    if(((int)self.homePosition.x==16||(int)self.homePosition.x==57||(int)self.homePosition.x==98||(int)self.homePosition.x==139||(int)self.homePosition.x==180||(int)self.homePosition.x==221||(int)self.homePosition.x==262)&&(int)self.homePosition.y==348)
    {
    [self.view addSubview:myImage];
    }
    else
    {
        NSLog(@"False");
    }
    if (touchPoint.y <self.scrollView.frame.size.height )
    {
        int newTouchPointX=(int)touchPoint.x+self.scrollView.contentOffset.x;
        int newTouchPointY=(int)touchPoint.y+self.scrollView.contentOffset.y;
        int temp=newTouchPointX%40;
        int t=40-temp;
        int x=newTouchPointX+t;
        temp=newTouchPointY%40;
        int y=newTouchPointY-temp;
        NSLog(@"x=%d y=%d",x,y); 
        storeMyPoint=[NSString stringWithFormat:@"%d,%d",x,y];
        while ([storePoint containsObject:storeMyPoint])
        {
            x=x-40;
            storeMyPoint=[NSString stringWithFormat:@"%d,%d",x,y];
            if([storePoint containsObject:storeMyPoint])
            {
                y=y-40;
                storeMyPoint=[NSString stringWithFormat:@"%d,%d",x,y];
                if([storePoint containsObject:storeMyPoint])
                {
                    x=x+40;
                    storeMyPoint=[NSString stringWithFormat:@"%d,%d",x,y];
                    if([storePoint containsObject:storeMyPoint])
                    {
                        x=x+40;
                        y=y+40;
                        storeMyPoint=[NSString stringWithFormat:@"%d,%d",x,y];
                    }
                }
            }
        }
        [storePoint addObject:storeMyPoint];
        locButton=((y/40)*15)+((x/40)+1);
        NSLog(@"Current x=%d",x);
        NSLog(@"Current y=%d",y);
        NSLog(@"Loc Button=%d",locButton);
        [locArray addObject:[NSString stringWithFormat:@"%d",locButton]];
        [self imageButton:locButton];
        [self.dragObject removeFromSuperview];
        NSLog(@"touchPoint.x=%f",touchPoint.x);
        NSLog(@"touchPoint.y=%f",touchPoint.y);
        NSLog(@"dropTarget=%f",self.scrollView.frame.size.height);
        NSLog(@"LocArray=%@",locArray);
        sqlite3_stmt    *statement;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO BUTTON(LOC, CHAR, COIN) VALUES(\'%d\',\'%@\',\'%@\')",locButton,currentChar,currentPoint];
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(swagDB, insert_stmt,-1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
                
            {
                NSLog(@"Contact added");
            } else {
                NSLog(@"Failed to add contact");
            }
            sqlite3_finalize(statement);
            sqlite3_close(swagDB);
            
        }
    }
    else
    {
        int tag;
        NSLog(@"touchPoint=%f",touchPoint.y);
        NSLog(@"dropTarget=%f",self.scrollView.frame.size.height);
        if(touchPoint.y>310)
        {
            if(touchPoint.x<65)
                tag=1;
            else if(touchPoint.x<105)
                tag=2;
            else if(touchPoint.x<145)
                tag=3;
            else if(touchPoint.x<185)
                tag=4;
            else if(touchPoint.x<225)
                tag=5;
            else if(touchPoint.x<265)
                tag=6;
            else if(touchPoint.x<305)
                tag=7;
        }
        for (UIImageView *img in self.view.subviews) 
        {
            if (img.tag == tag&&img.tag>0&&img.tag<8)
            {
                if(img.image)
                {
                    NSLog(@"True");
                    UIImage *newImage=img.image;
                    sqlite3_stmt    *statement;
                    const char *dbpath = [databasePath UTF8String];
                    if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
                    {
                        NSString *querySQL = [NSString stringWithFormat:@"SELECT CHAR,COIN FROM IMAGE WHERE LOC=\'%d\'",img.tag];
                        const char *query_stmt = [querySQL UTF8String];
                        if (sqlite3_prepare_v2(swagDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
                        {
                            while(sqlite3_step(statement) == SQLITE_ROW)
                            {
                                oldChar = [[NSString alloc]
                                           initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 0)];
                                oldPoint=[[NSString alloc]
                                          initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 1)];
                                NSLog(@"Current Char=%@",currentChar);
                            }
                            sqlite3_finalize(statement);
                        }
                        querySQL = [NSString stringWithFormat:@"DELETE FROM IMAGE WHERE LOC=\'%d\'",img.tag];
                        query_stmt = [querySQL UTF8String];
                        sqlite3_prepare_v2(swagDB, query_stmt,-1, &statement, NULL);
                        if (sqlite3_step(statement) != SQLITE_DONE)
                        {
                            NSLog(@"Problem with prepare statement:  %s", sqlite3_errmsg(swagDB));
                        }
                        else
                        {
                            NSLog(@"Record Deleted");
                        }
                        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO IMAGE(LOC, CHAR,COIN) VALUES(\'%d\',\'%@\',\'%@\')",img.tag,currentChar,currentPoint];
                        const char *insert_stmt = [insertSQL UTF8String];
                        sqlite3_prepare_v2(swagDB, insert_stmt,-1, &statement, NULL);
                        if (sqlite3_step(statement) == SQLITE_DONE)
                            
                        {
                            NSLog(@"Contact added");
                        } else {
                            NSLog(@"Failed to add contact");
                        }
                        
                        
                        sqlite3_finalize(statement);
                        sqlite3_close(swagDB);
                    }

                    img.image=currentImage;
                    for (UIImageView *notImg in self.view.subviews)
                    {
                        if(notImg.tag!=tag&&notImg.tag!=0&&notImg.tag<8)
                        {
                            NSLog(@"NOt Image=%d",notImg.tag);
                            if(notImg.image)
                            {   
                                
                            }
                            else
                            {
                                sqlite3_stmt    *statement;
                                const char *dbpath = [databasePath UTF8String];
                                if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
                                {
                                    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO IMAGE(LOC, CHAR,COIN) VALUES(\'%d\',\'%@\',\'%@\')",notImg.tag,oldChar,oldPoint];
                                    const char *insert_stmt = [insertSQL UTF8String];
                                    sqlite3_prepare_v2(swagDB, insert_stmt,-1, &statement, NULL);
                                    if (sqlite3_step(statement) == SQLITE_DONE)
                                        
                                    {
                                        NSLog(@"Contact added");
                                    } else {
                                        NSLog(@"Failed to add contact");
                                    }
                                    sqlite3_finalize(statement);
                                    sqlite3_close(swagDB);
                                    
                                }

                                notImg.image=newImage;
                                break;
                            }
                            //                           tag=notImg.tag;
                        }       
                    }
                    
                }
                else {
                    NSLog(@"False");
                    
                    img.image=currentImage;
                    currentImage=nil;
                    sqlite3_stmt    *statement;
                    const char *dbpath = [databasePath UTF8String];
                    if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
                    {
                        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO IMAGE(LOC, CHAR,COIN) VALUES(\'%d\',\'%@\',\'%@\')",img.tag,currentChar,currentPoint];
                        const char *insert_stmt = [insertSQL UTF8String];
                        sqlite3_prepare_v2(swagDB, insert_stmt,-1, &statement, NULL);
                        if (sqlite3_step(statement) == SQLITE_DONE)
                            
                        {
                            NSLog(@"Contact added");
                        } else {
                            NSLog(@"Failed to add contact");
                        }
                        sqlite3_finalize(statement);
                        sqlite3_close(swagDB);
                        
                    }

                }
            }
        }
        
       
        
        
                   
        NSLog(@"touchPoint=%f",touchPoint.y);
        NSLog(@"dropTarget=%f",self.scrollView.frame.size.height);
    }
    self.dragObject.image=nil;
    self.homePosition=CGPointZero;
    
}

-(void)animateFirstTouchAtPoint:(CGPoint)touchPoint forView:(UIImageView *)theView
{
    // Pulse the view by scaling up, then move the view to under the finger.
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.15];
	theView.transform = CGAffineTransformMakeScale(1.8, 1.8);
	[UIView commitAnimations];
   
    
}
-(void)animate:(CGPoint)touchPoint forView:(UIButton *)button
{
    // Pulse the view by scaling up, then move the view to under the finger.
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.15];
	button.transform = CGAffineTransformMakeScale(1.8, 1.8);
	[UIView commitAnimations];
}
-(void)animateView:(UIView *)theView toPosition:(CGPoint)thePosition
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.15];
	// Set the center to the final postion
	//theView.center = thePosition;
    CGPoint newPoint=CGPointMake(thePosition.x+self.framePoint.x/2, thePosition.y+self.framePoint.y/2);
    theView.center=newPoint;
	// Set the transform back to the identity, thus undoing the previous scaling effect.
	theView.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}
- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer 
{
    
    // Get the location within the image view where we tapped
    // CGPoint pointInView = [recognizer locationInView:self.imageView];
    
    // Get a zoom scale that's zoomed in slightly, capped at the maximum zoom scale specified by the scroll view
    if(zoom)
    {
        self.imageView.userInteractionEnabled=NO;
        CGFloat newZoomScale = self.scrollView.zoomScale * 0.0f;
        // newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
        newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
        [self.scrollView setZoomScale:newZoomScale animated:YES];
        zoom=FALSE;
    }
    else
    {
        self.imageView.userInteractionEnabled=YES;
        CGFloat newZoomScale = self.scrollView.zoomScale * 2.0f;
        // newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
        newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
        [self.scrollView setZoomScale:newZoomScale animated:YES];
        zoom=TRUE;
    }
    // Figure out the rect we want to zoom to, then zoom to it
    //    CGSize scrollViewSize = self.scrollView.bounds.size;
    //    
    //    CGFloat w = scrollViewSize.width / newZoomScale;
    //    CGFloat h = scrollViewSize.height / newZoomScale;
    //    CGFloat x = pointInView.x - (w / 2.0f);
    //    CGFloat y = pointInView.y - (h / 2.0f);
    //    
    //   // CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    //    
    //    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
    
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer 
{
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    if(zoom)
    {
        self.imageView.userInteractionEnabled=NO;
        CGFloat newZoomScale = self.scrollView.zoomScale * 0.0f;
        // newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
        newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
        [self.scrollView setZoomScale:newZoomScale animated:YES];
        zoom=FALSE;
    }
    else
    {  
        self.imageView.userInteractionEnabled=YES;
        CGFloat newZoomScale = self.scrollView.zoomScale * 2.0f;
        // newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
        newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
        [self.scrollView setZoomScale:newZoomScale animated:YES];
        zoom=TRUE;
    }}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    [self centerScrollViewContents];
}
-(void)imageButton:(NSInteger)tag
{
    
    for (UIButton *button in self.imageView.subviews) 
    {
        if (button.tag == tag) 
        {
            [button setBackgroundImage:currentImage forState:UIControlStateNormal];
        }
    }
    currentImage=nil;
}
- (void)isDragged:(UIButton *)button withEvent:(UIEvent *)event
{
    UITouch *touch = [[event touchesForView:button] anyObject];
    //get delta
    CGPoint previousLocation = [touch previousLocationInView:button];
    CGPoint location = [touch locationInView:button];
    CGFloat delta_x = location.x - previousLocation.x;
    CGFloat delta_y = location.y - previousLocation.y;
    
    //move button
    button.center = CGPointMake(button.center.x + delta_x,button.center.y + delta_y);
    
    //    NSLog(@"button.center=%f",button.center.y);
    //    NSLog(@"superView=%@",button.superview);
    
}

- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event
{

	// get the touch
    NSLog(@"Was Dragged Width=%f",button.frame.size.width);
    if(button.currentBackgroundImage&&button.frame.size.width<70&&button.tag!=1)
    {
        int x;
        int y;
        currentTag=button.tag;
        NSLog(@"storePoint=%@",storePoint);
        NSLog(@"current Tag=%d",currentTag);
        int removex=((((button.tag%15))-1)*40);
        int removey=((button.tag/15)*40);
        NSLog(@"remove x=%d,y=%d",removex,removey);
        removeMyPoint=[NSString stringWithFormat:@"%d,%d",removex,removey];
        if([storePoint containsObject:removeMyPoint])
            [storePoint removeObject:removeMyPoint];
        NSLog(@"storePoint=%@",storePoint);
        
        //   [storePoint removeObject:storeMyPoint];
        self.homePosition = CGPointMake(button.frame.origin.x, button.frame.origin.y);
        UIButton *myButton=[[UIButton alloc]init];
        myButton=button;
        [myButton addTarget:self action:@selector(draggingStop:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"button.y=%f",button.frame.origin.y);
        NSLog(@"ContentOffset.y=%f",self.scrollView.contentOffset.y);
        NSString *tagString=[NSString stringWithFormat:@"%d",button.tag];
        if([buttonArray containsObject:tagString])
        {
            x=button.frame.origin.x;
            y=button.frame.origin.y;
            if(self.scrollView.contentOffset.x>0)
            {
                x=button.frame.origin.x-self.scrollView.contentOffset.x;
            }
            if(self.scrollView.contentOffset.y>0)
            {
                y=button.frame.origin.x-self.scrollView.contentOffset.y;
            }
            myButton.frame=CGRectMake(x,y, button.frame.size.width, button.frame.size.height);
        }
        else
        {
            
            x=button.frame.origin.x-20;
            y=button.frame.origin.y-20;
            if(self.scrollView.contentOffset.x>0)
            {
                x=button.frame.origin.x-self.scrollView.contentOffset.x-20;
            }
            if(self.scrollView.contentOffset.y>0)
            {
                y=button.frame.origin.y-self.scrollView.contentOffset.y-20;
            }
            myButton.frame=CGRectMake(x,y+53, button.frame.size.width+30, button.frame.size.height+30);
            [buttonArray addObject:tagString];   
        }
        NSLog(@"My button origin.x=%f,y=%f,w=%f,h=%f",myButton.frame.origin.x,myButton.frame.origin.y,myButton.frame.size.width,myButton.frame.size.height);
        NSLog(@"contentOffset x=%f",self.scrollView.contentOffset.x);
        NSLog(@"contentOffset y=%f",self.scrollView.contentOffset.y);
        
        [self.view addSubview:myButton];
        // [self.imageView addSubview:mybutton];
        [myButton addTarget:self action:@selector(isDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        [locArray removeObject:[NSString stringWithFormat:@"%d",currentTag]];
        //[self.scrollView addSubview:img];
        //[self animate:touchPoint forView:button];
        
        /*  UITouch *touch = [[event touchesForView:myButton] anyObject];
         //get delta
         CGPoint previousLocation = [touch previousLocationInView:myButton];
         CGPoint location = [touch locationInView:myButton];
         CGFloat delta_x = location.x - previousLocation.x;
         CGFloat delta_y = location.y - previousLocation.y;
         
         //move button
         myButton.center = CGPointMake(myButton.center.x + delta_x,myButton.center.y + delta_y);
         
         //    NSLog(@"button.center=%f",button.center.y);
         //    NSLog(@"superView=%@",button.superview);
         */
        //[self animateView:button toPosition:button.center];
        
        
        sqlite3_stmt    *statement;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat:@"SELECT CHAR,COIN FROM BUTTON WHERE LOC=\'%d\'",currentTag];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(swagDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    currentChar = [[NSString alloc]
                                   initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 0)];
                    currentPoint=[[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 1)];
                    NSLog(@"Current Char=%@",currentChar);
                }
                sqlite3_finalize(statement);
            }
            querySQL = [NSString stringWithFormat:@"DELETE FROM BUTTON WHERE LOC=\'%d\'",currentTag];
            query_stmt = [querySQL UTF8String];
            sqlite3_prepare_v2(swagDB, query_stmt,-1, &statement, NULL);
            if (sqlite3_step(statement) != SQLITE_DONE)
            {
                NSLog(@"Problem with prepare statement:  %s", sqlite3_errmsg(swagDB));
            }
            else
            {
                NSLog(@"Record Deleted");
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(swagDB);

            
        }

    }
}

-(void)draggingStop:(UIButton *)button withEvent:(UIEvent *)event
{
    NSLog(@"width=%f",button.frame.size.width);
    self.dropTarget.frame=CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y
                                     , self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    CGPoint touchPoint = CGPointMake(button.frame.origin.x, button.frame.origin.y);
    //    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    //NSLog(@"contentOffset%f",self.scrollView.contentOffset.x);
    //NSLog(@"Contentoffset%f",self.scrollView.contentOffset.y);
    currentImage=button.currentBackgroundImage;
    
    NSLog(@"currentImage=%@",currentImage);
    if (touchPoint.y <self.scrollView.frame.size.height ) 
    {
        int newTouchPointX=(int)touchPoint.x+self.scrollView.contentOffset.x;
        int newTouchPointY=(int)touchPoint.y+self.scrollView.contentOffset.y;
        int temp=newTouchPointX%40;
        int t=40-temp;
        int x=newTouchPointX+t;
        temp=newTouchPointY%40;
        int y=newTouchPointY-temp;
        
        storeMyPoint=[NSString stringWithFormat:@"%d,%d",x,y];
        //  NSString *stringX=[NSString stringWithFormat:@"%d",x];
        // NSString *stringY=[NSString stringWithFormat:@"%d",y];
        while ([storePoint containsObject:storeMyPoint])
        {
            
            x=x-40;
            storeMyPoint=[NSString stringWithFormat:@"%d,%d",x,y];
            if([storePoint containsObject:storeMyPoint])
            {
                y=y-40;
                storeMyPoint=[NSString stringWithFormat:@"%d,%d",x,y];
                if([storePoint containsObject:storeMyPoint])
                {
                    x=x+40;
                    storeMyPoint=[NSString stringWithFormat:@"%d,%d",x,y];
                    if([storePoint containsObject:storeMyPoint])
                    {
                        x=x+40;
                        y=y+40;
                        storeMyPoint=[NSString stringWithFormat:@"%d,%d",x,y];
                    }
                }
            }        }
        //[xArray addObject:stringX];
        //[yArray addObject:stringY];
        [storePoint addObject:storeMyPoint];
        locButton=((y/40)*15)+((x/40)+1);
        NSLog(@"Current x=%d",x);
        NSLog(@"Current y=%d",y);
        NSLog(@"Loc Button=%d",locButton);
        [locArray addObject:[NSString stringWithFormat:@"%d",locButton]];
        image=TRUE;
        //  [self imageButton:locButton];
        [button removeFromSuperview];
        [self.dragObject removeFromSuperview];
        NSLog(@"touchPoint.x=%f",touchPoint.x);
        NSLog(@"touchPoint.y=%f",touchPoint.y);
        NSLog(@"dropTarget=%f",self.scrollView.frame.size.height);
        
        sqlite3_stmt    *statement;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO BUTTON(LOC, CHAR, COIN) VALUES(\'%d\',\'%@\',\'%@\')",locButton,currentChar,currentPoint];
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(swagDB, insert_stmt,-1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
                
            {
                NSLog(@"Contact added");
            } else {
                NSLog(@"Failed to add contact");
            }
            sqlite3_finalize(statement);
            sqlite3_close(swagDB);
            
        }

        
    }
    else
    {
        int tag;
        NSLog(@"touchPoint=%f",touchPoint.y);
        NSLog(@"dropTarget=%f",self.scrollView.frame.size.height);
        [button removeFromSuperview];
        if(touchPoint.y>310)
        {
            if(touchPoint.x<30)
                tag=1;
            else if(touchPoint.x<75)
                tag=2;
            else if(touchPoint.x<120)
                tag=3;
            else if(touchPoint.x<165)
                tag=4;
            else if(touchPoint.x<210)
                tag=5;
            else if(touchPoint.x<255)
                tag=6;
            else if(touchPoint.x<300)
                tag=7;
        }
        
        for (UIImageView *img in self.view.subviews) 
        {
            NSLog(@"img.tag=%d",img.tag);
            
            if (img.tag == tag&&img.tag>0&&img.tag<8)
            {
                if(img.image)
                {
                    NSLog(@"True");
                    UIImage *newImage=img.image;
                    
                    sqlite3_stmt    *statement;
                    const char *dbpath = [databasePath UTF8String];
                    if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
                    {
                        NSString *querySQL = [NSString stringWithFormat:@"SELECT CHAR,COIN FROM IMAGE WHERE LOC=\'%d\'",img.tag];
                        const char *query_stmt = [querySQL UTF8String];
                        if (sqlite3_prepare_v2(swagDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
                        {
                            while(sqlite3_step(statement) == SQLITE_ROW)
                            {
                                oldChar = [[NSString alloc]
                                               initWithUTF8String:
                                               (const char *) sqlite3_column_text(statement, 0)];
                                oldPoint=[[NSString alloc]
                                              initWithUTF8String:
                                              (const char *) sqlite3_column_text(statement, 1)];
                                NSLog(@"Current Char=%@",currentChar);
                            }
                            sqlite3_finalize(statement);
                        }
                        querySQL = [NSString stringWithFormat:@"DELETE FROM IMAGE WHERE LOC=\'%d\'",img.tag];
                        query_stmt = [querySQL UTF8String];
                        sqlite3_prepare_v2(swagDB, query_stmt,-1, &statement, NULL);
                        if (sqlite3_step(statement) != SQLITE_DONE)
                        {
                            NSLog(@"Problem with prepare statement:  %s", sqlite3_errmsg(swagDB));
                        }
                        else
                        {
                            NSLog(@"Record Deleted");
                        }
                        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO IMAGE(LOC, CHAR,COIN) VALUES(\'%d\',\'%@\',\'%@\')",img.tag,currentChar,currentPoint];
                        const char *insert_stmt = [insertSQL UTF8String];
                        sqlite3_prepare_v2(swagDB, insert_stmt,-1, &statement, NULL);
                        if (sqlite3_step(statement) == SQLITE_DONE)
                            
                        {
                            NSLog(@"Contact added");
                        } else {
                            NSLog(@"Failed to add contact");
                        }

                        
                        sqlite3_finalize(statement);
                        sqlite3_close(swagDB);
                    }
                    
                    img.image=currentImage;
                    
                    for (UIImageView *notImg in self.view.subviews)
                    {
                        if(notImg.tag!=tag&&notImg.tag!=0&&notImg.tag<8)
                        {
                            NSLog(@"NOt Image=%d",notImg.tag);
                            if(notImg.image)
                            {   
                                
                            }
                            else
                            {
                                notImg.image=newImage;
                                sqlite3_stmt    *statement;
                                const char *dbpath = [databasePath UTF8String];
                                if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
                                {
                                    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO IMAGE(LOC, CHAR,COIN) VALUES(\'%d\',\'%@\',\'%@\')",notImg.tag,oldChar,oldPoint];
                                    const char *insert_stmt = [insertSQL UTF8String];
                                    sqlite3_prepare_v2(swagDB, insert_stmt,-1, &statement, NULL);
                                    if (sqlite3_step(statement) == SQLITE_DONE)
                                        
                                    {
                                        NSLog(@"Contact added");
                                    } else {
                                        NSLog(@"Failed to add contact");
                                    }
                                    sqlite3_finalize(statement);
                                    sqlite3_close(swagDB);
                                    
                                }

                               
                                break;
                            }
                            //                           tag=notImg.tag;
                        }       
                    }
                    
                }
                else
                {
                    NSLog(@"False");
                    img.image=currentImage;
                    currentImage=nil;
                    sqlite3_stmt    *statement;
                    const char *dbpath = [databasePath UTF8String];
                    if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
                    {
                        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO IMAGE(LOC, CHAR,COIN) VALUES(\'%d\',\'%@\',\'%@\')",img.tag,currentChar,currentPoint];
                        const char *insert_stmt = [insertSQL UTF8String];
                        sqlite3_prepare_v2(swagDB, insert_stmt,-1, &statement, NULL);
                        if (sqlite3_step(statement) == SQLITE_DONE)
                            
                        {
                            NSLog(@"Contact added");
                        } else {
                            NSLog(@"Failed to add contact");
                        }
                        sqlite3_finalize(statement);
                        sqlite3_close(swagDB);
                        
                    }

                }
                
            }
        }
        NSLog(@"Tag=%d",tag);
                
    }
    mybutton = [UIButton buttonWithType:UIButtonTypeCustom];
    mybutton.frame=CGRectMake(self.homePosition.x, self.homePosition.y,40,40);
    mybutton.tag=currentTag;
    
    [buttonArray removeObject:[NSString stringWithFormat:@"%d",currentTag]];
    mybutton.exclusiveTouch=YES;
    
    [mybutton addTarget:self action:@selector(wasDragged:withEvent:)forControlEvents:UIControlEventTouchDown];
    [self.imageView addSubview:mybutton];
    
    if(image)
    {
        [self imageButton:locButton];
        image=false;
    }
    
    NSLog(@"locArray=%@",locArray);
}

- (void)panEvent:(id)sender {
    mybutton.center = [sender locationInView:self.view];
}


- (IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)chat:(id)sender {
}

- (IBAction)play:(id)sender
{
    if(locArray.count>0)
    {
        if([locArray containsObject:@"113"]||[fixedLocArray containsObject:@"113"])
        {
            [wordsArray removeAllObjects];
            sortedLocArray=nil;
            totalPoint=0;
            myWord=[[NSMutableString alloc]init];
            [self ShowActivityIndicatorWithTitle:@"Checking..."];
        /*---------------- sorting location Array ----------------------*/
            sortedLocArray = [locArray sortedArrayUsingComparator: ^(id obj1, id obj2){
            if ([obj1 integerValue] > [obj2 integerValue])
            {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 integerValue] < [obj2 integerValue])
            {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;}];
    
            NSLog(@"locarray=%@",locArray);
            NSLog(@"Sorted Array=%@",sortedLocArray);
    
            First=[sortedLocArray objectAtIndex:0];
            NSString *second=[sortedLocArray objectAtIndex:1];
        
            if(First.intValue+1==second.intValue)
            {
                for(int i=0;i<sortedLocArray.count;i++)
                {
                    First=[sortedLocArray objectAtIndex:i];
                    if ([fixedLocArray containsObject:[NSString stringWithFormat:@"%d",First.intValue-15]])
                    {
                        [self VerticalPreviousChar:First.intValue-15];
                    }
            
                    sqlite3_stmt    *statement;
                    const char *dbpath = [databasePath UTF8String];
                    if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
                    {
                        NSString *querySQL;
                        const char *query_stmt;
                        querySQL = [NSString stringWithFormat:@"SELECT * FROM BUTTON WHERE LOC=\'%d\'",First.intValue];
                        query_stmt = [querySQL UTF8String];
                        if (sqlite3_prepare_v2(swagDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
                        {
                            while(sqlite3_step(statement) == SQLITE_ROW)
                            {
                                [myWord appendString:[NSString stringWithString:[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
                                totalPoint=totalPoint+[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)].intValue;
                                NSLog(@"myWord=%@",myWord);
                                NSLog(@"total point=%d",totalPoint);
                            }
                            sqlite3_finalize(statement);
                        }
                    }

            
                    if ([fixedLocArray containsObject:[NSString stringWithFormat:@"%d",First.intValue+15]])
                    {
                        [self VerticalNextChar:First.intValue+15];
                    }
            
                    NSUInteger characterCount = [myWord length];
                    NSLog(@"Count=%d",characterCount);
                    if(characterCount!=1)
                        [wordsArray addObject:myWord];
                    myWord=[[NSMutableString alloc]init];
            
                }
            }
    
            else if(First.intValue+15==second.intValue)
            {
                for(int i=0;i<sortedLocArray.count;i++)
                {
                    First=[sortedLocArray objectAtIndex:i];
                    NSLog(@"First=%@",First);
                    if ([fixedLocArray containsObject:[NSString stringWithFormat:@"%d",First.intValue-1]])
                    {
                        [self HorizantalPreviousChar:First.intValue-1];
                    }
            
                    sqlite3_stmt    *statement;
                    const char *dbpath = [databasePath UTF8String];
                    if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
                    {
                        NSString *querySQL;
                        const char *query_stmt;
                        querySQL = [NSString stringWithFormat:@"SELECT * FROM BUTTON WHERE LOC=\'%d\'",First.intValue];
                        query_stmt = [querySQL UTF8String];
                        if (sqlite3_prepare_v2(swagDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
                        {
                    
                            while(sqlite3_step(statement) == SQLITE_ROW)
                            {
                                [myWord appendString:[NSString stringWithString:[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
                                totalPoint=totalPoint+[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)].intValue;
                                NSLog(@"myWord=%@",myWord);
                                NSLog(@"total point=%d",totalPoint);
                            }
                            sqlite3_finalize(statement);
                        }
                    }

                    if ([fixedLocArray containsObject:[NSString stringWithFormat:@"%d",First.intValue+1]])
                    {
                        [self HorizantalNextChar:First.intValue+1];
                    }
            
                    NSUInteger characterCount = [myWord length];
                    NSLog(@"Count=%d",characterCount);
                    if(characterCount!=1)
                        [wordsArray addObject:myWord];
                    myWord=[[NSMutableString alloc]init];
                }
            }
    
            First=[sortedLocArray objectAtIndex:0];
            NSString *returnWord=[self CheckWord:First.intValue];
            if(returnWord)
            {
                [wordsArray addObject:returnWord];
                NSString *mywords=[wordsArray componentsJoinedByString:@","];
                NSLog(@"wordsArray=%@",wordsArray);
                NSLog(@"mywords=%@",mywords);
                [self validWords:mywords];
            }
        }
        else
        {
            msgLabel.frame=CGRectMake(11, 33, 210, 56);
            msgLabel.text=@"Sorry, the first word played must cross the center star.";
            msgLabel.textAlignment=UITextAlignmentLeft;
            msgLabel.textColor=[UIColor whiteColor];
            msgLabel.font=[UIFont systemFontOfSize:14];
            
            [popView addSubview:invalidMoveLabel];
            [popView addSubview:msgLabel];
            [popView addSubview:okButton];
            [myView addSubview:popView];
            [self.view addSubview:myView];
            [self.view bringSubviewToFront:myView];
            for (UIImageView *imageview in self.view.subviews)
            {
                if (imageview.tag==1||imageview.tag==2||imageview.tag==3||imageview.tag==4||imageview.tag==5||imageview.tag==6||imageview.tag==7)
                {
                    [imageview removeFromSuperview];
                }
            }

        }
    }
}

-(NSString *)CheckWord:(int)loc1
{
    /*-------------------------- Checking Valid and Invalid tile placement ----------------------*/
    First=[NSString stringWithFormat:@"%d",loc1];
    NSString *second=[sortedLocArray objectAtIndex:1];
    
    if([fixedLocArray containsObject:[NSString stringWithFormat:@"%d",First.intValue-1]])
    {
        [self HorizantalPreviousChar:First.intValue-1];
    }
    if([fixedLocArray containsObject:[NSString stringWithFormat:@"%d",First.intValue-15]])
    {
        [self VerticalPreviousChar:First.intValue-15];
    }
    
    if ([fixedLocArray containsObject:[NSString stringWithFormat:@"%d",First.intValue+1]])
    {
        sqlite3_stmt    *statement;
        
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
        {
            NSString *querySQL;
            const char *query_stmt;
            querySQL = [NSString stringWithFormat:@"SELECT * FROM BUTTON WHERE LOC=\'%d\'",First.intValue];
            query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(swagDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    [myWord appendString:[NSString stringWithString:[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
                    totalPoint=totalPoint+[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)].intValue;
                    NSLog(@"myWord=%@",myWord);
                    NSLog(@"total point=%d",totalPoint);
                }
                sqlite3_finalize(statement);
            }
        }
        [self HorizantalNextChar:First.intValue+1];
    }
    
    if ([fixedLocArray containsObject:[NSString stringWithFormat:@"%d",First.intValue+15]])
    {
        sqlite3_stmt    *statement;
        
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
        {
            NSString *querySQL;
            const char *query_stmt;
            querySQL = [NSString stringWithFormat:@"SELECT * FROM BUTTON WHERE LOC=\'%d\'",First.intValue];
            query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(swagDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    [myWord appendString:[NSString stringWithString:[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
                    totalPoint=totalPoint+[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)].intValue;
                    NSLog(@"myWord=%@",myWord);
                    NSLog(@"total point=%d",totalPoint);
                }
                sqlite3_finalize(statement);
            }
        }
        [self VerticalNextChar:First.intValue+15];
    }
    
    if(First.intValue+15==second.intValue)  //Checking Vertically
    {
        for (int i=1; i<sortedLocArray.count; i++)
        {
            second=[sortedLocArray objectAtIndex:i];
            NSLog(@"First=%@",First);
            NSLog(@"Second=%@",second);
            sqlite3_stmt    *statement;
            
            const char *dbpath = [databasePath UTF8String];
            if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
            {
                NSString *querySQL;
                const char *query_stmt;
                querySQL = [NSString stringWithFormat:@"SELECT * FROM BUTTON WHERE LOC=\'%d\'",First.intValue];
                query_stmt = [querySQL UTF8String];
                if (sqlite3_prepare_v2(swagDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    
                    while(sqlite3_step(statement) == SQLITE_ROW)
                    {
                        [myWord appendString:[NSString stringWithString:[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
                        totalPoint=totalPoint+[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)].intValue;
                        NSLog(@"myWord=%@",myWord);
                        NSLog(@"total point=%d",totalPoint);
                    }
                    sqlite3_finalize(statement);
                }
            }
            
            
            
            
            if(First.intValue+15==second.intValue)
            {
                First=second;
                if(i==sortedLocArray.count-1)
                {
                    if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
                    {
                        NSString *querySQL;
                        const char *query_stmt;
                        querySQL = [NSString stringWithFormat:@"SELECT * FROM BUTTON WHERE LOC=\'%d\'",second.intValue];
                        query_stmt = [querySQL UTF8String];
                        if (sqlite3_prepare_v2(swagDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
                        {
                            
                            while(sqlite3_step(statement) == SQLITE_ROW)
                            {
                                [myWord appendString:[NSString stringWithString:[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
                                totalPoint=totalPoint+[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)].intValue;
                                NSLog(@"myWord=%@",myWord);
                                NSLog(@"total point=%d",totalPoint);
                            }
                            sqlite3_finalize(statement);
                        }
                    }
                    if([fixedLocArray containsObject:[NSString stringWithFormat:@"%d",First.intValue+15]])
                    {
                        [self VerticalNextChar:First.intValue+15];
                    }
                    
                   // [self validWords];
                }
            }
            else
            {
                NSLog(@"First=%@",First);
                if([fixedLocArray containsObject:[NSString stringWithFormat:@"%d",First.intValue+15]])
                {
                    [self VerticalNextChar:First.intValue+15];
                    i--;
                }
                else
                {
                    msgLabel.frame=CGRectMake(11, 33, 210, 56);
                    msgLabel.text=@"Sorry, must place all tiles in one row or column.";
                    msgLabel.textAlignment=UITextAlignmentLeft;
                    msgLabel.textColor=[UIColor whiteColor];
                    msgLabel.font=[UIFont systemFontOfSize:14];

                    [popView addSubview:invalidMoveLabel];
                    [popView addSubview:msgLabel];
                    [popView addSubview:okButton];
                    [myView addSubview:popView];
                    [self.view addSubview:myView];
                    [self.view bringSubviewToFront:myView];
                    for (UIImageView *imageview in self.view.subviews)
                    {
                        if (imageview.tag==1||imageview.tag==2||imageview.tag==3||imageview.tag==4||imageview.tag==5||imageview.tag==6||imageview.tag==7)
                        {
                            [imageview removeFromSuperview];
                        }
                    }
                   // UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Invalid Move" message:@"Sorry, must place all tiles in one row or column" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                   // [alert show];
                    [self HideActivityIndicator];
                    return 0;
                    break;
                }
            }
        }
        
    }
    
    else if(First.intValue+1==second.intValue)//Checking Horizantally
    {
        
        for (int i=1; i<sortedLocArray.count; i++)
        {
            second=[sortedLocArray objectAtIndex:i];
            NSLog(@"First=%@",First);
            NSLog(@"Second=%@",second);
            sqlite3_stmt    *statement;
            
            const char *dbpath = [databasePath UTF8String];
            if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
            {
                NSString *querySQL;
                const char *query_stmt;
                querySQL = [NSString stringWithFormat:@"SELECT * FROM BUTTON WHERE LOC=\'%d\'",First.intValue];
                query_stmt = [querySQL UTF8String];
                if (sqlite3_prepare_v2(swagDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    
                    while(sqlite3_step(statement) == SQLITE_ROW)
                    {
                        [myWord appendString:[NSString stringWithString:[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
                        totalPoint=totalPoint+[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)].intValue;
                        NSLog(@"myWord=%@",myWord);
                        NSLog(@"total point=%d",totalPoint);
                    }
                    sqlite3_finalize(statement);
                }
            }
            
            
            if(First.intValue+1==second.intValue)
            {
                First=second;
                if(i==sortedLocArray.count-1)
                {
                    if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
                    {
                        NSString *querySQL;
                        const char *query_stmt;
                        querySQL = [NSString stringWithFormat:@"SELECT * FROM BUTTON WHERE LOC=\'%d\'",second.intValue];
                        query_stmt = [querySQL UTF8String];
                        if (sqlite3_prepare_v2(swagDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
                        {
                            
                            while(sqlite3_step(statement) == SQLITE_ROW)
                            {
                                [myWord appendString:[NSString stringWithString:[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
                                totalPoint=totalPoint+[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)].intValue;
                                NSLog(@"myWord=%@",myWord);
                                NSLog(@"total point=%d",totalPoint);
                            }
                            sqlite3_finalize(statement);
                        }
                    }
                    if([fixedLocArray containsObject:[NSString stringWithFormat:@"%d",First.intValue+1]])
                    {
                        [self HorizantalNextChar:First.intValue+1];
                    }
                    
                   // [self validWords];
                }
                
            }
            else
            {
                if([fixedLocArray containsObject:[NSString stringWithFormat:@"%d",First.intValue+1]])
                {
                    [self HorizantalNextChar:First.intValue+1];
                    i--;
                }
                else
                {
                    msgLabel.frame=CGRectMake(11, 33, 210, 56);
                    msgLabel.text=@"Sorry, must place all tiles in one row or column.";
                    msgLabel.textAlignment=UITextAlignmentLeft;
                    msgLabel.textColor=[UIColor whiteColor];
                    msgLabel.font=[UIFont systemFontOfSize:14];

                    [popView addSubview:invalidMoveLabel];
                    [popView addSubview:msgLabel];
                    [popView addSubview:okButton];
                    [myView addSubview:popView];
                    [self.view addSubview:myView];
                    [self.view bringSubviewToFront:myView];
                    for (UIImageView *imageview in self.view.subviews)
                    {
                        if (imageview.tag==1||imageview.tag==2||imageview.tag==3||imageview.tag==4||imageview.tag==5||imageview.tag==6||imageview.tag==7)
                        {
                            [imageview removeFromSuperview];
                        }
                    }


                  //  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Invalid Move" message:@"Sorry, must place all tiles in one row or column" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                  //  [alert show];
                    [self HideActivityIndicator];
                    return 0;
                    break;
                }
            }
        }
    }
    else
    {
       // if ([fixedLocArray containsObject:[NSString stringWithFormat:@"%d",First.intValue-1]] )
      //  {
      //      [self HorizantalPreviousChar:First.intValue-1];
      //  }
      //  if ([fixedLocArray containsObject:[NSString stringWithFormat:@"%d",First.intValue-15]] )
       // {
       //     [self VerticalPreviousChar:First.intValue-15];
      //  }
        msgLabel.frame=CGRectMake(11, 33, 210, 56);
        msgLabel.text=@"Sorry, must place all tiles in one row or column.";
        msgLabel.textAlignment=UITextAlignmentLeft;
        msgLabel.textColor=[UIColor whiteColor];
        msgLabel.font=[UIFont systemFontOfSize:14];

        [popView addSubview:invalidMoveLabel];
        [popView addSubview:msgLabel];
        [popView addSubview:okButton];
        [myView addSubview:popView];
        [self.view addSubview:myView];
        [self.view bringSubviewToFront:myView];
        for (UIImageView *imageview in self.view.subviews)
        {
            if (imageview.tag==1||imageview.tag==2||imageview.tag==3||imageview.tag==4||imageview.tag==5||imageview.tag==6||imageview.tag==7)
            {
                [imageview removeFromSuperview];            }
        }


        //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Invalid Move" message:@"Sorry, must place all tiles in one row or column" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[alert show];
        [self HideActivityIndicator];
        return 0;
    }

    return myWord;
}

-(void)HorizantalPreviousChar:(int)loc
{
    prevCounter=0;
    while ([fixedLocArray containsObject:[NSString stringWithFormat:@"%d",loc]])
    {
        prevCounter++;
        loc=loc-1;
        NSLog(@"Loc=%d",loc);
    }
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    int i;
    if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
    {
        NSString *querySQL;
        const char *query_stmt;
       
        for( i=loc+1;i<=loc+prevCounter;i++)
        {
            [fixedLocArray removeObject:[NSString stringWithFormat:@"%d",i]];
            querySQL = [NSString stringWithFormat:@"SELECT * FROM FIXED WHERE LOC=\'%d\'",i];
            query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(swagDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
            
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    [myWord appendString:[NSString stringWithString:[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
                    totalPoint=totalPoint+[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)].intValue;
                    NSLog(@"myWord=%@",myWord);
                    NSLog(@"total point=%d",totalPoint);
                }
                sqlite3_finalize(statement);
            }
        }
    }
    First=[NSString stringWithFormat:@"%d",i];
    NSLog(@"First=%@",First);
    
}

-(void)HorizantalNextChar:(int)loc
{
    while ([fixedLocArray containsObject:[NSString stringWithFormat:@"%d",First.intValue+1]])
    {
        First=[NSString stringWithFormat:@"%d",First.intValue+1];
        NSLog(@"First=%@",First);
        sqlite3_stmt    *statement;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
        {
            NSString *querySQL;
            const char *query_stmt;
            [fixedLocArray removeObject:First];
            querySQL = [NSString stringWithFormat:@"SELECT * FROM FIXED WHERE LOC=\'%d\'",First.intValue];
            query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(swagDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    [myWord appendString:[NSString stringWithString:[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
                    totalPoint=totalPoint+[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)].intValue;
                    NSLog(@"myWord=%@",myWord);
                    NSLog(@"total point=%d",totalPoint);
                }
                sqlite3_finalize(statement);
            }
        }
    }

}

-(void)VerticalPreviousChar:(int)loc
{
    prevCounterVertical=0;
    while ([fixedLocArray containsObject:[NSString stringWithFormat:@"%d",loc]])
    {
        prevCounterVertical=prevCounterVertical+15;
        loc=loc-15;
        NSLog(@"Loc=%d",loc);
    }
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    int i;
    if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
    {
        NSString *querySQL;
        const char *query_stmt;
        
        for( i=loc+15;i<=loc+prevCounterVertical;i=i+15)
        {
            [fixedLocArray removeObject:[NSString stringWithFormat:@"%d",i]];
            querySQL = [NSString stringWithFormat:@"SELECT * FROM FIXED WHERE LOC=\'%d\'",i];
            query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(swagDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    [myWord appendString:[NSString stringWithString:[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
                    totalPoint=totalPoint+[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)].intValue;
                    NSLog(@"myWord=%@",myWord);
                    NSLog(@"total point=%d",totalPoint);
                }
                sqlite3_finalize(statement);
            }
        }
    }
    First=[NSString stringWithFormat:@"%d",i];
    NSLog(@"First=%@",First);
    
}

-(void)VerticalNextChar:(int)loc
{
    while ([fixedLocArray containsObject:[NSString stringWithFormat:@"%d",First.intValue+15]])
    {
        First=[NSString stringWithFormat:@"%d",First.intValue+15];
        NSLog(@"First=%@",First);
        sqlite3_stmt    *statement;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
        {
            NSString *querySQL;
            const char *query_stmt;
            [fixedLocArray removeObject:First];
            querySQL = [NSString stringWithFormat:@"SELECT * FROM FIXED WHERE LOC=\'%d\'",First.intValue];
            query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(swagDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    [myWord appendString:[NSString stringWithString:[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
                    totalPoint=totalPoint+[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)].intValue;
                    NSLog(@"myWord=%@",myWord);
                    NSLog(@"total point=%d",totalPoint);
                }
                sqlite3_finalize(statement);
            }
        }
    }
    
}


/*-------------------------- Checking Words  is valid or not -------------------------*/
-(void)validWords:(NSString *)mywords
{
   /*----------- Fetching character, location and point from database -----------------------*/
    NSLog(@"Valid Words");
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
    {
        NSString *querySQL;
        const char *query_stmt;
        for(int i=0;i<sortedLocArray.count;i++)
        {
        querySQL = [NSString stringWithFormat:@"SELECT * FROM BUTTON WHERE LOC=\'%@\'",[sortedLocArray objectAtIndex:i]];
        query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(swagDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
           
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                [buttonLocArray addObject:[[NSString alloc]
                               initWithUTF8String:
                               (const char *) sqlite3_column_text(statement, 0)]];
                [buttonCharArray addObject:[[NSString alloc]
                                           initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 1)]];
                [buttonCoinArray addObject:[[NSString alloc]
                                            initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 2)]];
               //  [myWord appendString:[NSString stringWithString:[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
              //  totalPoint=totalPoint+[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)].intValue;
             //   NSLog(@"myWord=%@",myWord);
            //    NSLog(@"total point=%d",totalPoint);
            }
            sqlite3_finalize(statement);
        }
        }
        charArray=[[NSMutableArray alloc]init];
        charPointArray=[[NSMutableArray alloc]init];
        querySQL = [NSString stringWithFormat:@"SELECT * FROM IMAGE"];
            query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(swagDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    [self.charArray addObject:[[NSString alloc]
                                               initWithUTF8String:
                                               (const char *) sqlite3_column_text(statement, 1)]];
                    [self.charPointArray addObject:[[NSString alloc]
                                               initWithUTF8String:
                                               (const char *) sqlite3_column_text(statement, 2)]];
                }
                sqlite3_finalize(statement);
            }

        
        
        sqlite3_close(swagDB);
        gameCharacter = [buttonCharArray componentsJoinedByString:@","];
        gameCharPos = [buttonLocArray componentsJoinedByString:@","];
    }
/*------------------------ Sending/Receiving data from server  to check valid words-------------------------*/
     NSLog(@"ButtonLocArray=%@ buttonCharArray=%@ buttonCoinArray=%@",buttonLocArray,buttonCharArray,buttonCoinArray);
     NSString *post =[[NSString alloc] initWithFormat:@"access_token=%@&game_word=%@&mode=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"],mywords,[[NSUserDefaults standardUserDefaults]valueForKey:@"gameMode"]];
     NSURL *url=[NSURL URLWithString:@"http://23.23.78.187/swwf/check_words.php"];
     NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
     NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
     [request setURL:url];
     [request setHTTPMethod:@"POST"];
     [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
     [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
     [request setHTTPBody:postData];
     NSError *error;
     NSURLResponse *response;
     NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
     if (data)
     {
     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
     NSLog(@"json is %@",json);
         NSArray *validwords=[json valueForKey:@"valid words"];
         NSArray *invalideWords=[json valueForKey:@"invalid words"];
         if(validwords)
         {
              msgLabel.frame=CGRectMake(15, 33, 200, 56);
             msgLabel.text=[NSString stringWithFormat:@"Send Move to '%@'?",self.opponentNameString];
             msgLabel.textColor=[UIColor yellowColor];
             msgLabel.textAlignment=UITextAlignmentCenter;
             msgLabel.font=[UIFont boldSystemFontOfSize:16];
             [popView addSubview:msgLabel];
             [popView addSubview:yesButton];
             [popView addSubview:noButton];
             [myView addSubview:popView];
             [self.view addSubview:myView];
             [self.view bringSubviewToFront:myView];
             for (UIImageView *imageview in self.view.subviews)
             {
                 if (imageview.tag==1||imageview.tag==2||imageview.tag==3||imageview.tag==4||imageview.tag==5||imageview.tag==6||imageview.tag==7)
                 {
                     [imageview removeFromSuperview];
                 }
             }

             
             [self HideActivityIndicator];
         }
         else if(invalideWords)
         {
             NSString *invalidwords=[invalideWords componentsJoinedByString:@","];
             msgLabel.text=[NSString stringWithFormat:@"Sorry,'%@' may be misspelled or may be a proper noun",invalidwords];
             msgLabel.frame=CGRectMake(11, 33, 210, 56);
             msgLabel.textAlignment=UITextAlignmentLeft;
             msgLabel.textColor=[UIColor whiteColor];
             msgLabel.font=[UIFont systemFontOfSize:14];
             [popView addSubview:invalidMoveLabel];
             [popView addSubview:msgLabel];
             [popView addSubview:okButton];
             [myView addSubview:popView];
             [self.view addSubview:myView];
             [self.view bringSubviewToFront:myView];
             for (UIImageView *imageview in self.view.subviews)
             {
                 if (imageview.tag==1||imageview.tag==2||imageview.tag==3||imageview.tag==4||imageview.tag==5||imageview.tag==6||imageview.tag==7)
                 {
                     [imageview removeFromSuperview];
                 }
             }
            // UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Invalid Move" message:[NSString stringWithFormat:@"Sorry,'%@' may be misspelled or may be a proper noun",invalidwords] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             //[alert show];
             [self HideActivityIndicator];
             NSLog(@"Invalid Words=%@",invalideWords);
             [buttonCharArray removeAllObjects];
             [buttonCoinArray removeAllObjects];
             [buttonLocArray removeAllObjects];
             [wordsArray removeAllObjects];
         }
     }
 }

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if(alertView.tag==1)
    {
        if(buttonIndex==1)
        {
            [self ShowActivityIndicatorWithTitle:@"Sending..."];
            NSLog(@"Word Send");
            NSLog(@"game id=%@",self.gameId);
            NSLog(@"game Character=%@",gameCharacter);
            NSLog(@"game char Pos=%@",gameCharPos);
            
            NSString *post =[[NSString alloc] initWithFormat:@"access_token=%@&game=%@&coins=%@&game_word=%@&game_character=%@&game_character_pos=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"],self.gameId,[NSString stringWithFormat:@"%d",totalPoint],validWord,gameCharacter,gameCharPos];
            NSURL *url=[NSURL URLWithString:@"http://23.23.78.187/swwf/complete.php"];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"ratecount"]+1  forKey:@"ratecount"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSError *error;
            NSURLResponse *response;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            if(data)
            {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSLog(@"json is %@",json);
                NSDictionary *characterArray=[json objectForKey:@"character_array"];
                NSArray *coins=[characterArray valueForKey:@"coins"];
                NSArray *newChar=[characterArray valueForKey:@"name"];
                [self.charArray addObjectsFromArray:newChar];
                [self.charPointArray addObjectsFromArray:coins];
                NSLog(@"Char Array=%@",self.charArray);
                NSLog(@"char Point Array=%@",self.charPointArray);
                [fixedLocArray addObjectsFromArray:buttonLocArray];
                [fixedCharArray addObjectsFromArray:buttonCharArray];
                [self.imageView removeFromSuperview];
                [self DataBase];
                [self scrableBoard];
                userScore.text=[NSString stringWithFormat:@"%d",totalPoint];
                [self HideActivityIndicator];
                
            }
                        
        }
        
    }
    
}

- (IBAction)pass:(id)sender {
}


- (IBAction)shuffle:(id)sender {
}

- (IBAction)swap:(id)sender {
}

- (IBAction)recall:(id)sender
{
    NSLog(@"Recall");
    const char *dbpath = [databasePath UTF8String];
    [imageLocArray removeAllObjects];
    [imageCharArray removeAllObjects];
    [imageCoinArray removeAllObjects];
    [buttonCharArray removeAllObjects];
    [buttonCoinArray removeAllObjects];
    [buttonLocArray removeAllObjects];
    if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
    {
        NSString *querySQL;
        querySQL = [NSString stringWithFormat:@"SELECT * FROM IMAGE"];
        const char *query_stmt = [querySQL UTF8String];
        // const char *sql = "SELECT * FROM  data WHERE date=\"%@\"",currentDate;
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(swagDB, query_stmt, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            // NSLog(@"Problem with prepare statement:  %@", sqlite3_errmsg(db));
        }else
        {
            while (sqlite3_step(sqlStatement)==SQLITE_ROW)
            {
                [imageLocArray addObject:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,0)]];
            }
        }
        
        querySQL = [NSString stringWithFormat:@"SELECT * FROM BUTTON"];
        query_stmt = [querySQL UTF8String];
        // const char *sql = "SELECT * FROM  data WHERE date=\"%@\"",currentDate;
        if(sqlite3_prepare(swagDB, query_stmt, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            // NSLog(@"Problem with prepare statement:  %@", sqlite3_errmsg(db));
        }else
        {
            while (sqlite3_step(sqlStatement)==SQLITE_ROW)
            {
                [buttonLocArray addObject:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,0)]];
                [buttonCharArray addObject:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)]];
                [buttonCoinArray addObject:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,2)]];
            }
        }
        sqlite3_finalize(sqlStatement);
        sqlite3_close(swagDB);
    }
    
    NSMutableArray *wArray=[[NSMutableArray alloc]init];
    for (int i=1; i<8; i++)
    {
        if(![imageLocArray containsObject:[NSString stringWithFormat:@"%d",i]])
        {
            [wArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    NSLog(@"ButtonLocArray=%@ wArray=%@ buttonChar=%@",buttonLocArray,wArray,buttonCharArray);
    
    UIImageView *imageToMove=[[UIImageView alloc]init];
    for(int i=0; i<buttonLocArray.count; i++)
    {
        
        imageToMove.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[buttonCharArray objectAtIndex:i]]];
      //  imageToMove.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[buttonCharArray objectAtIndex:i]]];
        NSString *loc=[buttonLocArray objectAtIndex:i];
        int x=((((loc.intValue %15))-1)*40);
        int y=((loc.intValue/15)*40)+20;
        if(self.scrollView.contentOffset.x>0)
        {
            x=x-self.scrollView.contentOffset.x;
        }
        if(self.scrollView.contentOffset.y>0)
        {
            y=y-self.scrollView.contentOffset.y;
        }
        
        imageToMove.frame=CGRectMake(x, y, 40, 40);
        [self.view addSubview:imageToMove];
        NSString *wString=[wArray objectAtIndex:i];
        int w=wString.intValue*41-25;
        NSLog(@"x=%d y=%d w=%d",x,y,w);
       // [self moveImage:imageToMove duration:2.0 curve:UIViewAnimationCurveLinear x:w-x y:348-y];
       
        [self slideView:imageToMove withDuration:1 toX:w andY:348];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    }
}

- (IBAction)resign:(id)sender {
}

/*---------------- Activity Indicator -------------------------------------*/
-(void)ShowActivityIndicatorWithTitle:(NSString *)Title{
    
    [SVProgressHUD showWithStatus:Title maskType:SVProgressHUDMaskTypeGradient];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    
}

-(void)HideActivityIndicator{
    [SVProgressHUD dismiss];
}

-(void)okButton
{
   // lowerView.userInteractionEnabled=NO;
    [myView removeFromSuperview];
    [invalidMoveLabel removeFromSuperview];
    [msgLabel removeFromSuperview];
    [okButton removeFromSuperview];
    [popView removeFromSuperview];
    [yesButton removeFromSuperview];
    [noButton removeFromSuperview];
    
    
    const char *dbpath = [databasePath UTF8String];
    [imageLocArray removeAllObjects];
    [imageCharArray removeAllObjects];
    [imageCoinArray removeAllObjects];
    if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
    {
        NSString *querySQL;
        querySQL = [NSString stringWithFormat:@"SELECT * FROM IMAGE"];
        const char *query_stmt = [querySQL UTF8String];
        // const char *sql = "SELECT * FROM  data WHERE date=\"%@\"",currentDate;
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(swagDB, query_stmt, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            // NSLog(@"Problem with prepare statement:  %@", sqlite3_errmsg(db));
        }else
        {
            while (sqlite3_step(sqlStatement)==SQLITE_ROW)
            {
                [imageLocArray addObject:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,0)]];
                [imageCharArray addObject:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)]];
                [imageCoinArray addObject:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,2)]];
            }
        }
        sqlite3_finalize(sqlStatement);
        sqlite3_close(swagDB);
    }
    int x=16;
    for (int j=1; j<8; j++)
    {
        myImage=[[UIImageView alloc]init];
        myImage.frame=CGRectMake(x, 348, 40, 40);
        if([imageLocArray containsObject:[NSString stringWithFormat:@"%d",j]])
        {
            
            myImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[imageCharArray objectAtIndex:[imageLocArray indexOfObject:[NSString stringWithFormat:@"%d",j]]]]];
        }
        
        myImage.tag=j;
        [self.view addSubview:myImage];
        x=x+41;
    }
}

-(void)yesButton
{
    /*----------------------- Send Move  ------------------------------------*/
    [myView removeFromSuperview];
    [invalidMoveLabel removeFromSuperview];
    [msgLabel removeFromSuperview];
    [okButton removeFromSuperview];
    [popView removeFromSuperview];
    [yesButton removeFromSuperview];
    [noButton removeFromSuperview];
    [self ShowActivityIndicatorWithTitle:@"Sending..."];
    NSLog(@"Word Send");
    NSLog(@"game id=%@",self.gameId);
    NSLog(@"game Character=%@",gameCharacter);
    NSLog(@"game char Pos=%@",gameCharPos);
    
    NSString *post =[[NSString alloc] initWithFormat:@"access_token=%@&game=%@&coins=%@&game_word=%@&game_character=%@&game_character_pos=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"],self.gameId,[NSString stringWithFormat:@"%d",totalPoint],validWord,gameCharacter,gameCharPos];
    NSURL *url=[NSURL URLWithString:@"http://23.23.78.187/swwf/complete.php"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"ratecount"]+1  forKey:@"ratecount"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSError *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(data)
    {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"json is %@",json);
        NSDictionary *characterArray=[json objectForKey:@"character_array"];
        NSArray *coins=[characterArray valueForKey:@"coins"];
        NSArray *newChar=[characterArray valueForKey:@"name"];
        [self.charArray addObjectsFromArray:newChar];
        [self.charPointArray addObjectsFromArray:coins];
        NSLog(@"Char Array=%@",self.charArray);
        NSLog(@"char Point Array=%@",self.charPointArray);
        [fixedLocArray addObjectsFromArray:buttonLocArray];
        [fixedCharArray addObjectsFromArray:buttonCharArray];
        [locArray removeAllObjects];
        [self.imageView removeFromSuperview];
        [self DataBase];
        [self scrableBoard];
        userScore.text=[NSString stringWithFormat:@"%d",totalPoint];
        [self HideActivityIndicator];
   }
}

-(void) slideView:(UIView *)uiv_slide withDuration:(double)d_duration toX:(CGFloat)xValue andY:(CGFloat)yValue
{
    //Make an animation to slide the view off the screen
    [UIView animateWithDuration:d_duration animations:^
    {
        //uiv_slide.center = CGPointMake(xValue,yValue);
        [uiv_slide setFrame:CGRectMake(xValue, yValue, uiv_slide.frame.size.width, uiv_slide.frame.size.height)];
    }
    completion:^(BOOL finished)
    {
    
    }];
}

- (void)moveImage:(UIImageView *)moveImage duration:(NSTimeInterval)duration
            curve:(int)curve x:(CGFloat)x y:(CGFloat)y
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
    moveImage.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
 }



@end
