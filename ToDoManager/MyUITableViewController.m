//
//  MyUITableViewController.m
//  ToDoManager
//
//  Created by Mircea Popescu on 8/20/18.
//  Copyright © 2018 Mircea Popescu. All rights reserved.
//

#import "MyUITableViewController.h"
#import <CoreData/CoreData.h>
#import "MyUITableViewCell.h"
#import "MPHandlesToDoEntity.h"

@interface MyUITableViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSFetchedResultsController *resultsController;


@end

@implementation MyUITableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialiseNSFetchedResultsControllerDelegate];
    
}

#pragma mark - TableView Delegates

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _resultsController.sections[section].numberOfObjects;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Setup the cell for a particular row with the data corresponding to the section and row that our UI is asking for
    ToDoEntity *item = _resultsController.sections[indexPath.section].objects[indexPath.row];
    // Create a new cell by asking for a cell from our pool associated with our prototype cells - TableCellIdentifier
    MyUITableViewCell *cell = (MyUITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"TableCellIdentifier" forIndexPath:indexPath];
    // Set all the internal fields based on the ToDoEntity thats associated with this
    [cell setInternalFields:item];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2) {
        cell.backgroundColor = [UIColor yellowColor];
    } else {
        cell.backgroundColor = [UIColor cyanColor];
    }
}

// in order to enable to edit the tableView, in my case, I want to swipe delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

// implement swipe delete function
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        // Delete the row from the data source
        id object = [_resultsController objectAtIndexPath:indexPath];
        [_managedObjectContext deleteObject:object];

    }
}
#pragma mark - NSFetchedResultsControllerDelegate
// To support automatic updates to our table view, we will use a fetched results controller. A fetched results controller is an object that can manage a fetch request with a big number of items and is the perfect Core Data companion to a table view

-(void) initialiseNSFetchedResultsControllerDelegate {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    fetchRequest.entity = [NSEntityDescription entityForName:@"ToDoEntity" inManagedObjectContext:_managedObjectContext];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    // sorts the listing by whatever field you want, either title, date, etc. As it's a ToDo list, makes sense to use the date.
    //fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"toDoTitle" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"toDoDueDate" ascending:YES]];
    
    _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _resultsController.delegate = self;
    
    NSError *err;
    BOOL fetchSucceeded = [_resultsController performFetch:&err];
    if(!fetchSucceeded){
        @throw [NSException exceptionWithName:NSGenericException reason:@"Could't fetch!" userInfo:@{NSUnderlyingErrorKey:err}];
    }
    
}

// Listening to changes. NSFetchedResultsController will listen and implement any changes to the table view, like delete, changes, moves

-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}

-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];

            break;
            
        case NSFetchedResultsChangeUpdate:{
            MyUITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            ToDoEntity *item = [controller objectAtIndexPath:indexPath];
            [cell setInternalFields:item];
            break;
        }
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        
    // Using the Controler we created, we are passing our managedObjectContext down to our segue, destinationViewController is MyUIViewControler
    id<MPHandlesMOC,MPHandlesToDoEntity> child = (id<MPHandlesMOC,MPHandlesToDoEntity>)[segue destinationViewController];
        [child receiveMOC:_managedObjectContext];
    
    ToDoEntity *item;
    // If you press on the + button, it will create a new entity and pass it to the View Controler, if you press a table cell, it will pull out the entity associated with that cell and pass the information to the Vew Controller.
    if([sender isMemberOfClass:[UIBarButtonItem class]]){
        item = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoEntity" inManagedObjectContext:_managedObjectContext];
    }
    else {
        MyUITableViewCell *source = (MyUITableViewCell *) sender;
        item = source.localToDoEntity;
    }
    // Initializing the View Controller with the value of the new or the passing the value of the existing entity from above.
    [child receiveToDoEntity:item];

}

- (void) receiveMOC:(NSManagedObjectContext *)incomingMOC{
    
    _managedObjectContext = incomingMOC;
    
}

- (void) saveMyToDoEntity{
    
    NSError *error;
    BOOL saveSuccess = [_managedObjectContext save:&error];
    
    if (!saveSuccess){
        @throw [NSException exceptionWithName:NSGenericException reason:@"Could't save!" userInfo:@{NSUnderlyingErrorKey:error}];
    }
    
}

@end
