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
        
        /** /!\ /!\ /!\
         *  WARNING: Don't use this PID (54934) in production. Contact your Publisher Manager to obtain your own dedicated PID
         *  /!\ /!\ /!\
         */
        textField.placeholder = @"54934";
        if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"pid"] isEqual:@"54934"]) {
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
                                 /** /!\ /!\ /!\
                                  *  WARNING: Don't use this PID (54934) in production. Contact your Publisher Manager to obtain your own dedicated PID
                                  *  /!\ /!\ /!\
                                  */
                                 [[NSUserDefaults standardUserDefaults] setObject:@"54934" forKey:@"pid"];;
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
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.placeholder = @"DOM selector (empty = auto fin slot)";
        if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"placeholderText"] isEqual:@""]) {
            textField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"placeholderText"];
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
                                 [[NSUserDefaults standardUserDefaults] setObject:typedUrl forKey:@"website"];
                                 
                                 [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"placeholderText"];
                                 
                             } else {
                                 [[NSUserDefaults standardUserDefaults] setObject:@"Default demo website" forKey:@"website"];
                                 
                                 if (![alert.textFields[1].text isEqualToString:@""]) {
                                     [[NSUserDefaults standardUserDefaults] setObject:alert.textFields[1].text forKey:@"placeholderText"];
                                 } else {
                                     [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"placeholderText"];
                                 }
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
