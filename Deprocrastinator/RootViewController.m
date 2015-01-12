//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Tewodros Wondimu on 1/12/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *taskTextField;
@property NSMutableArray *taskList;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.taskList = [NSMutableArray arrayWithObjects:@"Task1", @"Task2", @"Task3", @"Task4", nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.taskList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tasksCell"];
    cell.textLabel.text = [self.taskList objectAtIndex:indexPath.row];
    return cell;
}

- (IBAction)onAddButtonPressed:(UIButton *)sender
{
    [self.taskList addObject:self.taskTextField.text];
    [self.taskTextField resignFirstResponder];
    self.taskTextField.text = @"";
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
