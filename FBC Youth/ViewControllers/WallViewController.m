//
//  WallViewController.m
//  FBC Youth
//
//  Created by Zach Stegall on 2/17/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "WallViewController.h"
#import "WallCell.h"

#import <SAMGradientView/SAMGradientView.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface WallViewController ()
@property (nonatomic) NSUInteger toggleView;
@property (nonatomic) MFMessageComposeViewController *messageVC;
@end

@implementation WallViewController

NSString *const YOUTH_KEY = @"MVyouthFBC";
NSString *const ADMIN_KEY = @"MVadminFBC1819";

-(NSUInteger)toggleView
{
    if (!_toggleView) _toggleView = 0;
    return _toggleView;
}

-(NSMutableArray *)wallData
{
    if (!_wallData) {
        _wallData = [[NSMutableArray alloc] init];
    }
    return _wallData;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _WriteMessageViewC = [[WriteMessageViewController alloc] init];
        _WriteMessageViewC.view.tag = 17;
        _WriteMessageViewC.newsButton.UserInteractionEnabled = YES;
        _WriteMessageViewC.thoughtButton.UserInteractionEnabled = YES;
        _WriteMessageViewC.iloveyouButton.UserInteractionEnabled = YES;
        _WriteMessageViewC.delegate =  self;
        _WriteMessageViewC.rideDelegate = self;
        
        _messageVC = [[MFMessageComposeViewController alloc] init];
        
        _MenuViewC = [[MenuViewController alloc] initWithNibName:nil bundle:nil];
        _MenuViewC.view.frame = CGRectMake(0.0f, -202.0f, [UIScreen mainScreen].bounds.size.width, 202.0f);
        [self.view addSubview:_MenuViewC.view];
    }
    return self;
}

#pragma mark - WallViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _wallOfPosts = [[ZSWallTableView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0f) style:UITableViewStylePlain];
    [_wallOfPosts setDataSource:self];
    [_wallOfPosts setDelegate:self];
    [self.view addSubview:_wallOfPosts];
    
    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"List.png"] style:UIBarButtonItemStyleDone target:self action:@selector(listPressed:)];
    listButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:listButton];
    
    UIBarButtonItem *pencilAddButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Pencil.png"] style:UIBarButtonItemStyleDone target:self action:@selector(pencilAddPressed:)];
    pencilAddButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:pencilAddButton];
    
    SAMGradientView *gradientView = [[SAMGradientView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height)];
    gradientView.gradientColors = @[UIColorFromRGB(0xF7941E), UIColorFromRGB(0xF7c41E)];
    [self.view addSubview:gradientView];
    [self.view sendSubviewToBack:gradientView];
    self.view.backgroundColor = UIColorFromRGB(0x222222);
}

#pragma mark - Data Collection and Organization

-(void)dishOutWallData:(NSMutableDictionary *)data
{
    [self setArrayFromDictionary:data];
    [_wallOfPosts reloadData];
}

-(void)setArrayFromDictionary:(NSMutableDictionary *)dict
{
    if ([self.wallData count] > 0)
        [self.wallData removeAllObjects];
    
    for (NSInteger i = 0; i < [dict count]; i++) {
        NSString *keyForObject = [NSString stringWithFormat:@"%ld", (long)i];
        NSDictionary *item = [dict objectForKey:keyForObject];
        
        Wall *post = [[Wall alloc] init];
        [post setMessage:[item objectForKey:@"message"]];
        [post setIcon:[item objectForKey:@"icon"]];
        
        [self.wallData addObject:post];
    }
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellId";
    
    WallCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[WallCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    cell.message.font = [UIFont fontWithName:@"Verdana" size:16.0f];
    cell.message.lineBreakMode = NSLineBreakByWordWrapping;
    cell.message.numberOfLines = 0;
    
    Wall *post = [_wallData objectAtIndex:indexPath.row];
    cell.message.text = [post message];
    cell.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", [post icon], @".png"]];
    
    CGSize size = [cell.message sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - 75.0f, FLT_MAX)];
    cell.message.frame = CGRectMake(55.0f, 15.0f, size.width, size.height);
    CGFloat yval = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    cell.icon.frame = CGRectMake(20.0f, (yval/2.0f)-7.5f, 15.0f, 15.0f);
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_wallData count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self textViewHeightForRowAtIndexPath:indexPath];
}

-(CGFloat)textViewHeightForRowAtIndexPath: (NSIndexPath *)item
{
    UITextView *textF = [[UITextView alloc] init];
    textF.font = [UIFont fontWithName:@"Verdana" size:16.0f];
    
    Wall *post = [_wallData objectAtIndex:item.row];
    textF.text = [post message];
    
    CGSize size = [textF sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - 75.0f, FLT_MAX)];
    return size.height+15.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"signkey"] isEqualToString:ADMIN_KEY])
        return YES;
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Wall *post = [_wallData objectAtIndex:indexPath.row];
        [self.tableDelegate didEditForTable:[NSArray arrayWithObjects:@"delete", post.message, post.icon, @"delete", nil]];
    }
}

#pragma mark - User Interaction

-(void)listPressed:(id)sender
{
    [self.delegate didToggle];
}

-(void)pencilAddPressed:(id)sender
{
//    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
//    if (self.toggleView == 0) {
//        [self.view addSubview:_WriteMessageViewC.view];
//    } else {
//        [[self.view viewWithTag:17] removeFromSuperview];
//    }
    
    if (self.toggleView == 0) {
        [self presentViewController:self.messageVC animated:YES completion:nil];
    } else {
        [self.messageVC dismissViewControllerAnimated:YES completion:nil];
    }
    
    self.toggleView = (self.toggleView + 1) % 2;
}

-(void)refreshPressed:(id)sender
{
    [self.reloadDelegate didRequestReload];
}

#pragma mark - Protocols

-(void)didFinishWritingPost:(NSString *)message type:(NSString *)icon
{
    [self.tableDelegate didEditForTable:[NSArray arrayWithObjects:@"insert", message, icon, nil]];
    [[self.view viewWithTag:17] removeFromSuperview];
    self.toggleView = 0;
}

-(void)didFinishSendingRideQuestion:(NSString *)message
{
    [self.pushRideDelegate didWantToSendRideQuestion:message];
    [[self.view viewWithTag:17] removeFromSuperview];
    self.toggleView = 0;
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
