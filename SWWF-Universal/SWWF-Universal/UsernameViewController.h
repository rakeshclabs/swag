//
//  UsernameViewController.h
//  swwf
//
//  Created by Samar on 26/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsernameViewController : UIViewController
{
    IBOutlet UITextField *userField;
 }
- (IBAction)goBackButton:(id)sender;
- (IBAction)continueButton:(id)sender;
@property(nonatomic,strong)NSString *emailId;
@property(strong,nonatomic) NSString *accessToken;
@property(strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSString *userImage;


@end
