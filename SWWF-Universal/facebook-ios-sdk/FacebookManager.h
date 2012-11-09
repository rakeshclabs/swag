//
//  FacebookManager.h
//  ApptheGame
//
//  Created by Dmitry Miller on 4/1/12.
//  Copyright (c) 2012 Self employed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"


extern NSString * const FacebookManagerLoginSuccess;
extern NSString * const FacebookManagerLoginFailure;


@protocol FBManagerDelegate 
@required
-(void)FB_Post_To_Wall_Request_Sent;
-(void)FB_Post_To_Wall_Successfully;

-(void)FB_Post_To_Friend_Wall_Request_Sent;
-(void)FB_Post_To_Friend_Wall_Successfully;

-(void)FB_Login_Request_Sent;
-(void)FB_Logged_In_Successfully;



@end


@interface FacebookManager : NSObject <FBSessionDelegate,FBDialogDelegate,FBRequestDelegate>{
        
    id<FBManagerDelegate>_Delegate;  
    
    BOOL Post_To_Wall_Method_Called;
    BOOL Post_To_Friend_Wall_Method_Called;

    
}

@property(retain,nonatomic)id<FBManagerDelegate> Delegate;
@property (nonatomic, readonly) Facebook * facebook;

+(FacebookManager *) facebookConnect;
-(void)Call_FB;
-(void)Call_Share_Dialog;
-(void)User_FB_Friends;
-(void)PostToWall_WithMessage:(NSString*)Message WithLink:(NSString*)Link ;
-(void)Post_To_Friend_Wall_WithMsg:(NSString*)InviteMsg  Friend_FBID:(NSString *)FBID  WithLink:(NSString*)Link;






-(void)FB_LogOut;

@end
