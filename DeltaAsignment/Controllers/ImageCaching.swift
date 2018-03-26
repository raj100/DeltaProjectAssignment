//
//  ImageCaching.swift
//  DeltaAsignment
//
//  Created by A1P5KF3Z on 3/26/18.
//  Copyright © 2018 raj. All rights reserved.
//

import Foundation
import UIKit

class ImageCaching {
    
    static var imageCaching:ImageCaching = ImageCaching.init()
    let imageCacheObject:NSCache<NSString,UIImage> = NSCache<NSString,UIImage>()
    
    class func getInstance()-> ImageCaching{
        return imageCaching
    }
    
    func cacheImage(imageUrl url:String,image:UIImage){
        let sepa = url.split(separator: "/")
        let key = sepa[sepa.count - 2]
        imageCacheObject.setObject(image , forKey: url as NSString)
    }
    
    func getCachedImage(withUrl url:String)-> UIImage?{
        let sepa = url.split(separator: "/")
        let key = sepa[sepa.count - 2]
        let image = imageCacheObject.object(forKey: url as NSString)
        return image
    }
}
