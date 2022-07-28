//
//  MyTableViewController.m
//  memorandum
//
//  Created by yuxintao on 2022/7/24.
//

#import "MyTableViewController.h"
#import "BackData.h"
#import "TextViewController.h"
#import "DetailViewController.h"


@interface MyTableViewController()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BackData *backData;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MyTableViewController

#pragma mark -property
-(BackData *)backData{
    if (!_backData) _backData = [[BackData alloc] init];
    return _backData;
}

#pragma mark -manageData
-(NSMutableArray *)getData{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    NSMutableArray *tmpData = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    return tmpData;
}

-(void)saveData{
    //&&&&&&&&
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    NSLog(@"path = %@\n", path);
    [self.backData saveToPath:path];
}

#pragma mark -controler lifecycle
-(void)viewDidLoad{
    [super viewDidLoad];
    [self setManage];
    NSMutableArray* tmpData = [self getData];
    if (tmpData) [self.backData setData:tmpData];
    //add rightBarButtonItem to self.navigationItem
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"add" style:UIBarButtonItemStylePlain target:self action:@selector(prepareForSegue)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    //add self.tableView to self.view
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    //添加收听，当程序结束时，保存数据
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveData) name:UIApplicationWillTerminateNotification object:app];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveData) name:UIApplicationDidEnterBackgroundNotification object:app];
    
    NSLog(@"MyTableView viewDidLoad\n");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];//更新tableview
}

#pragma mark -set leftbarbuttonitem
//&&&&&&&&
-(void)setManage{
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"manage" style:UIBarButtonItemStylePlain target:self action:@selector(manageAction:)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

-(void)setDone{
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"done" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

#pragma mark -action(leftButtonItem)
-(void)manageAction:(id) sender{
    [self.tableView setEditing:YES animated:YES];
    [self setDone];
}
//*+&&&&&&&&&
-(void)doneAction{
    [self.tableView setEditing:NO animated:YES];
    [self setManage];
}

#pragma mark -segue
-(void)prepareForSegue{
        //&&&&&&&
    TextViewController* dtvc = [[TextViewController alloc] init];
    dtvc.backData = self.backData;
    [self.navigationController pushViewController:dtvc animated:YES];
    NSLog(@"prepareForSegue\n");
}

#pragma mark -UITableView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.backData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [[self.backData chooseIndex:indexPath.row] valueForKey:@"text"];//=>objectForKey&&&&&&&&&
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//indicator
    return cell;
}

#pragma mark -UITableView delegate
//选中cell时的delegate,跳转到DetailsViewController
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    //&&&&&
    detailViewController.backData = self.backData;
    detailViewController.indexPath = indexPath;
    [self.navigationController pushViewController:detailViewController animated:YES];//push controller
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//编辑模式下的delegate
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //beginupdate endupdate
        [self.backData removeObject:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

@end
