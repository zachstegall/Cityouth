//
//  HomeViewController.m
//  FBC Youth
//
//  Created by Zach Stegall on 2/11/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "HomeViewController.h"
#import "AllYouthCell.h"
#import "ProfileViewController.h"

@interface HomeViewController ()
{
    CGFloat screenWidth;
    CGFloat screenHeight;
    NSInteger colorToggle;
    NSString *viewInTable;
    NSString *youthKey;
    NSString *adminKey;
}

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        screenWidth = [UIScreen mainScreen].bounds.size.width;
        screenHeight = [UIScreen mainScreen].bounds.size.height;
        colorToggle = 0;
        viewInTable = @"names";
        youthKey = @"MVyouthFBC";
        adminKey = @"MVadminFBC1819";
        _namesArray = [[NSMutableArray alloc] init];
        _colorArray = [[NSArray alloc] initWithObjects:UIColorFromRGB(0xF7941E), UIColorFromRGB(0xF7A41E),
                       UIColorFromRGB(0xF7b41E), UIColorFromRGB(0xF7c41E),
                       UIColorFromRGB(0xF7d41E), UIColorFromRGB(0xF7e41E), nil];
        _colorsForNames = [[NSMutableArray alloc] init];
        _youthData = [[NSMutableDictionary alloc] init];
        [self MenuViewControllerAllocation];
    }
    return self;
}

#pragma mark - HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"List.png"] style:UIBarButtonItemStyleDone target:self action:@selector(listPressed:)];
    listButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:listButton];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Refresh.png"] style:UIBarButtonItemStylePlain target:self action:@selector(refreshPressed:)];
    refreshButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:refreshButton];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"signkey"] isEqualToString:adminKey]) {
        UISwipeGestureRecognizer *swipeToLocation = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeViewLoc:)];
        [swipeToLocation setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self.view addGestureRecognizer:swipeToLocation];
        
        UISwipeGestureRecognizer *swipeToNames = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeViewNames:)];
        [swipeToNames setDirection:UISwipeGestureRecognizerDirectionRight];
        [self.view addGestureRecognizer:swipeToNames];
    }
    
    [self titleImageViewAllocation];
    [self bgImageViewAllocation];
    [self allYouthTableAllocation];
    
    self.view.userInteractionEnabled = YES;
}

-(void)titleImageViewAllocation
{
    _titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"house.png"]];
    self.navigationItem.titleView = _titleImageView;
}

-(void)bgImageViewAllocation
{
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, screenWidth, screenHeight)];
    _bgImageView.image = [UIImage imageNamed:@"Lightblack.jpg"];
    [self.view addSubview:_bgImageView];
}

-(void)allYouthTableAllocation
{
    _allYouthTable = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, screenWidth, screenHeight - 64.0f)];
    _allYouthTable.backgroundColor = [UIColor clearColor];
    _allYouthTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _allYouthTable.contentInset = UIEdgeInsetsMake(-64.0f, 0.0f, 0.0f, 0.0f);
    [_allYouthTable setDelegate:self];
    [_allYouthTable setDataSource:self];
    [self.view addSubview:_allYouthTable];
}

-(void)MenuViewControllerAllocation
{
    _MenuViewC = [[MenuViewController alloc] initWithNibName:nil bundle:nil];
    _MenuViewC.view.frame = CGRectMake(0.0f, -202.0f, screenWidth, 202.0f);
    [self.view addSubview:_MenuViewC.view];
}

#pragma mark - Data Collection and Organization

// This method will receive data from a JSON response object and
// begin to store all data in _youthData and their names and
// and location in _namesArray. The reason it looks complicated
// is because when this method comes across the user's name, it is
// temporarily stored for adding it to the end of the _youthData.
// It is not added to the _namesArray because users do not need to
// view their own profile. They will already be able to edit it.
// We set the user's name as selfLastObject to keep consistency
// with all data sources.
-(void)dishOutHomeData:(NSMutableDictionary *)data
{
    NSMutableDictionary *selfLastObject = [[NSMutableDictionary alloc] init];
    NSInteger nextObjectInt = 999;
    NSString *positionKey;
    
    if ([_namesArray count] > 0)
        [_namesArray removeAllObjects];
    if ([_youthData count] > 0)
        [_youthData removeAllObjects];
    
    for (NSInteger i = 0; i < [data count]; i++) {
        NSString *keyforobject = [NSString stringWithFormat:@"%ld", (long)i];
        NSMutableDictionary *dict = [data objectForKey:keyforobject];
        
        if (nextObjectInt == 999) {
            positionKey = keyforobject;
        } else {
            positionKey = [NSString stringWithFormat:@"%ld", (long)nextObjectInt];
        }
        
        if (![[dict objectForKey:@"device_token"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"]]) {
            NameLocation *newName = [[NameLocation alloc] init];
            [newName setNameAndLocation:[NSString stringWithFormat:@"%@%@%@", [dict objectForKey:@"firstname"], @" ", [dict objectForKey:@"lastname"]]
                                    loc:[dict objectForKey:@"location"]];
            [_namesArray addObject:newName];
            [_youthData setObject:dict forKey:positionKey];
        } else {
            selfLastObject = dict;
            nextObjectInt = i - 1;
        }
        
        if (nextObjectInt != 999)
            nextObjectInt++;
    }
    
    [self setColorsForTable];
    [_youthData setObject:selfLastObject forKey:[NSString stringWithFormat:@"%ld", (long)[_youthData count]]];
    [_allYouthTable reloadData];
}

-(void)setColorsForTable
{
    for (NSInteger i = 0; i < [_namesArray count]; i++) {
        NSInteger mod = i % 6;
        if (mod == 6) mod = 0;
        
        if (mod == 0 && i != 0) {
            colorToggle = (colorToggle + 1) % 2;
        }
        
        if (colorToggle == 0) {
            [_colorsForNames addObject:[_colorArray objectAtIndex:mod]];
        } else {
            [_colorsForNames addObject:[_colorArray objectAtIndex:(([_colorArray count] - 1) - mod)]];
        }
    }
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellId";
    
    AllYouthCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[AllYouthCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NameLocation *nameLoc = [_namesArray objectAtIndex:indexPath.row];
    if ([viewInTable isEqualToString:@"names"]) {
        cell.name.text = [nameLoc name];
        cell.userInteractionEnabled = YES;
    } else {
        cell.name.text = [nameLoc location];
        cell.userInteractionEnabled = NO;
    }
    cell.name.textColor = [_colorsForNames objectAtIndex:indexPath.row];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_namesArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProfileViewController *profile = [[ProfileViewController alloc] initWithNibName:Nil bundle:nil];
    [profile viewerSettings:[_youthData objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]]];
    [self.navigationController pushViewController:profile animated:YES];
}

#pragma mark - User Interaction

-(void)swipeViewLoc:(id)sender
{
    viewInTable = @"locations";
    _titleImageView.image = [UIImage imageNamed:@"location.png"];
    [_allYouthTable reloadData];
}

-(void)swipeViewNames:(id)sender
{
    viewInTable = @"names";
    _titleImageView.image = [UIImage imageNamed:@"house.png"];
    [_allYouthTable reloadData];
}

-(void)listPressed:(id)sender
{
    // Navigation Controller is responsible
    // for this delegate
    [self.delegate didToggle];
}

-(void)refreshPressed:(id)sender
{
    // Navigation Controller is responsible
    // for this delegate
    [self.reloadDelegate didRequestReload];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
