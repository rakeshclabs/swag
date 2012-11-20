//
//  account.h
//  swwf
//
//  Created by Samar on 27/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface account : UIViewController
{
    IBOutlet UITextField *userNameField;
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *newPassword;
    IBOutlet UITextField *retypePassword;
    
}
@property (strong, nonatomic) IBOutlet UIButton *logout;
- (IBAction)logout:(id)sender;
- (IBAction)saveclose:(id)sender;

@end
