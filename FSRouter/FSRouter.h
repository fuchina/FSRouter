//
//  FSRouter.h
//  FSAccount
//
//  Created by FudonFuchina on 2019/5/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSRouter : NSProxy

+ (void)route:(NSString *)url completion:(nullable void(^)(BOOL parsed,NSDictionary *params))completion;

+ (void)routeClass:(NSString *)className params:(nullable NSDictionary *)params completion:(nullable void (^)(id vc))configBlockParam;

+ (void)setNavigationController:(UINavigationController *)controller;

+ (UIViewController *)currentVisibleController;

@end

NS_ASSUME_NONNULL_END
