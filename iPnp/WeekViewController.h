//
//  WeekViewController.h
//  iPnp
//
//  Created by Franco Cedillo on 10/3/14.
//  Copyright (c) 2014 HartasCuerdas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekViewController : UIViewController

@property (strong, nonatomic) NSDictionary *weekDetail;
@property (strong, nonatomic) IBOutlet UITableView *daysTableView;
@property (strong, nonatomic) NSMutableArray *daysArray;

- (void)LoadWeekDetail;

@end

