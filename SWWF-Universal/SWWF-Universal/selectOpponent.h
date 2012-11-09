//
//  selectOpponent.h
//  swwf
//
//  Created by Samar on 27/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface selectOpponent : UIViewController
{
    IBOutlet UIImageView *bg;
    IBOutlet UIButton *facebookButton;
    IBOutlet UIButton *usernameButton;
    IBOutlet UIButton *randomButton;
    IBOutlet UIButton *passButton;
    NSString *image;
    
}
- (IBAction)facebookButton:(id)sender;
- (IBAction)user:(id)sender;
- (IBAction)random:(id)sender;
- (IBAction)pass:(id)sender;

@end
