//
//  ViewController.h
//  SWWF-Universal
//
//  Created by Samar on 06/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "database.h"

@interface ViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    BOOL zoom;
    UIImageView *popView;
    UIView *myView;
    UILabel *invalidMoveLabel;
    UILabel *msgLabel;
    UIButton *okButton;
    UIButton *yesButton;
    UIButton *noButton;
    UIImageView *movingImageView;
    UIButton *mybutton;
    UIImageView *myImage;
    NSMutableArray *storePoint;
    NSMutableArray *xArray;
    NSMutableArray *yArray;
    int locButton;
    int currentTag;
    int totalPoint;
    UIImage *currentImage;
    NSMutableArray *buttonArray;
    NSString *storeMyPoint;
    NSString *removeMyPoint;
    BOOL image;
    IBOutlet UILabel *userName;
    IBOutlet UILabel *opponentName;
    IBOutlet UILabel *userScore;
    IBOutlet UILabel *opponentScore;
    IBOutlet UILabel *remainingLetters;
    NSString *gameWord;
    NSString *gameCharacter;
    NSString *gameCharPos;
    NSMutableString *prevWord;
    NSMutableArray *locArray;
    NSMutableArray *imageLocArray;
    NSMutableArray *imageCharArray;
    NSMutableArray *imageCoinArray;
    NSMutableArray *buttonLocArray;
    NSMutableArray *buttonCharArray;
    NSMutableArray *buttonCoinArray;
    NSMutableArray *fixedLocArray;
    NSMutableArray *fixedCharArray;
    NSMutableArray *wordsArray;
    NSArray *sortedLocArray;
    NSString *currentChar;
    NSString *currentPoint;
    NSString *oldChar;
    NSString *oldPoint;
    NSString *validWord;
    NSString *First;
    NSMutableString *myWord;
    
    sqlite3 *swagDB;
    NSString *databasePath;
    database *path;
    int prevCounter;
    int prevCounterVertical;
    IBOutlet UIView *lowerView;
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

@property(strong,nonatomic)NSString *opponentNameString;
@property(strong,nonatomic)NSString *userScoreString;
@property (strong,nonatomic)NSString *opponentScoreString;
@property (strong,nonatomic)NSString *remainingLettersString;
@property (strong,nonatomic)NSString *gameId;
@property (strong,nonatomic)NSMutableArray *charArray;
@property (strong,nonatomic)NSMutableArray *charPointArray;

- (IBAction)backButton:(id)sender;
- (IBAction)chat:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)pass:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *shuffle;
- (IBAction)shuffle:(id)sender;
- (IBAction)swap:(id)sender;
- (IBAction)recall:(id)sender;
- (IBAction)resign:(id)sender;



@end
