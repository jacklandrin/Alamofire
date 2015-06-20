//
//  ButtonViewController.swift
//  iOS Example
//
//  Created by jack on 15/6/20.
//  Copyright (c) 2015年 Alamofire. All rights reserved.
//

import UIKit
import Alamofire

class ButtonViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        button.setBackgroundImageForState(UIControlState.Normal, url: "http://static.cnbetacdn.com/article/2015/0620/6a025c7342ee132.jpg", placeholderImage: UIImage(named: "Logo"), success: { (image) -> Void in
            
        }) { (error) -> Void in
            print("\(error)")
        }
        
    }
    @IBOutlet weak var button: UIButton!
}