//
//  FacebookManager.m
//  ApptheGame
//
//  Created by Dmitry Miller on 4/1/12.
//  Copyright (c) 2012 Self employed. All rights reserved.
//

#import "FacebookManager.h"



NSString * const FacebookManagerLoginSuccess = @"FacebookManagerLoginSuccess";
NSString * const FacebookManagerLoginFailure = @"FacebookManagerLoginFailure";



@implementation FacebookManager

@synthesize facebook;
@synthesize Delegate=_Delegate;


+(FacebookManager *) facebookConnect
{
    static FacebookManager * instance;
    
    if(instance == nil)
    {
        instance = [[FacebookManager alloc] init];
    }
    
    return instance;
}


#pragma mark -
#pragma mark constructor/destructor

-(id) init
{
    if(self = [super init])
    {
        facebook = [[Facebook alloc] initWithAppId:@"375687625849686" andDelegate:self];
        
    }
    
    
    return self;    
}


-(void)Call_Share_Dialog{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"http://apple.com", @"link",
                                   @"http://clicklabs.com", @"picture",
                                   @"Download the free ApptheGame app", @"name",
                                   @"", @"caption",
                                   @"Celebrate Victory on your iPhone now. To learn more visit www.appthegame.co", @"description",@"http://click-labs.com", @"message",
                                   nil];
    
    [self.facebook dialog:@"feed" andParams:params andDelegate:self];
}



- (void) dialogDidNotComplete:(FBDialog *)dialog{
    NSLog(@"feed dialog cancled");
    
}




-(void)Call_FB{
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && 
        [defaults objectForKey:@"FBExpirationDateKey"]) {
        
        facebook.accessToken    = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
     
        NSLog(@"\nFB_Token=%@\n",facebook.accessToken);
       // [_Delegate FB_Logged_In_Successfully];
    
    }
    
    if (![facebook isSessionValid]) {
        //[facebook authorize:nil];
        facebook.sessionDelegate=self;
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"user_likes", 
                                @"read_stream",
                                @"publish_stream", 
                                nil];
        [facebook authorize:permissions];
        
        
        
    }
    
    

}

- (void)fbDidLogin {
    [_Delegate FB_Login_Request_Sent];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    
    [defaults setInteger:1 forKey:@"SAI"];
    
    [defaults synchronize];
    
    [facebook requestWithGraphPath:@"me" andDelegate:self];
    
 
}

- (void)request:(FBRequest *)request didLoad:(id)result {
  
    NSString *facebookId = [result objectForKey:@"id"   ];
    NSString *userName   = [result objectForKey:@"name" ];
    NSString *userEmail  = [result objectForKey:@"email"]; 
    NSLog(@"fbId=%@ \n uName=%@ \n email=%@",facebookId,userName,userEmail); 
        
        
        if(userName){ 
            [[NSUserDefaults standardUserDefaults]setObject:facebookId forKey:@"fbid"];  
            [[NSUserDefaults standardUserDefaults]setObject:userName forKey:@"fbuname"];  

            [[NSUserDefaults standardUserDefaults]synchronize];
            [_Delegate FB_Logged_In_Successfully];
        }
  

         
}


-(void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
       
    if(Post_To_Wall_Method_Called) {
        [_Delegate FB_Post_To_Wall_Successfully];
                   Post_To_Wall_Method_Called=NO;
    }
    
    if(Post_To_Friend_Wall_Method_Called){
        [_Delegate FB_Post_To_Friend_Wall_Successfully];
                    Post_To_Friend_Wall_Method_Called=NO;
    }
        
    NSLog(@"received response=%@",response);
  
  
}






-(void)PostToWall_WithMessage:(NSString*)Message WithLink:(NSString*)Link {
    
 // Message= [NSString stringWithFormat:@"%@ has just recorded another song on Sing me Something! check out the recording here: %@",/*[[DatabaseHandler sharedInstance]DB_Get_App_Uname ]*/ Link];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"GTC", @"name",
                                   Link, @"link",
                                   @"An app for iPhone", @"caption",
                                   @"It is an awesome app", @"description",
                                   Message,@"message",              
                                   nil];
    
    
    // This is the most important method that you call. It does the actual job, the message posting.
  //   [facebook dialog:@"feed" andParams:params andDelegate:self];
    
   
    
    [facebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:self];
    
     [_Delegate FB_Post_To_Wall_Request_Sent];
     Post_To_Wall_Method_Called=YES;
  
   
}


-(void)Post_To_Friend_Wall_WithMsg:(NSString*)InviteMsg  Friend_FBID:(NSString *)FBID  WithLink:(NSString*)Link{
   // InviteMsg=@"I'm playing sing me something, a new twist on draw something. Play with me now, it’s a great laugh, simply taking turns to show off our singing talent and music knowledge.Download the game from the app store. Quickly register and start singing with me!";
        
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       InviteMsg          ,@"message",
                                       Link               , @"link",
                                       @"GTC",             @"name",
                                       nil];
    
         
    NSString *Method=[NSString stringWithFormat:@"%@/feed",FBID];
    [facebook requestWithGraphPath:Method  andParams:params andHttpMethod:@"POST" andDelegate:self];
    
    [_Delegate FB_Post_To_Friend_Wall_Request_Sent];
    Post_To_Friend_Wall_Method_Called=YES;
    
    NSLog(@"Invited %@ msg=%@",FBID,InviteMsg);
    
}


-(void)User_FB_Friends{
    [facebook requestWithGraphPath:@"me/friends" andDelegate:self];
    
}


//============================================================LOGOUT=========================================================================


-(void)fbDidNotLogin:(BOOL)cancelled{
    NSLog(@"cancled");
}
-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt{
    
}
-(void)fbSessionInvalidated{
    
}


    

-(void)FB_LogOut{
    [facebook logout];
    
}

- (void) fbDidLogout {
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
}

@end
