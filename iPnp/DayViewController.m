//
//  DayViewController.m
//  iPnp
//
//  Created by Franco Cedillo on 10/4/14.
//  Copyright (c) 2014 HartasCuerdas. All rights reserved.
//

#import "DayViewController.h"
#import "OdCustomCell.h"
#import "AFNetworking.h"

@interface DayViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *wrLabel;
@property (weak, nonatomic) IBOutlet UISwitch *wrSwitch;
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

    bool wr = [[self.dayDetail objectForKey:@"wr"] boolValue];
    NSString *strWr = @"";
    if (wr) {
        strWr = @"Well";
        [self.wrSwitch setOn:YES];
    } else {
        strWr = @"Poor";
        [self.wrSwitch setOn:NO];
    }

    self.wrLabel.text = [NSString stringWithFormat:@"%@", strWr];
    
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
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *tempDictionary= [self.odsArray objectAtIndex:indexPath.row];
    //cell.textLabel.text = [tempDictionary objectForKey:@"timekey"];

    OdCustomCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.timekeyLabel.text = [tempDictionary objectForKey:@"timekey"];
    bool o = [[tempDictionary objectForKey:@"o"] boolValue];
    bool d = [[tempDictionary objectForKey:@"d"] boolValue];
    if (o) {
        [cell.oSwitch setOn:YES];
    } else {
        [cell.oSwitch setOn:NO];
    }
    if (d) {
        [cell.dSwitch setOn:YES];
    } else {
        [cell.dSwitch setOn:NO];
    }
    
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
