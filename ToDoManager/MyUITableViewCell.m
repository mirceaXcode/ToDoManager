//
//  MyUITableViewCell.m
//  ToDoManager
//
//  Created by Mircea Popescu on 8/20/18.
//  Copyright © 2018 Mircea Popescu. All rights reserved.
//

#import "MyUITableViewCell.h"

@implementation MyUITableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setInternalFields:(ToDoEntity *) incomingToDoEntity{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    _toDoTitleLabel.text = incomingToDoEntity.toDoTitle;
    _toDoDueDateLabel.text = [dateFormatter stringFromDate: incomingToDoEntity.toDoDueDate];
    
    _localToDoEntity = incomingToDoEntity;
    
}

@end
