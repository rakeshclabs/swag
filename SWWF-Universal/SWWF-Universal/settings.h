//
//  settings.h
//  swwf
//
//  Created by Samar on 27/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface settings : UIViewController<MFMailComposeViewControllerDelegate>
{
    IBOutlet UIButton *soundButton;
    IBOutlet UIButton *vibrationButton;
    IBOutlet UIButton *alertButton;
    IBOutlet UIImageView *soundImageView;
    IBOutlet UIImageView *vibrationImageView;
    IBOutlet UIImageView *alertImageView;
    BOOL sound;
    BOOL vibration;
    BOOL alert;
    
}

@end
