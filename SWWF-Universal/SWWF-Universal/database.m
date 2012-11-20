//
//  database.m
//  HelloSecretFolder
//
//  Created by Samar on 27/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "database.h"
#define kFilename @"swagDatabase.sqlite"

@implementation database
-(id)init
{
	if(self = [super init])
	{
		//ensure the database is initialized by initializing it upon creating any manager
		[self checkAndCreateDatabase];
	}
	
	return self;
}

- (NSString *) dataFilePath
{
	NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:kFilename];
    // NSLog(@"documents directory");
}

-(void) checkAndCreateDatabase{
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	//NSLog(@"documents directory2");
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	NSString * databasePath = [self dataFilePath];
	success = [fileManager fileExistsAtPath:databasePath];
	//NSLog(@"%@",databasePath);
	// If the database already exists then return without doing anything
	if(success) return;
	NSLog(@"creating database");
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kFilename];  //[self dataFilePath];
	//NSLog(@"documents directory2");
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	
	//[fileManager release];
}



@end
