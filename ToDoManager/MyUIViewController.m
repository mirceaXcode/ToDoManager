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


@end

@implementation MyUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) saveMyToDoEntity{
    
    NSError *error;
    BOOL saveSuccess = [_managedObjectContext save:&error];
    
    if (!saveSuccess){
        @throw [NSException exceptionWithName:NSGenericException reason:@"Could't save!" userInfo:@{NSUnderlyingErrorKey:error}];
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) textViewDidEndEditing:(NSNotification *) notification{
    
    if([notification object] == self){
        
        _localToDoEntity.toDoDetails = _detailsField.text;
        [self saveMyToDoEntity];
    }
    
}

-(void) viewWillAppear:(BOOL)animated{
    
    // Setup Form
    _titleField.text = _localToDoEntity.toDoTitle;
    _detailsField.text = _localToDoEntity.toDoDetails;
    
    NSDate *dueDate = _localToDoEntity.toDoDueDate;
    if(dueDate != nil){
        [_dueDateField setDate:dueDate];
    }
    
    // Detect edit ends
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:self];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    // Save everything;
    _localToDoEntity.toDoTitle = _titleField.text;
    _localToDoEntity.toDoDetails = _detailsField.text;
    _localToDoEntity.toDoDueDate = _dueDateField.date;
     [self saveMyToDoEntity];
    
    // Remove Detection
      [[NSNotificationCenter defaultCenter] removeObserver:self  name:UITextViewTextDidEndEditingNotification object:self];
    
}

- (IBAction)titleFieldEdited:(id)sender {
    
    _localToDoEntity.toDoTitle = _titleField.text;
    [self saveMyToDoEntity];
    
}

- (IBAction)dueDateEdited:(id)sender {
    
    _localToDoEntity.toDoDueDate = _dueDateField.date;
    [self saveMyToDoEntity];
    
}


- (void) receiveMOC:(NSManagedObjectContext *)incomingMOC{
    
    _managedObjectContext = incomingMOC;
    
}

- (void) receiveToDoEntity:(ToDoEntity * ) incomingToDoEntity{
    
    _localToDoEntity = incomingToDoEntity;
    
}

@end
