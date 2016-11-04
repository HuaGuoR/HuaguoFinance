
//判断是否为iphone5的宏
#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)

//日志输出宏定义
#ifdef DEBUG
//调试状态
#define MyLog(...) NSLog(__VA_ARGS__)
#else
//发布状态
#define MyLog(...)

#endif

#define iOS7 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)

#define iOS6 (([[[UIDevice currentDevice]systemVersion] floatValue] >= 6.0)&&([[[UIDevice currentDevice]systemVersion] floatValue] < 7.0))

// 获得RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

// 去除滚动条
#pragma mark 重写这个方法的目的。去掉父类默认的操作：显示滚动条
#define kHideScroll - (void)viewDidAppear:(BOOL)animated { }


//单例宏

// .h
#define single_interface(class)  + (class *)shared##class;

// .m
// \ 代表下一行也属于宏
// ## 是分隔符
#define single_implementation(class) \
static class *_instance; \
\
+ (class *)shared##class \
{ \
if (_instance == nil) { \
_instance = [[self alloc] init]; \
} \
return _instance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
}



