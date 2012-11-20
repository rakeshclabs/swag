//
//  emailViewController.h
//  swwf
//
//  Created by Samar on 26/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface emailViewController : UIViewController
{
    IBOutlet UITextField *idField;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *connectButton;
    NSString *numberOfGames;
}
- (IBAction)connectButton:(id)sender;
- (IBAction)cancelButton:(id)sender;
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
