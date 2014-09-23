//
//  SearchViewController.m
//  MKProject
//
//  Created by baojuan on 14-6-22.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"
@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation SearchViewController
{
    AppDelegate *appdelegate;
    MKNavigationView *navigationView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appdelegate = APPDELEGATE;
        _dataArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_USERDEFAULT]];
    }
    return self;
}

- (void)setHeadView
{
    self.navigationController.navigationBarHidden = YES;
    navigationView = [[MKNavigationView alloc] initWithTitle:self.title rightButtonImage:Nil ForPad:NO ForPadFullScreen:NO];
    [navigationView.leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigationView];
    
    self.textField = [[UITextField alloc] initWithFrame:RECT(10, 15 + navigationView.frame.size.height + navigationView.frame.origin.y, SCREEN_WIDTH - 20, 30)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.textField.frame = RECT(10, 15 + navigationView.frame.size.height + navigationView.frame.origin.y, 320 - 20, 30);
    }
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.delegate = self;
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.textField.font = FONTSIZE(14);
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.placeholder = LOCAL_LANGUAGE(@"search");
    [self.view addSubview:self.textField];
}

- (void)backButtonClick
{
    [[NSUserDefaults standardUserDefaults] setObject:_dataArray forKey:SEARCH_USERDEFAULT];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_dataArray insertObject:textField.text atIndex:0];
    [self.tableView reloadData];
    [self pushToResultViewController:textField.text];
    return YES;
}

- (void)pushToResultViewController:(NSString *)title
{
    self.textField.text = @"";
    SearchResultViewController *resultViewController = [[SearchResultViewController alloc] init];
    resultViewController.title = title;
    [self.navigationController pushViewController:resultViewController animated:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClick)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGes];
    self.view.backgroundColor = appdelegate.navigationBackgroundColor;
    [self setHeadView];
    [self setTableViewProperty];
}


- (void)setTableViewProperty
{
    self.tableView = [[UITableView alloc] initWithFrame:RECT(0, self.textField.frame.size.height + self.textField.frame.origin.y + 15, SCREEN_WIDTH, SCREEN_HEIGHT - (self.textField.frame.size.height + self.textField.frame.origin.y + 15)) style:UITableViewStylePlain];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.tableView.frame = RECT(0, self.textField.frame.size.height + self.textField.frame.origin.y + 15, 320, SCREEN_WIDTH - (self.textField.frame.size.height + self.textField.frame.origin.y + 15));
    }
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if([_tableView respondsToSelector:@selector(setSeparatorInset:)]){
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    self.tableView.tableFooterView = [self tableViewFooterViewButton];
    [self.view addSubview:self.tableView];
}

- (UIView *)tableViewFooterViewButton
{
    UIView *view = [[UIView alloc] initWithFrame:RECT(0, 0, SCREEN_WIDTH, 50)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = appdelegate.navigationColor;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setTitle:LOCAL_LANGUAGE(@"Clean Up") forState:UIControlStateNormal];
    button.frame = RECT(20, 10, SCREEN_WIDTH - 40, 30);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        button.frame = RECT(20, 10, 320 - 40, 30);
    }
    [button addTarget:self action:@selector(cleanButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
}

- (void)cleanButtonClick
{
    MKLog(@"clean button click");
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"searchCellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.font = FONTSIZE(14);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushToResultViewController:[_dataArray objectAtIndex:indexPath.row]];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
