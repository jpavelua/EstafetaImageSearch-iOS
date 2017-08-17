
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^SearchResponseCompletion)(NSDictionary* dicResponse);

@interface U : NSObject

+ (void) saveCurrentLocation: (CLLocation*) l;
+ (void) saveCurrentLat: (double) lat
                 andLon: (double) lon;
+ (CLLocation*) getCurrentLocation;
+ (NSString*) getAppImagesFolderPath;
+ (NSString*) getSearchUrlWithSearchString: (NSString*) strToSearch
                                 andApiKey: (NSString*) apiKey
                         andSearchEngineID: (NSString*) searchEngineID;
+ (NSString*) getTestSearchJson;
+ (NSArray*) parseSearchJson: (NSDictionary*) dicSearch ;

+ (NSArray*) getTestImages;
+ (NSArray*) getImagesFromTestJson;
+ (void) getImagesFromWeb: (NSString*) searchString
           withCompletion: (SearchResponseCompletion)completion;

+ (void) clearAppCashe;

@end
