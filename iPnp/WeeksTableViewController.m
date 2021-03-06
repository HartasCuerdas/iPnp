//
//  WeeksTableViewController.m
//  iPnp
//
//  Created by Franco Cedillo on 10/3/14.
//  Copyright (c) 2014 HartasCuerdas. All rights reserved.
//

#import "WeeksTableViewController.h"
#import "WeekViewController.h"
#import "AFNetworking.h"

@interface WeeksTableViewController ()

@property (strong, nonatomic) NSMutableArray *weeksArray;

@end



@implementation WeeksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeWeeksRequests];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setEditing:(BOOL)editing animated:(BOOL) animated {
    if( editing != self.editing )
    {
        [super setEditing:editing animated:animated];
        [self.tableView setEditing:editing animated:animated];
        
        NSArray *indexes =
        [NSArray arrayWithObject:
         [NSIndexPath indexPathForRow:[self.weeksArray count] inSection:0]
        ];
        
        if (editing == YES ) {
            [self.tableView insertRowsAtIndexPaths:indexes
                                  withRowAnimation:UITableViewRowAnimationLeft];
        } else {
            [self.tableView deleteRowsAtIndexPaths:indexes
                                  withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

#pragma mark - Weeks table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger count = [self.weeksArray count];
    if(self.editing) {
        count = count + 1;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"WeekCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < [self.weeksArray count] )
    {
        NSDictionary *tempDictionary= [self.weeksArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [tempDictionary objectForKey:@"firstDay"];
    }
    else
    {
        cell.textLabel.text = @"Add New Week";
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    
    return cell;
}

-(void)makeWeeksRequests
{
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/weeks"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation
        setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            self.weeksArray = [NSMutableArray arrayWithArray:responseObject];
            [self.tableView reloadData];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Request Failed: %@, %@", error, error.userInfo);
        }
     ];
    
    [operation start];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    WeekViewController *weekViewController = (WeekViewController *)segue.destinationViewController;
    // Pass the selected object to the new view controller.
    weekViewController.weekDetail = [self.weeksArray objectAtIndex:indexPath.row];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (UITableViewCellEditingStyle)tableView:(UITableView *)tv
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.weeksArray count] ) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleInsert;
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        
        NSDictionary *tempDictionary= [self.weeksArray objectAtIndex:indexPath.row];
        integer_t week_id = [[tempDictionary objectForKey:@"id"] integerValue];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager
            DELETE:[NSString stringWithFormat:@"http://localhost:3000/weeks/%id", week_id ]
            parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.weeksArray removeObjectAtIndex:indexPath.row];
                [self.tableView endUpdates];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Request Failed: %@, %@", error, error.userInfo);
            }
        ];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager
             POST: @"http://localhost:3000/weeks"
             parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 [self.tableView beginUpdates];
                 [self.weeksArray addObject:responseObject];
                 [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                 [self.tableView endUpdates];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Request Failed: %@, %@", error, error.userInfo);
             }
         ];
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
