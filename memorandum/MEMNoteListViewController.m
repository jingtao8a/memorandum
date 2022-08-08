//
//  MyTableViewController.m
//  memorandum
//
//  Created by yuxintao on 2022/7/24.
//

#import "MEMNoteListViewController.h"
#import "MEMNoteListTableViewCell.h"
#import "MEMNoteViewController.h"
#import "MEMNoteViewControllerDelegate.h"


@interface MEMNoteListViewController () <UITableViewDelegate, UITableViewDataSource, MEMNoteViewControllerDelegate>


@property (nonatomic, strong, readwrite) MEMNoteList *noteList;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong, readwrite) UIBarButtonItem *rightBarButton;
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonManage;
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonDone;

@property (nonatomic, assign) NSInteger indexPathRow;

@end


@implementation MEMNoteListViewController

#pragma mark - setIndexPathRow

- (void)setIndexPathRow:(NSInteger)indexPathRow
{
    _indexPathRow = indexPathRow;
}

#pragma mark - property

- (MEMNoteList *)noteList
{
    if (!_noteList) {
        _noteList = [[MEMNoteList alloc] init];
    }
    return _noteList;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor underPageBackgroundColor];
        [_tableView setSeparatorColor:[UIColor blackColor]];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (UIBarButtonItem *)rightBarButton
{
    if (!_rightBarButton) {
        _rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"add"
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(segueToMEMNoteViewControllerAction:)];
    }
    return _rightBarButton;
}

- (UIBarButtonItem *)leftBarButtonManage
{
    if (!_leftBarButtonManage) {
        _leftBarButtonManage = [[UIBarButtonItem alloc] initWithTitle:@"manage"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(changeLeftBarButtonManageToDoneAction:)];
    }
    return _leftBarButtonManage;
}

- (UIBarButtonItem *)leftBarButtonDone
{
    if (!_leftBarButtonDone) {
        _leftBarButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"done"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(changeLeftBarButtonDoneToManageAction:)];
    }
    return _leftBarButtonDone;
}

#pragma mark - controler lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    //add self.tableView to self.view
    [self.view addSubview:self.tableView];

    //add self.rightBarButton to self.navigationItem
    self.navigationItem.rightBarButtonItem = self.rightBarButton;

    //add self.leftBarButtonManage to self.navigationItem;
    self.navigationItem.leftBarButtonItem = self.leftBarButtonManage;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData]; //更新tableview
}

#pragma mark - button action

- (void)changeLeftBarButtonManageToDoneAction:(UIBarButtonItem *)sender
{
    [self.tableView setEditing:YES animated:YES];
    self.navigationItem.leftBarButtonItem = self.leftBarButtonDone;
}

- (void)changeLeftBarButtonDoneToManageAction:(UIBarButtonItem *)sender
{
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.leftBarButtonItem = self.leftBarButtonManage;
}

- (void)segueToMEMNoteViewControllerAction:(UIBarButtonItem *)sender
{
    if ([[self.splitViewController viewControllers] count] == 1) { //只有竖屏时，点击add才会执行
        self.indexPathRow = [self.noteList.indexArray count];
        MEMNoteViewController *noteViewController = [[MEMNoteViewController alloc] init];
        noteViewController.delegate = self;
        [self.navigationController pushViewController:noteViewController animated:YES];
        NSLog(@"segueToMEMTextViewController\n");
    }
}

#pragma mark - UITableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.noteList.indexArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MEMNoteListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MEMNoteListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    MEMNote *note = [self.noteList getNoteAtIndex:indexPath.row];
    [cell configWithNote:note];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - UITableView delegate
//选中cell时的delegate,跳转到MEMTextViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPathRow = indexPath.row;
    if ([[self.splitViewController viewControllers] count] == 1) { //竖屏时执行
        MEMNoteViewController *noteViewController = [[MEMNoteViewController alloc] initWithNote:[self.noteList getNoteAtIndex:indexPath.row]];
        noteViewController.delegate = self;
        [self.navigationController pushViewController:noteViewController animated:YES]; //push controller
    } else {                                                                            //横屏时执行
        MEMNoteViewController *secondaryNoteViewController = [[self.splitViewController viewControllers] lastObject];
        secondaryNoteViewController.delegate = self;
        [secondaryNoteViewController setNote:[self.noteList getNoteAtIndex:indexPath.row]];
        [secondaryNoteViewController setNoteViewControllerCategory:MEMNoteViewControllerCategoryDetail];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//编辑模式下的delegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    [self.tableView beginUpdates];
    [self.noteList removeNoteAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}


#pragma mark - MEMTextViewController delegate

- (void)noteViewController:(MEMNoteViewController *)sender didFinishEdittingNote:(MEMNote *)note
{
    if (MEMNoteViewControllerCategoryAdd == sender.noteViewControllerCategory) {
        [self.noteList addNote:[note copy]];
    } else if (MEMNoteViewControllerCategoryDetail == sender.noteViewControllerCategory) {
        [self.noteList updateNote:[note copy] atIndex:self.indexPathRow];
    }
    [self.tableView reloadData];
}

@end
