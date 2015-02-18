//
//  UCScheduleTableViewController.m
//  AlmappUC
//
//  Created by Patricio López on 17-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCScheduleTableViewController.h"
#import "UCScheduleConstants.h"
#import "UCAppDelegate.h"

static float const kDatePickerHeight = 50.0f;

@interface UCScheduleTableViewController ()

@end

@implementation UCScheduleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scheduleItems = [NSArray array];
    
    for (NSString *nibName in @[[UCScheduleCell nibName], [UCScheduleEndCell nibName]]) {
        UINib *nib = [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]];
        [self.tableView registerNib:nib forCellReuseIdentifier:nibName];
    }
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.backgroundView = [[UIView alloc]initWithFrame:self.tableView.bounds];
    self.tableView.backgroundView.backgroundColor = [UCScheduleConstants backgroundColor];
    
    _datePicker = [[DIDatepicker alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kDatePickerHeight)];
    [_datePicker addTarget:self action:@selector(updateSelectedDate) forControlEvents:UIControlEventValueChanged];
    [_datePicker fillCurrentYear];
    [_datePicker selectDate:[NSDate date]];
    self.tableView.tableHeaderView = _datePicker;
    
    [self refreshTable];
}


- (ALMScheduleDay)currentDay {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:_datePicker.selectedDate];
    int weekday = (int)[comps weekday];
    return [self transformDayNumber:weekday];
}

- (ALMScheduleDay)transformDayNumber:(int)day {
    // Monday = 1
    return (day == 1) ? 7 : --day;
}

- (void)refreshTable {
    _scheduleItems = [[UCAppDelegate controllerSchedule] scheduleItemsAtDay:self.currentDay];
    
    // [self.tableView reloadData];
    NSRange range = NSMakeRange(0, [self numberOfSectionsInTableView:self.tableView]);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)updateSelectedDate {
    [self refreshTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _scheduleItems.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _scheduleItems.count) {
        
        UCScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:[UCScheduleCell nibName] forIndexPath:indexPath];
        [cell setItem:_scheduleItems[indexPath.row] onDay:_datePicker.selectedDate];
        
        cell.isEven = (indexPath.row % 2 == 0);
        
        return cell;
    }
    else {
        UCScheduleEndCell *cell = [tableView dequeueReusableCellWithIdentifier:[UCScheduleEndCell nibName] forIndexPath:indexPath];
        [cell showTimelineProgressOn:_datePicker.selectedDate];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UCScheduleCell height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _scheduleItems.count) {
        return [UCScheduleCell height];
    }
    else {
        return [UCScheduleEndCell height];
    }
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (UIScrollView *)scrollViewForParallaxController {
    return self.tableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
