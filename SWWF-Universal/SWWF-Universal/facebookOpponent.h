//
//  facebookOpponent.h
//  SWWF-Universal
//
//  Created by Samar on 21/11/12.
//
//

#import <UIKit/UIKit.h>
#import "asyncimageview.h"

@interface facebookOpponent : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    AsyncImageView *asyncImageView;
    NSMutableArray *imageArray;
    NSMutableArray *charArray;
    NSMutableArray *charPointArray;
    NSString *gameId;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSArray *fbFriends;
@property (strong,nonatomic) NSString *gameMode;
@property(strong,nonatomic) NSString *oppName;
- (IBAction)backAction:(id)sender;
- (IBAction)settings:(id)sender;

@end
