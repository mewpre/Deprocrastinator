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

- (IBAction)onSwipeRight:(UISwipeGestureRecognizer *)gesture
{
    CGPoint touchPoint;
    NSIndexPath *indexPath;
    UITableViewCell *cell;
    touchPoint  = [gesture locationInView:self.tableView];
    indexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];

    if (cell.textLabel.textColor == [UIColor blackColor]) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    else if (cell.textLabel.textColor == [UIColor redColor])
    {
        cell.textLabel.textColor = [UIColor yellowColor];
    }
    else if (cell.textLabel.textColor == [UIColor yellowColor])
    {
        cell.textLabel.textColor = [UIColor greenColor];
    }
    else
    {
        cell.textLabel.textColor = [UIColor blackColor];
    }
}

/*************************/
// Use this method if you want to change the buttons in edit mode in any way (add more, change title, etc.)
//-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Title" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        [self.taskList removeObjectAtIndex:indexPath.row];
//        [self.tableView reloadData];
//    }];
//
//    return @[deleteAction];
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete

        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.taskList removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        [self.tableView endUpdates];

    }
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
        NSDictionary *attribute = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                    };
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:cell.textLabel.text attributes:attribute];
        cell.textLabel.attributedText = attributedString;
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
