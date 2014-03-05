//
//  CSCViewController.m
//  LifeCounter
//
//  Created by Charles Chandler on 11/20/13.
//  Copyright (c) 2013 Charles Chandler. All rights reserved.
//

#import "CSCViewController.h"
#import <QuartzCore/QuartzCore.h>

#define IS_568_SCREEN (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)


@interface CSCViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *oppLifeTotal;
@property (weak, nonatomic) IBOutlet UIPickerView *userLifeTotal;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *poisonButton;
@property (weak, nonatomic) IBOutlet UIButton *logButton;
@property (weak, nonatomic) IBOutlet UIButton *randomButton;
@property (weak, nonatomic) IBOutlet UITextField *oppName;
@property (weak, nonatomic) IBOutlet UITextField *userName;

@property UITextView *logViewUser;
@property UITextView *logViewOpp;
@property UITextView *logUserName;
@property UITextView *logOppName;
@property UIView *logBackground;
@property NSArray *lifeRange;
@property NSInteger poison;
@property CGPoint position;
@property NSInteger savedUserLifeTotal;
@property NSInteger savedOppLifeTotal;
@property NSInteger savedUserPoisonTotal;
@property NSInteger savedOppPoisonTotal;

- (IBAction)resetButton:(id)sender;
- (IBAction)poisonButton:(id)sender;
- (IBAction)logButton:(id)sender;
- (IBAction)randomButton:(id)sender;

- (void)outputLifeTotals:(NSTimer *)lifeLog;

@end

@implementation CSCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // create the values to be stored in the pickers
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i=0; i<999; i++) {
        [temp addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    self.lifeRange = [[NSArray alloc] initWithArray:temp];
    
    // set starting values for pickers
    [self.oppLifeTotal selectRow:20 inComponent:0 animated:YES];
    [self.userLifeTotal selectRow:20 inComponent:0 animated:YES];
    
    // cosmetic changes to UI
    [self.oppLifeTotal setBackgroundColor:[UIColor blackColor]];
    [self.userLifeTotal setBackgroundColor:[UIColor blackColor]];
    
    // For 4" screens
    if (IS_568_SCREEN) {
        
        // create the frame for the background
        CGRect logBackgroundFrame = CGRectMake(20, 40, 280, 460);
        self.logBackground = [[UITextView alloc] initWithFrame:logBackgroundFrame];
        [self.logBackground setBackgroundColor:[UIColor lightGrayColor]];
        self.logBackground.hidden = YES;
        [self.view addSubview:self.logBackground];
        
        // create the frame and view for the log user name
        CGRect logUserNameFrame = CGRectMake(30, 40, 130, 30);
        self.logUserName = [[UITextView alloc] initWithFrame:logUserNameFrame];
        [self.logUserName setBackgroundColor:[UIColor lightGrayColor]];
        self.logUserName.hidden = YES;
        [self.view addSubview:self.logUserName];
        
        // create the frame and view for the log opponent name
        CGRect logOppNameFrame = CGRectMake(160, 40, 130, 30);
        self.logOppName = [[UITextView alloc] initWithFrame:logOppNameFrame];
        [self.logOppName setBackgroundColor:[UIColor lightGrayColor]];
        self.logOppName.hidden = YES;
        [self.view addSubview:self.logOppName];
        
        // create the frame and view for the user log subview
        CGRect logFrameUser = CGRectMake(30, 70, 130.00, 430.00);
        self.logViewUser = [[UITextView alloc] initWithFrame:logFrameUser];
        [self.logViewUser setBackgroundColor:[UIColor lightGrayColor]];
        self.logViewUser.hidden = YES;
        [self.view addSubview:self.logViewUser];
        
        // create the frame and view for the opponent log subview
        CGRect logFrameOpp = CGRectMake(160, 70, 130.00, 430.00);
        self.logViewOpp = [[UITextView alloc] initWithFrame:logFrameOpp];
        [self.logViewOpp setBackgroundColor:[UIColor lightGrayColor]];
        self.logViewOpp.hidden = YES;
        [self.view addSubview:self.logViewOpp];
    
    // For 3.5" screens
    } else {
        
        // create the frame for the background
        CGRect logBackgroundFrame = CGRectMake(20, 20, 280, 425);
        self.logBackground = [[UITextView alloc] initWithFrame:logBackgroundFrame];
        [self.logBackground setBackgroundColor:[UIColor lightGrayColor]];
        self.logBackground.hidden = YES;
        [self.view addSubview:self.logBackground];
        
        // create the frame and view for the log user name
        CGRect logUserNameFrame = CGRectMake(30, 20, 130, 30);
        self.logUserName = [[UITextView alloc] initWithFrame:logUserNameFrame];
        [self.logUserName setBackgroundColor:[UIColor lightGrayColor]];
        self.logUserName.hidden = YES;
        [self.view addSubview:self.logUserName];
        
        // create the frame and view for the log opponent name
        CGRect logOppNameFrame = CGRectMake(160, 20, 130, 30);
        self.logOppName = [[UITextView alloc] initWithFrame:logOppNameFrame];
        [self.logOppName setBackgroundColor:[UIColor lightGrayColor]];
        self.logOppName.hidden = YES;
        [self.view addSubview:self.logOppName];
        
        // create the frame and view for the user log subview
        CGRect logFrameUser = CGRectMake(30, 50, 130.00, 395.00);
        self.logViewUser = [[UITextView alloc] initWithFrame:logFrameUser];
        [self.logViewUser setBackgroundColor:[UIColor lightGrayColor]];
        self.logViewUser.hidden = YES;
        [self.view addSubview:self.logViewUser];
        
        // create the frame and view for the opponent log subview
        CGRect logFrameOpp = CGRectMake(160, 50, 130.00, 395.00);
        self.logViewOpp = [[UITextView alloc] initWithFrame:logFrameOpp];
        [self.logViewOpp setBackgroundColor:[UIColor lightGrayColor]];
        self.logViewOpp.hidden = YES;
        [self.view addSubview:self.logViewOpp];
    }
    
    // add text to subviews
    self.logUserName.text = [self.logUserName.text stringByAppendingFormat:@"%@", self.userName.text];
    self.logOppName.text = [self.logOppName.text stringByAppendingFormat:@"%@", self.oppName.text];
    
    self.logViewUser.text = @"_________________\n";
    self.logViewOpp.text = @"_________________\n";
    
    // make it so players cannot change the life totals
    self.logViewUser.editable = NO;
    self.logViewOpp.editable = NO;
    
    // prevent screen idling
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    // increase text size for the names on the log view
    [self.logUserName setFont:[UIFont boldSystemFontOfSize:16]];
    [self.logOppName setFont:[UIFont boldSystemFontOfSize:16]];
}

- (void)viewDidAppear:(BOOL)animated
{
    // every time to timer is fired, output the life totals to the logview
    __unused NSTimer *lifeLog = [NSTimer scheduledTimerWithTimeInterval:1
                                                                 target:self
                                                               selector:@selector(outputLifeTotals:)
                                                               userInfo:nil
                                                                repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Picker Data Source Methods

// number of columns
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.poison == 1) {
        return 2;
    } else {
        return 1;
    }
}

// range of the columns
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.lifeRange count];
}

#pragma mark Picker Delegate Methods

// set delagates, made unique view for asthetic reasons
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 40)];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:28];
    label.text = [NSString stringWithFormat:@"                %ld", (long)row];
    return label;
}



// reset button, with alert to prevent accidental usage
- (IBAction)resetButton:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Life Reset"
                                                    message:Nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Ok", nil];
    
    alert.tag = 1;
    [alert show];
}

// after alert is dismissed, fires if OK was chosen.  Tagged from the alert UIAlertView
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // fires the correct UIAlertView
    if (alertView.tag == 1) {
    
        if (buttonIndex == 1) {
            
            self.poison = 0;
            
            [self.oppLifeTotal reloadAllComponents];
            [self.userLifeTotal reloadAllComponents];
            
            [self.oppLifeTotal selectRow:20 inComponent:0 animated:YES];
            [self.userLifeTotal selectRow:20 inComponent:0 animated:YES];
            
            // determine the length of each life total column
            NSUInteger userLength = [[self.logViewUser.text componentsSeparatedByString:@"\n"] count];
            NSUInteger oppLength = [[self.logViewOpp.text componentsSeparatedByString:@"\n"] count];

            // equalize the length of each life total colummn
            if (userLength > oppLength) {
                while (userLength >oppLength) {
                    self.logViewOpp.text = [self.logViewOpp.text stringByAppendingString:@"\n."];
                    oppLength = [[self.logViewOpp.text componentsSeparatedByString:@"\n"] count];
                }
            } else if (oppLength > userLength) {
                while (oppLength > userLength) {
                    self.logViewUser.text = [self.logViewUser.text stringByAppendingString:@"\n."];
                    userLength = [[self.logViewUser.text componentsSeparatedByString:@"\n"] count];
                }
            }
            
            self.logViewUser.text = [self.logViewUser.text stringByAppendingString:@"\n_________________\n"];
            
            // output the starting life total if it didnt change during the game
            if (self.savedUserLifeTotal == 20) {
                self.logViewUser.text = [self.logViewUser.text stringByAppendingFormat:@"\n%ld", (long)[self.userLifeTotal selectedRowInComponent:0]];
            }
            
            self.logViewOpp.text = [self.logViewOpp.text stringByAppendingString:@"\n_________________\n"];
            
            // output the starting life total if it didnt change during the game
            if (self.savedOppLifeTotal == 20) {
                self.logViewOpp.text = [self.logViewOpp.text stringByAppendingFormat:@"\n%ld", (long)[self.oppLifeTotal selectedRowInComponent:0]];
            }
            
            // revert button color
            [self.poisonButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
    }
    
}

// increments the global variable poison, which changes the numberOfComponentsInPickerView value
- (IBAction)poisonButton:(id)sender
{
    self.poison = 1;
    
    [self.oppLifeTotal reloadAllComponents];
    [self.userLifeTotal reloadAllComponents];
    
    // change button color
    [self.poisonButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

// sets the name textfields to blank upon editing
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.logUserName.text = self.userName.text;
    self.logOppName.text = self.oppName.text;
}

// resigns keyboard upon hitting enter
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

// toggles the logView subview hidden attribute
- (IBAction)logButton:(id)sender
{
    if (self.logViewUser.hidden == YES) {
        self.logBackground.hidden = NO;
        self.logOppName.hidden = NO;
        self.logUserName.hidden = NO;
        self.logViewUser.hidden = NO;
        self.logViewOpp.hidden = NO;
        [self.logViewUser scrollRangeToVisible:NSMakeRange(0,[self.logViewUser.text length])];
        [self.logViewOpp scrollRangeToVisible:NSMakeRange(0,[self.logViewOpp.text length])];
    } else if (self.logViewUser.hidden == NO) {
        self.logViewUser.hidden = YES;
        self.logViewOpp.hidden = YES;
        self.logUserName.hidden = YES;
        self.logOppName.hidden = YES;
        self.logBackground.hidden = YES;
    }
}

// outputs the lifetotals of the players to the subview
- (void)outputLifeTotals:(NSTimer *)lifeLog
{
    // enable editing
    self.logViewUser.editable = YES;
    self.logViewOpp.editable = YES;
    
    // output the strings if the values have changed
    if (self.poison == 0) {
       
        if ([self.userLifeTotal selectedRowInComponent:0] != self.savedUserLifeTotal) {
            
            self.logViewUser.text = [self.logViewUser.text stringByAppendingFormat:@"\n%ld", (long)[self.userLifeTotal selectedRowInComponent:0]];
        
            // create a persistent value for the userLifeTotal and oppLifeTotal in comp. 0 to check against
            self.savedUserLifeTotal = [self.userLifeTotal selectedRowInComponent:0];
        }
        
        if ([self.oppLifeTotal selectedRowInComponent:0] != self.savedOppLifeTotal) {
            
            self.logViewOpp.text = [self.logViewOpp.text stringByAppendingFormat:@"\n%ld", (long)[self.oppLifeTotal selectedRowInComponent:0]];
            
            self.savedOppLifeTotal = [self.oppLifeTotal selectedRowInComponent:0];
        }
    }
    
    // output poison if its been activated and poison values have changed
    if (self.poison == 1) {
        
        // Outputs life total and poison total  for user
        if ([self.userLifeTotal selectedRowInComponent:1] != self.savedUserPoisonTotal ||
            [self.userLifeTotal selectedRowInComponent:0] != self.savedUserLifeTotal) {
            
            self.logViewUser.text = [self.logViewUser.text stringByAppendingFormat:@"\n%ld", (long)[self.userLifeTotal selectedRowInComponent:0]];
            
            self.logViewUser.text = [self.logViewUser.text stringByAppendingFormat:@"               %ld", (long)[self.userLifeTotal selectedRowInComponent:1]];
        
            // create a persistant value for the userLifeTotal and oppLifeTotal in comp. 1 to check against
            self.savedUserLifeTotal = [self.userLifeTotal selectedRowInComponent:0];
        
            self.savedUserPoisonTotal = [self.userLifeTotal selectedRowInComponent:1];
        }
        
        // Outputs life total and poison total for opponent
        if ([self.oppLifeTotal selectedRowInComponent:0] != self.savedOppLifeTotal ||
            [self.oppLifeTotal selectedRowInComponent:1] != self.savedOppPoisonTotal) {
            
            self.logViewOpp.text = [self.logViewOpp.text stringByAppendingFormat:@"\n%ld", (long)[self.oppLifeTotal selectedRowInComponent:0]];
            
            self.logViewOpp.text = [self.logViewOpp.text stringByAppendingFormat:@"             %ld", (long)[self.oppLifeTotal selectedRowInComponent:1]];
            
            self.savedOppLifeTotal = [self.oppLifeTotal selectedRowInComponent:0];
            
            self.savedOppPoisonTotal = [self.oppLifeTotal selectedRowInComponent:1];
        }
    }
    
    // disable editing
    self.logViewUser.editable = NO;
    self.logViewOpp.editable = NO;
    
}

// For rolling random numbers
- (IBAction)randomButton:(id)sender
{
    UIAlertView *random = [[UIAlertView alloc] initWithTitle:@"Choose an option"
                                                    message:Nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Coin flip", @"D 20", nil];
    random.tag = 2;
    [random show];
}

// Outputs random variables.  Tagged from the random UIAlertView.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // fires the correct UIAlertView
    if (alertView.tag == 2) {
    
        // Displays random 0 or 1, labeled Heads or Tails
        if (buttonIndex == 1) {
            
            NSString *coinResult = Nil;
            int coin = arc4random() % 2;
            
            if (coin == 0) {
                coinResult = @"Heads";
            } else if (coin == 1) {
                coinResult = @"Tails";
            }
            
            UIAlertView *coinFlip = [[UIAlertView alloc] initWithTitle:coinResult
                                                             message:Nil
                                                            delegate:self
                                                   cancelButtonTitle:@"Done"
                                                   otherButtonTitles:nil];
            [coinFlip show];
        
        // Displays a random number between 1 and 20
        } else if (buttonIndex == 2) {
            
            int roll = arc4random() % 20;
            roll += 1;
            NSString *rollResult = [NSString stringWithFormat:@"%d", roll];
            
            UIAlertView *d20 = [[UIAlertView alloc] initWithTitle:rollResult
                                                             message:Nil
                                                            delegate:self
                                                   cancelButtonTitle:@"Done"
                                                   otherButtonTitles:nil];
            [d20 show];
        }
    }
}

@end

