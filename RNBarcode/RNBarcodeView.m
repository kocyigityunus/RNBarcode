//
//  RCTQRCodeView.m
//  reactbabylon
//
//  Created by yunus kocyigit on 07/02/16.
//

#import "RNBarcodeView.h"
#import <ZXingObjC/ZXingObjC.h>

typedef enum {
  QRCodeErrorCorrectionLevelL, // %7
  QRCodeErrorCorrectionLevelM, // %15
  QRCodeErrorCorrectionLevelQ, // %25
  QRCodeErrorCorrectionLevelH  // %30
} QRCodeErrorCorrectionLevel;

@implementation RNBarcodeView {
  NSString *barcodeText;
  ZXBarcodeFormat barcodeFormat;
  QRCodeErrorCorrectionLevel correctionLevel;
}

-(instancetype)init {
  
  if( self = [super init] ){
    self.frame = CGRectZero;
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.backgroundColor = [UIColor whiteColor];
    barcodeFormat = kBarcodeFormatQRCode;
    correctionLevel = QRCodeErrorCorrectionLevelL;
  }
  
  return self;
}

-(void)reactSetFrame:(CGRect)frame{
  self.frame = frame;
  [self redrawBarcode];
}

-(void)sendErrorWithNSError : (NSError *) error{
  if( _onBarcodeError && error ){
    _onBarcodeError(@{
                      @"errorCode": @(error.code),
                      @"errorDescription": error.localizedDescription,
                      });
  }
}

-(void)setText:(NSString *)text {
  barcodeText = text;
  [self redrawBarcode];
}

-(void)setFormat:(NSString *)format{
  if( format && format.length > 0 ){
    if( [format hasPrefix:@"qr"] ){
      barcodeFormat = kBarcodeFormatQRCode;
      if([format hasSuffix:@"L"]){ correctionLevel = QRCodeErrorCorrectionLevelL; }
      else if([format hasSuffix:@"M"]){ correctionLevel = QRCodeErrorCorrectionLevelM; }
      else if([format hasSuffix:@"Q"]){ correctionLevel = QRCodeErrorCorrectionLevelQ; }
      else if([format hasSuffix:@"H"]){ correctionLevel = QRCodeErrorCorrectionLevelH; }
    }
    else if( [format isEqualToString:@"aztec"] ){ barcodeFormat = kBarcodeFormatAztec; }
    else if( [format isEqualToString:@"codabar"] ){ barcodeFormat = kBarcodeFormatCodabar; }
    else if( [format isEqualToString:@"code39"] ){ barcodeFormat = kBarcodeFormatCode39; }
    else if( [format isEqualToString:@"code93"] ){ barcodeFormat = kBarcodeFormatCode93; }
    else if( [format isEqualToString:@"code128"] ){ barcodeFormat = kBarcodeFormatCode128; }
    else if( [format isEqualToString:@"datamatrix"] ){ barcodeFormat = kBarcodeFormatDataMatrix; }
    else if( [format isEqualToString:@"ean8"] ){ barcodeFormat = kBarcodeFormatEan8; }
    else if( [format isEqualToString:@"ean13"] ){ barcodeFormat = kBarcodeFormatEan13; }
    else if( [format isEqualToString:@"itf"] ){ barcodeFormat = kBarcodeFormatITF; }
    else if( [format isEqualToString:@"maxicode"] ){ barcodeFormat = kBarcodeFormatMaxiCode; }
    else if( [format isEqualToString:@"pdf417"] ){ barcodeFormat = kBarcodeFormatPDF417; }
    else if( [format isEqualToString:@"rss14"] ){ barcodeFormat = kBarcodeFormatRSS14; }
    else if( [format isEqualToString:@"rssexpanded"] ){ barcodeFormat = kBarcodeFormatRSSExpanded; }
    else if( [format isEqualToString:@"upca"] ){ barcodeFormat = kBarcodeFormatUPCA; }
    else if( [format isEqualToString:@"upce"] ){ barcodeFormat = kBarcodeFormatUPCE; }
    else if( [format isEqualToString:@"upceanextension"] ){ barcodeFormat = kBarcodeFormatUPCEANExtension; }
    else{  }
    [self redrawBarcode];
  }
}

-(void) redrawBarcode {
  
  if(self.frame.size.width == 0 || self.frame.size.height == 0){
    return;
  }
  
  UIImage *img;
  NSError *error = nil;
  
  @try {
    ZXEncodeHints *hints = [ZXEncodeHints hints];
    hints.margin = @(0);
    
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result;
    
    if( barcodeText && barcodeText.length == 0 ){
      [self sendErrorWithNSError:[NSError errorWithDomain:@"0 barcode text length"
                                                     code:100
                                                 userInfo:nil]];
      return;
    }
    
    // set qr code correction levels if necessary
    if(barcodeFormat == kBarcodeFormatQRCode){
      switch (correctionLevel) {
        case QRCodeErrorCorrectionLevelL:
          hints.errorCorrectionLevel = [ZXQRCodeErrorCorrectionLevel errorCorrectionLevelL];
          break;
        case QRCodeErrorCorrectionLevelM:
          hints.errorCorrectionLevel = [ZXQRCodeErrorCorrectionLevel errorCorrectionLevelM];
          break;
        case QRCodeErrorCorrectionLevelQ:
          hints.errorCorrectionLevel = [ZXQRCodeErrorCorrectionLevel errorCorrectionLevelQ];
          break;
        default:
          hints.errorCorrectionLevel = [ZXQRCodeErrorCorrectionLevel errorCorrectionLevelH];
          break;
      }
    }
    
    // if its a 2d barcode format or pdf417
    if( barcodeFormat == kBarcodeFormatQRCode
       || barcodeFormat == kBarcodeFormatAztec
       || barcodeFormat == kBarcodeFormatDataMatrix
       || barcodeFormat == kBarcodeFormatPDF417 ){
      
      result = [writer encode: barcodeText ? barcodeText :  @"0"
                       format:barcodeFormat
                        width:self.frame.size.width
                       height:self.frame.size.height
                        hints:hints
                        error:&error];
    }
    else{
      result = [writer encode: barcodeText ? barcodeText :  @"0"
                       format:barcodeFormat
                        width:0
                       height:self.frame.size.height
                        hints:hints
                        error:&error];
    }
    
    if (result) {
      CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
      img = [UIImage imageWithCGImage:image];
    } else {
      [self sendErrorWithNSError:error];
    }
  }
  @catch (NSException *exception) {
    [self sendErrorWithNSError:[NSError errorWithDomain:[NSString stringWithFormat:@"Other Error -- %@", exception.reason]
                                                   code:99
                                               userInfo:nil]];
  }
  
  self.image = nil;
  self.image = img;
}

@end
