//
//  ViewController.h
//  DownloadImage_GCD
//
//  Created by BeyondVincent on 13-5-2.
//  Copyright (c) 2013年 BeyondVincent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UIImageView *image6;
@property (weak, nonatomic) IBOutlet UILabel *status;
- (IBAction)downloadAction:(UIButton *)sender;
- (IBAction)deleteCacheImage:(id)sender;
@end
