//
//  DemoUtils.m
//  TeadsSDKDemo
//
//  Created by Nikolaï Roycourt on 17/11/2015.
//  Copyright © 2015 Teads. All rights reserved.
//

#import "DemoUtils.h"

@implementation DemoUtils

+(void)presentControllerToChangePid:(id)controller {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Set a custom PID"
                                  message:@"Enter PID. Leave empty to reset to default"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.placeholder = @"27695";
        if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"pid"] isEqual:@"27695"]) {
            textField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"pid"];
        }
    }];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             if (![alert.textFields.firstObject.text isEqual:@""]) {
                                 [[NSUserDefaults standardUserDefaults] setObject:alert.textFields.firstObject.text forKey:@"pid"];;
                             } else {
                                 [[NSUserDefaults standardUserDefaults] setObject:@"27695" forKey:@"pid"];;
                             }
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [controller presentViewController:alert animated:YES completion:nil];
}

+(void)presentControllerToChangeWebsite:(id)controller {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Set a custom website"
                                  message:@"Enter url. Leave empty to reset to default"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.placeholder = @"Default demo website";
        if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"website"] isEqual:@"Default demo website"]) {
            textField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"website"];
        }
        
    }];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             if (![alert.textFields.firstObject.text isEqual:@""]) {
                                 NSString *typedUrl = [alert.textFields.firstObject.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                 
                                 if (![typedUrl.lowercaseString hasPrefix:@"http://"] && ![typedUrl.lowercaseString hasPrefix:@"https://"]) {
                                     typedUrl = [NSString stringWithFormat:@"http://%@", typedUrl];
                                 }
                                 [[NSUserDefaults standardUserDefaults] setObject:typedUrl forKey:@"website"];;
                             } else {
                                 [[NSUserDefaults standardUserDefaults] setObject:@"Default demo website" forKey:@"website"];;
                             }
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [controller presentViewController:alert animated:YES completion:nil];
}


@end
