//
//  TextViewController.m
//  memorandum
//
//  Created by yuxintao on 2022/7/24.
//

#import "TextViewController.h"
#import "MyCollectionViewLayout.h"
#import "MyCollectionViewCell.h"

@interface TextViewController()<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *addImageButton;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *imageArray;//of UIImage

@end

@implementation TextViewController
/*
#pragma mark -init
-(instancetype)initWithBackData:{
    [super init];
}
*/
#pragma mark - property
-(NSMutableArray *)imageArray {
    if (!_imageArray) _imageArray = [[NSMutableArray alloc] init];
    return _imageArray;
}

#pragma mark -controller lifecycle

//不用宏&&&&
#define     HEIGHT_VIEW     self.view.bounds.size.height
#define     WIDTH_VIEW      self.view.bounds.size.width
#define     RADIUS      self.view.bounds.size.height * 0.03

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    //add textView to self.view
    CGRect rect = CGRectMake(0, HEIGHT_VIEW * 0.3, WIDTH_VIEW, HEIGHT_VIEW * 0.7);
    CGRect inRect = CGRectInset(rect, RADIUS, RADIUS);
    self.textView = [[UITextView alloc] initWithFrame: inRect];
    self.textView.delegate = self;
    self.textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    
    //add collectionView to self.view
    rect = CGRectMake(0, HEIGHT_VIEW * 0.1, WIDTH_VIEW * 0.6, HEIGHT_VIEW * 0.2);
    inRect = CGRectInset(rect, RADIUS, RADIUS);
    UICollectionViewLayout *layout = [[MyCollectionViewLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:inRect collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    /*
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
    */
    [self.view addSubview:self.collectionView];
    
    //add rightBarButton to self.navigationItem
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"save" style:UIBarButtonItemStylePlain target:self action:@selector(buttonSave:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    //add addImageButton to self.view
    rect = CGRectMake(WIDTH_VIEW * 0.6, HEIGHT_VIEW * 0.1, WIDTH_VIEW * 0.4, HEIGHT_VIEW * 0.2);
    inRect = CGRectInset(rect, RADIUS, RADIUS);
    self.addImageButton = [[UIButton alloc] initWithFrame: inRect];
    NSMutableAttributedString *mastr = [[NSMutableAttributedString alloc] initWithString:@"+"];
    [mastr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor blackColor]} range:NSMakeRange(0, [mastr length])];
    [self.addImageButton setAttributedTitle:mastr forState:UIControlStateNormal];
    self.addImageButton.backgroundColor = [UIColor whiteColor];
    [self.addImageButton addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addImageButton];
    
    NSLog(@"TextView viewDidLoad\n");
}

#pragma mark -button action
//saveButton action
- (void)buttonSave:(UIBarButtonItem *)sender {
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for (UIImage *tmpImage in self.imageArray) {
        NSData *data = UIImageJPEGRepresentation(tmpImage, 1.0f);
        NSString *encodeImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [tmpArray addObject:encodeImageStr];
    }
    [self.backData addText:self.textView.text Img:tmpArray];
    self.textView.text = nil;
    self.imageArray = nil;
    [self.collectionView reloadData];
}
//addImageButton action
-(void)addImage{
    //self.view present UIAlertController
    //&&&&&&&&&&&&&&
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"add image" preferredStyle:UIAlertControllerStyleAlert];
    //__weak TextViewController *weakself = self;
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //self.view present UIImagePickerController
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -UIImagePickerController delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    @try {
        UIImage *tmpImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.imageArray addObject:tmpImage];//add image to imageArray
        [self.collectionView reloadData];
    } @catch (NSException *exception) {
        NSLog(@"error");
    } @finally {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    //[[picker parentViewController] dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -UICollectionView delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"delete image" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.imageArray removeObjectAtIndex:indexPath.row];
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
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    cell.image.image = [self.imageArray objectAtIndex:indexPath.row];
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
    return [self.imageArray count];
}

#pragma mark -longPress Gesture action
-(void)handleLongPress:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self.imageArray removeObjectAtIndex:recognizer.view.tag];
        [self.collectionView reloadData];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"longPressGestrure ended\n");
    }
}

@end
