//
//  TextViewController.m
//  memorandum
//
//  Created by yuxintao on 2022/7/24.
//

#import "MEMTextViewController.h"
#import "MEMMyCollectionViewLayout.h"
#import "MEMMyCollectionViewCell.h"
#import "MEMDataItem.h"
#import "MEMTextViewControllerDelegate.h"

@interface MEMTextViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *addImageButton;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIBarButtonItem *rightBarButton;
@property (strong, nonatomic) UITextField *textField;
//delegate
@property (nonatomic, weak) id delegateOfTextViewController;

//detail viewcontroller
@property (nonatomic, strong) NSIndexPath *indexPath;

//common
@property (nonatomic, strong) MEMDataItem *dataItem;
@property (nonatomic, copy, readwrite) NSString *addOrDetailString;//@"add" or @"detail"

@end

@implementation MEMTextViewController

#pragma mark -initialization
-(instancetype)initOfAddViewController:(id)delegate{
    self = [super init];
    if (self) {
        _delegateOfTextViewController = delegate;
        _dataItem = [[MEMDataItem alloc] init];
        _addOrDetailString = @"add";
    }
    return self;
}

-(instancetype)initOfDetailViewController:(id)delegate indexPath:(NSIndexPath *)indexPath dataItem:(MEMDataItem *)dataItem {
    self = [super init];
    if (self) {
        _delegateOfTextViewController = delegate;
        _indexPath = indexPath;
        _dataItem = [dataItem copy];
        _addOrDetailString = @"detail";
    }
    return self;
}

#pragma mark - property

-(UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        if ([self.addOrDetailString isEqualToString:@"detail"]) {
            self.textView.text = self.dataItem.text;
        }
    }
    return _textView;
}

-(UIButton *)addImageButton {
    if (!_addImageButton) {
        _addImageButton = [[UIButton alloc] init];
        NSMutableAttributedString *mastr = [[NSMutableAttributedString alloc] initWithString:@"+"];
        [mastr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor blackColor]} range:NSMakeRange(0, [mastr length])];
        [_addImageButton setAttributedTitle:mastr forState:UIControlStateNormal];
        _addImageButton.backgroundColor = [UIColor whiteColor];
        [_addImageButton addTarget:self action:@selector(addImageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addImageButton;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewLayout *layout = [[MEMMyCollectionViewLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[MEMMyCollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

-(UIBarButtonItem *)rightBarButton {
    if (!_rightBarButton) {
        _rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"save" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
    }
    return _rightBarButton;
}

-(UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor whiteColor];
        if ([self.addOrDetailString isEqualToString:@"detail"]) {
            _textField.text = self.dataItem.title;
        }
    }
    return _textField;
}

#pragma mark -controller lifecycle

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.title = self.addOrDetailString;

    CGFloat heightOfSelfView = self.view.bounds.size.height;
    CGFloat widthOfSelfView = self.view.bounds.size.width;
    CGFloat radius = self.view.bounds.size.height * 0.03;
    
    //add textView to self.view
    CGRect rect = CGRectMake(0, heightOfSelfView * 0.4, widthOfSelfView, heightOfSelfView * 0.6);
    CGRect inRect = CGRectInset(rect, radius, radius);
    self.textView.frame = inRect;
    [self.view addSubview:self.textView];
    
    //add addImageButton to self.view
    rect = CGRectMake(widthOfSelfView * 0.6, heightOfSelfView * 0.1, widthOfSelfView * 0.4, heightOfSelfView * 0.2);
    inRect = CGRectInset(rect, radius, radius);
    self.addImageButton.frame = inRect;
    [self.view addSubview:self.addImageButton];
    
    //add collectionView to self.view
    rect = CGRectMake(0, heightOfSelfView * 0.1, widthOfSelfView * 0.6, heightOfSelfView * 0.2);
    inRect = CGRectInset(rect, radius, radius);
    self.collectionView.frame = inRect;
    [self.view addSubview:self.collectionView];
    
    //add rightBarButton to self.navigationItem
    self.navigationItem.rightBarButtonItem = self.rightBarButton;
    
    //add textFiled to self.view
    rect = CGRectMake(0, heightOfSelfView * 0.3, widthOfSelfView, heightOfSelfView * 0.1);
    inRect = CGRectInset(rect, radius, 0);
    self.textField.frame = inRect;
    [self.view addSubview:self.textField];
    
    NSLog(@"TextView viewDidLoad\n");
}

#pragma mark -action
//saveButton action
- (void)saveAction:(UIBarButtonItem *)sender {
    self.dataItem.text = self.textView.text;
    self.dataItem.title = self.textField.text;
    //盲通信
    [self.delegateOfTextViewController textViewController:self dataItem:self.dataItem indexPath:self.indexPath];
    
    if ([self.addOrDetailString isEqualToString:@"add"]) {
        self.dataItem.text = nil;
        self.dataItem.title = nil;
        self.textView.text = nil;
        self.textField.text = nil;
        self.dataItem.imageArray = nil;
        [self.collectionView reloadData];
    }
}

//addImageButton action
-(void)addImageAction:(UIButton *)sender{
    //self.view present UIImagePickerController
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark -UIImagePickerController delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *tmpImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.dataItem.imageArray addObject:tmpImage];//add image to imageArray
    [self.collectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -UICollectionView delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"delete image" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.dataItem.imageArray removeObjectAtIndex:indexPath.row];
        [self.collectionView reloadData];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    NSLog(@"select collecitonViewCell\n");
}

#pragma mark -UICollectionView dataSource
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MEMMyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    cell.image.image = [self.dataItem.imageArray objectAtIndex:indexPath.row];
    cell.image.frame = cell.bounds;
    [cell addSubview:cell.image];
    //添加长按手势
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressRecognizer.minimumPressDuration = 1.0f;//长按事件为1s
    longPressRecognizer.delegate = self;
    longPressRecognizer.view.tag = indexPath.row;
    [cell addGestureRecognizer:longPressRecognizer];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataItem.imageArray count];
}

#pragma mark -longPress Gesture action
-(void)handleLongPress:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self.dataItem.imageArray removeObjectAtIndex:recognizer.view.tag];
        [self.collectionView reloadData];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"longPressGestrure ended\n");
    }
}

@end
