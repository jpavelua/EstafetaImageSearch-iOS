
#import "U.h"
#import "S.h"
#import "ImageModel.h"
#import "AFNetworking.h"

@implementation U

NSString *const KEY_LAT = @"KEY_LAT";
NSString *const KEY_LON = @"KEY_LON";

+ (void) saveCurrentLocation: (CLLocation*) l {
    [U saveCurrentLat: l.coordinate.latitude
               andLon: l.coordinate.longitude];
}

+ (void) saveCurrentLat: (double) lat
                 andLon: (double) lon {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setDouble:lat forKey:KEY_LAT];
    [ud setDouble:lon forKey:KEY_LON];
    [ud synchronize];
}

+ (CLLocation*) getCurrentLocation {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    double lat = [ud doubleForKey:KEY_LAT];
    double lon = [ud doubleForKey:KEY_LON];
    
    return [[CLLocation alloc] initWithLatitude:lat longitude:lon];
}

+ (NSString*) getAppImagesFolderPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *appFolderPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, APP_IMAGE_DIRECTORY];
    
    return appFolderPath;
}

+ (NSString*) getSearchUrlWithSearchString: (NSString*) strToSearch
                                 andApiKey: (NSString*) apiKey
                         andSearchEngineID: (NSString*) searchEngineID{

    NSString *strNoSpaces = [strToSearch stringByReplacingOccurrencesOfString:@" "
                                                                   withString:@"+"];
    
    NSMutableString *msRequest = [[NSMutableString alloc] initWithString: SEARCH_API_HOST];
    [msRequest appendString:@"?"];
    [msRequest appendString:[NSString stringWithFormat:@"%@=%@", @"q", strNoSpaces]];
    [msRequest appendString:@"&"];
    [msRequest appendString:[NSString stringWithFormat:@"%@=%@", @"key", apiKey]];
    [msRequest appendString:@"&"];
    [msRequest appendString:[NSString stringWithFormat:@"%@=%@", @"cx", searchEngineID]];
    [msRequest appendString:@"&"];
    [msRequest appendString:[NSString stringWithFormat:@"%@=%@", @"alt", @"json"]];
    [msRequest appendString:@"&"];
    [msRequest appendString:[NSString stringWithFormat:@"%@=%@", @"searchType", @"image"]];
 
    return (NSString *)msRequest;
}

+ (NSString*) getTestSearchJson {
    
    NSString *result = nil;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test_response"
                                                     ofType:@"txt"];
    
    result = [NSString stringWithContentsOfFile:path
                                       encoding:NSUTF8StringEncoding
                                          error:NULL];
    
    return result;
}

+ (NSArray*) parseSearchJson: (NSDictionary*) dicSearch {
    
    NSMutableArray *imageModels = [NSMutableArray new];
    
    if(dicSearch){
        
        NSArray *arrItems = [dicSearch objectForKey:@"items"];
        
        
        for(NSDictionary *item in arrItems)
        {
            
            NSString *imageTitle = [item valueForKey:@"title"];
            NSString *imageLink  = [item valueForKey:@"link"];
            
            if(imageLink && imageLink.length > 0){
                
                long timestamp = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
                CLLocation *location = [U getCurrentLocation];
                
                ImageModel *im = [[ImageModel alloc] initWithTitle:imageTitle
                                                            andUrl:[NSURL URLWithString:imageLink]
                                                      andTimestamp:timestamp
                                                       andLocation:location];
                
                [imageModels addObject:im];
            }
        }
        
    }

    return imageModels;
}

+ (NSArray*) getTestImages {
    
    NSArray *imageModels = @[
                         [ [ImageModel alloc] initWithTitle:@"Afghanistan" andUrl: [NSURL URLWithString:@"https://www.infoplease.com/sites/infoplease.com/files/public%3A/afghan.gif"] ],
                         [ [ImageModel alloc] initWithTitle:@"Albania" andUrl: [NSURL URLWithString:@"https://www.infoplease.com/sites/infoplease.com/files/public%3A/albania.gif"] ],
                         [ [ImageModel alloc] initWithTitle:@"Algeria" andUrl: [NSURL URLWithString:@"https://www.infoplease.com/sites/infoplease.com/files/public%3A/algeria.gif"] ],
                         [ [ImageModel alloc] initWithTitle:@"Andorra" andUrl: [NSURL URLWithString:@"https://www.infoplease.com/sites/infoplease.com/files/public%3A/andorra.gif"] ],
                         [ [ImageModel alloc] initWithTitle:@"Angola" andUrl: [NSURL URLWithString:@"https://www.infoplease.com/sites/infoplease.com/files/public%3A/angola.gif"] ],
                         [ [ImageModel alloc] initWithTitle:@"Bahamas" andUrl: [NSURL URLWithString:@"https://www.infoplease.com/sites/infoplease.com/files/public%3A/bahamas.gif"] ],
                         [ [ImageModel alloc] initWithTitle:@"Bahrain" andUrl: [NSURL URLWithString:@"https://www.infoplease.com/sites/infoplease.com/files/public%3A/bahrain.gif"] ],
                         [ [ImageModel alloc] initWithTitle:@"Bangladesh" andUrl: [NSURL URLWithString:@"https://www.infoplease.com/sites/infoplease.com/files/2017-03/banglad.gif"] ],
                         [ [ImageModel alloc] initWithTitle:@"Barbados" andUrl: [NSURL URLWithString:@"https://www.infoplease.com/sites/infoplease.com/files/public%3A/barbados.gif"] ],
                         [ [ImageModel alloc] initWithTitle:@"Belarus" andUrl: [NSURL URLWithString:@"https://www.infoplease.com/sites/infoplease.com/files/public%3A/belarus.gif"] ],
                         [ [ImageModel alloc] initWithTitle:@"Belgium" andUrl: [NSURL URLWithString:@"https://www.infoplease.com/sites/infoplease.com/files/public%3A/belgium.gif"] ],
                         [ [ImageModel alloc] initWithTitle:@"Cambodia" andUrl: [NSURL URLWithString:@"https://www.infoplease.com/sites/infoplease.com/files/public%3A/cambodia.gif"] ],
                         [ [ImageModel alloc] initWithTitle:@"Cape Verde" andUrl: [NSURL URLWithString:@"https://www.infoplease.com/sites/infoplease.com/files/public%3A/capeverd.gif"] ],
                         [ [ImageModel alloc] initWithTitle:@"Chile" andUrl: [NSURL URLWithString:@"https://www.infoplease.com/sites/infoplease.com/files/public%3A/chile.gif"] ],
                         [ [ImageModel alloc] initWithTitle:@"Comoros" andUrl: [NSURL URLWithString:@"https://www.infoplease.com/sites/infoplease.com/files/public%3A/comoros.gif"] ],
                         [ [ImageModel alloc] initWithTitle:@"Costa Rica" andUrl: [NSURL URLWithString:@"https://www.infoplease.com/sites/infoplease.com/files/public%3A/costaric.gif"] ],
                         [ [ImageModel alloc] initWithTitle:@"Cuba" andUrl: [NSURL URLWithString:@"https://www.infoplease.com/sites/infoplease.com/files/public%3A/cuba.gif"] ],
                         [ [ImageModel alloc] initWithTitle:@"Denmark" andUrl: [NSURL URLWithString:@"https://www.infoplease.com/sites/infoplease.com/files/public%3A/denmark.gif"] ],
                         [ [ImageModel alloc] initWithTitle:@"Dominican Republic" andUrl: [NSURL URLWithString:@"https://www.infoplease.com/sites/infoplease.com/files/public%3A/domrep.gif"] ]
                         ];
    return imageModels;
}

+ (NSArray*) getImagesFromTestJson {
    NSString *response = [U getTestSearchJson];
    
    NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dicResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    return [U parseSearchJson:dicResponse];
}

+ (void) getImagesFromWeb: (NSString*) searchString
               withCompletion: (SearchResponseCompletion)completion {
    
//        https://www.googleapis.com/customsearch/v1?q=Guitar&key=AIzaSyB1vZrTxlNS23C0jqCUVae6KDhtJDgHzAs&cx=004160727337875953838:xmj6fvuai_c&alt=json&searchType=image
    
    NSString *url = [U getSearchUrlWithSearchString:searchString
                                          andApiKey:API_KEY
                                  andSearchEngineID:SEARCH_ENGINE_ID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completion((NSDictionary*)responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion([NSDictionary new]);
    }];
}



+ (void) clearAppCashe {
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *files = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
    
    while (files.count > 0) {
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error];
        if (error == nil) {
            for (NSString *path in directoryContents) {
                NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:path];
                BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
                files = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
                if (!removeSuccess) {
                    // Error
                }
            }
        } else {
            // Error
        }
    }
    
    
    NSError *error2 = nil;
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory2 = [paths2 objectAtIndex:0];
    NSArray *files2 = [fileMgr contentsOfDirectoryAtPath:documentsDirectory2 error:nil];
    
    NSLog(@"");
}

@end
