//
//  loginView.h
//  SWWF-Universal
//
//  Created by Samar on 06/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginView : UIViewController
{
    IBOutlet UIImageView *BG;
    IBOutlet UIButton *emailButton;
    IBOutlet UIButton *facebookButton;
    NSString *numberOfGames;
    
}
- (IBAction)emailButton:(id)sender;
- (IBAction)facebookButton:(id)sender;
@property(strong,nonatomic) NSString *accessToken;
@property(strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSString *userImage;

@property(strong,nonatomic) NSMutableArray *gameIdArray;
@property (strong,nonatomic) NSMutableArray *userTurnArray;
@property (strong,nonatomic) NSMutableArray *userStatusArray;
@property(strong,nonatomic)NSMutableArray *gameStatusArray;
@property(strong,nonatomic) NSMutableArray *userTurnDataArray;
@property(strong,nonatomic) NSMutableArray *oppNameArray;
@property (strong,nonatomic) NSMutableArray *oppImageArray;
@property (strong,nonatomic) NSMutableArray *dateCreatedArray;

@end
