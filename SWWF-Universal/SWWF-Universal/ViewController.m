//
//  ViewController.m
//  SWWF-Universal
//
//  Created by Samar on 06/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

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
        if(!myImage.image)
            myImage.image=[UIImage imageNamed:@"S.png"];
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
                    img.image=currentImage;
                    for (UIImageView *notImg in self.view.subviews)
                    {
                        if(notImg.tag!=tag&&notImg.tag!=0)
                        {
                            NSLog(@"NOt Image=%d",notImg.tag);
                            if(notImg.image)
                            {   
                                
                            }
                            else
                            {
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
                }
            }
        }
        
        sqlite3_stmt    *statement;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO IMAGE(LOC, CHAR, COIN) VALUES(\'%d\',\'%@\',\'%@\')",locButton,currentChar,currentPoint];
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
                    img.image=currentImage;
                    for (UIImageView *notImg in self.view.subviews)
                    {
                        if(notImg.tag!=tag&&notImg.tag!=0)
                        {
                            NSLog(@"NOt Image=%d",notImg.tag);
                            if(notImg.image)
                            {   
                                
                            }
                            else
                            {
                                notImg.image=newImage;
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
                }
                
            }
        }
        
        sqlite3_stmt    *statement;
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &swagDB) == SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO IMAGE(LOC, CHAR,COIN) VALUES(\'%d\',\'%@\',\'%@\')",locButton,currentChar,currentPoint];
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
/*---------------- sorting location Array ----------------------*/
    sortedLocArray = [locArray sortedArrayUsingComparator: ^(id obj1, id obj2)
    {
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
    
/*-------------------------- Checking Valid and Invalid tile placement ----------------------*/
    NSString *First=[sortedLocArray objectAtIndex:0];
    NSString *second=[sortedLocArray objectAtIndex:1];
    if(First.intValue+15==second.intValue)  //Checking Vertically
    {
        for (int i=1; i<sortedLocArray.count; i++)
        {
            second=[sortedLocArray objectAtIndex:i];
            if(First.intValue+15==second.intValue)
            {
                First=second;
                if(i==sortedLocArray.count-1)
                {
                   [self validWords]; 
                }
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Invalid Move" message:@"Sorry, must place all tiles in one row or column" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                break;
            }
        }
    
    }
    else if(First.intValue+1==second.intValue)//Checking Horizantally
     {
         for (int i=1; i<sortedLocArray.count; i++)
         {
             second=[sortedLocArray objectAtIndex:i];
             if(First.intValue+1==second.intValue)
             {
                 First=second;
                 if(i==sortedLocArray.count-1)
                 {
                     [self validWords];
                 }
                 
             }
             else
             {
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Invalid Move" message:@"Sorry, must place all tiles in one row or column" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
                 break;
             }
         }
        
    }
    else
    {
          UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Invalid Move" message:@"Sorry, must place all tiles in one row or column" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
          [alert show];
    }

    
  

}

/*-------------------------- Checking Words  is valid or not -------------------------*/
-(void)validWords
{
/*----------- Fetching character, location and point from database -----------------------*/
    NSLog(@"Valid Words");
    sqlite3_stmt    *statement;
    NSMutableString *myWord=[[NSMutableString alloc]init];
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
                 [myWord appendString:[NSString stringWithString:[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]]];
                totalPoint=totalPoint+[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)].intValue;
                NSLog(@"myWord=%@",myWord);
                NSLog(@"total point=%d",totalPoint);
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
     NSString *post =[[NSString alloc] initWithFormat:@"access_token=%@&game_word=%@&mode=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"],myWord,[[NSUserDefaults standardUserDefaults]valueForKey:@"gameMode"]];
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
         validWord=[json valueForKey:@"valid_words1"];
         NSString *invalideWords=[json valueForKey:@"invalid_words1"];
         if(validWord)
         {
             NSLog(@"valid Words=%@",validWord);
             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Send Move to %@ ?",self.opponentNameString] delegate:self cancelButtonTitle:@"Cancel Move" otherButtonTitles:@"Send Move",nil];
             [alert show];
             alert.tag=1;
         }
         else if(invalideWords)
         {
             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Invalid Move" message:[NSString stringWithFormat:@"Sorry,'%@' may be misspelled or may be a proper noun",invalideWords] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         NSLog(@"Invalid Words=%@",invalideWords);
             [buttonCharArray removeAllObjects];
             [buttonCoinArray removeAllObjects];
             [buttonLocArray removeAllObjects];
         }
     }
 }

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
/*----------------------- Send Move  ------------------------------------*/
    if(alertView.tag==1)
    {
        if(buttonIndex==1)
        {
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

- (IBAction)recall:(id)sender {
}

- (IBAction)resign:(id)sender {
}
@end
