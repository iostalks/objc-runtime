//
//  main.m
//  debug-objc
//
//  Created by Closure on 2018/12/4.
//

#import <Foundation/Foundation.h>
//#import "objc-runtime.h"
#import <objc/runtime.h>
#import <mach-o/loader.h>

@interface FKBar : NSObject
@end

@implementation FKBar
- (void)lazyLoadClass {
}
@end

@interface FKFather: NSObject
@end

@implementation FKFather
- (void)lazyLoadClass {
    
}
@end

void barLoad() {
    NSLog(@"123");
}

NSString* binaryWithInteger(NSUInteger decInt) {
    NSString *string = @"";
    NSUInteger x = decInt;
    while (x > 0) {
        string = [[NSString stringWithFormat:@"%lu", x & 1] stringByAppendingString:string];
       x = x >> 1;
    }
    return string;
}

NSString *nameGetter(id self, SEL sel) {
    Ivar ivar = class_getInstanceVariable(NSClassFromString(@"FKSonObject"), "_name");
    return object_getIvar(self, ivar);
}

void nameSetter(id self, SEL sel, NSString *nName) {
    Ivar ivar = class_getInstanceVariable(NSClassFromString(@"FKSonObject"), "_name");
    id old = object_getIvar(self, ivar);
    if (old != nName) {
        object_setIvar(self, ivar, nName);
    }
}


// 会在 main 函数之前调用
__attribute__((constructor)) void beforeFunction()
{
    printf("beforeFunction\n");
}

void loadImageFunc(const struct mach_header * _Nonnull header) {
    printf("load image func: %d\n", header->filetype);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        
        NSLog(@"main");
//        FKSon *p = [[FKSon alloc] init];
//        [p hello];
        
        // 10001110
        // 11111000 - 1 = 11110111 = 10001000
        // 00001000
        // -8
        // 10001000 // 原码
        // 11110111 // 反码
        // 11111000 // 补码

        // 248 8
//        FKBar *bar = [FKBar new];
//        ((void(*)(id, SEL))(objc_msgSend))(bar, @selector(hello));

        
//        ((void(*)(id, SEL))_objc_msgForward)(p, @selector(howAreYou));

//        [p hello];
//
//        [p hello];
        
//        struct objc_object *strP = (__bridge struct objc_object *)p;
//        NSLog(@"%@", binaryWithInteger(strP->isa));
//        NSLog(@"%@", binaryWithInteger((uintptr_t)[FKPerson class]));
//                  |has_sidetable_rc|deallocating|weakly_referenced|magic|shiftcls|has_cxx_dtor|has_assoc|nonpointer
//         11101100 0 0 0 000000 000100000000000000000010000100101 001 // obj isa
//                               000100000000000000000010000100101 000 // class pointer
        
        // New Class
        
        // 实例变量的大小是如何设置的？？
#if 0
        Class FKObject = objc_allocateClassPair([NSObject class], "FKObject", 0);
//        class_addMethod(FKObject, @selector(hi), hi, "v@:");
        class_addIvar(FKObject, "_age", sizeof(int), rint(log2(sizeof(int))), @encode(int));
        objc_registerClassPair(FKObject);
        
        Class FKSonObject = objc_allocateClassPair(FKObject, "FKSonObject", 0);
        class_addIvar(FKSonObject, "_name", sizeof(NSString *), rint(log2(sizeof(NSString *))), @encode(NSString *));
        objc_registerClassPair(FKSonObject);
        
        objc_property_attribute_t type = {"T", "@\"String\""};
        objc_property_attribute_t backingvar = { "V", "_name" };
        objc_property_attribute_t attrs[] = { type, backingvar };
        class_addProperty(FKSonObject, "name", attrs, 2);
        
        class_addMethod(FKSonObject, @selector(name), (IMP)nameGetter, "@@:");
        class_addMethod(FKSonObject, @selector(setName:), (IMP)nameSetter, "@@:");
        
        id son = [[FKSonObject alloc] init];
        [son performSelector:@selector(setName:) withObject:@"jiangxiaofei"];
        id n = [son performSelector:@selector(name)];
        NSLog(@"name: %@", n);

#endif
        
// Category with assocition object
#if 0
        FKFather *father = [FKFather new];
        father.name = @"Smallfly";
        NSString *s = father.name;
        NSLog(@"%@", s);
#endif

#if 0
        NSString *s = @"Smallfly";
        NSString *p = [s stringByAppendingString:@"-Append"];
        struct objc_object *strP = (__bridge struct objc_object *)p;
        NSLog(@"%@", binaryWithInteger(strP->isa)); // 111111111111111 1000 1110 1111 0001 1101 0100 1110 0000
#endif
    

#if 0
        NSMutableArray __weak *array = nil;
        if (1) {
            NSMutableArray *innerArray = [NSMutableArray array];
            [innerArray addObject:[NSObject new]];
            array = innerArray;
        }
        NSLog(@"%@", array);
        NSLog(@"%@", array);
        NSLog(@"%@", array);
        NSLog(@"%@", array);
#endif

    }
    return 0;
}

