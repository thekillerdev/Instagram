//
//  ViewController.m
//  Instagram
//
//  Created by Saulo Arruda Coelho on 7/23/12.
//  Copyright (c) 2012 Jera. All rights reserved.
//

#import "HomeViewController.h"
#import "Photo.h"
#import "PhotoCell.h"

@interface HomeViewController ()

- (IBAction)refreshButtonTapped:(id)sender;
@property (nonatomic, strong) NSArray* photosArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIView *instagramView;

@end

@implementation HomeViewController

@synthesize photosArray;
@synthesize refreshButton;
@synthesize loadingView;
@synthesize instagramView;

- (void)viewDidAppear:(BOOL)animated
{
    [self loadPhotos];
}

- (void)loadPhotos
{
    [self.refreshButton setEnabled:NO];
    [self.loadingView setHidden:NO];
    [self.instagramView setHidden:YES];
    [[Timeline sharedInstance] allPhotosWithDelegate:self];    
}

#pragma mark - Actions

- (IBAction)refreshButtonTapped:(id)sender {
    [self loadPhotos];
}


#pragma mark - TimelineLoadDelegate methods

- (void)timelineLoadFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Ocorreu um erro" message:@"Não foi possível carregar sua timeline" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Repetir", nil] show];
    [self.refreshButton setEnabled:YES];
    [self.loadingView setHidden:YES];
    [self.instagramView setHidden:NO];
}

- (void)timelineDidFinishLoad:(NSArray *)photos
{
    NSLog(@"Loaded photos: %@", photos);
    self.photosArray = photos;
    [self.tableView reloadData];
    [self.refreshButton setEnabled:YES];
    [self.loadingView setHidden:YES];
    [self.instagramView setHidden:NO];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
        [self loadPhotos];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.photosArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Photo* photo = [self.photosArray objectAtIndex:section];
    return photo.longDescription;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"photoCell"; 
    PhotoCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Photo* photo = [self.photosArray objectAtIndex:indexPath.section];
    [cell configureWithPhoto:photo];
    return cell;
}

- (void)viewDidUnload {
    [self setRefreshButton:nil];
    [self setLoadingView:nil];
    [self setInstagramView:nil];
    [super viewDidUnload];
}
@end
