
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ImageModel : NSObject

@property(nonatomic, strong) NSString *title;
//    public String url;
@property(nonatomic, strong) NSURL *url;
@property(nonatomic, strong) NSString *filePath;
@property(nonatomic, assign) long timestamp;
@property(nonatomic, strong) CLLocation* location;

- (id)initWithTitle:(NSString*)title
             andUrl: (NSURL*) url;

- (id)initWithTitle:(NSString*)title
             andUrl:(NSURL*) url
        andFielPath:(NSString*) filePath;

- (id)initWithTitle:(NSString*)title
             andUrl: (NSURL*) url
       andTimestamp: (long) timestamp
        andLocation: (CLLocation*) location;

- (NSString*) getSavedFilePath;

@end
