//
//  UIImageView+Alamowater.swift
//  Alamofire
//
//  Created by jack on 15/6/17.
//  Copyright (c) 2015年 Alamofire. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol AWImageCacheProtocol{
    /**
    Returns a cached image for the specififed request, if available.
    
    @param request The image request.
    
    @return The cached image.
    */
    func cachedImageForRequest(request:NSURLRequest) -> UIImage?;
    
    /**
    Caches a particular image for the specified request.
    
    @param image The image to cache.
    @param request The request to be used as a cache key.
    */
    func cacheImage(image:UIImage!,request:NSURLRequest!);
}

class AWImageCache: NSCache,AWImageCacheProtocol {
    
    func cachedImageForRequest(request: NSURLRequest) -> UIImage?{
        switch request.cachePolicy {
        case .ReloadIgnoringLocalCacheData:
            let a = 0
        case .ReloadIgnoringLocalAndRemoteCacheData:
            return nil
        default:
            break
        }
        return objectForKey(AWImageCacheKeyFromURLRequest(request)) as? UIImage
    }
    
    func cacheImage(image: UIImage!, request: NSURLRequest!) {
        setObject(image, forKey: AWImageCacheKeyFromURLRequest(request))
    }
    
    
    func AWImageCacheKeyFromURLRequest(request:NSURLRequest) -> NSString {
        return request.URL!.absoluteString!
    }
}



extension UIImageView {
    
    
    class func aw_sharedImageRequestOperationQueue() -> NSOperationQueue {
        struct Static {
            static var _aw_shareImageRequestOperationQueue:NSOperationQueue? = nil
            static var onceToken:dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken, { () -> Void in
            Static._aw_shareImageRequestOperationQueue = NSOperationQueue()
            Static._aw_shareImageRequestOperationQueue?.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount
        })
        return Static._aw_shareImageRequestOperationQueue!
    }
    
    var aw_imageRequestOperation:Request?{
        get {
            return objc_getAssociatedObject(self, "aw_imageRequestOperation") as? Request
        }
        set(newValue){
            objc_setAssociatedObject(self, "aw_imageRequestOperation", newValue, UInt(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    
    class var sharedImageCache:AWImageCache? {
        struct Static {
            static var onceToken:dispatch_once_t = 0
            static var instance:AWImageCache? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = AWImageCache()
            
            NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidReceiveMemoryWarningNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
                Static.instance?.removeAllObjects()
            })
        }
        return (objc_getAssociatedObject(self, "sharedImageCache") as? AWImageCache != nil) ? nil : Static.instance
    }
    
//    var imageResponseSerializer:Request{
//        get{
//            struct Static {
//                static var onceToken:dispatch_once_t = 0
//                static var instance:Request? = nil
//            }
//            
////            dispatch_once(&Static.onceToken, { () -> Void in
////                 Static.instance = Request.responseDataSerializer()
////            })
//            
//            return ((objc_getAssociatedObject(self, "imageResponseSerializer") as? Request != nil) ? nil : Static.instance)!
//        }
//        set (newValue){
//            objc_setAssociatedObject(self, "imageResponseSerializer", newValue, UInt(OBJC_ASSOCIATION_RETAIN))
//        }
//    }
    /**
    Asynchronously downloads an image from the specified URL, and sets it once the request is finished. Any previous image request for the receiver will be cancelled.
    
    If the image is cached locally, the image is set immediately, otherwise the specified placeholder image will be set immediately, and then the remote image will be set once the request is finished.
    
    By default, URL requests have a `Accept` header field value of "image / *", a cache policy of `NSURLCacheStorageAllowed` and a timeout interval of 30 seconds, and are set not handle cookies. To configure URL requests differently, use `setImageWithURLRequest:placeholderImage:success:failure:`
    
    @param url The URL used for the image request.
    */
    
    
    public func setImageWithURL(url:NSURL){
        setImageWithURL(url, placeholderImage: nil)
    }
    
    /**
    Asynchronously downloads an image from the specified URL, and sets it once the request is finished. Any previous image request for the receiver will be cancelled.
    
    If the image is cached locally, the image is set immediately, otherwise the specified placeholder image will be set immediately, and then the remote image will be set once the request is finished.
    
    By default, URL requests have a `Accept` header field value of "image / *", a cache policy of `NSURLCacheStorageAllowed` and a timeout interval of 30 seconds, and are set not handle cookies. To configure URL requests differently, use `setImageWithURLRequest:placeholderImage:success:failure:`
    
    @param url The URL used for the image request.
    @param placeholderImage The image to be set initially, until the image request finishes. If `nil`, the image view will not change its image until the image request finishes.
    */
    public func setImageWithURL(url:NSURL,placeholderImage:UIImage?){
//        let request = NSMutableURLRequest(URL: url)
//        request .addValue("image/*", forHTTPHeaderField: "Accept")
        setImageWithURLRequest(url, placeholderImage: placeholderImage, success: nil, failure: nil)
    }
    
    /**
    Asynchronously downloads an image from the specified URL request, and sets it once the request is finished. Any previous image request for the receiver will be cancelled.
    
    If the image is cached locally, the image is set immediately, otherwise the specified placeholder image will be set immediately, and then the remote image will be set once the request is finished.
    
    If a success block is specified, it is the responsibility of the block to set the image of the image view before returning. If no success block is specified, the default behavior of setting the image with `self.image = image` is applied.
    
    @param urlRequest The URL request used for the image request.
    @param placeholderImage The image to be set initially, until the image request finishes. If `nil`, the image view will not change its image until the image request finishes.
    @param success A block to be executed when the image request operation finishes successfully. This block has no return value and takes three arguments: the request sent from the client, the response received from the server, and the image created from the response data of request. If the image was returned from cache, the request and response parameters will be `nil`.
    @param failure A block object to be executed when the image request operation finishes unsuccessfully, or that finishes successfully. This block has no return value and takes three arguments: the request sent from the client, the response received from the server, and the error object describing the network or parsing error that occurred.
    */
    public func setImageWithURLRequest(URLString: URLStringConvertible,placeholderImage:UIImage?,success:((image:UIImage)-> Void)?,failure:((error:NSError) -> Void)?){
        cancelImageRequestOperation()
//        let request = NSMutableURLRequest(URL: URLString as! NSURL)
//        request.addValue("image/*", forHTTPHeaderField: "Accept")
//        let cacheImage = UIImageView.sharedImageCache!.cachedImageForRequest(request)
//        if cacheImage != nil {
//            if (success != nil) {
//                success!(image: cacheImage!)
//            } else {
//                image = cacheImage
//            }
//            self.aw_imageRequestOperation = nil
//        } else {
            if placeholderImage != nil {
                self.image = placeholderImage
            }
            //weak var weakSelf:UIImageView? = self
            Alamofire.request(.GET,URLString).response{ (_,_,data,erro) -> Void in
                
                if erro == nil {
                    
                    let image = UIImage(data: data! as! NSData)
                    self.image = image
                    if success != nil {
                        success!(image:image!)
                    }
//                    UIImageView.sharedImageCache!.cachedImageForRequest(request)
                } else {
                    self.image = placeholderImage
                    if failure != nil {
                        failure!(error:erro!)
                    }
                }
                
            }
//        }
        
        
    }
    /**
    Cancels any executing image operation for the receiver, if one exists.
    */
    public func cancelImageRequestOperation(){
        self.aw_imageRequestOperation?.cancel()
        self.aw_imageRequestOperation = nil
    }
    
    
}