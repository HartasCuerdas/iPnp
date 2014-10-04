//
//  ViewController.m
//  iPnp
//
//  Created by Franco Cedillo on 10/3/14.
//  Copyright (c) 2014 HartasCuerdas. All rights reserved.
//

#import "WeekViewController.h"
#import "AFNetworking.h"

@interface WeekViewController ()

@property (weak, nonatomic) IBOutlet UILabel *firstDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *oAvgLabel;
@property (weak, nonatomic) IBOutlet UILabel *dAvgLabel;

@property (strong, nonatomic) IBOutlet UITableView *daysTableView;

@property (strong, nonatomic) NSArray *daysArray;

@end



@implementation WeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    self.firstDayLabel.text = [self.weekDetail objectForKey:@"firstDay"];
    
    double oAVG = [[self.weekDetail objectForKey:@"oAVG"] doubleValue];
    self.oAvgLabel.text = [NSString stringWithFormat:@"%.1f", oAVG];
    
    double dAVG = [[self.weekDetail objectForKey:@"dAVG"] doubleValue];
    self.dAvgLabel.text = [NSString stringWithFormat:@"%.1f", dAVG];
    
    [self makeDaysRequests];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)daysTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return  [self.daysArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DayCell";
    //UITableViewCell *cell = [self.daysTableView dequeueReusableCellWithIdentifier:@"DayCell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *tempDictionary= [self.daysArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [tempDictionary objectForKey:@"date"];
    
    return cell;
}

-(void)makeDaysRequests
{
    
    integer_t day_id = [[self.weekDetail objectForKey:@"id"] integerValue];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://localhost:3000/weeks/%d/days", day_id ] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.daysArray = responseObject;
        NSLog(@"Days Array: %@",self.daysArray);
        [self.daysTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
