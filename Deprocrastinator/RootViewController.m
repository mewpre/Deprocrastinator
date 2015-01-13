//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Yi-Chin Sun, Tewodros Wondimu on 1/12/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *taskTextField;
@property NSMutableArray *taskList;
@property BOOL editModeStatus;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property NSIndexPath *deleteCellIndexPath;
@property BOOL isStrikethrough;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.taskList = [NSMutableArray arrayWithObjects:@"Task1", @"Task2", @"Task3", @"Task4", nil];
    self.editModeStatus = NO;
    self.isStrikethrough = NO;
    self.taskTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

#pragma  mark - IBActions

- (IBAction)onAddButtonPressed:(UIButton *)sender
{
    if (![self.taskTextField.text isEqualToString:@""])
    {
        [self.taskList addObject:self.taskTextField.text];
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
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    if (cell.backgroundColor == [UIColor clearColor]) {
        cell.backgroundColor = [UIColor redColor];
    }
    else if (cell.backgroundColor == [UIColor redColor])
    {
        cell.backgroundColor = [UIColor yellowColor];
    }
    else if (cell.backgroundColor == [UIColor yellowColor])
    {
        cell.backgroundColor = [UIColor greenColor];
    }
    else
    {
        cell.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - Table View Methods
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
        //add code here for when you hit delete

        UIAlertView *deleteWarning = [[UIAlertView alloc] initWithTitle:@"Delete Warning:" message:@"Do you really want to delete this task?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        // optional - add more buttons:
        [deleteWarning addButtonWithTitle:@"Delete"];
        [deleteWarning show];
        self.deleteCellIndexPath = indexPath;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!self.editModeStatus)
    {
        //Make text strikethrough
        NSDictionary *textAttribute = [[NSDictionary alloc]init];

        if (self.isStrikethrough)
        {
            //Make text not strikethrough
            textAttribute = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleNone]};
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:cell.textLabel.text attributes:textAttribute];
            cell.textLabel.attributedText = attributedString;
        }
        else
        {
            //Make text strikethrough
            textAttribute = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:cell.textLabel.text attributes:textAttribute];
            cell.textLabel.attributedText = attributedString;
        }
        self.isStrikethrough = !self.isStrikethrough;
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *stringToMove = self.taskList[sourceIndexPath.row];
    [self.taskList removeObjectAtIndex:sourceIndexPath.row];
    [self.taskList insertObject:stringToMove atIndex:destinationIndexPath.row];
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

@end
