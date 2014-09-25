#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_EXTRA_HEIGHT (UIScreen mainScreen].bounds.size.height - 480.0f)
#define EXTRA_IOS7 (([[[UIDevice currentDevice] systemVersion] floatValue]>=7 && [[[UIDevice currentDevice] systemVersion] floatValue]<8)?20.0f:0.0f)

#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue]>=8?YES:NO)


#define RECT(x,y,width,height) (CGRectMake(x, y, width, height))
#define POINT(x,y) (CGPointMake(x, y))
#define SIZE(width,height) (CGSizeMake(width, height))


#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define IMAGENAMED(name) ([UIImage imageNamed:name])
#define FONTSIZE(number) ([UIFont fontWithName:@"Helvetica Neue" size:number])
#define FONTBOLDSIZE(number) ([UIFont boldSystemFontOfSize:number])


#define LOCAL_LANGUAGE(key) (NSLocalizedStringFromTable(key, @"InfoPlist", nil))

#ifdef DEBUG
#define MKLog( s, ... ) NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define MKLog( s, ... )
#endif




#define BASIC_YOUKU @"<html><head><div id=\"youkuplayer\"></div><script type=\"text/javascript\" src=\"http://player.youku.com/jsapi\">player= new YKU.Player('youkuplayer',{client_id:'04a4fa40c0634318',vid:'%@'});</script></head></html>"

#define BASIC_YOUKU_INNER @"<html><head><div id=\"youkuplayer\"></div><script type=\"text/javascript\" src=\"http://player.youku.com/jsapi\">player= new YKU.Player('youkuplayer',{client_id:'04a4fa40c0634318',vid:'%@',embsig:'%@'});</script></head></html>"


///////////////////////////////////////////////////////////////////////////////

//需手动填写

#define FILE_PATH(filename) ([[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]stringByAppendingPathComponent:filename])


#define DB_FILENAME @"X.db"

#define UMENG @""

#define SEARCH_USERDEFAULT @"searchForUserDefault"

#define COLLECT_USERDEFAULT @"collectForUserDefault"

#define HISTORY_USERDEFAULT @"historyForUserDefault"

#define READ_USERDEFAULT @"readForUserDefault"


#define HOST @"http://app.hbook.us"

#define DEFAULT_ICON @""
#define DEFAULT_BANNER @""
#define DEFAULT_USERICON @""

#define BUNDLE_ID @""


#define TABBAR_SELECT @"tabbarDidSelectViewController"

///////////////////////////////////////////////////////////////////////////////



typedef enum {
    SHARE_BUTTON_EMAIL = 110007,
    SHARE_BUTTON_WEIXIN = 110000,
    SHARE_BUTTON_WX_FRIEND= 110001,
    SHARE_BUTTON_WEIBO= 110002,
    SHARE_BUTTON_QQ= 110003,
}SHARE_BUTTON_TAG;



typedef enum {
    NETWORK_TYPE_NONE= 0,
    NETWORK_TYPE_WIFI= 1,
    NETWORK_TYPE_2G= 2,
    NETWORK_TYPE_3G= 3,
}NETWORK_TYPE;

typedef enum {
    POST_TYPE_TABLE = 0,
    POST_TYPE_FILE = 1,
}POST_TYPE;




