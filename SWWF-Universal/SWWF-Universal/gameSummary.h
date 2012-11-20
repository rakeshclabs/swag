//
//  gameSummary.h
//  swwf
//
//  Created by Samar on 27/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gameSummary : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UIScrollView *gamesScroll;
    UIImageView *line;
    int h;
    NSString *status;
    NSString *lastStatus;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSString *numberOfGames;
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
