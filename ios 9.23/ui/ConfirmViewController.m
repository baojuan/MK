//
//  ConfirmViewController.m
//  MKProject
//
//  Created by baojuan on 14-6-27.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "ConfirmViewController.h"
#import "ConfirmiPhoneCell.h"
#import "LeftModel.h"
#import "LeftViewController.h"
#import "BlurView.h"

#define BaseButtonTag 100

@interface ConfirmViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ConfirmViewController
{
    AppDelegate *appdelegate;
    MKNavigationView *navigationView;
    
    BOOL isModify;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appdelegate = APPDELEGATE;
        
    }
    return self;
}

- (id)initWithTypeId:(NSString *)typeId
{
    if (self = [super init]) {
        self.typeId = typeId;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self readDataArray];
        });
    }
    return self;
}

- (void)readDataArray
{
    self.dataArray = [[NSMutableArray alloc] initWithArray:[[DataBase sharedDataBase] readLeftTableAllDataFromTypeId:self.typeId]];
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [self.tableView reloadData];
}


- (void)setHeadView
{
    self.navigationController.navigationBarHidden = YES;
    navigationView = [[MKNavigationView alloc] initWithTitle:self.title rightButtonImage:IMAGENAMED(@"refresh") ForPad:NO ForPadFullScreen:NO];
    [navigationView.leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationView.rightButton addTarget:self action:@selector(refreshButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigationView];
}

- (void)backButtonClick
{
    if (isModify) {
        NSMutableArray *noConfirmArray = [[NSMutableArray alloc] init];
        NSMutableArray *confirmArray = [[NSMutableArray alloc] init];
        
        for (LeftModel *model in _dataArray) {
            if ([model.sortId integerValue] == -1) {
                [noConfirmArray addObject:model];
            }
            else {
                [confirmArray addObject:model];
            }
        }
        ((LeftViewController *)self.delegate).dataArray = confirmArray;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[DataBase sharedDataBase] updateDataIntoLeftTable:confirmArray];
            [[DataBase sharedDataBase] updateDataIntoLeftTableForNoComfirm:noConfirmArray];
        });
    }
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)refreshButtonClick
{
    isModify = YES;
    for (LeftModel *model in _dataArray) {
        if ([model.sortId integerValue] == -1) {
            model.sortId = @"0";
        }
    }
    [self.tableView reloadData];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"刷新成功";
    [hud hide:YES afterDelay:1];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClick)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGes];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.view.backgroundColor = [UIColor clearColor];
        
    }
    else {
        self.view.backgroundColor = appdelegate.drawLeftAndRightViewBackgroundColor;
        
    }

    UIView *view = [[UIView alloc] initWithFrame:RECT(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.7;
    [self.view addSubview:view];
    BlurView *blurView = [[BlurView alloc] initWithFrame:RECT(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:blurView];

    [self setHeadView];
    [self setTableViewProperty];

}

- (void)setTableViewProperty
{
    self.tableView = [[UITableView alloc] initWithFrame:RECT(0, navigationView.frame.size.height + navigationView.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT - (navigationView.frame.size.height + navigationView.frame.origin.y)) style:UITableViewStylePlain];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.tableView.frame = RECT(0, navigationView.frame.size.height + navigationView.frame.origin.y, 320, SCREEN_WIDTH - (navigationView.frame.size.height + navigationView.frame.origin.y));
    }
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    UIView *tempFooterView = [[UIView alloc] initWithFrame:RECT(0, 0, self.tableView.frame.size.width, 1)];
    tempFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = tempFooterView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"comfirmIphoneCell";
    ConfirmiPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[ConfirmiPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        [cell.button addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    cell.button.tag = BaseButtonTag + indexPath.row;
    LeftModel * model = [_dataArray objectAtIndex:indexPath.row];
    if ([model.sortId integerValue] == -1) {
        cell.button.selected = YES;
    }
    else {
        cell.button.selected = NO;
    }
    cell.textLabel.text = model.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConfirmiPhoneCell *cell = (ConfirmiPhoneCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self confirmButtonClick:cell.button];
}

- (void)confirmButtonClick:(UIButton *)button
{
    LeftModel * model = [_dataArray objectAtIndex:(button.tag - BaseButtonTag)];
    if (button.selected) {
        model.sortId = @"0";
    }
    else {
        model.sortId = @"-1";
    }
    button.selected = !button.selected;
    isModify = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
