//
//  MyTableViewController.m
//  memorandum
//
//  Created by yuxintao on 2022/7/24.
//

#import "MEMTableViewController.h"
#import "MEMBackData.h"
#import "MEMTextViewController.h"
#import "MEMDataItem.h"
#import "MEMMyTableViewCell.h"
#import "MEMTextViewControllerDelegate.h"

@interface MEMTableViewController () <UITableViewDelegate, UITableViewDataSource, MEMTextViewControllerDelegate>

@property (nonatomic, strong) MEMBackData *backData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *rightBarButton;
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonManage;
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonDone;
@property (nonatomic, assign) BOOL flag;
@end

@implementation MEMTableViewController

#pragma mark -property

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //[_tableView registerClass:[MEMMyTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

-(UIBarButtonItem *)rightBarButton {
    if (!_rightBarButton) {
        _rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"add" style:UIBarButtonItemStylePlain target:self action:@selector(segueToMEMTextViewControllerAction:)];
    }
    return _rightBarButton;
}

-(UIBarButtonItem *)leftBarButtonManage {
    if (!_leftBarButtonManage) {
        _leftBarButtonManage = [[UIBarButtonItem alloc] initWithTitle:@"manage" style:UIBarButtonItemStylePlain target:self action:@selector(changeLeftBarButtonManageToDoneAction:)];
    }
    return _leftBarButtonManage;
}
-(UIBarButtonItem *)leftBarButtonDone{
    if (!_leftBarButtonDone) {
        _leftBarButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"done" style:UIBarButtonItemStylePlain target:self action:@selector(changeLeftBarButtonDoneToManageAction:)];
    }
    return _leftBarButtonDone;
}

#pragma mark -controler lifecycle
-(void)viewDidLoad {
    [super viewDidLoad];

    //add self.tableView to self.view
    [self.view addSubview:self.tableView];
    
    //add self.rightBarButton to self.navigationItem
    self.navigationItem.rightBarButtonItem = self.rightBarButton;
    
    //add self.leftBarButtonManage to self.navigationItem;
    self.navigationItem.leftBarButtonItem = self.leftBarButtonManage;
    
    //initialize self.backData
    self.backData = [[MEMBackData alloc] initWithFilePath:[self getDataFilePath]];
    
    //添加收听，当程序结束时，保存数据
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveDataToFile) name:UIApplicationWillTerminateNotification object:app];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveDataToFile) name:UIApplicationDidEnterBackgroundNotification object:app];
    //set flag
    self.flag = true;
    NSLog(@"MyTableView viewDidLoad\n");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];//更新tableview
}

#pragma mark -action
-(void)changeLeftBarButtonManageToDoneAction:(UIBarButtonItem *) sender{
    [self.tableView setEditing:YES animated:YES];
    self.navigationItem.leftBarButtonItem = self.leftBarButtonDone;
}

-(void)changeLeftBarButtonDoneToManageAction:(UIBarButtonItem *) sender{
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.leftBarButtonItem = self.leftBarButtonManage;
}

-(void)segueToMEMTextViewControllerAction:(UIBarButtonItem *) sender{
    MEMTextViewController* textViewController = [[MEMTextViewController alloc] initOfAddViewController:self];
    [self.navigationController pushViewController:textViewController animated:YES];
    NSLog(@"segueToMEMTextViewController\n");
}

#pragma mark -UITableView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.backData.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEMMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MEMMyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    MEMDataItem *dataItem = [self.backData.dataArray objectAtIndex:indexPath.row];
    [cell configWithDataItem:dataItem];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//indicator
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UIScreen mainScreen].bounds.size.height / 10;
}

#pragma mark -UITableView delegate
//选中cell时的delegate,跳转到MEMTextViewController
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MEMTextViewController *textViewController = [[MEMTextViewController alloc] initOfDetailViewController:self indexPath:indexPath dataItem:[self.backData.dataArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:textViewController animated:YES];//push controller
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//编辑模式下的delegate
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    [self.tableView beginUpdates];
    [self.backData removeObjectOfdataItemAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}


#pragma mark -manageData
-(NSString *)getDataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingString:@"/yuxintao.plist"];
    return filePath;
}

-(void)saveDataToFile {
    //self.flag 用于保证在app程序结束时只进行一次数据存储
    if (self.flag) {
        [self.backData saveToPath:[self getDataFilePath]];
        self.flag = false;
    }
}

#pragma mark -MEMTextViewController delegate

-(void)textViewController:(MEMTextViewController *)sender dataItem:(MEMDataItem *)dataItem indexPath:(NSIndexPath *)indexPath {
    if ([sender.addOrDetailString isEqualToString:@"add"]) {
        [self.backData addObjectOfdataItem:[dataItem copy]];
    }else if ([sender.addOrDetailString isEqualToString:@"detail"]) {
        [self.backData reviseObjectOfdataItemAtIndex:[dataItem copy] index:indexPath.row];
    }
}

@end
