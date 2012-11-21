//
//  facebookOpponent.m
//  SWWF-Universal
//
//  Created by Samar on 21/11/12.
//
//

#import "facebookOpponent.h"

@interface facebookOpponent ()

@end

@implementation facebookOpponent
@synthesize fbFriends;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageArray=[[NSMutableArray alloc]init];
    NSSortDescriptor *lastDescriptor =[[NSSortDescriptor alloc] initWithKey:@"name"
                                                                  ascending:YES
                                                                   selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *descriptors = [NSArray arrayWithObjects:lastDescriptor, nil];
    if(!(fbFriends ==(id)[NSNull null]))
    {
        
        fbFriends=[fbFriends sortedArrayUsingDescriptors:descriptors];
    }

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return fbFriends.count;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    else {
        AsyncImageView* oldImage = (AsyncImageView*)
        [cell.contentView viewWithTag:999];
        [oldImage removeFromSuperview];
    }
    /* cellLabel = nil;
     cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(78, 17, 68, 25)];
     [cellLabel setFont:[UIFont boldSystemFontOfSize:20]];
     cellLabel.text = @"";
     [cell addSubview:cellLabel];
     */
    
        cell.textLabel.text = [NSString stringWithFormat:@"            %@", [[fbFriends objectAtIndex:indexPath.row] objectForKey:@"name"]];
    UIImageView *pic=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 60, 60)];
    pic.image=[UIImage imageNamed:@"Frame.png"];
        asyncImageView = [[AsyncImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        [asyncImageView setTag:999];
         if([imageArray count] >=indexPath.row+1) {
            asyncImageView = [imageArray objectAtIndex:indexPath.row];
        }
        else {
            NSLog(@"else");
            [asyncImageView loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", [[fbFriends objectAtIndex:indexPath.row] objectForKey:@"id"]]]];
            [imageArray addObject:asyncImageView];
        }
    
    [pic addSubview:asyncImageView];
    [cell.contentView addSubview:pic];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundView =[[UIImageView alloc] init];
    ((UIImageView *)cell.backgroundView).image=[UIImage imageNamed:@"fbCell.png"];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

@end
