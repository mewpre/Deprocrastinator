//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Yi-Chin Sun, Tewodros Wondimu on 1/12/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "RootViewController.h"
#import "TaskDetails.h"

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *taskTextField;
@property (strong, nonatomic) IBOutlet UIButton *addButton;

@property NSMutableArray *taskList;
@property NSIndexPath *deleteCellIndexPath;

@property BOOL editModeStatus;

@property NSDictionary *normalText;
@property NSDictionary *strikethroughText;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.normalText= @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleNone]};
    self.strikethroughText = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};

    [self initializeStartingTaskList];
    self.editModeStatus = NO;
    self.taskTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

#pragma  mark - IBActions

- (IBAction)onAddButtonPressed:(UIButton *)sender
{
    if (![self.taskTextField.text isEqualToString:@""])
    {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.taskTextField.text attributes:self.normalText];
        TaskDetails *newTaskDetails = [[TaskDetails alloc]initWithProperties:attributedString textColor:[UIColor blackColor] isStrikethrough:NO];
        [self.taskList addObject:newTaskDetails];
        [self.taskTextField resignFirstResponder];
        self.taskTextField.text = @"";
        [self.tableView reloadData];
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

- (IBAction)onSwipeRight:(UISwipeGestureRecognizer *)gesture
{
    CGPoint touchPoint  = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
    TaskDetails *taskDetails = [self.taskList objectAtIndex:indexPath.row];

    if (taskDetails.taskColor == [UIColor blackColor]) {
        taskDetails.taskColor = [UIColor redColor];
    }
    else if (taskDetails.taskColor == [UIColor redColor])
    {
        taskDetails.taskColor = [UIColor yellowColor];
    }
    else if (taskDetails.taskColor == [UIColor yellowColor])
    {
        taskDetails.taskColor = [UIColor greenColor];
    }
    else
    {
        taskDetails.taskColor = [UIColor blackColor];
    }
    [self.tableView reloadData];
}

#pragma mark - Table View Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.taskList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tasksCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tasksCell"];
    }
    TaskDetails *taskDetails = [self.taskList objectAtIndex:indexPath.row];
    cell.textLabel.attributedText = taskDetails.taskText;
    cell.textLabel.textColor = taskDetails.taskColor;
    return cell;
}

/*************************/
/* Use this method if you want to change the buttons in edit mode in any way (add more, change title, etc.)
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Title" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self.taskList removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }];

    return @[deleteAction];
} */

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self deleteWarningAlertView];
        self.deleteCellIndexPath = indexPath;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskDetails *taskDetails = [self.taskList objectAtIndex:indexPath.row];
    NSRange range = NSMakeRange(0, taskDetails.taskText.length);
    if (!self.editModeStatus)
    {
        if (taskDetails.isStrikethrough)
        {
            //Make text not strikethrough
            [taskDetails.taskText setAttributes:self.normalText range:range];
        }
        else
        {
            //Make text strikethrough
            [taskDetails.taskText setAttributes:self.strikethroughText range:range];

        }
        taskDetails.isStrikethrough = !taskDetails.isStrikethrough;
        [self.tableView reloadData];

    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSAttributedString *stringToMove = self.taskList[sourceIndexPath.row];
    [self.taskList removeObjectAtIndex:sourceIndexPath.row];
    [self.taskList insertObject:stringToMove atIndex:destinationIndexPath.row];
}

#pragma mark - Alert View Methods
- (void)deleteWarningAlertView
{
    UIAlertView *deleteWarning = [[UIAlertView alloc] initWithTitle:@"Delete Warning:" message:@"Do you really want to delete this task?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    // optional - add more buttons:
    [deleteWarning addButtonWithTitle:@"Delete"];
    [deleteWarning show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
    {
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[self.deleteCellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.taskList removeObjectAtIndex:self.deleteCellIndexPath.row];
        [self.tableView reloadData];
        [self.tableView endUpdates];
    }
}

#pragma mark - Initialize Task List

- (void)initializeStartingTaskList
{
    NSMutableAttributedString *task1 = [[NSMutableAttributedString alloc] initWithString:@"Task1" attributes:self.normalText];
    TaskDetails *task1Details = [[TaskDetails alloc] initWithProperties:task1 textColor:[UIColor blackColor] isStrikethrough:NO];
    NSMutableAttributedString *task2 = [[NSMutableAttributedString alloc] initWithString:@"Task1" attributes:self.normalText];
    TaskDetails *task2Details = [[TaskDetails alloc] initWithProperties:task2 textColor:[UIColor blackColor] isStrikethrough:NO];
    NSMutableAttributedString *task3 = [[NSMutableAttributedString alloc] initWithString:@"Task1" attributes:self.normalText];
    TaskDetails *task3Details = [[TaskDetails alloc] initWithProperties:task3 textColor:[UIColor blackColor] isStrikethrough:NO];
    NSMutableAttributedString *task4 = [[NSMutableAttributedString alloc] initWithString:@"Task1" attributes:self.normalText];
    TaskDetails *task4Details = [[TaskDetails alloc] initWithProperties:task4 textColor:[UIColor blackColor] isStrikethrough:NO];
    self.taskList = [[NSMutableArray alloc]initWithObjects:task1Details, task2Details, task3Details, task4Details, nil];
}

@end
