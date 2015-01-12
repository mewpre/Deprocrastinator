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
@property BOOL editModeStatus;
@property (strong, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.taskList = [NSMutableArray arrayWithObjects:@"Task1", @"Task2", @"Task3", @"Task4", nil];
    self.editModeStatus = NO;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.editModeStatus)
    {
        [self.taskList removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }

    else
    {
        cell.textLabel.textColor = [UIColor greenColor];
    }
}

- (IBAction)onEditButtonPressed:(UIBarButtonItem *)sender
{
    //if not in edit mode, go into edit mode
    if (!self.editModeStatus)
    {
        [self.tableView setEditing:YES animated:YES];
        sender.title = @"Done";
        self.addButton.enabled = NO;
    }
    else
    {
        [self.tableView setEditing:NO animated:YES];
        sender.title = @"Edit";
        self.addButton.enabled = YES;
    }
    self.editModeStatus = !self.editModeStatus;

}

@end
