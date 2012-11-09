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
    
}
- (IBAction)connectButton:(id)sender;
- (IBAction)cancelButton:(id)sender;

@end
