//
//  NavigationViewController.m
//  FBC Youth
//
//  Created by Zach Stegall on 2/11/14.
//  Copyright (c) 2014 Zach Stegall. All rights reserved.
//

#import "NavigationViewController.h"
#import "Cell.h"

@interface NavigationViewController ()
{
    CGFloat screenWidth;
    CGFloat screenHeight;
}

@end

@implementation NavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        screenWidth = [UIScreen mainScreen].bounds.size.width;
        screenHeight = [UIScreen mainScreen].bounds.size.height;
        
//        UIImage *listButtonImage = [[UIImage imageNamed:@"Lightbulboff.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
//        [[UIBarButtonItem appearance] setBackgroundImage:listButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        // Custom initialization
//        _bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, screenWidth, screenHeight)];
//        _bgImage.image = [UIImage imageNamed:@"IMG_1785.jpg"];
//        [self.view addSubview:_bgImage];
        
        _allYouthTable = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 200.0f, screenWidth, screenHeight - 200.0f)];
        _allYouthTable.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.15f];
        [_allYouthTable setDelegate:self];
        [_allYouthTable setDataSource:self];
        [self.view addSubview:_allYouthTable];
        
//        [self.navigationBar setBackgroundImage:[UIImage new]
//                                 forBarMetrics:UIBarMetricsDefault];
//        self.navigationBar.shadowImage = [UIImage new];
//        self.navigationBar.translucent = YES;
    }
    return self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellId";
    
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.name.text = @"Test";
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:nil];
//    [self.navigationItem setLeftBarButtonItem:listButton];
    //self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"84-lightbulb.png"];

    self.title = @"Title";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(buttonPRessed:)];
    
	// Do any additional setup after loading the view.
}

-(void)buttonPRessed:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
