//
//  ViewController.m
//  PDFBrowserObjC
//
//  Created by Abbie on 01/09/20.
//  Copyright © 2020 Abbie. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ViewMyPDFViewController.h"
#import "base65ViewController.h"

@interface ViewController ()<UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)buttonAction:(id)sender {
    
    NSArray *types = @[(NSString*)kUTTypePDF];
    //Create a object of document picker view and set the mode to Import
    UIDocumentPickerViewController *docPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeImport];
    //Set the delegate
    docPicker.delegate = self;
    //present the document picker
    [self presentViewController:docPicker animated:YES completion:nil];
}
#pragma mark Delegate-UIDocumentPickerViewController

/**
 *  This delegate method is called when user will either upload or download the file.
 *
 *  @param controller UIDocumentPickerViewController object
 *  @param url        url of the file
 */

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    if (controller.documentPickerMode == UIDocumentPickerModeImport)
    {
        NSString *urlString = [url absoluteString];
        // Condition called when user download the file
//        NSData *fileData = [NSData dataWithContentsOfURL:url];
//        NSLog(@"fileData %@", fileData);
        NSLog(@"%@", url);
       // NSURL *URL = [NSURL URLWithString:@"http://www.google.com"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"HEAD"];
     //   NSHTTPURLResponse *response;
       [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
       long long size = [response expectedContentLength];
       NSLog(@"File Size%lld",size);
        
        }] resume];
        NSData *fileData = [NSData dataWithContentsOfURL:url];
      //  NSString *pdfBaseString = [fileData base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
        NSString *pdfBaseString = [fileData base64EncodedStringWithOptions:0];
        NSLog(@"Base 64 sting%@", pdfBaseString);
        NSLog(@"Byte Length%@", [[NSByteCountFormatter new] stringFromByteCount:fileData.length]);
        long long filedata2 = fileData.length;
        NSLog(@"File 2Size%lld",filedata2);
        NSString *twoMB = [[NSByteCountFormatter new] stringFromByteCount:fileData.length];
        NSString *allowedmem = @"2 MB";
        if (filedata2 > 2097152 ) {
            NSLog(@"Greater than 2 MB");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"PDF file should be less than 2 MB" preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    //button click event
                                }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
//        ViewMyPDFViewController *webview = [[ViewMyPDFViewController alloc]init];
//        webview.productURL = url;
//        [self presentViewController:webview animated:YES completion:nil];
        
//        base65ViewController *webview = [[base65ViewController alloc]init];
//        webview.base64String = pdfBaseString;
      //  webview.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self.navigationController pushViewController:webview animated:YES];
            
            UIDocumentInteractionController *documentInteractionController =[UIDocumentInteractionController interactionControllerWithURL:url];
            documentInteractionController.delegate = self;
            [documentInteractionController presentPreviewAnimated:YES];
        }
    }
    
}

/**
 *  Delegate called when user cancel the document picker
 *
 *  @param controller - document picker object
 */
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
