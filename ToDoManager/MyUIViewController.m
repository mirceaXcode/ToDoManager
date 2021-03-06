//
//  MyUIViewController.m
//  ToDoManager
//
//  Created by Mircea Popescu on 8/20/18.
//  Copyright © 2018 Mircea Popescu. All rights reserved.
//

#import "MyUIViewController.h"

@interface MyUIViewController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) ToDoEntity *localToDoEntity;

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *detailsField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dueDateField;

@property(nonatomic,assign) BOOL wasDeleted;


@end

@implementation MyUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated{
    
    // Setup delete state
    _wasDeleted = false;
    
    // Setup Form
    _titleField.text = _localToDoEntity.toDoTitle;
    _detailsField.text = _localToDoEntity.toDoDetails;
    NSDate *dueDate = _localToDoEntity.toDoDueDate;
    if(dueDate != nil){
        [_dueDateField setDate:dueDate];
        
    }
    
    // Detect edit ends of Text Views by Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:self];
    
}

- (void) saveMyToDoEntity{
    
    NSError *error;
    BOOL saveSuccess = [_managedObjectContext save:&error];
    
    if (!saveSuccess){
        @throw [NSException exceptionWithName:NSGenericException reason:@"Could't save!" userInfo:@{NSUnderlyingErrorKey:error}];
    }
    
}

-(void) textViewDidEndEditing:(NSNotification *) notification{
    
    if([notification object] == self){
        
        _localToDoEntity.toDoDetails = _detailsField.text;
        [self saveMyToDoEntity];
    }
    
}

- (IBAction)titleFieldEdited:(id)sender {
    
    _localToDoEntity.toDoTitle = _titleField.text;
    [self saveMyToDoEntity];
    
}

- (IBAction)dueDateEdited:(id)sender {
    
    _localToDoEntity.toDoDueDate = _dueDateField.date;
    [self saveMyToDoEntity];
    
}

- (IBAction)trashTapped:(id)sender {
    
    _wasDeleted = true;
    [_managedObjectContext deleteObject:_localToDoEntity];
    [self saveMyToDoEntity];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    if(_wasDeleted == false){
        
        // Save everything before leaving the screen
        // Don't want to save anything when the item was deleted
        
        _localToDoEntity.toDoTitle = _titleField.text;
        _localToDoEntity.toDoDetails = _detailsField.text;
        _localToDoEntity.toDoDueDate = _dueDateField.date;
        [self saveMyToDoEntity];
        
    }
    // Remove Detection
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UITextViewTextDidEndEditingNotification object:self];
    
}

- (void) receiveMOC:(NSManagedObjectContext *)incomingMOC{
    
    _managedObjectContext = incomingMOC;
    
}

- (void) receiveToDoEntity:(ToDoEntity * ) incomingToDoEntity{
    
    _localToDoEntity = incomingToDoEntity;
    
}

@end
