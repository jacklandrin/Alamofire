//
//  UI.swift
//  Alamofire
//
//  Created by jack on 15/6/18.
//  Copyright (c) 2015年 Alamofire. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    public func setImageForState(state:UIControlState,url:URLStringConvertible) {
        setImageForState(state, url: url, placeholderImage: nil)
    }
    
    public func setImageForState(state:UIControlState,url:URLStringConvertible,placeholderImage:UIImage?) {
        setImageForState(state, url: url, placeholderImage: placeholderImage, success: nil, failure: nil)
    }
    
    public func setImageForState(state:UIControlState,url:URLStringConvertible,placeholderImage:UIImage?,success:((image:UIImage) -> Void)?,failure:((error:NSError)->Void)?){
        Alamofire.request(.GET,url).response{ (_,_,data,error) -> Void in
            if error == nil {
                let image = UIImage(data: data! as! NSData)
                self.setImage(image, forState: state)
                if success != nil {
                    success!(image: image!)
                }
            } else {
                self.setImage(placeholderImage, forState: state)
                if failure != nil {
                    failure!(error: error!)
                }
            }
        }
    }
    
    
    
    
    public func setBackgroundImageForState(state:UIControlState,url:URLStringConvertible) {
        setBackgroundImageForState(state, url: url, placeholderImage: nil)
    }
    
    public func setBackgroundImageForState(state:UIControlState,url:URLStringConvertible,placeholderImage:UIImage?) {
        setBackgroundImageForState(state, url: url, placeholderImage: placeholderImage, success: nil, failure: nil)
    }
    
    public func setBackgroundImageForState(state:UIControlState,url:URLStringConvertible,placeholderImage:UIImage?,success:((image:UIImage) -> Void)?,failure:((error:NSError) -> Void)?){
        Alamofire.request(.GET,url).response{ (_,_,data,error) -> Void in
            if error == nil {
                let image = UIImage(data: data! as! NSData)
                self.setBackgroundImage(image, forState: state)
                if success != nil {
                    success!(image: image!)
                }
            } else {
                self.setBackgroundImage(placeholderImage, forState: state)
                if failure != nil {
                    failure!(error: error!)
                }
            }
            
        }
    }
}