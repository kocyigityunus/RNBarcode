//
//  RCTQRCodeView.h
//  reactbabylon
//
//  Created by yunus kocyigit on 07/02/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCTEventDispatcher.h"
#import "UIView+React.h" // needed for RCTBubblingEventBlock event reactsetframe method

@interface RNBarcodeView : UIImageView

@property (nonatomic ,strong) NSString *text;
@property (nonatomic,copy) RCTBubblingEventBlock onBarcodeError;
@property (nonatomic ,strong) NSString *format;

@end
