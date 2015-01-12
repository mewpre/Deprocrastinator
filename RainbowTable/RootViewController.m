//
//  ViewController.m
//  RainbowTable
//
//  Created by Yi-Chin Sun on 1/12/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UITabBarControllerDelegate, UITableViewDataSource>
@property NSMutableArray *colorArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RootViewController

- (IBAction)addColorRow:(id)sender
{
    [self.colorArray addObject:[self randomColor]];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeColorArray];
}

-(void)initializeColorArray
{
    self.colorArray = [NSMutableArray arrayWithObjects:
                       [UIColor redColor],
                       [UIColor orangeColor],
                       [UIColor yellowColor],
                       [UIColor greenColor],
                       [UIColor cyanColor],
                       [UIColor blueColor],
                       [UIColor colorWithRed:75.0/255.0 green:0.0/255.0 blue:130.0/255.0 alpha:1.0],
                       [UIColor purpleColor], nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.colorArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ColorCellID"];
    //cell.textLabel.text = ([NSString stringWithFormat:@"row: %li", (long)indexPath.row ]);

    cell.backgroundColor = [self.colorArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Row %li", indexPath.row];
    return cell;
}

-(UIColor *)randomColor
{
    float randomRValue = arc4random_uniform(255)/255.0;
    float randomGValue = arc4random_uniform(255)/255.0;
    float randomBValue = arc4random_uniform(255)/255.0;
    NSLog([NSString stringWithFormat:@"%f, %f, %f", randomRValue, randomBValue, randomGValue]);
    return [UIColor colorWithRed:randomRValue green:randomGValue blue:randomBValue alpha:1.0];
}

@end
