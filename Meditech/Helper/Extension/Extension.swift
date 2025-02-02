

import UIKit
import CoreLocation

extension UIApplication {
    
    var screenShot: UIImage?  {
        
        if let rootViewController = Constants.keyWindow?.rootViewController {
            let scale = UIScreen.main.scale
            let bounds = rootViewController.view.bounds
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale);
            if let _ = UIGraphicsGetCurrentContext() {
                rootViewController.view.drawHierarchy(in: bounds, afterScreenUpdates: true)
                let screenshot = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return screenshot
            }
        }
        return nil
    }
    
}
// MARK: - Button Navigation Bar

extension UIViewController {
    func backButton(){
        self.navigationItem.leftBarButtonItems = nil
        navButtonWithImg(#imageLiteral(resourceName: "Back"), selector: #selector(navBtnBackAction),isLeft: true)
    }
    @objc func popVC() {
//        navigationController?.navigationBar.backItem?.title = ""
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    func navButtonWithImg(_ img : UIImage ,selector : Selector , isLeft : Bool = false ,lblBadge : UILabel? = nil,  isWithoutTint: Bool = false) {
        let btn = UIButton(type: isWithoutTint ? .custom : .system )
        btn.setImage(img, for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.addTarget(self, action: selector, for: .touchUpInside)
        btn.tintColor = .black
        btn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 35).isActive = true
//        btn.contentVerticalAlignment = .top
        let item = UIBarButtonItem(customView: btn)
        if lblBadge != nil {
            btn.addSubview(lblBadge!)
        }
        if (isLeft) {
            if var items = self.navigationItem.leftBarButtonItems {
                items.append(item)
                self.navigationItem.leftBarButtonItems  = items
            } else {
                self.navigationItem.leftBarButtonItem = item
            }
        } else {
            if var items = self.navigationItem.rightBarButtonItems {
                items.append(item)
                self.navigationItem.rightBarButtonItems  = items
            } else {
                self.navigationItem.rightBarButtonItem  = item
            }
        }
        
    }
    func barNavButtonWithImg(_ img : UIImage ,selector : Selector , isLeft : Bool = false) {
        let btn = UIButton(type: .system)
        btn.tintColor = .black
        btn.setImage(img, for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.addTarget(self, action: selector, for: .touchUpInside)
        btn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 35).isActive = true
        let item = UIBarButtonItem(customView: btn)
        if (isLeft) {
        
        } else {
         
        }
    }
    func setNavigationLogo() {
        let logo = #imageLiteral(resourceName: "LogoText")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    func addBackAccountChat() {
        self.navigationItem.rightBarButtonItems = nil
        self.navigationItem.leftBarButtonItems = nil
        navButtonWithImg(#imageLiteral(resourceName: "BackArrow"), selector: #selector(navBtnBackAction),isLeft: true)
        navButtonWithImg(#imageLiteral(resourceName: "Account"), selector: #selector(navBtnAccountAction), isLeft: false)
        navButtonWithImg(#imageLiteral(resourceName: "Chat"), selector: #selector(navBtnChatAction), isLeft: false)
    }
    @objc func navBtnBackAction() {
        if self.navigationController?.popViewController(animated: true) == nil {
            dismiss(animated: true, completion: nil)
        }
    }
    @objc func navBtnAccountAction() {
//        present(SideMenuManager.default.rightMenuNavigationController!, animated: true, completion: nil)
    }
    @objc func navBtnChatAction() {
//        let objChatTabBarVC = ChatTabBarVC.instantiate()
//        self.navigationController?.pushViewController(objChatTabBarVC)
//        let objChatListVC = ChatListVC.instantiate()
//        self.navigationController?.pushViewController(objChatListVC)
    }
    func addRightSideMenuGestures() {
        if let _ = view.viewWithTag(5647156) {
            return
        }
        let rightSlideView = UIView(frame: CGRect(x: view.w - 12, y: 0, width: 12, height: view.h))
        rightSlideView.backgroundColor = .clear
        rightSlideView.tag = 5647156
        view.addSubview(rightSlideView)
//        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: rightSlideView)
    }
    func addWillEnterForegroundNotifications() {
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification), name: UIScene.willEnterForegroundNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }
    @objc func willEnterForegroundNotification(_ notification: Notification) {
     }
}
extension UIApplication {
    ///  Run a block in background after app resigns activity
    func runInBackground(_ closure: @escaping () -> Void, expirationHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let taskID: UIBackgroundTaskIdentifier
            if let expirationHandler = expirationHandler {
                taskID = self.beginBackgroundTask(expirationHandler: expirationHandler)
            } else {
                taskID = self.beginBackgroundTask(expirationHandler: { })
            }
            closure()
            self.endBackgroundTask(taskID)
        }
    }
    
    ///  Get the top most view controller from the base view controller; default param is UIWindow's rootViewController
    public class func topViewController(_ base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if base == nil {
//          base = Constants.keyWindow?.rootViewController
            return nil
        }
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
}
extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}

// MARK: - Status Bar

extension UINavigationController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    func setShadowNavigationBar(_ bgColor : UIColor = .white) {
//        self.navigationBar.shadowColorView = UIColor.lightGray
//        self.navigationBar.shadowOffsetSizeView = CGSize(width: 0.0, height: 1.5)
//        self.navigationBar.shadowRadiusView = 2.0
//        self.navigationBar.shadowOpacityView = 0.8
//        self.navigationBar.layer.masksToBounds = false
////        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationBar.shadowImage = UIImage()
//        self.navigationBar.layoutIfNeeded()
        
//        if bgColor == .white {
//            self.navigationBar.shadowImage = UIImage()
//        } else {
        if bgColor != .white {
            self.navigationBar.setBackgroundImage(UIImage(color: bgColor), for: UIBarMetrics.default)
        }
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = false
        self.view.backgroundColor = bgColor
//        }
        
    }
    
    func removeBG(_ bgColor : UIColor = .clear) {
        if bgColor == .clear {
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        } else {
            self.navigationBar.setBackgroundImage(UIImage(color: bgColor), for: UIBarMetrics.default)
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.isTranslucent = false
            self.view.backgroundColor = bgColor
        }
    }
}
extension UITabBarController {
    func setShadowTabBar() {
//        self.tabBar.shadowColorView = UIColor.lightGray
//        self.tabBar.shadowOffsetSizeView = CGSize(width: 0.0, height: -1.5)
//        self.tabBar.shadowRadiusView = 2.0
//        self.tabBar.shadowOpacityView = 0.8
//        self.tabBar.layer.masksToBounds = false
        //        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        if #available(iOS 13.0, *) {
            let appearance = tabBar.standardAppearance
//            appearance.shadowImage = nil
//            appearance.shadowColor = nil
            appearance.backgroundColor = UIColor.white
            appearance.selectionIndicatorTintColor = .BlueStart()
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(r: 41, g: 41, b: 41)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(r: 41, g: 41, b: 41)]
//                ,NSAttributedString.Key.font:UIFont.brandonTextRegular(size: 10)]
//            appearance.
//            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: .red]
            tabBar.standardAppearance = appearance
        } else {
//            tabBar.shadowImage = UIImage()
//            tabBar.backgroundImage = UIImage()
            tabBar.backgroundColor = UIColor.white
        }
        tabBar.tintColor = .BlueStart()
        tabBar.unselectedItemTintColor = UIColor(r: 41, g: 41, b: 41)
        self.tabBar.layoutIfNeeded()
    }
}

// MARK: - Get Random Color Methods

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 0.25)
    }
}
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

// MARK: - RGB Color Extension

extension UIColor {
    convenience init(r: Int, g: Int, b: Int , a: CGFloat = 1.0) {
        assert(r >= 0 && r <= 255, "Invalid red component")
        assert(g >= 0 && g <= 255, "Invalid green component")
        assert(b >= 0 && b <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    convenience init(rgb: Int , a: CGFloat = 1.0) {
        self.init(
            r: (rgb >> 16) & 0xFF,
            g: (rgb >> 8) & 0xFF,
            b: rgb & 0xFF,
            a: a
        )
    }
    convenience init(hex:String)  {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
            return
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    var hexString: String? {
        guard self.cgColor.numberOfComponents == 4 else {
            return "Color not RGB."
        }
        var alpha: CGFloat = 0
        
        guard self.getRed(nil, green: nil, blue: nil, alpha: &alpha) else {
            return nil
        }
        let a = self.cgColor.components!.map { Int($0 * CGFloat(255.999999)) }
        let color = String.init(format: "#%02X%02X%02X", a[0], a[1], a[2])
        if alpha < 1.0 {
            let alpha = String.init(format: "%02X", a[3])
            return "\(color)\(alpha)"
        }
        return color
    }
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
}

// MARK: - UITextField Character Limit

private var kAssociationKeyMaxLength: Int = 0

extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        //text = prospectiveText.substring(to: maxCharIndex)
        text = String(prospectiveText.prefix(upTo: maxCharIndex))
        selectedTextRange = selection
    }
    func validZipCode()->Bool{
        let postalcodeRegex = "^[0-9]{5}(-[0-9]{4})?$"
        let pinPredicate = NSPredicate(format: "SELF MATCHES %@", postalcodeRegex)
        let bool = pinPredicate.evaluate(with: self.text) as Bool
        return bool
    }
//    static let emailRegex = "(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    func addLeftTextPadding(_ blankSize: CGFloat) {
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: blankSize, height: frame.height)
        self.leftView = leftView
        self.leftViewMode = UITextField.ViewMode.always
    }
    func addLeftIcon(_ image: UIImage?, frame: CGRect, imageSize: CGSize) {
        let leftView = UIView()
        leftView.frame = frame
        let imgView = UIImageView()
        imgView.frame = CGRect(x: frame.width - 8 - imageSize.width, y: (frame.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
        imgView.image = image
        leftView.addSubview(imgView)
        self.leftView = leftView
        self.leftViewMode = UITextField.ViewMode.always
    }
    
    func validateEmail() -> Bool {
        let emailTest = NSPredicate(format:"SELF MATCHES %@", UITextField.emailRegex)
        return emailTest.evaluate(with: self.text)
    }
    func validateDigits() -> Bool {
        let digitsRegEx = "[0-9]*"
        let digitsTest = NSPredicate(format:"SELF MATCHES %@", digitsRegEx)
        return digitsTest.evaluate(with: self.text)
    }
    
    
    /// Check if text field is empty.
    public var isEmpty: Bool {
        return trimmedText?.isEmpty == true
    }
    
    ///  Return text with no spaces or new lines in beginning and end.
    public var trimmedText: String? {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func checkMinAndMaxLength(withMinLimit minLen: Int, withMaxLimit maxLen: Int) -> Bool {
        if (self.text!.count ) >= minLen && (self.text!.count ) <= maxLen {
            return true
        }
        return false
    }
    enum Direction
    {
        case Left
        case Right
    }
    
    func addImage(direction:Direction,image:UIImage,Frame:CGRect,backgroundColor:UIColor)
    {
        let View = UIView(frame: Frame)
        View.backgroundColor = backgroundColor
        
        let imageView = UIImageView(frame: Frame)
        imageView.image = image
        imageView.contentMode = .center
        View.addSubview(imageView)
        
        if Direction.Left == direction
        {
            self.leftViewMode = .always
            self.leftView = View
        }
        else
        {
            self.rightViewMode = .always
            self.rightView = View
        }
    }

}

//@IBDesignable
extension UITextField {
    
    @IBInspectable var paddingLeftView: CGFloat {
        get {
            //return leftView!.frame.size.width
            //            if (self.isMember(of:UISearchBar.self)) {
            //                return self.leftView?.frame.width ?? 0
            //            }
            return self.leftView?.frame.width ?? 0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var paddingRightView: CGFloat {
        get {
            //            return rightView!.frame.size.width
            return self.leftView?.frame.width ?? 0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}



extension CGFloat {
    
    /// : Absolute of CGFloat value.
    public var abs: CGFloat {
        return Swift.abs(self)
    }
    
    /// : Ceil of CGFloat value.
    public var ceil: CGFloat {
        return Foundation.ceil(self)
    }
    
//    /// : Radian value of degree input.
//    public var degreesToRadians: CGFloat {
//        return CGFloat.pi * self / 180.0
//    }
    
    /// : Floor of CGFloat value.
    public var floor: CGFloat {
        return Foundation.floor(self)
    }
    
    /// : Check if CGFloat is positive.
    public var isPositive: Bool {
        return self > 0
    }
    
    /// : Check if CGFloat is negative.
    public var isNegative: Bool {
        return self < 0
    }
    
    /// : Int.
    public var int: Int {
        return Int(self)
    }
    
    /// : Float.
    public var float: Float {
        return Float(self)
    }
    
    /// : Double.
    public var double: Double {
        return Double(self)
    }
    
    /// : Degree value of radian input.
    public var radiansToDegrees: CGFloat {
        return self * 180 / CGFloat.pi
    }
    
    /// : Random CGFloat between two CGFloat values.
    ///
    /// - Parameters:
    ///   - min: minimum number to start random from.
    ///   - max: maximum number random number end before.
    /// - Returns: random CGFloat between two CGFloat values.
    public static func randomBetween(min: CGFloat, max: CGFloat) -> CGFloat {
        let delta = max - min
        return min + CGFloat(arc4random_uniform(UInt32(delta)))
    }
    
    func degreesToRadians() -> CGFloat {
        return (.pi * self) / 180.0
    }
}
extension URL {
///  Returns remote size of url, don't use it in main thread
    func remoteSize(_ completionHandler: @escaping ((_ contentLength: Int64) -> Void), timeoutInterval: TimeInterval = 30) {
        let request = NSMutableURLRequest(url: self, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
        request.httpMethod = "HEAD"
        request.setValue("", forHTTPHeaderField: "Accept-Encoding")
        URLSession.shared.dataTask(with: request as URLRequest) { (_, response, _) in
            let contentLength: Int64 = response?.expectedContentLength ?? NSURLSessionTransferSizeUnknown
            DispatchQueue.global(qos: .default).async(execute: {
                completionHandler(contentLength)
            })
            }.resume()
    }

    ///  Returns server supports resuming or not, don't use it in main thread
    func supportsResume(_ completionHandler: @escaping ((_ doesSupport: Bool) -> Void), timeoutInterval: TimeInterval = 30) {
        let request = NSMutableURLRequest(url: self, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
        request.httpMethod = "HEAD"
        request.setValue("bytes=5-10", forHTTPHeaderField: "Range")
        URLSession.shared.dataTask(with: request as URLRequest) { (_, response, _) -> Void in
            let responseCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            DispatchQueue.global(qos: .default).async(execute: {
                completionHandler(responseCode == 206)
            })
            }.resume()
    }
}

extension UIImage {
    
    //  Returns base64 string
    public var base64: String {
        return self.jpegData(compressionQuality: 1.0)!.base64EncodedString()
    }
    
    //  Returns compressed image to rate from 0 to 1
    func compressImage(rate: CGFloat) -> Data? {
        return self.jpegData(compressionQuality: rate)
    }
    
    //  Returns Image size in Bytes
    func getSizeAsBytes() -> Int {
        return self.jpegData(compressionQuality: 1.0)?.count ?? 0
    }
    
    //  Returns Image size in Kylobites
    func getSizeAsKilobytes() -> Int {
        let sizeAsBytes = getSizeAsBytes()
        return sizeAsBytes != 0 ? sizeAsBytes / 1024 : 0
    }
    
    //  scales image
    public class func scaleTo(image: UIImage, w: CGFloat, h: CGFloat) -> UIImage {
        let newSize = CGSize(width: w, height: h)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
}

    /// Returns resized image with width. Might return low quality
    func resizeWithWidth(_ width: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: width, height: aspectHeightForWidth(width))
        
        UIGraphicsBeginImageContext(aspectSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
    
    /// Returns resized image with height. Might return low quality
    func resizeWithHeight(_ height: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: aspectWidthForHeight(height), height: height)
        
        UIGraphicsBeginImageContext(aspectSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
    
    ///
    func aspectHeightForWidth(_ width: CGFloat) -> CGFloat {
        return (width * self.size.height) / self.size.width
    }
    
    ///
    func aspectWidthForHeight(_ height: CGFloat) -> CGFloat {
        return (height * self.size.width) / self.size.height
    }
    
    //  Returns cropped image from CGRect
    func croppedImage(_ bound: CGRect) -> UIImage? {
        guard self.size.width > bound.origin.x else {
            print(" Your cropping X coordinate is larger than the image width")
            return nil
        }
        guard self.size.height > bound.origin.y else {
            print(" Your cropping Y coordinate is larger than the image height")
            return nil
        }
        let scaledBounds: CGRect = CGRect(x: bound.origin.x * self.scale, y: bound.origin.y * self.scale, width: bound.width * self.scale, height: bound.height * self.scale)
        let imageRef = self.cgImage?.cropping(to: scaledBounds)
        let croppedImage: UIImage = UIImage(cgImage: imageRef!, scale: self.scale, orientation: UIImage.Orientation.up)
        return croppedImage
    }
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    class func circle(diameter: CGFloat, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)
        
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
}

public extension UICollectionView {
    /// - Parameter completion: completion handler to run after reloadData finishes.
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
}
public extension UITableView {
    /// Reload data with a completion handler.
    ///
    /// - Parameter completion: completion handler to run after reloadData finishes.
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    /// : Remove TableFooterView.
    func removeTableFooterView() {
        tableFooterView = nil
    }
    
    /// : Remove TableHeaderView.
    func removeTableHeaderView() {
        tableHeaderView = nil
    }
    /// : Scroll to bottom of TableView.
    ///
    /// - Parameter animated: set true to animate scroll (default is true).
    func scrollToBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: animated)
    }
    
    /// : Scroll to top of TableView.
    ///
    /// - Parameter animated: set true to animate scroll (default is true).
    func scrollToTop(animated: Bool = true) {
        setContentOffset(CGPoint.zero, animated: animated)
    }

}
public extension UIImageView {
    
    /// : Set image from a URL.
    ///
    /// - Parameters:
    ///   - url: URL of image.
    ///   - contentMode: imageView content mode (default is .scaleAspectFit).
    ///   - placeHolder: optional placeholder image
    ///   - completionHandler: optional completion handler to run when download finishs (default is nil).
    func download(from url: URL,
                         contentMode: UIView.ContentMode = .scaleAspectFit,
                         placeholder: UIImage? = nil,
                         completionHandler: ((UIImage?) -> Void)? = nil) {
        
        image = placeholder
        self.contentMode = contentMode
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data,
                let image = UIImage(data: data)
                else {
                    completionHandler?(nil)
                    return
            }
            DispatchQueue.main.async {
                self.image = image
                completionHandler?(image)
            }
            }.resume()
    }
    
    /// : Make image view blurry
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    func blur(withStyle style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        addSubview(blurEffectView)
        clipsToBounds = true
    }
    
    /// : Blurred version of an image view
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    /// - Returns: blurred version of self.
    func blurred(withStyle style: UIBlurEffect.Style = .light) -> UIImageView {
        let imgView = self
        imgView.blur(withStyle: style)
        return imgView
    }
    
}
public extension UINavigationController {
    
    /// : Pop ViewController with completion handler.
    ///
    /// - Parameter completion: optional completion handler (default is nil).
    func popViewController(_ completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: true)
        CATransaction.commit()
    }

      func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
          popToViewController(vc, animated: animated)
        }
      }

      func popViewControllers(viewsToPop: Int, animated: Bool = true) {
        if viewControllers.count > viewsToPop {
          let vc = viewControllers[viewControllers.count - viewsToPop - 1]
          popToViewController(vc, animated: animated)
        }
      }

    /// : Push ViewController with completion handler.
    ///
    /// - Parameters:
    ///   - viewController: viewController to push.
    ///   - completion: optional completion handler (default is nil).
    func pushViewController(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
    
    /// : Make navigation controller's navigation bar transparent.
    ///
    /// - Parameter tint: tint color (default is .white).
    func makeTransparent(withTint tint: UIColor = .white) {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.tintColor = tint
        navigationBar.titleTextAttributes = [.foregroundColor: tint]
    }
    
    func pushViewControllerWithFlipAnimation(_ viewController:UIViewController){
        self.pushViewController(viewController
            , animated: false)
        if let transitionView = self.view{
            UIView.transition(with:transitionView, duration: 0.35, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
    }
    
    func popViewControllerWithFlipAnimation(){
        self.popViewController(animated: false)
        if let transitionView = self.view{
            UIView.transition(with:transitionView, duration: 0.35, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
    }
    
}
public extension UISearchBar {
    
    /// : Text field inside search bar (if applicable).
    var textField: UITextField? {
        let subViews = subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }
    func removeBG(_ view : UIView? = nil) {
        var view = view
        if view == nil {
            view = self
        }
        for subview in view?.subviews ?? [] {
            if (subview.isKind(of: UITextField.self)) {
                let textField = subview as! UITextField
                textField.borderStyle = .none
                textField.layer.borderWidth = 1
                textField.layer.borderColor = UIColor.clear.cgColor
                textField.background = nil;
                textField.backgroundColor = UIColor.clear
            }
            removeBG(subview)
        }
    }
    /// : Text with no spaces or new lines in beginning and end (if applicable).
    var trimmedText: String? {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
public extension UISlider {
    
    /// : Set slide bar value with completion handler.
    ///
    /// - Parameters:
    ///   - value: slider value.
    ///   - animated: set true to animate value change (default is true).
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: an optional completion handler to run after value is changed (default is nil)
    func setValue(_ value: Float, animated: Bool = true, duration: TimeInterval = 1, completion: (() -> Void)? = nil) {
        if animated {
            UIView.animate(withDuration: duration, animations: {
                self.setValue(value, animated: true)
            }, completion: { _ in
                completion?()
            })
        } else {
            setValue(value, animated: false)
            completion?()
        }
    }
    
}
public extension UIViewController {
    
    /// : Assign as listener to notification.
    ///
    /// - Parameters:
    ///   - name: notification name.
    ///   - selector: selector to run with notified.
    func addNotificationObserver(name: Notification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    /// : Unassign as listener to notification.
    ///
    /// - Parameter name: notification name.
    func removeNotificationObserver(name: Notification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
    
    /// : Unassign as listener from all notifications.
    func removeNotificationsObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    var previousViewController:UIViewController?{
        if let controllersOnNavStack = self.navigationController?.viewControllers{
            let n = controllersOnNavStack.count
            //if self is still on Navigation stack
            if controllersOnNavStack.last === self, n > 1{
                return controllersOnNavStack[n - 2]
            }else if n > 0{
                return controllersOnNavStack[n - 1]
            }
        }
        return nil
    }
    
}
//public extension UIDatePicker {
//
//    /// : Text color of UIDatePicker.
//    public var textColor: UIColor? {
//        set {
//            setValue(newValue, forKeyPath: "textColor")
//        }
//        get {
//            return value(forKeyPath: "textColor") as? UIColor
//        }
//    }
//
//}
@IBDesignable
extension UIDatePicker {
    @IBInspectable var textLabelColor: UIColor? {
        get {
            return self.value(forKey: "textColor") as? UIColor
        }
        set {
            self.setValue(newValue, forKey: "textColor")
           // self.performSelector(inBackground: Selector("setHighlightsToday:"), with:newValue) //For some reason this line makes the highlighted text appear the same color but can not be changed from textColor.
        }
    }
}
public extension CLLocation {
    
    /// : Calculate the half-way point along a great circle path between the two points.
    ///
    /// - Parameters:
    ///   - start: Start location.
    ///   - end: End location.
    /// - Returns: Location that represents the half-way point.
    static func midLocation(start: CLLocation, end: CLLocation) -> CLLocation {
        let lat1 = Double.pi * start.coordinate.latitude / 180.0
        let long1 = Double.pi * start.coordinate.longitude / 180.0
        let lat2 = Double.pi * end.coordinate.latitude / 180.0
        let long2 = Double.pi * end.coordinate.longitude / 180.0
        
        // Formula
        //    Bx = cos φ2 ⋅ cos Δλ
        //    By = cos φ2 ⋅ sin Δλ
        //    φm = atan2( sin φ1 + sin φ2, √(cos φ1 + Bx)² + By² )
        //    λm = λ1 + atan2(By, cos(φ1)+Bx)
        // Source: http://www.movable-type.co.uk/scripts/latlong.html
        
        let bx = cos(lat2) * cos(long2 - long1)
        let by = cos(lat2) * sin(long2 - long1)
        let mlat = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + bx) * (cos(lat1) + bx) + (by * by)))
        let mlong = (long1) + atan2(by, cos(lat1) + bx)
        
        return CLLocation(latitude: (mlat * 180 / Double.pi), longitude: (mlong * 180 / Double.pi))
    }
    
    /// : Calculate the half-way point along a great circle path between self and another points.
    ///
    /// - Parameter point: End location.
    /// - Returns: Location that represents the half-way point.
    func midLocation(to point: CLLocation) -> CLLocation {
        return CLLocation.midLocation(start: self, end: point)
    }
    
    /// : Calculates the bearing to another CLLocation.
    ///
    /// - Parameters:
    ///   - destination: Location to calculate bearing.
    /// - Returns: Calculated bearing degrees in the range 0° ... 360°
    func bearing(to destination: CLLocation) -> Double {
        //http://stackoverflow.com/questions/3925942/cllocation-category-for-calculating-bearing-w-haversine-function
        let lat1 = Double.pi * coordinate.latitude / 180.0
        let long1 = Double.pi * coordinate.longitude / 180.0
        let lat2 = Double.pi * destination.coordinate.latitude / 180.0
        let long2 = Double.pi * destination.coordinate.longitude / 180.0
        
        //Formula: θ = atan2( sin Δλ ⋅ cos φ2 , cos φ1 ⋅ sin φ2 − sin φ1 ⋅ cos φ2 ⋅ cos Δλ )
        //Source: http://www.movable-type.co.uk/scripts/latlong.html
        
        let rads = atan2(sin(long2 - long1) * cos(lat2),
                         cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(long2 - long1))
        let degrees = rads * 180 / Double.pi
        
        return (degrees+360).truncatingRemainder(dividingBy: 360)
    }
    
}
@IBDesignable
class CustomSlider: UISlider {
    /// custom slider track height
    @IBInspectable var trackHeight: CGFloat = 3
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Use properly calculated rect
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
}

extension UIButton {
    @IBInspectable var bgImgColor: UIColor? {
        get {
            return self.bgImgColor
        }
        set {
            self.setBackgroundColor(color: newValue ?? UIColor.clear, forUIControlState: .normal)
        }
    }
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
    
    func setBackgroundColor(color: UIColor, forUIControlState state: UIControl.State) {
        self.setBackgroundImage(imageWithColor(color: color), for: state)
    }
}

//MARK:- Search bar
extension UISearchBar {
    
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    func setText(color: UIColor) { if let textField = getTextField() { textField.textColor = color } }
    func setPlaceholderText(color: UIColor) { getTextField()?.setPlaceholderText(color: color) }
    func setClearButton(color: UIColor) { getTextField()?.setClearButton(color: color) }
    
    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }
    
    func setSearchImage(color: UIColor) {
        guard let imageView = getTextField()?.leftView as? UIImageView else { return }
        imageView.tintColor = color
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
    }
    func setSearchImage(img: UIImage) {
        guard let imageView = getTextField()?.leftView as? UIImageView else { return }
        imageView.frame = CGRect(x: imageView.x, y: imageView.y, width: 20, height: 20)
        imageView.image = img.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = tintColor
    }
}
//MARK:- Search bar UITextField
extension UITextField {
    
    private class ClearButtonImage {
        static private var _image: UIImage?
        static private var semaphore = DispatchSemaphore(value: 1)
        static func getImage(closure: @escaping (UIImage?)->()) {
            DispatchQueue.global(qos: .userInteractive).async {
                semaphore.wait()
                DispatchQueue.main.async {
                    if let image = _image { closure(image); semaphore.signal(); return }
                    guard let window = UIApplication.shared.windows.first else { semaphore.signal(); return }
                    let searchBar = UISearchBar(frame: CGRect(x: 0, y: -200, width: UIScreen.main.bounds.width, height: 44))
                    window.rootViewController?.view.addSubview(searchBar)
                    searchBar.text = "txt"
                    searchBar.layoutIfNeeded()
                    _image = searchBar.getTextField()?.getClearButton()?.image(for: .normal)
                    closure(_image)
                    searchBar.removeFromSuperview()
                    semaphore.signal()
                }
            }
        }
    }
    
    func setClearButton(color: UIColor) {
        ClearButtonImage.getImage { [weak self] image in
            guard   let image = image,
                let button = self?.getClearButton() else { return }
            button.imageView?.tintColor = color
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    func setPlaceholderText(color: UIColor) {
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [.foregroundColor: color])
    }
    
    func getClearButton() -> UIButton? { return value(forKey: "clearButton") as? UIButton }
}
extension UserDefaults {
    
    func save<T:Encodable>(customObject object: T, inKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            self.set(encoded, forKey: key)
        }
    }
    
    func retrieve<T:Decodable>(object type:T.Type, fromKey key: String) -> T? {
        if let data = self.data(forKey: key) {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(type, from: data) {
                return object
            } else {
                print("Couldnt decode object")
                return nil
            }
        } else {
            print("Couldnt find key")
            return nil
        }
    }
    
}
extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}
//MARK:- Btn Action
typealias UIButtonTargetClosure = (UIButton) -> ()

class ClosureWrapper: NSObject {
    let closure: UIButtonTargetClosure
    init(_ closure: @escaping UIButtonTargetClosure) {
        self.closure = closure
    }
}

extension UIButton {
    
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIButtonTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func action(closure: @escaping UIButtonTargetClosure) {
        targetClosure = closure
        addTarget(self, action: #selector(UIButton.closureAction), for: .touchUpInside)
    }
    
    @objc func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }
}
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
//MARK:- Cell animation
enum ScrollDirection {
    case up
    case down
}
extension UIView
{
    func cell3DCardAnimate(_ scrollDirection: ScrollDirection = .down){
        //1. Setup the CATransform3D structure
        var rotation = CATransform3D()
        switch scrollDirection {
        case .up:
            rotation = CATransform3DMakeRotation((270.0 * .pi) / 180, 0.0, 0.7, 0.4)
        case .down:
            rotation = CATransform3DMakeRotation((90.0 * .pi) / 180, 0.0, 0.7, 0.4)
        }
        rotation.m34 = 1.0 / -600
        //2. Define the initial state (Before the animation)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: CGFloat(10), height: CGFloat(10))
        self.alpha = 0
        self.layer.transform = rotation
        self.layer.anchorPoint = CGPoint(x: CGFloat(0), y: CGFloat(0.5))
        //!!!FIX for issue #1 Cell position wrong————
        //        if cell.layer.position.x != 0 {
        self.layer.position = CGPoint(x: CGFloat(0), y: CGFloat(self.layer.position.y))
        //        }
        //3. Define the final state (After the animation) and commit the animation
//        UIView.beginAnimations("rotation", context: nil)
//        UIView.setAnimationDuration(0.5)
        UIView.animate(withDuration: 0.5) {
            self.layer.transform = CATransform3DIdentity
            self.alpha = 1
            self.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(0))
        }
//        UIView.commitAnimations()
    }
    func cellSlideAnimation(_ indexPath:IndexPath) {
        if indexPath.row % 2 == 0 {
            self.frame = CGRect(x: self.w, y: self.y, width: self.w, height: self.h)
            UIView.animate(withDuration: 0.5) {
                self.frame = CGRect(x: 0, y: self.y, width: self.w, height: self.h)
            }
        } else {
            self.frame = CGRect(x: -self.w, y: self.y, width: self.w, height: self.h)
            UIView.animate(withDuration: 0.5) {
                self.frame = CGRect(x: 0, y: self.y, width: self.w, height: self.h)
            }
        }
    }
    func cellScaleAnimation() {
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.25,animations: {
            self.transform = CGAffineTransform.identity
        },completion: { _ in
            
        })
    }
}

extension UIProgressView {

    @IBInspectable var barHeight : CGFloat {
        get {
            return transform.d * 2.0
        }
        set {
            // 2.0 Refers to the default height of 2
            let heightScale = newValue / 2.0
            let c = center
            transform = CGAffineTransform(scaleX: 1.0, y: heightScale)
            center = c
        }
    }
}

extension Encodable {
    /// Converting object to postable dictionary
    func toDictionary(_ encoder: JSONEncoder = JSONEncoder()) throws -> [String: Any] {
        let data = try encoder.encode(self)
        let object = try JSONSerialization.jsonObject(with: data)
        guard let json = object as? [String: Any] else {
            let context = DecodingError.Context(codingPath: [], debugDescription: "Deserialized object is not a dictionary")
            throw DecodingError.typeMismatch(type(of: object), context)
        }
        return json
    }
    
    func toArray(_ encoder: JSONEncoder = JSONEncoder()) throws -> [Any] {
        let data = try encoder.encode(self)
        let object = try JSONSerialization.jsonObject(with: data)
        guard let json = object as? [Any] else {
            let context = DecodingError.Context(codingPath: [], debugDescription: "Deserialized object is not a dictionary")
            throw DecodingError.typeMismatch(type(of: object), context)
        }
        return json
    }
}
extension Decodable {
    /// Converting dictionary to Decodable object
    static func decode(from dictionary: [String: Any], _ decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        return try decoder.decode(Self.self, from: data)
    }
}

//MARK:- UIPanGestureRecognizer Direction
public enum PanDirection: Int {
    case up, down, left, right
    public var isVertical: Bool { return [.up, .down].contains(self) }
    public var isHorizontal: Bool { return !isVertical }
}
public extension UIPanGestureRecognizer {

   var direction: PanDirection? {
        let velocity = self.velocity(in: view)
        let isVertical = abs(velocity.y) > abs(velocity.x)
        switch (isVertical, velocity.x, velocity.y) {
        case (true, _, let y) where y < 0: return .up
        case (true, _, let y) where y > 0: return .down
        case (false, let x, _) where x > 0: return .right
        case (false, let x, _) where x < 0: return .left
        default: return nil
        }
    }
}

extension UIPageViewController {
    var isPagingEnabled: Bool {
        get {
            var isEnabled: Bool = true
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    isEnabled = subView.isScrollEnabled
                }
            }
            return isEnabled
        }
        set {
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = newValue
                }
            }
        }
    }
}

extension String {
    func sortName() -> String {
        var str = String()
        let arr = self.trimmed.components(separatedBy: " ")
        
        if arr.count >= 2 {
            str = "\(arr[0].first ?? " ")".capitalized + "\(arr[1].first ?? " ")".capitalized
        } else if arr.count == 1 {
            str = "\(arr[0].first ?? " ")".capitalized + "\(arr[0].dropFirst().first ?? " ")".capitalized
        }
        return str
    }
    
    func image(with textColor: UIColor = .black, bgColor: UIColor = .Yellow()) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = bgColor//.lightGray
        nameLabel.textColor = textColor
        nameLabel.font = UIFont.poppinsTextMedium(size: 88)
        nameLabel.text = self
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return nameImage
        }
        return nil
    }
}


extension UILabel {

    @IBInspectable var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            } else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }
            attributedString.addAttribute(NSAttributedString.Key.kern,
                                           value: newValue,
                                           range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }

        get {
            if let currentLetterSpace = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            } else {
                return 0
            }
        }
    }
}

extension UIButton {

    @IBInspectable var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = titleLabel?.attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            } else {
                attributedString = NSMutableAttributedString(string: titleLabel?.text ?? "")
                setTitle(nil, for: .normal)
            }
            attributedString.addAttribute(NSAttributedString.Key.kern,
                                           value: newValue,
                                           range: NSRange(location: 0, length: attributedString.length))
            setAttributedTitle(attributedString, for: .normal)
        }

        get {
            if let currentLetterSpace = titleLabel?.attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            } else {
                return 0
            }
        }
    }
}

extension BehaviorRelay where Element: RangeReplaceableCollection {

    func add(_ element: Element.Element) {
        var array = self.value
        array.append(element)
        self.accept(array)
    }
    
    func add(_ elements: [Element.Element]) {
        var array = self.value
        array.append(contentsOf: elements)
        self.accept(array)
    }
    
    func remove(at: Element.Index) {
        var array = self.value
        array.remove(at: at)
        self.accept(array)
    }
    func replace(_ element: Element.Element ,at: Element.Index) {
        var array = self.value
        array.remove(at: at)
        array.append(element)
        self.accept(array)
    }

}
extension BehaviorRelay where Element: RangeReplaceableCollection, Element.Element: Equatable {

    
    func remove(_ element: Element.Element) {
        var array = self.value
        if let index = array.firstIndex(of: element) {
            array.remove(at: index)
            self.accept(array)
        }
        
    }
    
}
