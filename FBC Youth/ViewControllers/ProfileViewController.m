//
//  ProfileViewController.m
//  FBC Youth
//
//  Created by Zach Stegall on 2/15/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "ProfileViewController.h"
#import "TriangleProfile.h"
#import "ProfileCell.h"

@interface ProfileViewController ()
{
    NSInteger toggle;
    CGFloat screenWidth;
    CGFloat screenHeight;
    NSString *mode;
    BOOL typingNotFocused;
    CGFloat centerX;
    CGFloat centerY;
    NSInteger editingSection;
    NSString *dummyString;
}

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        screenWidth = [UIScreen mainScreen].bounds.size.width;
        screenHeight = [UIScreen mainScreen].bounds.size.height;
        toggle = 0;
        mode = @"viewer";
        typingNotFocused = YES;
        centerX = [UIScreen mainScreen].bounds.size.width/2;
        centerY = [UIScreen mainScreen].bounds.size.height/2;
        dummyString = @"this is a dummy string with 255 characters. this is a dummy string with 255 characters. this is a dummy string with 255 characters. this is a dummy string with 255 characters. this is a dummy string with 255 characters. this is a dummy string w";
        editingSection = 999;
        _editorsInfo = [[Profile alloc] init];
        _tempProfileYouthView = [[Profile alloc] init];
        _sectionHeaders = [[NSArray alloc] initWithObjects:@"Excited about", @"Objective of the week", @"Verse/Quote", nil];
        [self navBarButtonItemsAllocation];
        [self MenuViewControllerAllocation];
    }
    return self;
}

#pragma mark - ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self youthProfileInfoAllocation];
    [self nameAllocation];
    [self triangleProfileAllocation];
    
    self.view.backgroundColor = UIColorFromRGB(0x222222);
}

-(void)navBarButtonItemsAllocation
{
    _listButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"List.png"] style:UIBarButtonItemStyleDone target:self action:@selector(listPressed:)];
    _listButton.tintColor = [UIColor whiteColor];
    _editButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"EditTriangle.png"] style:UIBarButtonItemStyleDone target:self action:@selector(editPressed:)];
    _editButton.tintColor = [UIColor whiteColor];
    _doneButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"DoneCheck.png"] style:UIBarButtonItemStyleDone target:self action:@selector(donePressed:)];
    _doneButton.tintColor = [UIColor whiteColor];
    _backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackArrow.png"] style:UIBarButtonItemStyleDone target:self action:@selector(backPressed:)];
    _backButton.tintColor = [UIColor whiteColor];
}

-(void)youthProfileInfoAllocation
{
    // viewForTable is needed for collaboration with TriangleProfile
    UIView *viewForTable = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 202.0f, screenWidth, screenHeight - 202.0f)];
    viewForTable.backgroundColor = [UIColor whiteColor];
    _youthProfileInfo = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, screenWidth, viewForTable.frame.size.height - 64.0f)];
    _youthProfileInfo.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _youthProfileInfo.backgroundColor = [UIColor whiteColor];
    [_youthProfileInfo setSeparatorInset:UIEdgeInsetsZero];
    _youthProfileInfo.contentInset = UIEdgeInsetsMake(-64.0f, 0.0f, 0.0f, 0.0f);
    [_youthProfileInfo setDelegate:self];
    [_youthProfileInfo setDataSource:self];
    [viewForTable addSubview:_youthProfileInfo];
    [self.view addSubview:viewForTable];
}

-(void)nameAllocation
{
    _name = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 108.0f, screenWidth, 44.0f)];
    _name.font = [UIFont fontWithName:@"Verdana" size:20.0f];
    [_name setTextAlignment:NSTextAlignmentCenter];
    [_name setTextColor:[UIColor whiteColor]];
    _name.backgroundColor = UIColorFromRGB(0x222222);
    _name.enabled = NO;
    [_name setDelegate:self];
    [self.view addSubview:_name];
}

-(void)triangleProfileAllocation
{
    TriangleProfile *triangle = [[TriangleProfile alloc] initWithFrame:CGRectMake((screenWidth/2.0f) - 50.0f, 152.0f, 100.0f, 100.0f)];
    [self.view addSubview:triangle];
}

-(void)MenuViewControllerAllocation
{
    _MenuViewC = [[MenuViewController alloc] initWithNibName:nil bundle:nil];
    _MenuViewC.view.frame = CGRectMake(0.0f, -202.0f, [UIScreen mainScreen].bounds.size.width, 202.0f);
    [self.view addSubview:_MenuViewC.view];
}

#pragma mark - Data Collection and Organization

-(void)dishOutProfileData:(NSMutableDictionary *)data
{
    _youthData = data;
    
    for (NSInteger i = 0; i < [_youthData count]; i++) {
        NSString *keyforobject = [NSString stringWithFormat:@"%ld", (long)i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[_youthData objectForKey:keyforobject]];
        
        NSString *tableToken = [dict objectForKey:@"device_token"];
        NSString *userDefaultsToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"];
        if ([tableToken isEqualToString:userDefaultsToken]) {
            [_editorsInfo setObjectFromDictionary:dict];
            break;
        }
    }
    _name.text = [NSString stringWithFormat:@"%@%@%@", [_editorsInfo firstName], @" ", [_editorsInfo lastName]];
    [_youthProfileInfo reloadData];
}

#pragma mark - Permission Settings

-(void)viewerSettings:(NSMutableDictionary *)selectedProfile
{
    mode = @"viewer";
    [self.navigationItem setLeftBarButtonItem:_backButton];
    [_tempProfileYouthView setObjectFromDictionary:selectedProfile];
    _name.text = [NSString stringWithFormat:@"%@%@%@", [_tempProfileYouthView firstName], @" ", [_tempProfileYouthView lastName]];
    
    [_youthProfileInfo reloadData];
}

-(void)editorSettings
{
    mode = @"editor";
    [self.navigationItem setLeftBarButtonItem:_listButton];
    [self.navigationItem setRightBarButtonItem:_editButton];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellId";
    
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.textView setDelegate:self];
    }
    
    if ([mode isEqualToString:@"editor"]) {
        if (indexPath.section == 0) {
            cell.textView.text = [_editorsInfo excitedAbout];
        } else if (indexPath.section == 1) {
            cell.textView.text = [_editorsInfo objective];
        } else {
            cell.textView.text = [_editorsInfo versequote];
        }
    } else {
        if (indexPath.section == 0) {
            cell.textView.text = [_tempProfileYouthView excitedAbout];
        } else if (indexPath.section == 1) {
            cell.textView.text = [_tempProfileYouthView objective];
        } else {
            cell.textView.text = [_tempProfileYouthView versequote];
        }
    }

    CGSize size = [cell.textView sizeThatFits:CGSizeMake(screenWidth - 10.0f, FLT_MAX)];
    if (size.width < screenWidth - 10.0f)
        size.width = screenWidth - 10.0f;
    cell.textView.frame = CGRectMake(10.0f, 7.5f, size.width, size.height);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addSubview:cell.textView];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

#pragma mark - UITableViewDelegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self textViewHeightForRowAtIndexPath:indexPath];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self dismissKeyboard];
    }
    
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return (newLength > 255) ? NO : YES;
}

// heightForRowAtIndexPath is called after cellForRowAtIndexPath
// so we have to recreate a size for the text that will be going
// into the cells' textviews.
-(CGFloat)textViewHeightForRowAtIndexPath: (NSIndexPath *)item
{
    UITextView *textF = [[UITextView alloc] init];
    textF.font = [UIFont fontWithName:@"Verdana" size:18.0f];

    if ([mode isEqualToString:@"editor"]) {
        if (item.section == 0) {
            textF.text = [_editorsInfo excitedAbout];
        } else if (item.section == 1) {
            textF.text = [_editorsInfo objective];
        } else {
            textF.text = [_editorsInfo versequote];
        }
        
        if (editingSection != 999 && item.section == editingSection)
                textF.text = dummyString;
    } else {
        if (item.section == 0) {
            textF.text = [_tempProfileYouthView excitedAbout];
        } else if (item.section == 1) {
            textF.text = [_tempProfileYouthView objective];
        } else {
            textF.text = [_tempProfileYouthView versequote];
        }
    }
    
    CGSize size = [textF sizeThatFits:CGSizeMake(screenWidth - 10.0f, FLT_MAX)];

    return size.height + 17.5f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 25.0f)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, tableView.frame.size.width - 10.0f, view.frame.size.height)];
    [label setFont:[UIFont fontWithName:@"Verdana" size:13.0f]];
    [label setText:[_sectionHeaders objectAtIndex:section]];
    [view addSubview:label];
    view.backgroundColor = [UIColorFromRGB(0xF7941E) colorWithAlphaComponent:0.60f];
    
    return view;
}

#pragma mark - UITextViewDelegates

-(void)textViewDidChange:(UITextView *)textView
{
    if (editingSection == 0) {
        [_editorsInfo setExcitedAbout:textView.text];
    } else if (editingSection == 1) {
        [_editorsInfo setObjective:textView.text];
    } else if (editingSection == 2) {
        [_editorsInfo setVersequote:textView.text];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self raiseTable];
    CGFloat height;
    for (ProfileCell *cell in [_youthProfileInfo visibleCells]) {
        if (textView == cell.textView) {
            editingSection = [_youthProfileInfo indexPathForCell:cell].section;
            height = [self tableView:_youthProfileInfo heightForRowAtIndexPath:[_youthProfileInfo indexPathForCell:cell]];
            textView.frame = CGRectMake(10.0f, 7.5f, textView.frame.size.width, height);
        }
    }
    
    CGRect sectionRect = [_youthProfileInfo rectForSection:editingSection];
    [_youthProfileInfo scrollRectToVisible:sectionRect animated:NO];
    [_youthProfileInfo beginUpdates];
    [_youthProfileInfo endUpdates];
}

#pragma mark - UITextFieldDelegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

#pragma mark - User Interaction

-(void)donePressed:(id)sender
{
    NSString *firstTemp = @"";
    NSString *lastTemp = @"";
    NSString *excitedAbout = @"";
    NSString *objective = @"";
    NSString *versequote = @"";
    
    [self dismissKeyboard];
    [self.navigationItem setRightBarButtonItem:_editButton];
    _name.enabled = NO;
    
    for (ProfileCell *cell in [_youthProfileInfo visibleCells]) {
        cell.textView.editable = NO;
    }
    
    if ([[_name.text componentsSeparatedByString:@" "] count] > 1) {
        firstTemp = [[_name.text componentsSeparatedByString:@" "] objectAtIndex:0];
        lastTemp = [_name.text substringFromIndex:[firstTemp length]+1];
    } else {
        firstTemp = _name.text;
        lastTemp = @"";
    }
    
    for (ProfileCell *cell in [_youthProfileInfo visibleCells]) {
        if (cell == [[_youthProfileInfo visibleCells] objectAtIndex:0]) {
            excitedAbout = cell.textView.text;
        } else if (cell == [[_youthProfileInfo visibleCells] objectAtIndex:1]) {
            objective = cell.textView.text;
        } else {
            versequote = cell.textView.text;
        }
    }
    
    // Navigation Controller is responsible for this delegate
    [self.tableDelegate didEditForTable:[NSArray arrayWithObjects:@"update", firstTemp, lastTemp, excitedAbout, objective, versequote,
                                         [[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"], nil]];
}

-(void)editPressed:(id)sender
{
    _name.enabled = YES;
    [self.navigationItem setRightBarButtonItem:_doneButton];
    for (ProfileCell *cell in [_youthProfileInfo visibleCells]) {
        cell.textView.editable = YES;
    }
}

-(void)listPressed:(id)sender
{
    // Navigation Controller is responsible
    // for this delegate
    [self.delegate didToggle];
}

-(void)backPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Reposition Table For Editing

-(void)raiseTable
{
    if (typingNotFocused) {
        [self.view bringSubviewToFront:[_youthProfileInfo superview]];
        _youthProfileInfo.center = CGPointMake(centerX, _youthProfileInfo.center.y - 64.0f);
        [UIView animateWithDuration:0.15f animations:^{
            [_youthProfileInfo superview].center = CGPointMake(centerX, [_youthProfileInfo superview].center.y - 138.0f);
        }];
        typingNotFocused = NO;
    }
}

-(void)lowerTable
{
    if (!typingNotFocused) {
        _youthProfileInfo.center = CGPointMake(centerX, (_youthProfileInfo.frame.size.height/2) + 64.0f);
        [UIView animateWithDuration:0.15f animations:^{
            [_youthProfileInfo superview].center = CGPointMake(centerX, [_youthProfileInfo superview].center.y + 138.0f);
        } completion:^(BOOL finished) {
            [self.view sendSubviewToBack:[_youthProfileInfo superview]];
        }];
        typingNotFocused = YES;
    }
    editingSection = 999;
    [_youthProfileInfo reloadData];
}

#pragma mark - Keyboard Control

-(void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(_youthProfileInfo.contentInset.top, 0.0, kbSize.height, 0.0);
    _youthProfileInfo.contentInset = contentInsets;
    _youthProfileInfo.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(_youthProfileInfo.contentInset.top, 0.0, 0.0, 0.0);
    _youthProfileInfo.contentInset = contentInsets;
    _youthProfileInfo.scrollIndicatorInsets = contentInsets;
    [UIView commitAnimations];
}

-(void)dismissKeyboard
{
    [self lowerTable];
    for (ProfileCell *cell in [_youthProfileInfo visibleCells]) {
        [cell.textView resignFirstResponder];
    }
    [_name resignFirstResponder];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
