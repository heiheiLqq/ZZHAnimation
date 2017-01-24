# ZZHAnimation
一个关于iOS图层配合核心动画使用的Demo
##Core Animation
- Core Animation，中文翻译为核心动画，它是一组非常强大的动画处理API，使用它能做出非常炫丽的动画效果，而且往往是事半功倍。也就是说，使用少量的代码就可以实现非常强大的功能。
-  Core Animation可以用在Mac OS X和iOS平台。
-  Core Animation的动画执行过程都是在后台操作的，不会阻塞主线程。
-  要注意的是，Core Animation是直接作用在CALayer上的，并非UIView。

## Core Animation的使用步骤
- 1.首先得有CALayer
- 2.初始化一个CAAnimation对象，并设置一些动画相关属性
- 3.通过调用CALayer的addAnimation:forKey:方法，增加CAAnimation对象到CALayer中，这样就能开始执行动画了
- 4.通过调用CALayer的removeAnimationForKey:方法可以停止CALayer中的动画

##CAAnimation
- 是所有动画对象的父类，负责控制动画的持续时间和速度，是个抽象类，不能直接使用，应该使用它具体的子类
- 属性说明：
   - duration：动画的持续时间
   - repeatCount：重复次数，无限循环可以设置HUGE_VALF或者MAXFLOAT

  - repeatDuration：重复时间
  - removedOnCompletion：默认为YES，代表动画执行完毕后就从图层上移除，图形会恢复到动画执行前的状态。如果想让图层保持显示动画执行后的状态，那就设置为NO，不过还要设置fillMode为kCAFillModeForwards
 - fillMode：决定当前对象在非active时间段的行为。比如动画开始之前或者动画结束之后（要想fillMode有效，最好设置removedOnCompletion = NO）
   - kCAFillModeRemoved 这个是默认值，也就是说当动画开始前和动画结束后，动画对layer都没有影响，动画结束后，layer会恢复到之前的状态
   - kCAFillModeForwards 当动画结束后，layer会一直保持着动画最后的状态 
   - kCAFillModeBackwards 在动画开始前，只需要将动画加入了一个layer，layer便立即进入动画的初始状态并等待动画开始。
   - kCAFillModeBoth 这个其实就是上面两个的合成.动画加入后开始之前，layer便处于动画初始状态，动画结束后layer保持动画最后的状态

 - beginTime：可以用来设置动画延迟执行时间，若想延迟2s，就设置为CACurrentMediaTime()+2，CACurrentMediaTime()为图层的当前时间
 - timingFunction：速度控制函数，控制动画运行的节奏
   - kCAMediaTimingFunctionLinear（线性）：匀速，给你一个相对静态的感觉
   - kCAMediaTimingFunctionEaseIn（渐进）：动画缓慢进入，然后加速离开
   - kCAMediaTimingFunctionEaseOut（渐出）：动画全速进入，然后减速的到达目的地
   - kCAMediaTimingFunctionEaseInEaseOut（渐进渐出）：动画缓慢的进入，中间加速，然后减速的到达目的地。这个是默认的动画行为。

 - delegate：动画代理（监听动画开始和结束的状态）
  ```
-(void)animationDidStart:(CAAnimation *)anim;
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
```

- CALayer上动画的暂停和恢复
```
#pragma mark 暂停CALayer的动画
-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];

    // 让CALayer的时间停止走动
      layer.speed = 0.0;
    // 让CALayer的时间停留在pausedTime这个时刻
    layer.timeOffset = pausedTime;
}
```
- CALayer上动画的恢复
```
#pragma mark 恢复CALayer的动画
-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = layer.timeOffset;
    // 1. 让CALayer的时间继续行走
      layer.speed = 1.0;
    // 2. 取消上次记录的停留时刻
      layer.timeOffset = 0.0;
    // 3. 取消上次设置的时间
      layer.beginTime = 0.0;    
    // 4. 计算暂停的时间(这里也可以用CACurrentMediaTime()-pausedTime)
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    // 5. 设置相对于父坐标系的开始时间(往后退timeSincePause)
      layer.beginTime = timeSincePause;
}
```

## CABasicAnimation——基本动画
- 基本动画，是CAPropertyAnimation的子类
- 属性说明:
 - fromValue：keyPath相应属性的初始值
 - toValue：keyPath相应属性的结束值

- 动画过程说明：
 - 随着动画的进行，在长度为duration的持续时间内，keyPath相应属性的值从fromValue渐渐地变为toValue
 - keyPath内容是CALayer的可动画Animatable属性
 - 果fillMode=kCAFillModeForwards同时removedOnComletion=NO，那么在动画执行完毕后，图层会保持显示动画执行后的状态。但在实质上，图层的属性值还是动画执行前的初始值，并没有真正被改变。
```
    //位移动画
    CABasicAnimation * positionAnim = [CABasicAnimation animation];
    positionAnim.keyPath = @"position";
    positionAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.positionImageV.center.x+200, self.positionImageV.center.y)];
    // 设置动画执行次数
    positionAnim.repeatCount = MAXFLOAT;
    // 取消动画反弹
    // 设置动画完成的时候不要移除动画
    positionAnim.removedOnCompletion = NO;
    // 设置动画执行完成要保持最新的效果
    positionAnim.fillMode = kCAFillModeForwards;
    positionAnim.duration =2;
    [self.positionImageV.layer addAnimation:positionAnim forKey:nil];
    //创建一个基本形变动画
    CABasicAnimation * scaleAnim = [CABasicAnimation animation];
    //kvc设置需要动画的属性
    scaleAnim.keyPath = @"transform.scale";
    //设置该属性的最终装填
    scaleAnim.toValue = @0.5;
    // 设置动画执行次数
    scaleAnim.repeatCount = MAXFLOAT;
    // 取消动画反弹
    // 设置动画完成的时候不要移除动画
    scaleAnim.removedOnCompletion = NO;
    // 设置动画执行完成要保持最新的效果
    scaleAnim.fillMode = kCAFillModeForwards;
    //设置动画时间
    scaleAnim.duration =2;
    [self.scaleImageV.layer addAnimation:scaleAnim forKey:nil];
    //旋转动画
    CABasicAnimation * rotationAnim = [CABasicAnimation animation];
    rotationAnim.keyPath = @"transform.rotation";
    rotationAnim.toValue = @M_PI;
    // 设置动画执行次数
    rotationAnim.repeatCount = MAXFLOAT;
    // 取消动画反弹
    // 设置动画完成的时候不要移除动画
    rotationAnim.removedOnCompletion = NO;
    // 设置动画执行完成要保持最新的效果
    rotationAnim.fillMode = kCAFillModeForwards;
    rotationAnim.duration =2;
    [self.rotationImageV.layer addAnimation:rotationAnim forKey:nil];
```

##CAKeyframeAnimation——关键帧动画
- 关键帧动画，也是CAPropertyAnimation的子类，与CABasicAnimation的区别是：
 - CABasicAnimation只能从一个数值（fromValue）变到另一个数值（toValue），而CAKeyframeAnimation会使用一个NSArray保存这些数值

- 属性说明：
 - values：上述的NSArray对象。里面的元素称为“关键帧”(keyframe)。动画对象会在指定的时间（duration）内，依次显示values数组中的每一个关键帧
 - path：可以设置一个CGPathRef、CGMutablePathRef，让图层按照路径轨迹移动。path只对CALayer的anchorPoint和position起作用。如果设置了path，那么values将被忽略
 - keyTimes：可以为对应的关键帧指定对应的时间点，其取值范围为0到1.0，keyTimes中的每一个时间值都对应values中的每一帧。如果没有设置keyTimes，各个关键帧的时间是平分的

- 一个关键帧动画的小例子，在一个view画板上，手指随意画动轨迹，图片通过关键帧动画在这轨迹上移动
 - 自定一个DrawView，在DrawView上添加一张图片
 - 实现DrawView内部的方法
 1 手指刚触碰到view时
```
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取touch对象
    UITouch * touch = [touches anyObject];
    //获取手指位置
    CGPoint fingerP = [touch locationInView:self];
    //创建一个路径并保存
    UIBezierPath * path = [UIBezierPath bezierPath];
    self.path = path;
    //路径添加起点
    [path moveToPoint:fingerP];
}
```
 2 手指在view上移动时
```
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    CGPoint fingerP = [touch locationInView:self];
    //不断连线，
    [self.path addLineToPoint:fingerP];
    [self setNeedsDisplay];
}
```
 3 手指离开view时
```
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//创建一个帧动画
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    //动画需要改变的属性
    anim.keyPath = @"position";
    //动画的改变的路径
    anim.path = _path.CGPath;
    //动画的时间
    anim.duration = 1;
    //动画的重复次数
    anim.repeatCount = MAXFLOAT;
    [[[self.subviews firstObject] layer] addAnimation:anim forKey:nil];
}
```
 4 重绘方法drawRect
```
-(void)drawRect:(CGRect)rect{
    //划线
    [self.path stroke];
}
```
-  ![CAKeyframeAnimation.jpeg](http://upload-images.jianshu.io/upload_images/1161239-764fce563392c147.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##CAAnimationGroup——动画组
- 动画组，是CAAnimation的子类，可以保存一组动画对象，将CAAnimationGroup对象加入层后，组中所有动画对象可以同时并发运行
- 属性说明：
 - animations：用来保存一组动画对象的NSArray
 - 默认情况下，一组动画对象是同时运行的，也可以通过设置动画对象的beginTime属性来更改动画的开始时间
```
// 同时缩放，平移，旋转
    //创建一个动画组
    CAAnimationGroup *group = [CAAnimationGroup animation];
    //形变动画
    CABasicAnimation *scale = [CABasicAnimation animation];
    scale.keyPath = @"transform.scale";
    scale.toValue = @0.5;
    //旋转动画
    CABasicAnimation *rotation = [CABasicAnimation animation];
    rotation.keyPath = @"transform.rotation";
    rotation.toValue = @(M_PI);
    //位移动画
    CABasicAnimation *position = [CABasicAnimation animation];
    position.keyPath = @"position";
    position.toValue = [NSValue valueWithCGPoint:CGPointMake(self.imageView.center.x+200,self.imageView.center.y)];
    //动画组时间
    group.duration = 2;
    //动画组重复
    group.repeatCount = MAXFLOAT;
    //三个基本动画添加到动画组中
    group.animations = @[scale,rotation,position];
    [self.imageView.layer addAnimation:group forKey:nil];
}
```

##转场动画——CATransition
- CATransition是CAAnimation的子类，用于做转场动画，能够为层提供移出屏幕和移入屏幕的动画效果。iOS比Mac OS X的转场动画效果少一点
- UINavigationController就是通过CATransition实现了将控制器的视图推入屏幕的动画效果
- 动画属性:
 - type：动画过渡类型
   - fade 交叉淡化过渡
   - push 新视图把旧视图推出去 
   - moveIn 新视图移到旧视图上面
   - reveal 将旧视图移开,显示下面的新视图 
   - cube 立方体翻滚效果
   - oglFlip 上下左右翻转效果
   - suckEffect 收缩效果，如一块布被抽走
   - rippleEffect 水滴效果
   - pageCurl 向上翻页效果
   - pageUnCurl 向下翻页效果
   - cameraIrisHollowOpen 相机镜头打开效果
   - cameraIrisHollowClose 相机镜头关闭效果
 - subtype：动画过渡方向
 - startProgress：动画起点(在整体动画的百分比)
 - endProgress：动画终点(在整体动画的百分比)
- 一个imageView切换图片的转场实现
```
// 加载图片名称
    NSString *imageN = [NSString stringWithFormat:@"%d",i];  
    _imageView.image = [UIImage imageNamed:imageN];
    i++;
    // 转场动画
    CATransition *anim = [CATransition animation];
    //动画设置代理
    anim.delegate = self;
    //动画类型 苹果封装好多种类型
    anim.type = @"pageCurl";
    anim.duration = 2;
    [_imageView.layer addAnimation:anim forKey:nil];
```
- 
![转场动画.jpeg](http://upload-images.jianshu.io/upload_images/1161239-c7c978ce86f04f78.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


##使用UIView动画函数实现转场动画
- 单视图
 - duration：动画的持续时间
 - view：需要进行转场动画的视图
 - options：转场动画的类型
 - animations：将改变视图属性的代码放在这个block中
 - completion：动画结束后，会自动调用这个block
```
+(void)transitionWithView:(UIView *)view duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
```

- 双视图
 - duration：动画的持续时间
 - options：转场动画的类型
 - animations：将改变视图属性的代码放在这个block中
 - completion：动画结束后，会自动调用这个block
```
+(void)transitionFromView:(UIView *)fromView toView:(UIView *)toView duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion;
```

##CADisplayLink
- CADisplayLink是一种以屏幕刷新频率触发的时钟机制，每秒钟执行大约60次左右
- CADisplayLink是一个计时器，可以使绘图代码与视图的刷新频率保持同步，而NSTimer无法确保计时器实际被触发的准确时间
- 使用方法：
 - 定义CADisplayLink并制定触发调用方法
 - 将显示链接添加到主运行循环队列
```
// 创建定时器
//    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeChange)];
    // 添加主运行循环
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
```

##隐式动画
- 每一个UIView内部都默认关联着一个CALayer，我们可用称这个Layer为Root Layer（根层）
- 所有的非Root Layer，也就是手动创建的CALayer对象，都存在着隐式动画
- 列举几个常见的Animatable Properties：
 - bounds：用于设置CALayer的宽度和高度。修改这个属性会产生缩放动画
 - backgroundColor：用于设置CALayer的背景色。修改这个属性会产生背景色的渐变动画
 - position：用于设置CALayer的位置。修改这个属性会产生平移动画

- CALayer的属性
```
 //宽度和高度
@property CGRect bounds;
//位置(默认指中点，具体由anchorPoint决定)
@property CGPoint position;
//锚点(x,y的范围都是0-1)，决定了position的含义
@property CGPoint anchorPoint;
//背景颜色(CGColorRef类型)
@property CGColorRef backgroundColor;
//形变属性
@property CATransform3D transform;
//边框颜色(CGColorRef类型)
@property CGColorRef borderColor;
//边框宽度
@property CGFloat borderWidth;
//圆角半径
@property CGColorRef borderColor;
//内容(比如设置为图片CGImageRef)
@property(retain) id contents;
```
- position和anchorPoint
  - CALayer有2个非常重要的属性：position和anchorPoint
 ```
//用来设置CALayer在父层中的位置
//以父层的左上角为原点(0, 0)
@property CGPoint position;
//称为“定位点”、“锚点”
//决定着CALayer身上的哪个点会在position属性所指的位置
//以自己的左上角为原点(0, 0)
//它的x、y取值范围都是0~1，默认值为（0.5, 0.5）
@property CGPoint anchorPoint;
```
- 一个layer层随机变化的例子
- 手动创建一个layer
```    
//创建一个图层 （只有新创建的图层才可以有隐式动画）
    CALayer * layer = [[CALayer alloc] init];
    //设置大小
    layer.bounds = CGRectMake(0, 0, 80, 80);
    //设置颜色
    layer.backgroundColor = [self randomColor].CGColor;
    //设置位置点
    layer.position = CGPointMake(200, 150);
    //图层加载到view上
    [self.view.layer addSublayer:layer];
    self.layer = layer;
```
- 循环调用这个方法你会发现很好玩的隐式动画
```
#define angle2radion(angle) angle / 180 * M_PI
-(void)beginAnimation{
    //3D旋转
    self.layer.transform = CATransform3DMakeRotation(angle2radion(arc4random_uniform(360)), 0, 0, 1);
    //3D移动
    self.layer.position = CGPointMake(arc4random_uniform(200)+20, arc4random_uniform(400)+50);
    self.layer.cornerRadius = arc4random_uniform(50);
    self.layer.backgroundColor = [self randomColor].CGColor;
    self.layer.borderColor = [self randomColor].CGColor;
    self.layer.borderWidth = arc4random_uniform(10);
}
//随机产生颜色
-(UIColor *)randomColor{
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}
```

##转盘效果
- 十二星座即为十二个按钮
- 把十二个按钮重叠加载一起，然后进行旋转，得到圆形布局的而效果
```
#pragma mark - xib加载后创建12个按钮
-(void)awakeFromNib{
    [super awakeFromNib];
    //设置按钮父控件可以交互
    self.rotationView.userInteractionEnabled = YES;
    //按钮的宽高
    CGFloat btnW = 68;
    CGFloat btnH = 143;
    //view的宽高
    CGFloat wh = self.bounds.size.width;
    //12张按钮图片是连一起的一张大图 需要裁剪
    UIImage *bigImage = [UIImage imageNamed:@"LuckyAstrology"];
    //select状太下的图片
    UIImage *selBigImage = [UIImage imageNamed:@"LuckyAstrologyPressed"];
    //获取像素与点的比值
    CGFloat scale = [UIScreen mainScreen].scale;
    //每个图片的宽度
    CGFloat imageW = bigImage.size.width / 12 * scale;
    //每个图片的高度
    CGFloat imageH = bigImage.size.height * scale;
    for (int i = 0; i < 12; i ++) {
        //每个图片需要旋转的角度
        CGFloat angle = (30 * i) / 180.0 * M_PI;
        //自定义按钮
        TurnBtn * btn = [TurnBtn buttonWithType:UIButtonTypeCustom];
        //大小
        btn.bounds = CGRectMake(0, 0, btnW, btnH);
        //设置position 和anchorPoint 因为要旋转每个按钮
        btn.layer.anchorPoint = CGPointMake(0.5, 1);
        btn.layer.position = CGPointMake(wh*0.5, wh*0.5);
        //旋转angle
        btn.transform = CGAffineTransformMakeRotation(angle);
        [self.rotationView addSubview:btn];
        //图片裁剪区域
        CGRect clipR = CGRectMake(i * imageW, 0, imageW, imageH);
        //获得裁剪后的图片
        CGImageRef imgR =  CGImageCreateWithImageInRect(bigImage.CGImage, clipR);
        //转成UIImage
        UIImage *image = [UIImage imageWithCGImage:imgR];
        [btn setImage:image forState:UIControlStateNormal];
        imgR = CGImageCreateWithImageInRect(selBigImage.CGImage, clipR);
        image = [UIImage imageWithCGImage:imgR];
        [btn setImage:image forState:UIControlStateSelected];
        //设置背景图
        [btn setBackgroundImage:[UIImage imageNamed:@"LuckyRototeSelected"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            //默认选中第一张
            [self btnClick:btn];
        }
    }
}
```
- 加载一个定时器CADisplayLink，旋转转盘
```
#pragma mark -定时器懒加载
// 1.搞个定时器，每隔一段时间就旋转一定的角度，1秒旋转45°
-(CADisplayLink *)link{
    if (!_link) {
        //CADisplayLink 定时器一秒调用60次
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotation)];
        //讲定时器添加到驻训华
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _link;
}
#pragma mark - 定时器绑定的旋转方法
-(void)rotation{
    // 每一次调用旋转多少 45 \ 60.0
    CGFloat angle = (45 / 60.0) * M_PI / 180.0;
    self.rotationView.transform = CGAffineTransformRotate(self.rotationView.transform, angle);
}
#pragma mark - 开始旋转的方法
-(void)start{
    self.link.paused = NO;
}
#pragma mark - 暂停旋转的方法
-(void)purase {
    self.link.paused = YES;
}
```
- 点击选号按钮，将转盘快速旋转，并且当前选中的星座停留在最上方
```
#pragma mark -选号点击
-(IBAction)pickerClick:(id)sender {
    // 不需要定时器旋转
    self.link.paused = YES;
    // 中间的转盘快速的旋转，并且不需要与用户交互
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.toValue = @(M_PI * 2 * 3);
    anim.duration = 0.5;
    anim.delegate = self;
    [self.rotationView.layer addAnimation:anim forKey:nil];
    // 点击哪个星座，就把当前星座指向中心点上面
    // M_PI 3.14
    // 根据选中的按钮获取旋转的度数,
    // 通过transform获取角度
    CGFloat angle = atan2(self.btn.transform.b, self.btn.transform.a);
    // 旋转转盘
    self.rotationView.transform = CGAffineTransformMakeRotation(-angle);
}
```
-  ![转盘.jpeg](http://upload-images.jianshu.io/upload_images/1161239-e9f30895f2070c63.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##图片折叠
- 如何制作图片折叠效果？
 把一张图片分成两部分显示，上面一部分，下面一部分，折叠上面部分的内容。
- 如何把一张图片分成两部分显示。
搞两个控件，一个显示上半部分，一个显示下半部分，需要用到Layer(图层)的一个属性`contentsRect`,这个属性是可以控制图片显示的尺寸，可以让图片只显示上部分或者下部分，注意:`取值范围是0~1`.
CGRectMake(0, 0, 1, 0.5)   : `表示显示上半部分`
CGRectMake(0, 0.5, 1, 0.5) : `表示显示下半部分`
```
-(void)setImage:(UIImage *)image{
    _image = image;
    //给两张图片赋值
    self.topImageV.image = _image;
    //让上部图片只显示图片的上部分
    self.topImageV.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);
    self.bottomImageV.image = _image;
    //让下部图片只显示图片的下部分
    self.bottomImageV.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.5);
}
```
- 如何快速的把两部分拼接成一张完整的图片。
 - 首先了解折叠，折叠其实就是旋转，既然需要旋转就需要明确锚点，因为默认都是绕着锚点旋转的。
 - 上部分内容绕着底部中心旋转，所以设置上部分的锚点为（0.5，1）
 - 锚点设置好了，就可以确定位置了.
 - 可以把上下部分重合在一起，然后分别设置上下部分的锚点，
上部分的锚点为`（0.5，1）`，下部分的锚点为`（0.5，0）`,就能快速重叠了。
 ```
//两张重叠的图片设置锚点
    self.topImageV.layer.anchorPoint = CGPointMake(0.5, 1);
    self.bottomImageV.layer.anchorPoint = CGPointMake(0.5, 0);
```
- 如何折叠上部分内容。
 - 在拖动视图的时候，旋转上部分控件。修改`transform`属性。
 - 可以在上部分和下部分底部添加一个拖动控件（`拖动控件尺寸就是完整的图片尺寸`），给这个控件添加一个pan手势，就能制造一个假象，拖动控件的时候，折叠图片。
 - 计算Y轴每偏移一点，需要旋转多少角度，假设完整图片尺寸高度为200，当y = 200时，上部分图片应该刚好旋转180°，因此`angle = offsetY  * M_PI / 200`;
 - 上部分内容应该是绕着X轴旋转，`逆时针旋转`，因此角度需要为负数。
 - 为了让折叠效果更加有效果，更加具有立体感，可以给形变设置m34属性，就能添加立体感。
- 反弹效果
当手指抬起的时候，应该把折叠图片还原，其实就是把形变清空。
- 阴影效果
 - 当折叠图片的时候，底部应该有个阴影渐变过程。
 -  利用`CAGradientLayer`（渐变图层）制作阴影效果，添加到底部视图上，并且一开始需要隐藏，在拖动的时候慢慢显示出来。
```
 //渐变图层
    CAGradientLayer * gradientL = [CAGradientLayer layer];
    gradientL.frame = self.bottomImageV.bounds;
    //渐变颜色数组
    gradientL.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor];
    gradientL.opacity = 0;
    self.gradientL = gradientL;
    //添加到底部imageView
    [self.bottomImageV.layer addSublayer:gradientL];
```
 -  颜色应是由`透明到黑色`渐变,表示阴影从无到有。
 -  在拖动的时候计算不透明度值，假设拖动200，阴影完全显示，不透明度应该为1，因此 opacity = y轴偏移量 * 1 /  200.0;
 -  在手指抬起的时候，需要把阴影设置隐藏，不透明度为0；

```
-(void)pan:(UIPanGestureRecognizer *)pan{
    //获得手指偏移量
    CGPoint curP = [pan translationInView:self];
    //根据手指偏移量设置3D旋转角度
    CGFloat angle = - curP.y / self.frame.size.height * M_PI;
    //复位
    CATransform3D transfrom = CATransform3DIdentity;
    // 增加旋转的立体感，近大远小,d：距离图层的距离
    transfrom.m34 = -1 / 500.0;
    //3D旋转
    transfrom = CATransform3DRotate(transfrom, angle, 1, 0, 0);
    //旋转上部图片
    self.topImageV.layer.transform = transfrom;
    //设置渐变图层的透明度
    self.gradientL.opacity = curP.y * 1.0 / self.frame.size.height;
    //手势结束时
    if (pan.state == UIGestureRecognizerStateEnded) {
        //弹簧效果的物理动画
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //恢复顶部图片
            self.topImageV.layer.transform = CATransform3DIdentity;
            //隐藏渐变图层
            self.gradientL.opacity = 0;
            
        } completion:^(BOOL finished) {
            
        }];
    }
}
```
- ![图片折叠.jpeg](http://upload-images.jianshu.io/upload_images/1161239-48cfab47b4791ceb.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##复制图层CAReplicatorLayer
- 什么是CAReplicatorLayer？
一种可以复制自己子层的layer,并且复制出来的layer和原生子层有同样的属性，位置，形变，动画。
- CAReplicatorLayer属性
 - `instanceCount`: 子层总数（包括原生子层）
 - `instanceDelay`: 复制子层动画延迟时长
 - `instanceTransform`: 复制子层形变(不包括原生子层)，每个复制子层都是相对上一个。
 - `instanceColor`: 子层颜色，会和原生子层背景色冲突，因此二者选其一设置。
 - `instanceRedOffset、instanceGreenOffset、instanceBlueOffset、instanceAlphaOffset`: 颜色通道偏移量，每个复制子层都是相对上一个的偏移量。

##### 音量振动条
- 首先创建复制CAReplicatorLayer,音乐振动条layer添加到复制CAReplicatorLayer上，然后复制子层就好了。
```
/创建一个复制图层
    CAReplicatorLayer * repL = [CAReplicatorLayer layer];
    //设置复制图层的大小
    repL.frame = self.bounds;
    //添加复制图层
    [self.layer addSublayer:repL];
```
- 先创建一个音量振动条，并且设置好动画,动画是绕着底部缩放，设置锚点
```
//创建一个图层
    CALayer * layer = [CALayer layer];
    //设置这个的位置
    layer.position = CGPointMake(15, self.frame.size.height);
    //设置图层的锚点
    layer.anchorPoint = CGPointMake(0.5, 1);
    //设置背景颜色
    layer.backgroundColor = [UIColor grayColor].CGColor;
    //设置大小
    layer.bounds = CGRectMake(0, 0, 30, 150);
    //把这个图层添加到复制图层中
    [repL addSublayer:layer];
    //创建一个动画
    CABasicAnimation * anim = [CABasicAnimation animation];
    anim.keyPath = @"transform.scale.y";
    anim.toValue = @0.1;
    anim.repeatCount = MAXFLOAT;
    //动画回到原始位置
    anim.autoreverses = YES;
    //把动画加载到layer上
    [layer addAnimation:anim forKey:nil];
```
- 复制子层
```
//给复制图层中子图层设置transform便宜，每个图层沿x便宜45
    repL.instanceTransform = CATransform3DMakeTranslation(45, 0, 0);
    //复制4个图层 包括复制图层
    repL.instanceCount = 4;
    //每个图层一个比一个延迟一秒执行动画
    repL.instanceDelay = 0.1;
    //每个图层的颜色
    repL.instanceColor = [UIColor greenColor].CGColor;
    //每个图层颜色渐变，
    repL.instanceGreenOffset = -0.03;
```

##### 指示器
- 创建复制图层
```
//创建一个复制图层
    CAReplicatorLayer * repL = [CAReplicatorLayer layer];
    //设置图层的的大小
    repL.frame = self.bounds;
    //添加复制图层
    [self.layer addSublayer:repL];
```
- 创建一个矩形图层，设置缩放动画。
```
//创建一个子图层
    CALayer * layer = [CALayer layer];
    //设置初始位置
    layer.position = CGPointMake(self.frame.size.width * 0.5, 10);
    //设置子图层大小
    layer.bounds = CGRectMake(0, 0, 5, 5);
    //设置图层的背景颜色
    layer.backgroundColor = [UIColor purpleColor].CGColor;
    //默认形变为0是不显示的
    layer.transform = CATransform3DMakeScale(0, 0, 0);
    //把图层添加到复制图层中
    [repL addSublayer:layer];
    //创建一个动画
    CABasicAnimation * anim = [CABasicAnimation animation];
    //设置形变
    anim.keyPath = @"transform.scale";
    anim.fromValue = @1;
    anim.toValue = @0;
    anim.repeatCount = MAXFLOAT;
    CGFloat duration = 1;
    anim.duration = duration;
    [layer addAnimation:anim forKey:nil];
```
- 复制矩形图层，并且设置每个复制层的角度形变
```
//20个子图层
    repL.instanceCount = count;
    repL.instanceDelay = duration / count;
    //每个子图层transform旋转偏移
    CGFloat angle = M_PI * 2 / count;
    repL.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
```
- 设置复制动画延长时间（需要保证第一个执行完毕之后，绕一圈刚好又是从第一个执行，因此需要把动画时长平均分给每个子层）公式:延长时间 = 动画时长 / 子层总数` repL.instanceDelay = duration / count; `假设有两个图层，动画时间为1秒，延长时间就为0.5秒。当第一个动画执行到一半的时候（0.5），第二个开始执行。第二个执行完

##### 倒影效果

- 用复制图层实现，搞个UIImageView展示图片，然后复制UIImageView.
- 注意：`复制图层只能复制子层，但是UIImageView只有一个主层，并没有子层，因此不能直接复制UIImageView`.
- 正确做法:应该把UIImageView添加到一个UIView上，然后复制UIView的层，就能复制UIImageView.
- 注意：`默认A控件是B控件的子控件，那么A控件的层就是B控件的层的子层。`
- 但是有问题，默认UIView的层不是复制层，我们想把UIView的层变成复制层，重写+layerClass方法。
```
+(Class)layerClass
{
    return [CAReplicatorLayer class];
}
```
- 倒影效果：就是就是把复制图片旋转180度，然后往下平移，最好先偏移在，在旋转。
```
    CAReplicatorLayer *layer =  (CAReplicatorLayer *)self.layer;
    layer.anchorPoint = CGPointMake(0.5, 1);   
    layer.instanceCount = 3;
    // 往下面平移控件的高度
    layer.instanceTransform = CATransform3DMakeRotation(M_PI*0.5, 1, 0, 0);
    layer.instanceAlphaOffset = -0.1;
    layer.instanceBlueOffset = -0.1;
    layer.instanceGreenOffset = -0.1;
    layer.instanceRedOffset = -0.1;
```
- ![复制图层.jpeg](http://upload-images.jianshu.io/upload_images/1161239-9ee13b262e6b2032.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##仿QQ消息提醒（粘性效果）
- 自定义大圆控件（UILabel）
- 让大圆控件随着手指移动而移动
 - 注意不能根据形变修改大圆的位置，只能通过center，因为全程都需要用到中心点计算。
```
//消息按钮跟随手指移动
    CGPoint tranP = [pan translationInView:self];
    CGPoint center = self.center;
    center.x += tranP.x;
    center.y += tranP.y;
    self.center = center;
    [pan setTranslation:CGPointZero inView:self];
```
- 在拖动的时候，添加一个小圆控件在原来大圆控件的位置
```
//计算拖动圆与原位置占位圆之间的距离
    CGFloat d = [self circleCenterDistanceWithBigCircleCenter:self.center smallCircleCenter:self.backSmallView.center];
    //根据距离缩小占位圆
    CGFloat h = self.bounds.size.height*0.5;
    CGFloat smallRadius = h - d / 10;
    self.backSmallView.bounds = CGRectMake(0, 0, smallRadius * 2, smallRadius * 2);
    self.backSmallView.layer.cornerRadius = smallRadius;
```
```
#pragma mark - 计算两个圆心之间的距离
-(CGFloat)circleCenterDistanceWithBigCircleCenter:(CGPoint)bigCircleCenter smallCircleCenter:(CGPoint)smallCircleCenter
{
    CGFloat offsetX = bigCircleCenter.x - smallCircleCenter.x;
    CGFloat offsetY = bigCircleCenter.y - smallCircleCenter.y;
    
    return  sqrt(offsetX * offsetX + offsetY * offsetY);
}
```
 - 注意这个小圆控件并不会随着手指移动而移动，因此应该添加到父控件上
 - 一开始设置中心点和尺寸和大圆控件一样。
 - 随着大圆拖动，小圆半径不断减少，可以根据两个圆心的距离，随便生成一段比例，随着圆心距离增加，圆心半径不断减少。
 - 每次小圆改变，需要重新设置小圆的尺寸和圆角半径。
- 粘性效果
 - 就是在两圆之间绘制一个形变矩形，描述形变矩形路径。
```
#pragma mark - 不规则矩形图层（根据路径创建的图层） 懒加载
-(CAShapeLayer *)shapeLayer
{
    if (_shapeLayer == nil) {
        // 展示不规则矩形，通过不规则矩形路径生成一个图层
        CAShapeLayer *layer = [CAShapeLayer layer];
        _shapeLayer = layer;
        layer.fillColor = self.backgroundColor.CGColor;
        [self.superview.layer insertSublayer:layer below:self.layer];
    }
    return _shapeLayer;
}
```
 - 这里需要用到CAShapeLayer,可以根据一个路径，生成一个图层，展示出来。把形变图层添加到父控件并且显示在小圆图层下就OK了。`self.shapeLayer.path = [self pathWithBigCirCleView:self smallCirCleView:self.backSmallView].CGPath;`因为所有计算出来的点，都是基于父控件。
 -`注意：这里不能用绘图，因为绘图内容只要超过当前控件尺寸就不会显示，但是当前形变矩形必须显示在控件之外`
![粘性计算图.png](http://upload-images.jianshu.io/upload_images/1161239-fb1fca35ebb4ba24.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
```
#pragma mark - 描述两圆之间一条矩形路径
-(UIBezierPath *)pathWithBigCirCleView:(UIView *)bigCirCleView  smallCirCleView:(UIView *)smallCirCleView
{
    CGPoint bigCenter = bigCirCleView.center;
    CGFloat x2 = bigCenter.x;
    CGFloat y2 = bigCenter.y;
    CGFloat r2 = bigCirCleView.bounds.size.width / 2;
    CGPoint smallCenter = smallCirCleView.center;
    CGFloat x1 = smallCenter.x;
    CGFloat y1 = smallCenter.y;
    CGFloat r1 = smallCirCleView.bounds.size.width / 2;
    // 获取圆心距离
    CGFloat d = [self circleCenterDistanceWithBigCircleCenter:bigCenter smallCircleCenter:smallCenter];
    CGFloat sinθ = (x2 - x1) / d;
    CGFloat cosθ = (y2 - y1) / d;
    // 坐标系基于父控件
    CGPoint pointA = CGPointMake(x1 - r1 * cosθ , y1 + r1 * sinθ);
    CGPoint pointB = CGPointMake(x1 + r1 * cosθ , y1 - r1 * sinθ);
    CGPoint pointC = CGPointMake(x2 + r2 * cosθ , y2 - r2 * sinθ);
    CGPoint pointD = CGPointMake(x2 - r2 * cosθ , y2 + r2 * sinθ);
    CGPoint pointO = CGPointMake(pointA.x + d / 2 * sinθ , pointA.y + d / 2 * cosθ);
    CGPoint pointP =  CGPointMake(pointB.x + d / 2 * sinθ , pointB.y + d / 2 * cosθ);
    UIBezierPath *path = [UIBezierPath bezierPath];
    // A
    [path moveToPoint:pointA];
    // AB
    [path addLineToPoint:pointB];
    // 绘制BC曲线
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    // CD
    [path addLineToPoint:pointD];
    // 绘制DA曲线
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    return path;
}
```
- 粘性业务逻辑处理
 - 当圆心距离超过100，就不需要描述形变矩形（并且把之前的形变矩形移除父层），小圆也需要隐藏。
 - 没有超过100，则相反。
- 手指停止拖动业务逻辑
 - 判断下圆心是否超过100，超过就播放爆炸效果，添加个UIImageView在当前控件上，并且需要取消控制器view的自动布局。
 - 没有超过，就还原。

```
#pragma mark - 手势事件
-(void)pan:(UIPanGestureRecognizer *)pan{
    
    //消息按钮跟随手指移动
    CGPoint tranP = [pan translationInView:self];
    CGPoint center = self.center;
    center.x += tranP.x;
    center.y += tranP.y;
    self.center = center;
    [pan setTranslation:CGPointZero inView:self];
    //计算拖动圆与原位置占位圆之间的距离
    CGFloat d = [self circleCenterDistanceWithBigCircleCenter:self.center smallCircleCenter:self.backSmallView.center];
    //根据距离缩小占位圆
    CGFloat h = self.bounds.size.height*0.5;
    CGFloat smallRadius = h - d / 10;
    self.backSmallView.bounds = CGRectMake(0, 0, smallRadius * 2, smallRadius * 2);
    self.backSmallView.layer.cornerRadius = smallRadius;
    if (d > kMaxDistance) {
        //当距离超过规定距离时
        // 可以拖出来
        // 隐藏占位圆
        self.backSmallView.hidden = YES;
        // 移除不规则的矩形
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
    }else if(d > 0 && self.backSmallView.hidden == NO){
        // 有圆心距离，并且圆心距离不大，才需要展示
        // 展示不规则矩形，通过不规则矩形路径生成一个图层
        self.shapeLayer.path = [self pathWithBigCirCleView:self smallCirCleView:self.backSmallView].CGPath;
    }
    //手势结束时 即手松开时
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (d > kMaxDistance) {
            // 当圆心距离大于规定距离
            // 展示gif动画
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            NSMutableArray *arrM = [NSMutableArray array];
            for (int i = 11; i < 19; i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
                [arrM addObject:image];
            }
            imageView.animationImages = arrM;
            imageView.animationRepeatCount = 1;
            imageView.animationDuration = 0.5;
            [imageView startAnimating];
            [self addSubview:imageView];
            //延迟执行
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
            });
        }else{
            // 当圆心距离大于最大圆心距离
            // 移除不规则矩形
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer = nil;
            // 还原位置
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
                // 设置大圆中心点位置
                self.center = self.backSmallView.center;
            } completion:^(BOOL finished) {
                // 显示小圆
                self.backSmallView.hidden = NO;
            }];
        }
    }
}
```
![仿QQ消息提醒.jpeg](http://upload-images.jianshu.io/upload_images/1161239-e55b8632bf1389c5.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

Demo地址：（https://github.com/heiheiLqq/ZZHAnimation ）
