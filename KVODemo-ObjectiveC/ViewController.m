//
//  ViewController.m
//  KVODemo-ObjectiveC
//
//  Created by derekcoder on 19/4/20.
//  Copyright © 2020 derekcoder. All rights reserved.
//

#import "ViewController.h"
#import "Foo.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  Foo *foo1 = [[Foo alloc] init];
  Foo *foo2 = [[Foo alloc] init];
  [foo2 addObserver:self
         forKeyPath:@"age"
            options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
            context:nil];
  
  [self printDescriptionWithName:@"foo1" object:foo1];
  [self printDescriptionWithName:@"foo2" object:foo2];
  
  //  IMP m1 = [foo1 methodForSelector:@selector(setAge:)];
  //  IMP m2 = [foo2 methodForSelector:@selector(setAge:)];
}

- (void)printDescriptionWithName:(NSString *)name object:(id)obj {
  NSLog(@"%@: %@", name, obj);
  NSLog(@"\tisa 指向的类：%@", object_getClass(obj));
  NSLog(@"\t类名：%s", class_getName([obj class]));
  NSLog(@"\t方法列表：<%@>", [[self classMethodNames:object_getClass(obj)] componentsJoinedByString:@", "]);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
  if ([keyPath isEqualToString:@"age"]) {
    NSLog(@"age: %@", change);
  }
}

- (NSArray *)classMethodNames:(Class)cls {
  NSMutableArray *array = [NSMutableArray array];
  
  unsigned int count;
  Method *methods = class_copyMethodList(cls, &count);
  for (int i = 0; i < count; i++) {
    Method method = methods[i];
    NSString *methodName = NSStringFromSelector(method_getName(method));
    [array addObject:methodName];
  }
  free(methods);
  
  return [array copy];
}

@end
