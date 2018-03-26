//
//  Utility.swift
//  DeltaAsignment
//
//  Created by A1P5KF3Z on 3/22/18.
//  Copyright © 2018 raj. All rights reserved.
//

import Foundation
class Utility  {
    
    class func saveDataToFile(data:String){
        
        let dir = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
        let fileDirectory = dir?.appendingPathComponent(Constants.CACHE_FILE_NAME)
        do {
            try data.write(to: fileDirectory!, atomically: true, encoding: String.Encoding.utf8)
        }catch{
            
        }
    }
    
    class func readDataFromFile() -> String{
        
        do {
            let dir = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
            let fileDirectory = dir?.appendingPathComponent(Constants.CACHE_FILE_NAME)
            let data = try Data.init(contentsOf: fileDirectory!)
            let stringData = String.init(data: data, encoding: String.Encoding.utf8)
            return stringData!
        } catch{
            return ""
        }
    }
}
