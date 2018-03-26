//
//  DataController.swift
//  DeltaAsignment
//
//  Created by A1P5KF3Z on 3/20/18.
//  Copyright © 2018 raj. All rights reserved.
//

import Foundation
import UIKit

class DataController{
    
    func makeRequest(handler:@escaping (Bool,NSMutableArray?) -> Void){
        let networkController = NetworkController.init()
        networkController.makeRequest(url: Constants.API_URL){(status,responseData) in
            let mainQueue = OperationQueue.main
            if status {
                do{
                    self.saveDownloadedData(jsonData: responseData!)
                    
                    let jsonArrayData = try JSONSerialization.jsonObject(with: responseData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    let userDetails =  self.parseJsonData(arrayData: jsonArrayData)
                    
                    mainQueue.addOperation {
                        handler(true,userDetails)
                    }
                } catch {
                    print("Error in parsing, retrieveing data from cache")
                    let userDetailsArray = self.retrieveSavedData()
                    if userDetailsArray == nil {
                        mainQueue.addOperation {
                            handler(false,nil)
                        }
                    }else{
                        mainQueue.addOperation {
                            handler(true,userDetailsArray! )
                        }
                    }
                }
            }else{
                print("Error in Connection, retrieveing data from cache")
                let userDetailsArray = self.retrieveSavedData()
                if userDetailsArray == nil {
                    mainQueue.addOperation {
                        handler(false,nil)
                    }
                }else{
                    mainQueue.addOperation {
                        handler(true,userDetailsArray! )
                    }
                }
            }
        }
    }
    
    func downloadImage(url:String,indexPath:IndexPath,imageDataCallbackHandler:@escaping(UIImage,IndexPath)-> Void){
        let mainQueue = OperationQueue.main
        if let cachedImage:UIImage = ImageCaching.getInstance().getCachedImage(withUrl: url){
            mainQueue.addOperation {
                imageDataCallbackHandler(cachedImage,indexPath)
            }
        }else{
            let networkController = NetworkController.init()
            networkController.makeRequest(url: url) { (status,imageData) in
                if status {
                    let image = UIImage.init(data: imageData!)
                    ImageCaching.getInstance().cacheImage(imageUrl: url, image: image!)
                    mainQueue.addOperation {
                        imageDataCallbackHandler(image!,indexPath)
                    }
                }
            }
        }
    }
    
    func parseJsonData(arrayData:NSArray)->NSMutableArray{
        let userDetailModalsArray:NSMutableArray = NSMutableArray.init()
        for value in 0...arrayData.count - 1{
            let userData:NSDictionary = arrayData.object(at: value) as! NSDictionary
            let id = userData.value(forKey: "id") as! Int
            let name = userData.value(forKey: "name") as! String
            let createdAt = userData.value(forKey: "created_at") as! String
            let updatedAt = userData.value(forKey: "updated_at") as! String
            let email = userData.value(forKey: "email") as! String
            let imageUrl = userData.value(forKey: "image") as! String
            
            let userDetailModal = UserDetailsModal.init(id: id, createdAt: createdAt, updatedAt: updatedAt, name: name, email: email, imageUrl: imageUrl,image: nil)
            userDetailModalsArray.add(userDetailModal)
        }
        return userDetailModalsArray
    }
    
    func saveDownloadedData(jsonData:Data){
        let stringData = String.init(data: jsonData, encoding: String.Encoding.utf8)
        Utility.saveDataToFile(data: stringData!)
    }
    
    func retrieveSavedData()->NSMutableArray!{
        
        let cacheDataString = Utility.readDataFromFile()
        let cacheData = cacheDataString.data(using: String.Encoding.utf8)
        do{
            let jsonArrayData = try JSONSerialization.jsonObject(with: cacheData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
            let userDetails =  self.parseJsonData(arrayData: jsonArrayData)
            return userDetails
        }catch{
            return nil
        }
    }
    
    
}
