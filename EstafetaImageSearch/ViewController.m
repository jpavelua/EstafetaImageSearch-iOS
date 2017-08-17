
#import "ViewController.h"
#import "U.h"
#import "S.h"
#import "ImageModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sb.delegate = self;
    
    self.tv.delegate = self;
    self.tv.dataSource = self;
    
    self.searchCashedImages = [NSArray new];
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.locationManager startUpdatingLocation];
//    [self.locationManager requestAlwaysAuthorization];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.searchController.searchBar.superview) {
        self.tv.tableHeaderView = self.searchController.searchBar;
    }
    if (!self.searchController.active && self.searchController.searchBar.text.length == 0) {
        self.tv.contentOffset = CGPointMake(0, CGRectGetHeight(self.searchController.searchBar.frame));
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchCashedImages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"RecipeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    ImageModel *im = [self.searchCashedImages objectAtIndex:indexPath.row];
    
    cell.textLabel.text = im.title;
    
//    >> >> load directly from web
//    NSData *data = [NSData dataWithContentsOfURL:im.url];
//    UIImage *image = [UIImage imageWithData:data];
//    cell.imageView.image = image;

//    >> >> load from files on the storage
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:im.filePath];
    cell.imageView.image = image;
    
    return cell;
}

#pragma mark - UISearchControllerDelegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"updateSearchResultsForSearchController");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"searchBarSearchButtonClicked : text=%@", searchBar.text);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        
//        ########  MAKE SEARCH API REQUEST
//        ########  AND
//        ########  SAVE TO STORAGE
        
//        >> Plaint Fake images  [title + links]
//        NSArray *searchResults = [U getTestImages];
//        self.searchCashedImages = [self saveLoadedImagesToStorage:searchResults];
        
//        >> Test Json from file res/raw/test_response.txt
//        NSArray *searchResults = [U getImagesFromTestJson];
//        self.searchCashedImages = [self saveLoadedImagesToStorage:searchResults];
        
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //update UI in main thread.
//            [self.tv reloadData];
//
//        });
        
        
//        >> Obtaining real value
        [U getImagesFromWeb:searchBar.text withCompletion:^(NSDictionary *searchResultsJson) {
            
            NSArray *searchResults = [U parseSearchJson:searchResultsJson];
            self.searchCashedImages = [self saveLoadedImagesToStorage:searchResults];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //update UI in main thread.
                [self.tv reloadData];
                
            });
        }];

    });

}

- (NSArray*) saveLoadedImagesToStorage:(NSArray*) searchResults{
    
    NSFileManager *fm = [[NSFileManager alloc] init];
    
//    [U clearAppCashe];
 
    NSString *appImagesFolderPath = [U getAppImagesFolderPath];
    if(![fm fileExistsAtPath:appImagesFolderPath]){
        
        NSError *error = nil;
        [fm createDirectoryAtPath:appImagesFolderPath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:&error];
    }
    

    
    for (ImageModel* im in searchResults) {
        
        NSString *imgName = im.title;
        NSURL *imgURL = im.url;
        
//        NSString *filePath = [appImagesFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imgName, @"png"]];
        
        if(imgName.length > 20)
            imgName = [imgName substringToIndex:20];
        NSString *filePath = [appImagesFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imgName, @"png"]];
        
        if(![fm fileExistsAtPath:filePath]){
            
            im.filePath = filePath;
            
            NSData * data = [NSData dataWithContentsOfURL:imgURL];
            
            [self saveImageData:data toPath:filePath];
        }
        else{
            NSLog(@"file exist");
        }
    }
    
    return searchResults;
}

- (void) saveImageData: (NSData*) imageData toPath:(NSString*) filePath{
    
    NSError *error = nil;
    
    [imageData writeToFile:filePath
                   options:NSAtomicWrite
                     error:&error];
    
    if (error) {
        NSLog(@"Error Writing File : %@",error);
    }else{
        NSLog(@"Image [%@] Saved SuccessFully",filePath);
    }

}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location: %@", [newLocation description]);
    [U saveCurrentLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error description]);
}

@end
