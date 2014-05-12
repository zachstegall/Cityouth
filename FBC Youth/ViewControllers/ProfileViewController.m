//
//  ProfileViewController.m
//  FBC Youth
//
//  Created by Zach Stegall on 2/15/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileCell.h"
#import "ImageScale.h"
#import "TalkController.h"
#import "ImagePresentingViewController.h"

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <SAMGradientView/SAMGradientView.h>
#import <SAMCache/SAMCache.h>

@interface ProfileViewController ()
{
    NSInteger toggle;
    CGFloat screenWidth;
    CGFloat screenHeight;
    NSString *mode;
    BOOL typingNotFocused;
    BOOL typingNotFocusedAccount;
    BOOL moveOnce;
    BOOL didEditProfile;
    BOOL imageChanged;
    CGFloat centerX;
    CGFloat centerY;
    NSInteger editingSection;
    NSString *dummyString;
}
@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) UIActivityIndicatorView *indicator;
@property (nonatomic) ImagePresentingViewController *imgPresentingController;

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
        typingNotFocusedAccount = YES;
        moveOnce = NO;
        didEditProfile = NO;
        imageChanged = NO;
        centerX = [UIScreen mainScreen].bounds.size.width/2;
        centerY = [UIScreen mainScreen].bounds.size.height/2;
        dummyString = @"this is a dummy string with 255 characters. this is a dummy string with 255 characters. this is a dummy string with 255 characters. this is a dummy string with 255 characters. this is a dummy string with 255 characters. this is a dummy string w";
        editingSection = 999;
        _editorsInfo = [[Profile alloc] init];
        _tempProfileYouthView = [[Profile alloc] init];
        _sectionHeaders = [[NSArray alloc] initWithObjects:@"Excited about", @"Objective of the week", @"Verse/Quote", nil];
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.imgPresentingController = [[ImagePresentingViewController alloc] init];
        
        [self profileImageViewAllocation];
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
    
    [self buttonAllocation];
    [self youthProfileInfoAllocation];
    [self nameAllocation];
    [self tableViewAccountAllocation];
    [self inputInfoAllocation];
    
    UISwipeGestureRecognizer *swipeBackHome = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backSwipe:)];
    [swipeBackHome setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeBackHome];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    SAMGradientView *gradientView = [[SAMGradientView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, screenWidth, screenHeight)];
    gradientView.gradientColors = @[UIColorFromRGB(0xF7941E), UIColorFromRGB(0xF7c41E)];
    [self.view addSubview:gradientView];
    [self.view sendSubviewToBack:gradientView];
    self.view.backgroundColor = UIColorFromRGB(0x222222);
}

- (void)profileImageViewAllocation
{
    self.profileImgView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth/2.0f) - 50.0f, 64.0f, 100.0f, 100.0f)];
    self.profileImgView.backgroundColor = [UIColor whiteColor];
    [self profileImage:[UIImage imageNamed:@"DefaultImage"]];
    [self.profileImgView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectImageChange)];
    [self.profileImgView addGestureRecognizer:tap];
    
    [self.view addSubview:self.profileImgView];
}

- (void)didSelectImageChange
{
    if (self.navigationItem.rightBarButtonItem.image == [UIImage imageNamed:@"DoneCheck"]) {
        self.profileImgView.alpha = 0.90f;
        
        [self.view addSubview:self.imgPresentingController.view];
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage, (NSString *) kUTTypeMovie];
        imagePicker.allowsEditing = YES;
        
        [self.imgPresentingController presentViewController:imagePicker animated:YES completion:^{
            self.navigationController.navigationBarHidden = YES;
        }];
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
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
    _youthProfileInfo = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 174.0f, screenWidth, screenHeight - 174.0f)];
    _youthProfileInfo.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _youthProfileInfo.backgroundColor = [UIColor clearColor];
    [_youthProfileInfo setSeparatorInset:UIEdgeInsetsZero];
    self.youthProfileInfo.separatorStyle = UITableViewCellSeparatorStyleNone;
    _youthProfileInfo.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    [_youthProfileInfo setDelegate:self];
    [_youthProfileInfo setDataSource:self];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(infoTo)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.youthProfileInfo addGestureRecognizer:swipe];
    
    [self.view addSubview:self.youthProfileInfo];
}

-(void)nameAllocation
{
    self.firstName = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, screenWidth, 44.0f)];
    self.firstName.font = [UIFont fontWithName:@"Verdana" size:20.0f];
    [self.firstName setTextAlignment:NSTextAlignmentCenter];
    [self.firstName setTextColor:[UIColor whiteColor]];
    self.firstName.backgroundColor = [UIColor clearColor];
    self.firstName.enabled = YES;
    
    [self.view addSubview:self.firstName];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (self.profileImgView.image == [UIImage imageNamed:@"ImageChangeSelected"])
        self.profileImgView.image = [UIImage imageNamed:@"DefaultImage"];
    imageChanged = NO;
 
    [self fixLayout:picker];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self profileImage:[info objectForKey:UIImagePickerControllerEditedImage]];
    imageChanged = YES;
    
    [self fixLayout:picker];
}

- (void)profileImage:(UIImage *)image
{
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[[UIImage imageNamed:@"TriangleMask.png"] CGImage];
    mask.frame = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
    self.profileImgView.layer.mask = mask;
    self.profileImgView.layer.masksToBounds = YES;
    
    self.profileImgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.profileImgView.layer.shadowOffset = CGSizeMake(3.0f, 1.0f);
    self.profileImgView.layer.shadowOpacity = 1.0f;
    self.profileImgView.layer.shadowRadius = 1.0f;
    self.profileImgView.clipsToBounds = NO;
    
    UIImage *scaleImg = [ImageScale imageWithImage:image scaledToSize:CGSizeMake(150.0f, 150.0f)];
    [self.profileImgView setImage:scaleImg];
}

-(void)fixLayout:(UIImagePickerController *)picker
{
    self.navigationController.navigationBarHidden = NO;
    
    self.profileImgView.alpha = 1.0f;
    
//    if (!moveOnce) {
//        _youthProfileInfo.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
//        moveOnce = YES;
//    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.navigationController.navigationBar setFrame:CGRectMake(0.0f, 20.0f, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
        [self.imgPresentingController.view removeFromSuperview];
    }];
}

-(void)MenuViewControllerAllocation
{
    _MenuViewC = [[MenuViewController alloc] initWithNibName:nil bundle:nil];
    _MenuViewC.view.frame = CGRectMake(0.0f, -202.0f, [UIScreen mainScreen].bounds.size.width, 202.0f);
    [self.view addSubview:_MenuViewC.view];
}

- (void)buttonAllocation
{
    CGFloat position = self.profileImgView.bounds.size.height + 64.0f;
    
    self.page = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, position, [UIScreen mainScreen].bounds.size.width/2, 38.0f)];
    self.page.backgroundColor = [UIColor clearColor];
    [self.page setTitle:@"page" forState:UIControlStateNormal];
    [self.page setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.page setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    [self.page addTarget:self action:@selector(pageTo) forControlEvents:UIControlEventTouchUpInside];
    self.page.alpha = 0.0f;
    self.page.enabled = NO;
    
    self.info = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, position, [UIScreen mainScreen].bounds.size.width/2, 38.0f)];
    self.info.backgroundColor = [UIColor clearColor];
    [self.info setTitle:@"info" forState:UIControlStateNormal];
    [self.info setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.info setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    [self.info addTarget:self action:@selector(infoTo) forControlEvents:UIControlEventTouchUpInside];
    self.info.alpha = 0.0f;
    self.info.enabled = NO;
    
    [self.view addSubview:self.page];
    [self.view addSubview:self.info];
}

-(void)tableViewAccountAllocation
{
    self.tableViewAccount = [[UITableView alloc] initWithFrame:CGRectMake(screenWidth + 20.0f, self.youthProfileInfo.frame.origin.y + 38.0f, screenWidth - 40.0f, 80.0f) style:UITableViewStylePlain];
    [self.tableViewAccount setDelegate:self];
    [self.tableViewAccount setDataSource:self];
    self.tableViewAccount.scrollEnabled = NO;
    self.tableViewAccount.layer.cornerRadius = 3;
    self.tableViewAccount.clipsToBounds = YES;
    [self.tableViewAccount setSeparatorInset:UIEdgeInsetsZero];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(pageTo)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableViewAccount addGestureRecognizer:swipe];
    
    [self.view addSubview:self.tableViewAccount];
}

-(void)inputInfoAllocation
{
    self.firstNameAccount = [[UITextField alloc] initWithFrame:CGRectMake(5, 2, 275, 40)];
    self.firstNameAccount.font = [UIFont fontWithName:@"Verdana" size:22.0f];
    self.firstNameAccount.clearButtonMode = UITextFieldViewModeAlways;
    [self.firstNameAccount setDelegate:self];
    self.lastNameAccount = [[UITextField alloc] initWithFrame:CGRectMake(5, 2, 275, 40)];
    self.lastNameAccount.font = [UIFont fontWithName:@"Verdana" size:22.0f];
    self.lastNameAccount.clearButtonMode = UITextFieldViewModeAlways;
    [self.lastNameAccount setDelegate:self];
//    self.password = [[UITextField alloc] initWithFrame:CGRectMake(5, 2, 275, 40)];
//    self.password.font = [UIFont fontWithName:@"Verdana" size:22.0f];
//    self.password.clearButtonMode = UITextFieldViewModeAlways;
//    self.password.secureTextEntry = YES;
//    [self.password setDelegate:self];
//    self.retypePassword = [[UITextField alloc] initWithFrame:CGRectMake(5, 2, 275, 40)];
//    self.retypePassword.font = [UIFont fontWithName:@"Verdana" size:22.0f];
//    self.retypePassword.clearButtonMode = UITextFieldViewModeAlways;
//    self.retypePassword.secureTextEntry = YES;
//    [self.retypePassword setDelegate:self];
}

- (void)pageTo
{
    CGPoint positionPage = CGPointMake(screenWidth/2, self.youthProfileInfo.center.y);
    CGPoint positionInfo = CGPointMake(screenWidth + screenWidth/2, self.tableViewAccount.center.y);
    
    [UIView animateWithDuration:0.5f animations:^{
        self.youthProfileInfo.center = positionPage;
        self.tableViewAccount.center = positionInfo;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)pageReturn
{
    CGPoint positionPage = CGPointMake(screenWidth/2, self.youthProfileInfo.center.y - 38.0f);
    CGPoint positionInfo = CGPointMake(screenWidth + screenWidth/2, self.tableViewAccount.center.y);
    
    [UIView animateWithDuration:0.5f animations:^{
        self.youthProfileInfo.center = positionPage;
        self.tableViewAccount.center = positionInfo;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)infoTo
{
    if (self.navigationItem.rightBarButtonItem.image == [UIImage imageNamed:@"DoneCheck"]) {
        CGPoint positionPage = CGPointMake(-(screenWidth + screenWidth/2), self.youthProfileInfo.center.y);
        CGPoint positionInfo = CGPointMake(screenWidth/2, self.tableViewAccount.center.y);
        
        [UIView animateWithDuration:0.5f animations:^{
            self.youthProfileInfo.center = positionPage;
            self.tableViewAccount.center = positionInfo;
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - Data Collection and Organization
-(void)dishOutProfileDataCache:(NSMutableDictionary *)data
{
    self.youthData = data;
    
    for (NSInteger i = 0; i < [self.youthData count]; i++) {
        NSString *keyforobject = [NSString stringWithFormat:@"%ld", (long)i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[self.youthData objectForKey:keyforobject]];
        
        NSString *tableToken = [dict objectForKey:@"device_token"];
        NSString *userDefaultsToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"];
        
        NSString *imageName = [NSString stringWithFormat:@"%@%@%@", [dict objectForKey:@"firstname"], [dict objectForKey:@"lastname"], @".png"];
        NSData *imageData = [[SAMCache sharedCache] objectForKey:imageName];
        if ([tableToken isEqualToString:userDefaultsToken]) {
            [self.editorsInfo setObjectFromDictionary:dict];
            if (!didEditProfile) {
                if (imageData) {
                    self.profileImgView.image = [UIImage imageWithData:imageData];
                }
            } else
                didEditProfile = NO;
        }
    }
    
    self.firstName.text = [self.editorsInfo firstName];
    [self.firstNameAccount setText:[self.editorsInfo firstName]];
    [self.lastNameAccount setText:[self.editorsInfo lastName]];
}

-(void)dishOutProfileData:(NSMutableDictionary *)data
{
    self.youthData = data;
    
    for (NSInteger i = 0; i < [self.youthData count]; i++) {
        NSString *keyforobject = [NSString stringWithFormat:@"%ld", (long)i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[self.youthData objectForKey:keyforobject]];
        
        NSString *tableToken = [dict objectForKey:@"device_token"];
        NSString *userDefaultsToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"];
        if ([tableToken isEqualToString:userDefaultsToken]) {
            [self.editorsInfo setObjectFromDictionary:dict];
            NSString *imageName = [NSString stringWithFormat:@"%@%@%@", [self.editorsInfo firstName], [self.editorsInfo lastName], @".png"];
            if ([self.editorsInfo imagepath])
                [TalkController downloadImage:self imagepath:self.editorsInfo.imagepath name:imageName completion:^(NSData *data) {
                    self.profileImgView.image = [UIImage imageWithData:data];
                }];
        }
    }
    
    self.firstName.text = [self.editorsInfo firstName];
    [self.firstNameAccount setText:[self.editorsInfo firstName]];
    [self.lastNameAccount setText:[self.editorsInfo lastName]];
}

#pragma mark - Permission Settings

-(void)viewerSettings:(NSMutableDictionary *)selectedProfile
{
    mode = @"viewer";
    [self.navigationItem setLeftBarButtonItem:_backButton];
    [_tempProfileYouthView setObjectFromDictionary:selectedProfile];
    self.firstName.text = [_tempProfileYouthView firstName];
    
    NSString *imageName = [NSString stringWithFormat:@"%@%@%@", [self.tempProfileYouthView firstName], [self.tempProfileYouthView lastName], @".png"];
    NSData *imageData = [[SAMCache sharedCache] objectForKey:imageName];
    if (imageData) {
        self.profileImgView.image = [UIImage imageWithData:imageData];
    }
    
    if (![[self.tempProfileYouthView imagepath] isEqualToString:@""]) {
        [TalkController downloadImage:self imagepath:[self.tempProfileYouthView imagepath] name:imageName completion:^(NSData *data) {
            self.profileImgView.image = [UIImage imageWithData:data];
        }];
    }
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
    if (tableView == self.youthProfileInfo) {
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
        cell.backgroundColor = [UIColor clearColor];
        [cell addSubview:cell.textView];
        
        return cell;
        
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:
                self.firstNameAccount.placeholder = @"first";
                [cell addSubview:self.firstNameAccount];
                break;
            case 1:
                self.lastNameAccount.placeholder = @"last";
                [cell addSubview:self.lastNameAccount];
                break;
//            case 2:
//                self.password.placeholder = @"password";
//                [cell addSubview:self.password];
//                break;
//            case 3:
//                self.retypePassword.placeholder = @"re-type password";
//                [cell addSubview:self.retypePassword];
//                break;
            default:
                break;
        }
        
        return cell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.youthProfileInfo)
        return 1;
    
    return 4;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.youthProfileInfo)
        return 3;
    
    return 1;
}

#pragma mark - UITableViewDelegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.youthProfileInfo)
        return [self textViewHeightForRowAtIndexPath:indexPath];
    
    return 40.0f;
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
    if (tableView == self.youthProfileInfo) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 25.0f)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, tableView.frame.size.width - 10.0f, view.frame.size.height)];
        label.textColor = [UIColor whiteColor];
        [label setFont:[UIFont fontWithName:@"Verdana" size:13.0f]];
        [label setText:[_sectionHeaders objectAtIndex:section]];
        [view addSubview:label];
        view.backgroundColor = [UIColor clearColor];
        
        
        return view;
    } else {
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.youthProfileInfo)
        return 25.0f;
    
    return 0.0f;
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
    
    if (![textView isFirstResponder]) {
        [textView becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self lowerAccount];
    return [textField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self raiseAccount];
}

#pragma mark - User Interaction

-(void)donePressed:(id)sender
{
    NSString *excitedAbout = @"";
    NSString *objective = @"";
    NSString *versequote = @"";
    didEditProfile = YES;
    
    [self dismissKeyboard];
    [self.navigationItem setRightBarButtonItem:_editButton];
    [self.view bringSubviewToFront:self.MenuViewC.view];
    
    if (typingNotFocused)
        [self lowerAccount];
    
    [self pageReturn];
    [UIView animateWithDuration:0.5 animations:^{
        self.info.alpha = 0.0f;
        self.info.enabled = NO;
        self.page.alpha = 0.0f;
        self.info.enabled = NO;
    } completion:^(BOOL finished) {
        
    }];
    
    for (ProfileCell *cell in [_youthProfileInfo visibleCells]) {
        cell.textView.editable = NO;
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
    
    NSString *churchID = [[NSString alloc] initWithString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"signkey"] substringToIndex:2]];
    NSString *urlYouth = @"http://198.58.106.245/youth/";
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", urlYouth, churchID, @"uploadImage.php"];
    NSData *imageData = UIImageJPEGRepresentation(self.profileImgView.image, 0.6);
    NSString *name = [NSString stringWithFormat:@"%@%@", self.firstNameAccount.text, self.lastNameAccount.text];
    NSString *imageFileName = [NSString stringWithFormat:@"%@%@", name, @".png"];
    NSString *imagePath = [NSString stringWithFormat:@"%@%@%@%@", urlYouth, churchID, @"images/", imageFileName];
    
    NSDictionary *items = [[NSDictionary alloc] initWithObjectsAndKeys:urlString, @"urlString", imageData, @"imageData",
                           imageFileName, @"imageFileName", nil];
    
    if (imageChanged) {
        self.indicator.center = CGPointMake(self.profileImgView.center.x, self.profileImgView.center.y - 15);
        [self.view addSubview:self.indicator];
        [self.indicator startAnimating];
        [TalkController uploadImage:self items:items completion:^(BOOL success) {
            if (success) {
                [self.indicator stopAnimating];
            } else {
                [self.indicator stopAnimating];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to upload picture at this time. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.frame = CGRectMake(50.0f, 50.0f, [UIScreen mainScreen].bounds.size.width - 100.0f, 150.0f);
                [alert show];
            }
        }];
        imageChanged = NO;
    }
    
    // Navigation Controller is responsible for this delegate
    [self.tableDelegate didEditForTable:[NSArray arrayWithObjects:@"update", self.firstNameAccount.text, self.lastNameAccount.text, excitedAbout, objective, versequote,
                                         [[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"], imagePath, nil]];
}

-(void)editPressed:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        self.info.alpha = 1.0f;
        self.info.enabled = YES;
        self.page.alpha = 1.0f;
        self.page.enabled = YES;
        self.youthProfileInfo.center = CGPointMake(self.youthProfileInfo.center.x, self.youthProfileInfo.center.y + 38.0f);
    } completion:^(BOOL finished) {
        
    }];
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

-(void)backSwipe:(id)sender
{
    if ([mode isEqualToString:@"viewer"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Reposition Table For Editing

-(void)raiseTable
{
    [[[UIApplication sharedApplication] keyWindow] becomeFirstResponder];
    if (typingNotFocused) {
        [self.view bringSubviewToFront:self.youthProfileInfo];
        //_youthProfileInfo.center = CGPointMake(centerX, _youthProfileInfo.center.y - 110.0f);
        [UIView animateWithDuration:0.15f animations:^{
            self.youthProfileInfo.center = CGPointMake(centerX, _youthProfileInfo.center.y - 148.0f);
            self.youthProfileInfo.backgroundColor = [UIColorFromRGB(0x222222) colorWithAlphaComponent:0.5f];
        }];
        typingNotFocused = NO;
    }
}

-(void)lowerTable
{
    if (!typingNotFocused) {
        //_youthProfileInfo.center = CGPointMake(centerX, (_youthProfileInfo.frame.size.height/2) + 110.0f);
        [UIView animateWithDuration:0.15f animations:^{
            _youthProfileInfo.center = CGPointMake(centerX, _youthProfileInfo.center.y + 148.0f);
            self.youthProfileInfo.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            //[self.view sendSubviewToBack:self.youthProfileInfo];
        }];
        typingNotFocused = YES;
    }
    editingSection = 999;
    [_youthProfileInfo reloadData];
}

- (void)raiseAccount
{
    if (typingNotFocusedAccount) {
        [self.view bringSubviewToFront:self.tableViewAccount];
        [UIView animateWithDuration:0.15f animations:^{
            CGFloat keyHeight = 216.0f;
            CGFloat position = self.view.bounds.size.height - keyHeight - 20.0f - (self.tableViewAccount.frame.size.height / 2.0f);
            self.tableViewAccount.center = CGPointMake(self.tableViewAccount.center.x, position);
        }];
        typingNotFocusedAccount = NO;
    }
}

- (void)lowerAccount
{
    if (!typingNotFocusedAccount) {
        [UIView animateWithDuration:0.15f animations:^{
            CGFloat position = 64.0f + self.profileImgView.frame.size.height + self.info.frame.size.height + 10.0f + (self.tableViewAccount.frame.size.height/2.0f);
            self.tableViewAccount.center = CGPointMake(self.tableViewAccount.center.x, position);
        }];
        typingNotFocusedAccount = YES;
    }
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
    if (!typingNotFocused)
        [self lowerTable];
    
    for (ProfileCell *cell in [_youthProfileInfo visibleCells]) {
        [cell.textView resignFirstResponder];
    }
    [self.firstNameAccount resignFirstResponder];
    [self.lastNameAccount resignFirstResponder];
//    [self.password resignFirstResponder];
//    [self.retypePassword resignFirstResponder];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
