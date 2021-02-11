//
//  JCDHTTPConnection.h
//  Created by Justin Driscoll on 11/26/11.
//

#import <Foundation/Foundation.h>


typedef void (^OnSuccess) (NSHTTPURLResponse *response, id bodyString);
typedef void (^OnFailure) (NSHTTPURLResponse *response, id bodyString, NSError *error);
typedef void (^OnDidSendData) (NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite);


@interface JCDHTTPConnection : NSObject

//- (id)initWithRequest:(NSURLRequest *)urlRequest;
-(id)initWithUrl:(NSString *)url params:(NSDictionary*)params;

- (BOOL)executeRequestOnSuccess:(OnSuccess)onSuccessBlock
                        failure:(OnFailure)onFailureBlock
                    didSendData:(OnDidSendData)onDidSendDataBlock;

@end
