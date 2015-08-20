//
//  MovieViewController.m
//  RottenTomato
//
//  Created by Li-Erh å¼µåŠ›å…’ Chang on 8/17/15.
//  Copyright (c) 2015 Li-Erh Chang. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "ViewController.h"
#import <UIImageView+AFNetworking.h>
#import <JGProgressHUD/JGProgressHUD.h>
#import <JGProgressHUD/JGProgressHUDErrorIndicatorView.h>

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating>;

//@property (weak, nonatomic) IBOutlet UISearchBar *movieSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) NSMutableArray *filteredMovies;
@property (strong, nonatomic) JGProgressHUD *hud;

@property (strong, nonatomic) NSCache *cache;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MyMovieCell"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(getMovies) forControlEvents:UIControlEventValueChanged];
    
    // loading hud
    self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.hud.textLabel.text = @"Loading";
    [self.hud showInView:self.view];
    
    // get movie data
    [self getMovies];
    
    // init cache
    self.cache = [[NSCache alloc]init];
    
    // search bar
    self.filteredMovies = [[NSMutableArray alloc]init];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)getMovies {
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us";
    // url = @"http://api.rottenoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            self.hud.textLabel.text = @"Network Error";
            self.hud.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
            [self.hud showInView:self.view];
            [self.hud dismissAfterDelay:3.0];
            return;
        }
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.movies = dict[@"movies"];
        self.filteredMovies = [NSMutableArray arrayWithCapacity:self.movies.count];
        [self.tableView reloadData];
        
        [self.refreshControl endRefreshing];
        [self.hud dismiss];
    }];
}


#pragma mark - Table view data source


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 174.; // you can have your own choice, of course
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return self.filteredMovies.count;
    } else {
        return self.movies.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MyMovieCell" forIndexPath:indexPath];
    NSArray *movies;
    
    if (self.searchController.active) {
        movies = [[NSArray alloc] initWithArray:self.filteredMovies];
    } else {
        movies = [[NSArray alloc] initWithArray:self.movies];
    }
    
    NSDictionary *movie = movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    
    // get poster thumbnail w/ cache operation
    NSString *posterUrl = [movie valueForKeyPath:@"posters.thumbnail"];
    UIImage *poster = [self.cache objectForKey:movie[@"title"]];
    if (poster) { // poster found in cache
        [cell.posterView setImage:poster];
    } else {
        cell.posterView.alpha = 0.0;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:posterUrl]];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        [cell.posterView setImageWithURLRequest:request placeholderImage:nil
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                [self storeImageInCache:image keyForObject:movie[@"title"]];
                [cell.posterView setImage:image];
                [UIView animateWithDuration:0.3 animations:^{
                    cell.posterView.alpha = 1.0;
                }];
            } failure:nil];
    }
    return cell;
}

- (void)storeImageInCache:(UIImage *)image keyForObject:(NSString *)key {
    [self.cache setObject:image forKey:key];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     ViewController *destVC = segue.destinationViewController;
     MovieCell *cell = sender;
     NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
     NSArray *movies;
     
     if (self.searchController.active) {
         movies = [[NSArray alloc] initWithArray:self.filteredMovies];
     } else {
         movies = [[NSArray alloc] initWithArray:self.movies];
     }
     destVC.movie = movies[indexPath.row];
 }


#pragma mark - Search content filtering

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    [self.filteredMovies removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@", searchText];
    self.filteredMovies = [NSMutableArray arrayWithArray:[self.movies filteredArrayUsingPredicate:predicate]];
}


#pragma mark - Search results updating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    [self filterContentForSearchText:searchText scope:nil];
    [self.tableView reloadData];
}


@end
