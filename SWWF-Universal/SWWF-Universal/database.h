//
//  database.h
//  HelloSecretFolder
//
//  Created by Samar on 27/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface database : NSObject
-(NSString *) dataFilePath;
-(void)checkAndCreateDatabase;


@end
