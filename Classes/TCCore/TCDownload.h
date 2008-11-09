/*
 
 Copyright (c) 2008 Technicolor Project
 Licensed under the MIT License
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import <Foundation/Foundation.h>

@class TCDownload;

@protocol TCDownloadDelegate

-(void)downloadReceivedData:(TCDownload *)download;
-(void)downloadFinished:(TCDownload *)download;
-(void)download:(TCDownload *)download hadError:(NSError *)error;

@end

typedef long long TCDownloadSize;

typedef enum {
	TCDownloadRequestTypeGET,
	TCDownloadRequestTypePOST,
	TCDownloadRequestTypeHEAD
} TCDownloadRequestType;

@interface TCDownload : NSObject {
	id<TCDownloadDelegate> mDelegate;
	
	NSURL *mURL;
	NSURLRequest *mRequest;
	NSHTTPURLResponse *mResponse;
	NSURLConnection *mConnection;
	NSDictionary *mHeaders;
	
	TCDownloadRequestType mRequestType;
	TCDownloadSize mExpectedSize;
	
	NSData *mRequestData;
	NSData *mData;
	
	BOOL mFinished;
}

@property (assign) id<TCDownloadDelegate> delegate;
@property (readonly) NSURL *url;
@property (readonly) NSURLRequest  *request;
@property (readonly) NSHTTPURLResponse *response;
@property (readonly) NSData *data;
@property (retain) NSData *requestData;
@property TCDownloadRequestType requestType;
@property (readonly) TCDownloadSize expectedSize;
@property (readonly, getter=isFinished) BOOL finished;

-(id)initWithURL:(NSURL *)url;

-(void)send;
-(void)cancel;

+(NSData *)loadResourceDataForURL:(NSURL *)url;
+(NSString *)loadResourceStringForURL:(NSURL *)url encoding:(NSStringEncoding)encoding;
@end
