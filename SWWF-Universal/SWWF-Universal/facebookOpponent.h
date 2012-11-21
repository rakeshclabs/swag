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
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSArray *fbFriends;

@end
