//
//  FSRouter.m
//  FSAccount
//
//  Created by FudonFuchina on 2019/5/25.
//

#import "FSRouter.h"
#import "FSRuntime.h"

@implementation FSRouter

+ (void)route:(NSString *)url completion:(nullable void(^)(BOOL parsed,NSDictionary *params))completion{
    BOOL parsed = YES;
    if (!([url isKindOfClass:NSString.class] && url.length)) {
        parsed = NO;
    }
    NSURL *u = [NSURL URLWithString:url];
    if (!u) {
        parsed = NO;
    }
    NSDictionary *param = [self parameterWithURL:u];
    if (completion) {
        completion(parsed,param);
    }
}

+ (void)routeClass:(NSString *)className params:(nullable NSDictionary *)params completion:(nullable void (^)(id vc))configBlockParam{
    dispatch_async(dispatch_get_main_queue(), ^{
        Class Controller = NSClassFromString(className);
        if (Controller) {
            UIViewController *viewController = [[Controller alloc] init];
            for (NSString *key in params) {
                SEL setSEL = [FSRuntime setterSELWithAttibuteName:key];
                if ([viewController respondsToSelector:setSEL]) {
                    [viewController performSelector:setSEL onThread:[NSThread currentThread] withObject:[params objectForKey:key] waitUntilDone:YES];
                }
            }
            
            if (configBlockParam) {
                configBlockParam(viewController);
            }
            
            UIViewController *visibleController = self.currentVisibleController;
            if (visibleController.navigationController) {
                [visibleController.navigationController pushViewController:viewController animated:YES];
            }else{
                NSAssert(_navigationController, @"未设置导航控制器");
                [_navigationController pushViewController:viewController animated:YES];
            }
        }
    });
}

static UINavigationController *_navigationController;
+ (void)setNavigationController:(UINavigationController *)controller{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAssert([controller isKindOfClass:UINavigationController.class], @"FSRouter：非导航控制器");
        _navigationController = controller;
    });
}

+ (UIViewController *)currentVisibleController{
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    UIViewController *currentViewController = window.rootViewController;
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                currentViewController = currentViewController.childViewControllers.lastObject;
                return currentViewController;
            } else {
                return currentViewController;
            }
        }
    }
    return currentViewController;
}

+ (NSDictionary *)parameterWithURL:(NSURL *)url {
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setValue:obj.value forKey:obj.name];
    }];
    return parm;
}

@end
