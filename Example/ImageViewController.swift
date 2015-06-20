//
//  ImageViewController.swift
//  iOS Example
//
//  Created by jack on 15/6/20.
//  Copyright (c) 2015年 Alamofire. All rights reserved.
//

import UIKit
import Alamofire

class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.setImageWithURLRequest("http://static.cnbetacdn.com/article/2015/0620/0382833fd2f3d37.jpg", placeholderImage: UIImage(named: "Logo"), success: { (image) -> Void in
            
        }, failure: { (error) -> Void in
            print("\(error)")
        })
    }
}
