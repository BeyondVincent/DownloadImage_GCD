//
//  ViewController.m
//  DownloadImage_GCD
//
//  Created by BeyondVincent on 13-5-2.
//  Copyright (c) 2013年 BeyondVincent. All rights reserved.
//

#import "ViewController.h"
#import "ImageInfo.h"

@interface ViewController ()
@property (retain, nonatomic) NSMutableArray *imageList;
@property (retain, nonatomic) NSString *baseUrl;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.baseUrl = @"http://beyondvincent.com/wp-content/uploads/2013/05/";
    self.imageList = [[NSMutableArray alloc] init];
    ImageInfo * info;
    info = [[ImageInfo alloc] init]; info.imageName = @"downloadimage_gdc_1.png"; [self.imageList addObject:info];
    info = [[ImageInfo alloc] init]; info.imageName = @"downloadimage_gdc_2.png"; [self.imageList addObject:info];
    info = [[ImageInfo alloc] init]; info.imageName = @"downloadimage_gdc_3.png"; [self.imageList addObject:info];
    info = [[ImageInfo alloc] init]; info.imageName = @"downloadimage_gdc_4.png"; [self.imageList addObject:info];
    info = [[ImageInfo alloc] init]; info.imageName = @"downloadimage_gdc_5.png"; [self.imageList addObject:info];
    info = [[ImageInfo alloc] init]; info.imageName = @"downloadimage_gdc_6.png"; [self.imageList addObject:info];
    
}

- (IBAction)downloadAction:(UIButton *)sender
{
    [self resetImage];
    self.status.text = @"正在下载";
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t downloadImage = dispatch_group_create();
    
    for (ImageInfo *info in self.imageList) {
        NSString* imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:info.imageName];

        NSFileManager *fileManager = [NSFileManager defaultManager];
        // 如果本地不存在图片，则从网络中下载
        if (![fileManager fileExistsAtPath:imagePath]) {
            dispatch_group_async(downloadImage, queue, ^{
                NSLog(@"Starting image download:%@", imagePath);
                // URL组装和编码
                NSString *urlString = [NSString stringWithFormat:@"%@/%@", self.baseUrl, info.imageName];
                NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                NSLog(@"image download from url:%@", urlString);
                
                // 开始下载图片
                NSData *responseData = [NSData dataWithContentsOfURL:url];
                // 将图片保存到指定路径中
                [responseData writeToFile:imagePath atomically:YES];
                // 将下载的图片赋值给info
                info.image = [UIImage imageWithData:responseData];
                NSLog(@"image download finish:%@", imagePath);
            });
        } else { // 将本地图片加载到systemInfo.MyImage
            info.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
        }
    }
    dispatch_group_notify(downloadImage, dispatch_get_main_queue(), ^{
        // 图片加载完毕之后，显示出来
        self.status.text = @"图片文件下载并缓存完毕";
        [self showImage];
    });
}

-(void)showImage
{
    self.image1.image = ((ImageInfo*)[self.imageList objectAtIndex:0]).image;
    self.image2.image = ((ImageInfo*)[self.imageList objectAtIndex:1]).image;
    self.image3.image = ((ImageInfo*)[self.imageList objectAtIndex:2]).image;
    self.image4.image = ((ImageInfo*)[self.imageList objectAtIndex:3]).image;
    self.image5.image = ((ImageInfo*)[self.imageList objectAtIndex:4]).image;
    self.image6.image = ((ImageInfo*)[self.imageList objectAtIndex:5]).image;
}

-(void)resetImage
{
    self.image1.image = [UIImage imageNamed:@"empty"];
    self.image2.image = [UIImage imageNamed:@"empty"];
    self.image3.image = [UIImage imageNamed:@"empty"];
    self.image4.image = [UIImage imageNamed:@"empty"];
    self.image5.image = [UIImage imageNamed:@"empty"];
    self.image6.image = [UIImage imageNamed:@"empty"];
}

- (IBAction)deleteCacheImage:(id)sender
{

    for (ImageInfo *info in self.imageList) {
        NSString* imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:info.imageName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:imagePath]) {
            [fileManager removeItemAtPath:imagePath error:nil];
        }
    }
    self.status.text = @"缓存文件已经删除";

    [self resetImage];
}

@end
