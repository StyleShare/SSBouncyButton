//
// The MIT License (MIT)
//
// Copyright (c) 2014 Suyeol Jeon (http://xoul.kr),
//                    StyleShare (https://stylesha.re)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import "SSAppDelegate.h"
#import "SSBouncyButton.h"

static CGFloat centerX;
static CGFloat centerY;

@implementation SSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    centerX = screenSize.width / 2;
    centerY = screenSize.height / 2;
    
    SSBouncyButton *followButton = [[SSBouncyButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    followButton.center = CGPointMake(centerX, centerY - 25);
    [followButton setTitle:@"Follow" forState:UIControlStateNormal];
    [followButton setTitle:@"Following" forState:UIControlStateSelected];
    [followButton addTarget:self action:@selector(buttonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:followButton];
    
    SSBouncyButton *tintedButton = [[SSBouncyButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    tintedButton.tintColor = [UIColor grayColor];
    tintedButton.center = CGPointMake(centerX, centerY + 25);
    [tintedButton setTitle:@"Follow" forState:UIControlStateNormal];
    [tintedButton setTitle:@"Following" forState:UIControlStateSelected];
    [tintedButton addTarget:self action:@selector(buttonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:tintedButton];
    
    return YES;
}

- (void)buttonDidPress:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (![self.window viewWithTag:999]) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Try touch long, too.";
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:12];
        label.tag = 999;
        [label sizeToFit];
        label.center = CGPointMake(centerX, centerY + 65);
        [self.window addSubview:label];
    }
}

@end
