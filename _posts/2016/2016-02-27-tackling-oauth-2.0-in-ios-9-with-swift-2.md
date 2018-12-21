---
layout: default
title: Tackling OAuth 2.0 in iOS 9 with Swift 2
tags: oauth2 ios swift
comments: true
---
# Tackling OAuth 2.0 in iOS 9 with Swift 2

In an earlier post I discussed how to [tackle OAuth 2.0 in an Android app]({% link _posts/2016/2016-02-18-tackling-oauth-2.0-in-an-android-app.md %}). This post discusses how to do that in iOS 9 with Swift 2.

Step 1, in the post referenced above, is performed in a UIWebView. The view containing the UIWebView implements UIWebViewDelegate, intercepts all accessed URLs in webView:shouldStartLoadWithRequest:navigationType: function, and acquires the authorization code using regular expressions.

```swift
class ViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        webView.delegate = self;
        webView.loadRequest(loginURL) // initialize loginURL
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        var continueToUrl = true
        do {
            let regex = try NSRegularExpression(pattern: "code=(.+?(?=&|$))", options: NSRegularExpression.Options())
            let url: String? = shouldStartLoadWithRequest.url?.absoluteString;
            let result: NSTextCheckingResult? = regex.firstMatch(in: url!, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, url!.characters.count))
            let codeNSRange = result?.rangeAt(1)
            if (codeNSRange != nil) {
                let startIndex = url?.index((url?.startIndex)!, offsetBy: (codeNSRange?.location)!)
                let endIndex = url?.index((url?.startIndex)!, offsetBy: (codeNSRange?.location)! + (codeNSRange?.length)!)
                let code = url?.substring(with: Range<String.Index>(startIndex!..<endIndex!))
                debugPrint(code)
                acquireAccessToken(code!)
                continueToUrl = false
            }
         } catch {
         }
         return continueToUrl;
     }
```

I found it challenging to use the interfaces for regular expression matching, and extracting substrings. They are quite different from those found in other popular languages, but should be familiar to Objective C developers. Step 2, to acquire the access token, can be performed thus

```swift
    func acquireAccessToken(code: String) {
        manager!.request(tokenURL, method: .post, parameters: ["code": code])
            .validate().responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        self.accessToken = json["access_token"].stringValue
                        debugPrint("Access Token: \(self.accessToken)")
                    }

                case .Failure(let error):
                    debugPrint(error)
                }
        }
    }
```

The code above utilizes [Alamofire](https://github.com/Alamofire/Alamofire) for performing REST calls, and [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) to handle JSON. Obtain those two frameworks using [Carthage](https://github.com/Carthage/Carthage). Create a Cartfile with

```text
github "Alamofire/Alamofire" ~> 3.0
github "SwiftyJSON/SwiftyJSON"
```

Then, invoke carthage to build the frameworks

```bash
carthage update
```

Drag the .framework files under `Carthage/Build/` into your Xcode project. The files are added by reference. Adjust project target settings to ensure that the frameworks are embedded, otherwise you'll get an error such as

```text
dyld: Library not loaded: @rpath/SwiftyJSON.framework/SwiftyJSON
  Referenced from: ...
```

If you use git for version control, remember to adjust [.gitignore](https://github.com/github/gitignore/blob/master/Swift.gitignore) to exclude `Carthage/` folder.
