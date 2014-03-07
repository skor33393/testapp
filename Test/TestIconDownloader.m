//
//  TestIconDownloader.m
//  Test
//
//  Created by Admin on 05.03.14.
//  Copyright (c) 2014 Alex Korenev. All rights reserved.
//

#import "TestIconDownloader.h"
#import "TestEmployee.h"

#define kAppIconSize 50

@interface TestIconDownloader ()
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;
@property BOOL successfull;
@end

@implementation TestIconDownloader

#pragma mark

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    
    self.successfull = NO;
    
    // check if phoyoURL is not nil
    if (self.employee.photoURL) {
        NSString *urlString = [NSString stringWithFormat:@"http://%@", self.employee.photoURL];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        
        // alloc+init and start an NSURLConnection; release on completion/failure
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        self.imageConnection = conn;
    }
    else {
        self.employee.photo = [UIImage imageNamed:@"noPhoto"];
        if (self.completionHandler) {
            self.completionHandler();
        }
    }
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.employee.photo = [UIImage imageNamed:@"noPhoto"];
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    if (self.completionHandler) {
        self.completionHandler();
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // check if image not found
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ([httpResponse statusCode] == 200 || [httpResponse statusCode] == 203) {
        self.successfull = YES;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.successfull) {

        // Set appIcon and clear temporary data/image
        UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
        if (image.size.width != kAppIconSize || image.size.height != kAppIconSize)
        {
            CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [image drawInRect:imageRect];
            self.employee.photo = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        else
        {
            self.employee.photo = image;
        }
    
        self.activeDownload = nil;
    
        // Release the connection now that it's finished
        self.imageConnection = nil;
        
        // call our delegate and tell it that our icon is ready for display
        if (self.completionHandler)
            self.completionHandler();
    }
    else {
        self.employee.photo = [UIImage imageNamed:@"noPhoto"];
        self.activeDownload = nil;
        
        // Release the connection now that it's finished
        self.imageConnection = nil;
        if (self.completionHandler) {
            self.completionHandler();
        }
    }
}


@end
