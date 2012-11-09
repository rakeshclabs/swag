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
    
    //  [self.buttonBackroundView addSubview:self.charImage];
    // [self.view addSubview:self.buttonBackroundView];
    // Set up the image we want to scroll & zoom and add it to the scroll view
    storePoint=[[NSMutableArray alloc]init];
    buttonArray=[[NSMutableArray alloc]init];
    xArray=[[NSMutableArray alloc]init];
    yArray=[[NSMutableArray alloc]init];
    UIImage *image = [UIImage imageNamed:@"green.jpeg"];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = CGRectMake(0, 0, 600, 600);//(CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=image.size};
    // self.scrollView.clipsToBounds=NO;
    [self.scrollView addSubview:self.imageView];
    int x=0;
    int y=0;
    int w=40;
    int h=40;
    for(int i=1;i<226;i++)
    {
        mybutton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        mybutton.frame=CGRectMake(x, y, w, h);
        mybutton.tag=i;
        mybutton.exclusiveTouch=YES;
        
        //[mybutton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
        [mybutton addTarget:self action:@selector(wasDragged:withEvent:)forControlEvents:UIControlEventTouchDown];
        [self.imageView addSubview:mybutton];
        x=x+w;
        if(x==600)
        {
            y=y+h;
            x=0;
        }
    }    
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
    
    x=5;
    for (int j=1; j<8; j++)
    {
        myImage=[[UIImageView alloc]init];
        myImage.frame=CGRectMake(x, 365, 40, 40);
        myImage.image=[UIImage imageNamed:@"green.jpeg"];
        myImage.tag=j;
        [self.view addSubview:myImage];
        x=x+45;
    }
    
    myImage.image=[UIImage imageNamed:@"photo1.png"];
    
    // UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] init];
    //[panGR addTarget:self action:@selector(panEvent:)];
    //[mybutton addGestureRecognizer:panGR];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)buttonClicked:(UIButton *)sender
{
    NSLog(@"Button %d Clicked",sender.tag);
    //  mybutton=sender;
    
    // mybutton.tag=5;
    //[mybutton setImage:[UIImage imageNamed:@"green.jpeg"] forState:UIControlStateNormal];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}




- (IBAction)touchDragInside:(id)sender 
{
    //    UIButton *button=sender;
    //    movingImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"green.jpeg"]];
    //    movingImageView.frame=CGRectMake(button.frame.origin.x-10, button.frame.origin.y-10, button.frame.size.width*2-10, button.frame.size.height*2-10);
    //    [self.view addSubview:movingImageView];
    // 
}

- (IBAction)touchDragOutside:(id)sender
{
    [movingImageView removeFromSuperview];
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
                    touchPoint.y < iView.frame.origin.y + iView.frame.size.height) 
                {
                    
                    self.dragObject = iView;
                    self.framePoint=CGPointMake(iView.frame.size.width, iView.frame.size.height);
                    self.touchOffset = CGPointMake(touchPoint.x - iView.frame.origin.x, 
                                                   touchPoint.y - iView.frame.origin.y);
                    self.homePosition = CGPointMake(iView.frame.origin.x, 
                                                    iView.frame.origin.y);
                    [self.view bringSubviewToFront:self.dragObject];
                    [self animateFirstTouchAtPoint:touchPoint forView:iView];
                }
            }
        }
        
        
        
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
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    NSLog(@"contentOffset%f",self.scrollView.contentOffset.x);
    NSLog(@"Contentoffset%f",self.scrollView.contentOffset.y);
    myImage = [[UIImageView alloc]init];
    myImage.frame=CGRectMake(self.homePosition.x, self.homePosition.y, 
                             40, 
                             40);
    if(self.homePosition.x<50)
        myImage.tag=1;
    else if(self.homePosition.x<95)
        myImage.tag=2;
    else if(self.homePosition.x<140)
        myImage.tag=3;
    else if(self.homePosition.x<185)
        myImage.tag=4;
    else if(self.homePosition.x<230)
        myImage.tag=5;
    else if(self.homePosition.x<275)
        myImage.tag=6;
    else if(self.homePosition.x<320)
        myImage.tag=7;
    
    currentImage=self.dragObject.image;
    // myImage.image=currentImage;
    [self.view addSubview:myImage];
    
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
            }
            
            
            
            
        }
        //[xArray addObject:stringX];
        //[yArray addObject:stringY];
        [storePoint addObject:storeMyPoint];
        locButton=((y/40)*15)+((x/40)+1);
        NSLog(@"Current x=%d",x);
        NSLog(@"Current y=%d",y);
        NSLog(@"Loc Button=%d",locButton);
        
        [self imageButton:locButton];
        [self.dragObject removeFromSuperview];
        NSLog(@"touchPoint.x=%f",touchPoint.x);
        NSLog(@"touchPoint.y=%f",touchPoint.y);
        NSLog(@"dropTarget=%f",self.scrollView.frame.size.height);
        
        //[self animateView:self.dragObject toPosition: self.homePosition];
    }
    else 
    {
        int tag;
        NSLog(@"touchPoint=%f",touchPoint.y);
        NSLog(@"dropTarget=%f",self.scrollView.frame.size.height);
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
        
        [self.dragObject removeFromSuperview];
        for (UIImageView *img in self.view.subviews) 
        {
            if (img.tag == tag) 
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
        
        
        NSLog(@"touchPoint=%f",touchPoint.y);
        NSLog(@"dropTarget=%f",self.scrollView.frame.size.height);
        //self.dragObject.frame = CGRectMake(self.homePosition.x, self.homePosition.y, 
        //                              self.dragObject.frame.size.width, 
        //                            self.dragObject.frame.size.height);
        //[self animateView:self.dragObject toPosition: self.homePosition];
    }
    
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
        image=TRUE;
        //  [self imageButton:locButton];
        [button removeFromSuperview];
        [self.dragObject removeFromSuperview];
        NSLog(@"touchPoint.x=%f",touchPoint.x);
        NSLog(@"touchPoint.y=%f",touchPoint.y);
        NSLog(@"dropTarget=%f",self.scrollView.frame.size.height);
        
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
            if (img.tag == tag) 
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
        
    }
    mybutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
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
}

- (void)panEvent:(id)sender {
    mybutton.center = [sender locationInView:self.view];
}


@end
