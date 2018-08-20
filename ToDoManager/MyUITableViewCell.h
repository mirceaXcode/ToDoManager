//
//  MyUITableViewCell.h
//  ToDoManager
//
//  Created by Mircea Popescu on 8/20/18.
//  Copyright © 2018 Mircea Popescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoEntity+CoreDataClass.h"

@interface MyUITableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *toDoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDoDueDateLabel;

@property (strong, nonatomic) ToDoEntity *localToDoEntity;

-(void) setInternalFields:(ToDoEntity *) incomingToDoEntity;


@end
