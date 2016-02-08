//
//  RCTQRCodeViewManager.m
//  reactbabylon
//
//  Created by yunus kocyigit on 07/02/16.
//

#import "RNBarcodeViewManager.h"
#import "RNBarcodeView.h"

@implementation RNBarcodeViewManager

RCT_EXPORT_VIEW_PROPERTY(format, NSString);
RCT_EXPORT_VIEW_PROPERTY(text, NSString);
RCT_EXPORT_VIEW_PROPERTY(onBarcodeError, RCTBubblingEventBlock)

RCT_EXPORT_MODULE();

- (UIView *)view
{
  return [[RNBarcodeView alloc] init];
}


@end
