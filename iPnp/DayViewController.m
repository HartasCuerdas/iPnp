//
//  DayViewController.m
//  iPnp
//
//  Created by Franco Cedillo on 10/4/14.
//  Copyright (c) 2014 HartasCuerdas. All rights reserved.
//

#import "DayViewController.h"
#import "AFNetworking.h"

@interface DayViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *oTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *dTotalLabel;

@property (strong, nonatomic) IBOutlet UITableView *odsTableView;

@property (strong, nonatomic) NSArray *odsArray;

@end

@implementation DayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    self.dateLabel.text = [self.dayDetail objectForKey:@"date"];
    
    integer_t oTotal = [[self.dayDetail objectForKey:@"oTotal"] integerValue];
    self.oTotalLabel.text = [NSString stringWithFormat:@"%d", oTotal];
    
    integer_t dTotal = [[self.dayDetail objectForKey:@"dTotal"] integerValue];
    self.dTotalLabel.text = [NSString stringWithFormat:@"%d", dTotal];
    
    [self makeOdsRequests];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)daysTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return  [self.odsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"OdCell";
    //UITableViewCell *cell = [self.daysTableView dequeueReusableCellWithIdentifier:@"DayCell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *tempDictionary= [self.odsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [tempDictionary objectForKey:@"timekey"];
    
    return cell;
}

-(void)makeOdsRequests
{
    
    integer_t day_id = [[self.dayDetail objectForKey:@"id"] integerValue];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://localhost:3000/days/%d/ods", day_id ] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.odsArray = responseObject;
        NSLog(@"Ods Array: %@",self.odsArray);
        [self.odsTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end