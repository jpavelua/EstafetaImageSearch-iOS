
#import "ImageModel.h"
#import "U.h"

@implementation ImageModel

- (id)initWithTitle:(NSString*)title
             andUrl: (NSURL*) url
{
    self = [super init];
    _title = title;
    _url = url;
    
    return self;
}

- (id)initWithTitle:(NSString*)title
             andUrl:(NSURL*) url
        andFielPath:(NSString*) filePath {
    
    self = [super init];
    _title = title;
    _url = url;
    _filePath = filePath;
    
    return self;
}

- (id)initWithTitle:(NSString*)title
             andUrl: (NSURL*) url
       andTimestamp: (long) timestamp
        andLocation: (CLLocation*) location
{
    self = [super init];
    _title = title;
    _url = url;
    _timestamp = timestamp;
    _location = location;
    
    return self;
}

- (NSString*) getSavedFilePath {
    NSString *appImagesFolderPath = [U getAppImagesFolderPath];
    return [NSString stringWithFormat:@"%@/%@", appImagesFolderPath, _title];
    
}

@end
