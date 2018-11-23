//
//  ViewController.m
//  RishilFBDB
//
//  Created by Rishil-iMac on 22/11/18.
//  Copyright © 2018 Rishil Patel. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    __block NSMutableArray *arrDataList;
    IBOutlet UITextField *txtName;
    IBOutlet UIButton *btnAdd;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUI];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - initial level UI setup
-(void)initializeUI{
    self.title = @"FireBase Database";
    arrDataList = [[NSMutableArray alloc]init];
    [self removeSeprator:_tableDataList];
    self.tableDataList.delegate = self;
    self.tableDataList.dataSource = self;
    [self loadData];
}
#pragma mark - Laod data from FireStore DB
-(void)loadData{
    txtName.text = @"";
    [btnAdd setTitle:@"ADD" forState:UIControlStateNormal];
    [[[theAppDelegate db] collectionWithPath:COLLECTION_NAME]
     getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot,
                                  NSError * _Nullable error) {
         if (error != nil) {
             NSLog(@"Error getting documents: %@", error);
         } else {
             // get all data without sort
             // [self reloadTableWithData:snapshot.documents];
             NSMutableArray *arrTempData = [[NSMutableArray alloc]init];
             // Load database
             for (FIRDocumentSnapshot *document in snapshot.documents) {
                 if([document.data valueForKey:@"Name"]){
                     [arrTempData addObject:document];
                 }
             }
             [self reloadTableWithData:[arrTempData copy]];
         }
     }];
}
#pragma mark - Reload Table with FireStore loaded Data
-(void)reloadTableWithData:(NSArray *)arrData{
    [arrDataList removeAllObjects];
    [arrDataList addObjectsFromArray:arrData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableDataList reloadData];
    });
}

#pragma mark - ADD data in FireStore DB
-(void)addDataFB:(NSString *)strName{
    __block FIRDocumentReference *ref =
    [[[theAppDelegate db] collectionWithPath:COLLECTION_NAME] addDocumentWithData:@{
                                                                                    DATAFIELD_NAME : strName
                                                                                    } completion:^(NSError * _Nullable error) {
                                                                                        if (error != nil) {
                                                                                            NSLog(@"Error adding document: %@", error);
                                                                                        } else {
                                                                                            
                                                                                            NSLog(@"Document added with ID: %@", ref.documentID);
                                                                                            [self loadData];
                                                                                        }
                                                                                    }];
}


#pragma mark - UITableView Delegates & DataSources
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CellClass *cell = (CellClass *)[_tableDataList dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    FIRDocumentSnapshot* document = (FIRDocumentSnapshot *)[arrDataList objectAtIndex:indexPath.row];
    [cell setAccessibilityLabel:document.documentID];
    [cell.lblName setText:[self stringFromDict:document.data]];
    [cell.btnDelete setAccessibilityLabel:document.documentID];
    [cell.btnUpdate setAccessibilityLabel:document.documentID];
    [cell.btnUpdate setAccessibilityValue:[NSString stringWithFormat:@"%@",[self stringFromDict:document.data]]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrDataList.count;
}
#pragma mark - Entry in FireStore DB
-(IBAction)action_AddData:(UIButton *)sender{
    if([btnAdd.titleLabel.text isEqualToString:@"ADD"]){
        if([txtName.text isEqualToString:@""]){
            [self showAlertTitle:@"" withMessage:@"Please Enter Name" onView:self];
        }else{
            [self addDataFB:txtName.text];
        }
    }else{
        if([txtName.text isEqualToString:@""]){
            [btnAdd setTitle:@"ADD" forState:UIControlStateNormal];
            [self showAlertTitle:@"" withMessage:@"Please Enter Name" onView:self];
        }else{
            [self updateDocument:btnAdd.accessibilityLabel and:txtName.text];
        }
    }
    
    
}
#pragma mark - Remove Entry from FireStore DB
- (void)deleteField:(NSString *)strID{
    [[[[theAppDelegate db] collectionWithPath:COLLECTION_NAME] documentWithPath:strID]
     deleteDocumentWithCompletion:^(NSError * _Nullable error) {
         if (error != nil) {
             NSLog(@"Error removing document: %@", error);
         } else {
             NSLog(@"Document successfully removed!");
             [self loadData];
         }
     }];
    
}
-(IBAction)action_Delete:(UIButton*)sender{
    [self deleteField:sender.accessibilityLabel];
}
#pragma mark - Update Entry in FireStore DB
-(IBAction)action_Update:(UIButton*)sender{
    txtName.text = [NSString stringWithFormat:@"%@",sender.accessibilityValue];
    [btnAdd setTitle:@"UPDATE" forState:UIControlStateNormal];
    [btnAdd setAccessibilityLabel:sender.accessibilityLabel];
}
- (void)updateDocument:(NSString *)strID and:(NSString *)strValue{
    FIRDocumentReference *refDB =
    [[[theAppDelegate db] collectionWithPath:COLLECTION_NAME] documentWithPath:strID];
    [refDB updateData:@{
                        DATAFIELD_NAME : strValue
                        }];
    [self loadData];
}
#pragma mark - Refresh data - FireStore DB
-(IBAction)action_Refresh:(UIButton *)sender{
    [self loadData];
}

- (void)showAlertTitle:(NSString *)title withMessage:(NSString *)message onView:(UIViewController *)viewController
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   //Handel your yes please button action here
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
    
    [alert addAction:okButton];
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

-(NSString *)stringFromDict:(NSDictionary *)dictObject{
    return [dictObject valueForKey:DATAFIELD_NAME];
}
-(void)removeSeprator:(UITableView *)tableView{
    tableView.tableFooterView = [UIView new];
}

@end
