//
//  subOpponent.h
//  SWWF-Universal
//
//  Created by Samar on 09/11/12.
//
//

#import <UIKit/UIKit.h>

@interface subOpponent : UIViewController
{
    IBOutlet UIImageView *imageBox;
    
}
- (IBAction)startButton:(id)sender;
- (IBAction)backButton:(id)sender;
- (IBAction)settingButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imageBox;
@property (strong,nonatomic) NSString *image;
@end
