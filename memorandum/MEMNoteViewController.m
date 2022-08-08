//
//  TextViewController.m
//  memorandum
//
//  Created by yuxintao on 2022/7/24.
//

#import "MEMNoteViewController.h"
#import "MEMNoteViewCollectionViewCell.h"
#import "MEMPresentBigImageViewController.h"
#import "MEMNoteViewCustomTextView.h"
#import "MEMNoteViewCustomTextField.h"
#import "MEMNoteViewCustomView.h"


@interface MEMNoteViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, UIActionSheetDelegate, UIScrollViewDelegate, UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) MEMNoteViewCustomTextView *textView;
@property (strong, nonatomic) MEMNoteViewCustomTextField *textField;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIBarButtonItem *rightBarButton;

//common
@property (nonatomic, strong) MEMNote *note;
@property (nonatomic, assign, readwrite) MEMNoteViewControllerCategory noteViewControllerCategory;

@end


@implementation MEMNoteViewController

#pragma mark - set note method

- (void)setNote:(MEMNote *)note
{
    _note = [note copy];
    _textField.text = _note.title;
    _textView.text = _note.text;
    [self.collectionView reloadData];
}

#pragma mark - set noteViewControllerCategory

- (void)setNoteViewControllerCategory:(MEMNoteViewControllerCategory)noteViewControllerCategory
{
    _noteViewControllerCategory = noteViewControllerCategory;
    self.navigationItem.title = self.noteViewControllerCategory == MEMNoteViewControllerCategoryDetail ? @"detail" : @"add";
}

#pragma mark - initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        _note = [[MEMNote alloc] init];
        _noteViewControllerCategory = MEMNoteViewControllerCategoryAdd;
    }
    return self;
}

- (instancetype)initWithNote:(MEMNote *)note
{
    self = [super init];
    if (self) {
        _note = [note copy];
        _noteViewControllerCategory = MEMNoteViewControllerCategoryDetail;
    }
    return self;
}

#pragma mark - property

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[MEMNoteViewCustomTextView alloc] init];
        _textView.delegate = self;
        if (MEMNoteViewControllerCategoryDetail == _noteViewControllerCategory) {
            _textView.text = _note.text;
        }
    }
    return _textView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.estimatedItemSize = CGSizeMake(150, 150);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor underPageBackgroundColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [_collectionView registerClass:[MEMNoteViewCollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (UIBarButtonItem *)rightBarButton
{
    if (!_rightBarButton) {
        _rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"save"
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(saveAction:)];
    }
    return _rightBarButton;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[MEMNoteViewCustomTextField alloc] init];
        _textField.delegate = self;
        if (MEMNoteViewControllerCategoryDetail == _noteViewControllerCategory) {
            _textField.text = _note.title;
        }
    }
    return _textField;
}

#pragma mark - controller lifecycle

- (void)loadView
{
    self.view = [[MEMNoteViewCustomView alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.noteViewControllerCategory == MEMNoteViewControllerCategoryDetail ? @"detail" : @"add";
    //add textView to self.view
    [self.view addSubview:self.textView];

    //add collectionView to self.view
    [self.view addSubview:self.collectionView];

    //add rightBarButton to self.navigationItem
    self.navigationItem.rightBarButtonItem = self.rightBarButton;

    //add textFiled to self.view
    [self.view addSubview:self.textField];

    CGFloat margin = 10;
    [NSLayoutConstraint activateConstraints:@[
        [self.textView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:margin],
        [self.textView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-margin],
        [self.textView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-margin],
        [self.textView.heightAnchor constraintEqualToConstant:340],
        [self.textField.bottomAnchor constraintEqualToAnchor:self.textView.topAnchor],
        [self.textField.leadingAnchor constraintEqualToAnchor:self.textView.leadingAnchor],
        [self.textField.trailingAnchor constraintEqualToAnchor:self.textView.trailingAnchor],
        [self.textField.heightAnchor constraintEqualToConstant:50],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.textField.topAnchor constant:-50],
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:margin],
        [self.collectionView.heightAnchor constraintEqualToConstant:160],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:margin]
    ]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoard:) name:UIApplicationWillResignActiveNotification object:[UIApplication sharedApplication]];

    NSLog(@"%f %f", [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    NSLog(@"noteView viewDidLoad\n");
}

#pragma mark - notification

- (void)hideKeyBoard:(NSNotification *)notification
{
    [self.textView resignFirstResponder];
    [self.textField resignFirstResponder];
    [self resumeView];
}

#pragma mark - save button action

- (void)saveAction:(UIBarButtonItem *)sender
{
    if (!self.delegate) {
        return;
    }
    [self.textView resignFirstResponder];
    [self.textField resignFirstResponder];
    [self resumeView];
    self.note.text = self.textView.text;
    self.note.title = self.textField.text;

    //盲通信
    [self.delegate noteViewController:self didFinishEdittingNote:self.note];
    if (MEMNoteViewControllerCategoryAdd == self.noteViewControllerCategory) {
        self.noteViewControllerCategory = MEMNoteViewControllerCategoryDetail; //转换模式
        self.navigationItem.title = @"detail";
    }
}

#pragma mark - addImage

- (void)addImage
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"image source"
                                                                   message:@"Please select"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof(self) weakSelf = self;

    UIAlertAction *buttonOne = [UIAlertAction actionWithTitle:@"cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil];
    UIAlertAction *buttonTwo = [UIAlertAction actionWithTitle:@"shoot"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                              NSLog(@"not support");
                                                              return;
                                                          }
                                                          UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                                          imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                          imagePicker.delegate = weakSelf;
                                                          __strong __typeof(weakSelf) strongSelf = weakSelf;
                                                          [strongSelf presentViewController:imagePicker animated:YES completion:nil];
                                                      }];
    UIAlertAction *buttonThree = [UIAlertAction actionWithTitle:@"album"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                                            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                                                            imagePicker.delegate = weakSelf;
                                                            __strong __typeof(weakSelf) strongSelf = weakSelf;
                                                            [strongSelf presentViewController:imagePicker animated:YES completion:nil];
                                                        }];
    [alert addAction:buttonOne];
    [alert addAction:buttonTwo];
    [alert addAction:buttonThree];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewDidBeginEditing");
    [self moveView];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"textViewDidEndEditing");
    [self resumeView];
}

#pragma mark - textField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing");
    [self moveView];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing");
    [self resumeView];
}


#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info
{
    UIImage *tmpImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.note addImage:tmpImage]; //add image to imageArray
    [self.collectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UICollectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.row == [self.note.imageArray count]) {
        [self addImage];
        return;
    }
    MEMNoteViewCollectionViewCell *noteViewCollectionViewCell = (MEMNoteViewCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    MEMPresentBigImageViewController *presentBigImageViewController = [[MEMPresentBigImageViewController alloc] initWithImage:noteViewCollectionViewCell.imageOfNoteView.image];
    [self.navigationController pushViewController:presentBigImageViewController animated:YES];
    NSLog(@"select collecitonViewCell\n");
}

#pragma mark - UICollectionView dataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    MEMNoteViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    if (indexPath.row == [self.note.imageArray count]) {
        cell.imageOfNoteView.image = [UIImage imageNamed:@"add"];
        cell.imageOfNoteView.frame = cell.contentView.bounds;
        [cell.contentView addSubview:cell.imageOfNoteView];
        return cell;
    }
    cell.imageOfNoteView.image = [self.note.imageArray objectAtIndex:indexPath.row];
    cell.imageOfNoteView.frame = cell.contentView.bounds;
    [cell.contentView addSubview:cell.imageOfNoteView];
    //添加长按手势
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressInCollectionViewCell:)];
    longPressRecognizer.minimumPressDuration = 1.0f; //长按事件为1s
    longPressRecognizer.delegate = self;
    [cell addGestureRecognizer:longPressRecognizer];
    longPressRecognizer.view.tag = indexPath.row;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.note.imageArray count] + 1;
}


#pragma mark - Gesture action

- (void)handleLongPressInCollectionViewCell:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:@"delete image"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        __weak __typeof(self) weakSelf = self;
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"ok"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       [weakSelf.note removeImageAtIndex:sender.view.tag];
                                                       [weakSelf.collectionView reloadData];
                                                   }];

        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - UIControl

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"controller");
    [self.textView resignFirstResponder];
    [self.textField resignFirstResponder];
    [self resumeView];
}


#pragma mark - move and resume view

- (void)moveView
{
    if (self.view.frame.origin.y == 0) {
        NSTimeInterval animationDuration = 0.40f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float fX = self.view.frame.origin.x;
        float fY = self.view.frame.origin.y - 271.0;
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        self.view.frame = CGRectMake(fX, fY, width, height);
        [UIView commitAnimations];
    }
}

- (void)resumeView
{
    if (self.view.frame.origin.y == -271.0) {
        NSTimeInterval animationDuration = 0.40f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float fX = self.view.frame.origin.x;
        float fY = self.view.frame.origin.y + 271.0;
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        self.view.frame = CGRectMake(fX, fY, width, height);
        [UIView commitAnimations];
    }
}


@end
