<img src="https://swift.org/assets/images/swift.svg" alt="Swift logo" height="70" >
# Swift Example

**Welcome to Swift!**

本项目主要用于辅助2016年06月13日本人的知乎 Live 内容。


## 项目内容

此项目主要包含以下可以学习的内容点：

### Swift 基础用法
此项目全部使用 Swift 语言编写，在 `Xcode 7.3.1 (7D1014) 版本（ Swift 2.2 SDK ）`下此项目可以正确编译并运行在 iOS 虚拟机或者 iOS 真机设备上。（项目编译存在的 Warming 是由于我懒，没有添加正确的 App 载入图片导致的）

**注意:** 由于我个人习惯，初始项目建立的 StoryBoard 已经被我从项目中踢除，全部界面内容都是通过代码来进行控制的。

### Swift 下 Singleton、Block、Delegate、NSNotification 四种多 Class 之间数据通讯和回掉用法

`ServerManager.swift` 包含 Singleton 和 Block 使用

	//singleton
    static let sharedInstance = ServerManager()//Singleton
    init(){
        session = NSURLSession.sharedSession();
    }
    
	//block
	func getNewsList(sid: Int?, success: ((array : NSArray) -> Void)?, fail: ((code : NSInteger, error : NSError?) -> Void)?)

Singleton 和 Block 回掉用法请参见 `ViewController.swift`

	ServerManager.sharedInstance.getNewsList(lastNews.sid, success: { (array) in
				...
            }, fail: { (code, error) in
                ...
            })
**注意:** 此方法在 Swift 3.0 中会发生更改。

Delegate 用法请参见 `NewsCell.swift`
创建 protocol

	@objc
	protocol NewsCellOptionalDelegate {
	    optional func selectTitle(title : String)
	}
	
	protocol NewsCellDelegate {
	    func openNewsDetail(news : CBNews)
	}
**注意:** 只有声明为 objc 的 protocol 才可以创建 optinonal （可选的）毁掉方法。此方法在 Swift 3.0 中会发生更改。

调用 Delegate 方法

	@objc func titleTaped(tap : UITapGestureRecognizer){
        optionalDelegate?.selectTitle?(titleLabel.text!)
    }
由于使用了 `?` ，所以不在需要对 delegate 是否包含协议方法再次做确认。
设置代理方法和 Objective-C 基本一致。

NSNotification 用法和 Objective-C 基本一致，请参见 `KLTheme.swift` 。

### 高度不同的 UITablviewCell 处理和 Cell 高度变化动画

在 iOS 开发中，我们经常会遇到需要处理高都不同的 Cell 在同一个 UITablview 里面展示的情况，此 Example 包含了一个简单的 Table 内 Cell 高度处理方法。

    extension NewsCell
    class func calHeight(news: CBNews, showDetail: Bool) -> CGFloat
在 `NewsCell.swift` 包含此方法，会在 Cell 计算高度时调用，向 Table 返回正确的高度数值。（后续为了提高 Table 滑动效率，可以在此方法中缓存指定内容的高度到 NSCache 或者内存空间）

在 Cell 高都切换时（ Cell 被点击），通过 `beginUpdate()` 和 `endUpdate()` 来要求 Table 刷新 Cell 高度，同时提供动画使 Cell 高度切换。    

### 全局配色主题切换

主要参见 `KLTheme.swift` 内容。
其核心思想是给 iOS 各种 UIKit 组件通过添加 Class Extension 的方式，使得每个在后期声明接受主题控制的 UI 控件在收到主题替换的 Notify 时切换显示颜色或者显示内容。

**注意:** iOS UIKit 中存在部分控件跳过 UIView 直接继承于 NSObject 的情况，所以在实现全部组件颜色切换时最好在 NSObject 上添加 extension ，而不要在 UIView 上添加 extension。但是在这样处理之后，需要注意 NSArray 等非 UIKit 组件的方法调用。

### UIGestureRecognizer 在 UIView 之间的传递
本程序实现了类似 Tweetbot 4 里面的双指上下滑动切换全局主题的功能。
此实现难点主要在于 UIScrollView 自带 UIPanGestureRecognizer ，导致手势无法很简单的直接添加到 View 上面实现效果。
这里核心内容在于我发现 UIScrollView 实际上添加了 UIGestureRecognizerDelegate 协议，但是其内部实现并没有实现所有方法，所以通过 extension 的形式添加

	public override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool
之后，我们就可以控制 UIScrollView 内 UIGestureRecognizer 的 delegate 方法处理。

### 其他内容

`KLTheme.swift` 内 NSObject extension 使用到了 iOS 4 时引入的 

	objc_getAssociatedObject
这一 Objective-C 特性在 Swift 下作为 NS 系列库属性被完整的继承了，无需添加 `@objc` 声明。

`BridgeHeader.h` 内声明了 iOS 的 CommonCrypto 库桥接头。针对此，Xcode 项目中 Building Setting 的 Swift Compiler - Code Generation 里面 Objective-C bridging Header 配置有所修改。
由于此声明， `Utils.swift` 内的 MD5 处理相关方法才可以使用。

我在 `ServerManager.swift` 内实现了一个基于 NSURLSession 的简单网络通讯库，出于载入效率考虑，我在 `UIImageViewExtension.swift` 中实现了简单的类 AFNetworking+UIImageview 方法，使用到了 NSCache 来缓存图片内容。

在 `NewsDetailViewController.swift` 中，我使用了 UITextView 的 TextKit 相关方法来实现对于 HTML 内容的排版处理。

## 特别感谢

在此特别感谢 [**远望の无限**](https://git.oschina.net/ywwxhz/cnBeta-reader) 提供的 CNBeta API 接口。 

##开源协议

The MIT License (MIT)
Copyright (c) 2016 Bill Cheng

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
