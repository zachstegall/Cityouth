//
//  MenuViewController.m
//  FBC Youth
//
//  Created by Zach Stegall on 2/15/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "MenuViewController.h"
#import "Cell.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _menuItems = [[NSArray alloc] initWithObjects:@"Home", @"Profile", @"Wall", nil];
    }
    return self;
}

#pragma mark - MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self dotViewAllocation];
    [self menuAllocation];
    
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = UIColorFromRGB(0xF7941E);
}

-(void)dotViewAllocation
{
    _dotView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Dot.png"]];
    _dotView.hidden = YES;
}

-(void)menuAllocation
{
    _menu = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 57.0f, [UIScreen mainScreen].bounds.size.width, 145.0f)];
    _menu.backgroundColor = UIColorFromRGB(0xF7941E);
    _menu.scrollEnabled = NO;
    [_menu setSeparatorInset:UIEdgeInsetsZero];
    [_menu setDelegate:self];
    [_menu setDataSource:self];
    [self.view addSubview:_menu];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellId";
    
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.name.text = [_menuItems objectAtIndex:indexPath.row];
    
    if ([[_menuItems objectAtIndex:indexPath.row] isEqualToString:@"Wall"]) {
        _dotView.frame = CGRectMake(75.0f, cell.center.y - 5.0f, 15.0f, 15.0f);
        [cell addSubview:_dotView];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_menuItems count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITableViewDelegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate didSelectViewController:self.view.superview andView:indexPath.row];
}

#pragma mark - Visuals For Updates

-(void)newWallPostDot
{
    _dotView.hidden = NO;
}

-(void)viewedNewWallPost
{
    _dotView.hidden = YES;
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
