//
//  ViewController.m
//  iPnp
//
//  Created by Franco Cedillo on 10/3/14.
//  Copyright (c) 2014 HartasCuerdas. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *firstDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *oAvgLabel;
@property (weak, nonatomic) IBOutlet UILabel *dAvgLabel;

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    self.firstDayLabel.text = [self.weekDetail objectForKey:@"firstDay"];
    
    double oAVG = [[self.weekDetail objectForKey:@"oAVG"] doubleValue];
    self.oAvgLabel.text = [NSString stringWithFormat:@"%.1f", oAVG];
    
    double dAVG = [[self.weekDetail objectForKey:@"dAVG"] doubleValue];
    self.dAvgLabel.text = [NSString stringWithFormat:@"%.1f", dAVG];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
