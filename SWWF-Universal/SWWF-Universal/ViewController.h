//
//  ViewController.h
//  SWWF-Universal
//
//  Created by Samar on 06/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    BOOL zoom;
    UIImageView *movingImageView;
    UIButton *mybutton;
    UIImageView *myImage;
    NSMutableArray *storePoint;
    NSMutableArray *xArray;
    NSMutableArray *yArray;
    int locButton;
    int currentTag;
    UIImage *currentImage;
    NSMutableArray *buttonArray;
    NSString *storeMyPoint;
    NSString *removeMyPoint;
    BOOL image;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *dropTarget;
@property (nonatomic, strong) UIImageView *dragObject;
@property (nonatomic, assign) CGPoint touchOffset;
@property (nonatomic, assign) CGPoint homePosition;
@property (nonatomic,assign) CGPoint framePoint;


- (void)centerScrollViewContents;
@property (strong, nonatomic) IBOutlet UIView *buttonView;

- (IBAction)touchDragInside:(id)sender;

- (IBAction)touchDragOutside:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *buttonBackroundView;
@property (strong, nonatomic) IBOutlet UIImageView *charImage;


@end
