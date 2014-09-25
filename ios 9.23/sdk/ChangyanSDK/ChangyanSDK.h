/////////////////////////////////////////////////////////////////////////////////////////////////////
//                                        使用声明                                                  //
//                                 1、可选参数不填赋值nil                                             //
//                                 2、所有参数为NSString类型（completeBlock除外）                      //
/////////////////////////////////////////////////////////////////////////////////////////////////////

typedef enum  CYStatusCode
{
    CYSuccess           = 0,    /* 成功 */
    CYParamsError       = 1,    /* 参数错误 */
    CYLoginError        = 2,    /* 登录错误 */
    CYOtherError        = 3,    /* 其他错误 */
    
}CYStatusCode;

typedef void (^CompleteBlock)(CYStatusCode statusCode,NSString *responseStr);

#define kChangyanSDKAppLoginNotification @"kChangyanSDKAppLoginNotification"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IsvUserInfo : NSObject

@property (nonatomic,strong) NSString *isvUserID; //单点登录UserID（单点登录必须）
@property (nonatomic,strong) NSString *nickName;  //用户昵称      （单点登录必须）
@property (nonatomic,strong) NSString *profieUrl; //用户主页
@property (nonatomic,strong) NSString *imgUrl;    //用户头像

@end

@interface ChangyanSDK : NSObject

/*
 *  功能 : 注册应用
 */
+ (BOOL)registerApp:(NSString *)appKey;

//-----------------------------------界面形式的畅言接口--------------------------------------//

/*
 *  功能 : 获取畅言PostCommentButton
 *  参数 :
 *        fame                     :Tool大小和位置
 *        target                   :(必须)
 *        conf                     :(必须)
 *        topicSourceID            :(必须)
 *        topicTitle               :(必须)
 *        isvUserInfo              :(单点登录用户信息)
 *        appSecret                :(单点登录 必须)
 *        showScore                :是否显示评分
 *        anonymous                :是否允许游客登录
 *        uploadImg                :是否允许上传图片
 *        allowAppAccountLogin     :是否允许第三方客户端登录(以下三个参数同时填写)
 *        loginIconUrl             :WebView内显示的第三方客户端登录图标
 *        loginViewController      :显示的客户端登陆界面
 *  返回 : UIView
 */
+ (UIView *)getChangYanPostCommentButton:(CGRect)frame
                                  target:(UIViewController *)viewController
                                    conf:(NSString *)conf
                           topicSourceID:(NSString *)topicSourceID
                              topicTitle:(NSString *)topicTitle
                             isvUserInfo:(IsvUserInfo *)isvUserInfo
                               appSecret:(NSString *)appSecret
                               showScore:(BOOL)showScore
                               anonymous:(BOOL)anonymous
                               uploadImg:(BOOL)uploadImg
                    allowAppAccountLogin:(BOOL)allowAppAccountLogin
                            loginIconUrl:(NSString *)loginIconUrl
                     loginViewController:(UIViewController *)loginViewController;
/*
 *  功能 : 获取畅言ListCommentButton
 *  参数 :
 *        fame                     :Tool大小和位置
 *        target                   :(必须)
 *        conf                     :(必须)
 *        topicSourceID            :(必须)
 *        topicTitle               :(必须)
 *        isvUserInfo              :(单点登录用户信息)
 *        appSecret                :(单点登录 必须)
 *        showScore                :是否显示评分
 *        anonymous                :是否允许游客登录
 *        uploadImg                :是否允许上传图片
 *        allowAppAccountLogin     :是否允许第三方客户端登录(以下三个参数同时填写)
 *        loginIconUrl             :WebView内显示的第三方客户端登录图标
 *        loginViewController      :显示的客户端登陆界面
 *  返回 : UIView
 */
+ (UIView *)getChangYanListCommentButton:(CGRect)frame
                                  target:(UIViewController *)viewController
                                    conf:(NSString *)conf
                           topicSourceID:(NSString *)topicSourceID
                              topicTitle:(NSString *)topicTitle
                             isvUserInfo:(IsvUserInfo *)isvUserInfo
                               appSecret:(NSString *)appSecret
                               showScore:(BOOL)showScore
                               anonymous:(BOOL)anonymous
                               uploadImg:(BOOL)uploadImg
                    allowAppAccountLogin:(BOOL)allowAppAccountLogin
                            loginIconUrl:(NSString *)loginIconUrl
                     loginViewController:(UIViewController *)loginViewController;
/*
 *  功能 : 获取畅言ToolBar 并 直接登录
 *  参数 :
 *        fame                     :Tool大小和位置
 *        target                   :(必须)
 *        conf                     :(必须)
 *        topicSourceID            :(必须)
 *        topicTitle               :(必须)
 *        appSecret                :(单点登录 必须)
 *        showScore                :是否显示评分
 *        anonymous                :是否允许游客登录
 *        uploadImg                :是否允许上传图片
 *        isvUserInfo              :(单点登录用户信息)
 *  返回 : UIView
 */
+ (UIView *)getChangYanToolBar:(CGRect)frame
                        target:(UIViewController *)viewController
                          conf:(NSString *)conf
                 topicSourceID:(NSString *)topicSourceID
                    topicTitle:(NSString *)topicTitle
                     appSecret:(NSString *)appSecret
                     showScore:(BOOL)showScore
                     anonymous:(BOOL)anonymous
                     uploadImg:(BOOL)uploadImg
                   isvUserInfo:(IsvUserInfo *)isvUserInfo;
/*
 *  功能 : 获取畅言ToolBar 并 应用内登录
 *  参数 :
 *        fame                     :Tool大小和位置
 *        target                   :(必须)
 *        conf                     :(必须)
 *        topicSourceID            :(必须)
 *        topicTitle               :(必须)
 *        isvUserInfo              :(单点登录用户信息)
 *        appSecret                :(单点登录 必须)
 *        showScore                :是否显示评分
 *        anonymous                :是否允许游客登录
 *        uploadImg                :是否允许上传图片
 *        allowAppAccountLogin     :是否允许第三方客户端登录(以下三个参数同时填写)
 *        loginIconUrl             :WebView内显示的第三方客户端登录图标
 *        loginViewController      :显示的客户端登陆界面
 *  返回 : UIView
 */
+ (UIView *)getChangYanToolBar:(CGRect)frame
                        target:(UIViewController *)viewController
                          conf:(NSString *)conf
                 topicSourceID:(NSString *)topicSourceID
                    topicTitle:(NSString *)topicTitle
                     appSecret:(NSString *)appSecret
                     showScore:(BOOL)showScore
                     anonymous:(BOOL)anonymous
                     uploadImg:(BOOL)uploadImg
          allowAppAccountLogin:(BOOL)allowAppAccountLogin
                  loginIconUrl:(NSString *)loginIconUrl
           loginViewController:(UIViewController *)loginViewController;
/*
 *  功能 : 获取畅言ToolBar
 *  参数 : 
 *        fame                     :Tool大小和位置
 *        target                   :(必须)
 *        conf                     :(必须)
 *        topicSourceID            :(必须)
 *        topicTitle               :(必须)
 *        isvUserInfo              :(单点登录用户信息)
 *        appSecret                :(单点登录 必须)
 *        showScore                :是否显示评分
 *        anonymous                :是否允许游客登录
 *        uploadImg                :是否允许上传图片
 *        allowAppAccountLogin     :是否允许第三方客户端登录(以下三个参数同时填写)
 *        loginIconUrl             :WebView内显示的第三方客户端登录图标
 *        loginViewController      :显示的客户端登陆界面
 *  返回 : UIView
 */
+ (UIView *)getChangYanToolBar:(CGRect)frame
                        target:(UIViewController *)viewController
                          conf:(NSString *)conf
                 topicSourceID:(NSString *)topicSourceID
                    topicTitle:(NSString *)topicTitle
                   isvUserInfo:(IsvUserInfo *)isvUserInfo
                     appSecret:(NSString *)appSecret
                     showScore:(BOOL)showScore
                     anonymous:(BOOL)anonymous
                     uploadImg:(BOOL)uploadImg
          allowAppAccountLogin:(BOOL)allowAppAccountLogin
                  loginIconUrl:(NSString *)loginIconUrl
           loginViewController:(UIViewController *)loginViewController;


//------------------------------------无需登陆的数据接口--------------------------------------//
/*
 *  功能 : 获取文章
 *  参数 : 
 *        topicURL      : (必须)
 *        topicTitle    : (可填)
 *        topicSourceID : (可填)
 *        pageSize      : (可填,默认为0)
 *        hotSize       : (可填,默认为0)
 *        completeBlock : 回调
 *  返回 : 无
 */
+ (void)loadTopic:(NSString *)topicUrl
       topicTitle:(NSString *)topicTitle
    topicSourceID:(NSString *)topicSourceID
         pageSize:(NSString *)pageSize
          hotSize:(NSString *)hotSize
    completeBlock:(CompleteBlock)completeBlock;

/*
 *  功能 : 获取评论数
 *  参数 : 
 *        topicUrl       : (三个必须提供一个)
 *        topicSourceID  : (三个必须提供一个)
 *        topicID        : (三个必须提供一个)
 *        completeBlock  : 回调
 *  返回 : 无
 */
+ (void)getCommentCountTopicUrl:(NSString *)topicUrl
                  topicSourceID:(NSString *)topicSourceID
                        topicID:(NSString *)topicID
                completeBlock:(CompleteBlock)completeBlock;

/*
 *  功能 : 获取文章评论列表
 *  参数 : 
 *        topicID       : (必须)
 *        pageSize      : (可填,默认30)
 *        pageNo        : (可填,默认1)
 *        completeBlock : 回调
 *  返回 : 无
 */
+ (void)getTopicComments:(NSString *)topicID
                pageSize:(NSString *)pageSize
                  pageNo:(NSString *)pageNo
           completeBlock:(CompleteBlock)completeBlock;

/*
 *  功能 : 顶或者踩某条评论
 *  参数 : 
 *        actionType    : (必须) 1:顶 2:踩
 *        topicID       : 文章ID(必须)
 *        commentID     : 评论ID(必须)
 *        completeBlock : 回调
 *  返回 : 无
 */
+ (void)commentAction:(NSInteger)actionType
              topicID:(NSString *)topicID
            commentID:(NSString *)commentID
        completeBlock:(CompleteBlock)completeBlock;

/*
 *  功能 : 获取Topic某个comment的回复列表
 *  参数 : 
 *        topicID       : 文章ID(必须)
 *        commentID     : 评论ID(必须)
 *        pageSize      : (可填,默认30)
 *        pageNo        : (可填,默认1)
 *        completeBlock : 回调
 *  返回 : 无
 */
+ (void)commentReplies:(NSString *)topicID
             commentID:(NSString *)commentID
              pageSize:(NSString *)pageSize
                pageNo:(NSString *)pageNo
         completeBlock:(CompleteBlock)completeBlock;

/*
 *  功能 : 获取topic的平均分
 *  参数 :
 *        topicID        : 畅言新闻id(三个必须提供一个)
 *        topicSourceID  : 新闻在本网站中的id(三个必须提供一个)
 *        topicUrl       : 新闻url(三个必须提供一个)
 *        simple         : 是否查询所有带有评分的评论，true：不查询，false：查询
 *        completeBlock  : 回调
 *  返回 : 无
 */
+ (void)getTopicAverageScore:(NSString *)topicID
               topicSourceID:(NSString *)topicSourceID
                    topicUrl:(NSString *)topicUrl
                      simple:(BOOL)simple
               completeBlock:(CompleteBlock)completeBlock;

/*
 *  功能 : 获取topic最新评分评论
 *  参数 :
 *        topicID        : 畅言新闻id(三个必须提供一个)
 *        topicSourceID  : 新闻在本网站中的id(三个必须提供一个)
 *        topicUrl       : 新闻url(三个必须提供一个)
 *        count          : 评论数 默认 5
 *        completeBlock  : 回调
 *  返回 : 无
 */
+ (void)getTopicScoreComments:(NSString *)topicID
                topicSourceID:(NSString *)topicSourceID
                     topicUrl:(NSString *)topicUrl
                        count:(NSInteger )count
                completeBlock:(CompleteBlock)completeBlock;

/*
 *  功能 : 匿名发表评论
 *  参数 :
 *        topicID       : 要评论的话题ID(必须)
 *        content       : 评论内容(必须)
 *        accessToken   : 自己定义的匿名Token(必须)
 *        replyID       : (可填)
 *        score         : 评分（默认0分）
 *        appType       : 40:iPhone 41:iPad 42:Android
 *        picUrls       : 附带图片URL数组
 *        completeBlock : 回调
 *  返回 : 无
 */
+ (void)anonymousSubmitComment:(NSString *)topicID
                       content:(NSString *)content
                   accessToken:(NSString *)accessToken
                       replyID:(NSString *)replyID
                         score:(NSString *)score
                       appType:(NSInteger )appType
                       picUrls:(NSArray *)picUrls
                 completeBlock:(CompleteBlock)completeBlock;

//------------------------------------------登陆接口---------------------------------------------//
/*
 *  功能 : 判断用户是否登录或者登陆是否过期
 *  参数 : 无
 *  返回 : YES:登录 NO:未登陆
 */
+ (BOOL)isLogin;

/*
 *  功能 : 登出
 *  参数 : 无
 *  返回 : 无
 */
+ (void)logout;

/*
 *  功能 : Oauth2登录
 *  参数 : 
 *        appSecret     : (必须)
 *        redirectURI   : (必须)
 *        platform      : 2:新浪 3:QQ 11:搜狐 //0:游客、第三方
 *        completeBlock : 回调
 *  返回 : 无
 */
+ (void)authorize:(NSString *)appSecret
      redirectURI:(NSString *)uri
         platform:(NSInteger)platform
    completeBlock:(CompleteBlock)completeBlock;

/*
 *  功能 : 单点登录
 *  参数 : 
 *        isvUserID     : isv用户ID (必须)
 *        nickName      : isv用户名 (必须)
 *        profileUrl    : isv用户个人主页
 *        imgUrl        : isv用户头像
 *        completeBlock : 回调
 *  返回 : 无
 */
+ (void)loginWithIsv:(NSString *)isvUserID
            userName:(NSString *)nickName
          profileUrl:(NSString *)profileUrl
              imgUrl:(NSString *)imgUrl
           appSecret:(NSString *)appSecret
       completeBlock:(CompleteBlock)completeBlock;

//------------------------------------------需要登陆数据接口---------------------------------------------//
/*
 *  功能 : 提交评论或者回复某条评论
 *  参数 : 
 *        topicID       : 要评论的话题ID(必须)
 *        content       : 评论内容(必须)
 *        replyID       : (可填)
 *        score         : 评分（默认0分）
 *        appType       : 40:iPhone 41:iPad 42:Android
 *        picUrls       : 附带图片URL数组
 *        completeBlock : 回调
 *  返回 : 无
 */
+ (void)submitCommentTopic:(NSString *)topicID
                   content:(NSString *)content
                   replyID:(NSString *)replyID
                     score:(NSString *)score
                   appType:(NSInteger )appType
                   picUrls:(NSArray *)picUrls
             completeBlock:(CompleteBlock)completeBlock;

/*
 *  功能 : 上传评论的附属文件，应该是图片（需要登录）
 *  参数 : 
 *        fileData      : 上传文件的二进制数据
 *        completeBlock : 回调
 *  返回 : 无
 */
+ (void)attachUpload:(NSData *)fileData
       completeBlock:(CompleteBlock)completeBlock;

/*
 *  功能 : 获取用户信息（需要登录）
 *  参数 : completeBlock : 回调
 *  返回 : 无
 */
+ (void)getUserInfoCompleteBlock:(CompleteBlock)completeBlock;

/*
 *  功能 : 获取用户信息（需要登录）
 *  参数 : 
 *        pageSize       : (可填,默认30)
 *        pageNo         : (可填,默认1)
 *        completeBlock  : 回调
 *  返回 : 无
 */
+ (void)getUserNewReplyPageSize:(NSString *)pageSize
                         pageNo:(NSString *)pageNo
                  completeBlock:(CompleteBlock)completeBlock;
@end
