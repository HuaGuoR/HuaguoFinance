//
//  SCGIFImageView.h
//  TestGIF
//
//  Created by shichangone on 11-7-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageLoader.h"

@interface AnimatedGifFrame : NSObject
{
	NSData *data;
	NSData *header;
	double delay;
	int disposalMethod;
	CGRect area;
}

@property (nonatomic, copy) NSData *header;
@property (nonatomic, copy) NSData *data;
@property (nonatomic) double delay;
@property (nonatomic) int disposalMethod;
@property (nonatomic) CGRect area;

@end

@protocol FWGIFImageViewDelegate;

@interface FWGIFImageView : UIImageView<EGOImageLoaderObserver> {
	NSData *GIF_pointer;
	NSMutableData *GIF_buffer;
	NSMutableData *GIF_screen;
	NSMutableData *GIF_global;
	NSMutableArray *GIF_frames;
	
	int GIF_sorted;
	int GIF_colorS;
	int GIF_colorC;
	int GIF_colorF;
	int animatedGifDelay;
	
	int dataPointer;
    
	NSURL* imageURL;
	UIImage* placeholderImage;
	id<FWGIFImageViewDelegate> delegate; 
    BOOL GIF_disable;
}
@property (nonatomic, retain) NSMutableArray *GIF_frames;

- (id)initWithGIFFile:(NSString*)gifFilePath;
- (id)initWithGIFData:(NSData*)gifImageData;

- (void)loadImageData;

+ (NSMutableArray*)getGifFrames:(NSData*)gifImageData;
+ (BOOL)isGifImage:(NSData*)imageData;

- (void)setGIFImageData:(NSData*) anData;

- (void) decodeGIF:(NSData *)GIFData;
- (void) GIFReadExtensions;
- (void) GIFReadDescriptor;
- (bool) GIFGetBytes:(int)length;
- (bool) GIFSkipBytes: (int) length;
- (NSData*) getFrameAsDataAtIndex:(int)index;
- (UIImage*) getFrameAsImageAtIndex:(int)index;

- (id)initWithPlaceholderImage:(UIImage*)anImage; // delegate:nil
- (id)initWithPlaceholderImage:(UIImage*)anImage delegate:(id<FWGIFImageViewDelegate>)aDelegate;

- (void)cancelImageLoad;

@property(nonatomic,assign) BOOL GIF_disable;
@property(nonatomic,retain) NSURL* imageURL;
@property(nonatomic,retain) UIImage* placeholderImage;
@property(nonatomic,assign) id<FWGIFImageViewDelegate> delegate;
@end

@protocol FWGIFImageViewDelegate<NSObject>
@optional
- (void)imageViewLoadedImage:(FWGIFImageView*)imageView;
- (void)imageViewFailedToLoadImage:(FWGIFImageView*)imageView error:(NSError*)error;
@end
