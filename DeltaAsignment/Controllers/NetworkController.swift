//
//  NetworkController.swift
//  DeltaAsignment
//
//  Created by A1P5KF3Z on 3/22/18.
//  Copyright © 2018 raj. All rights reserved.
//

import Foundation
class NetworkController {
    
    func makeRequest(url:String ,completionHandler: @escaping (Bool,Data?)->Void){
        if Reachability.isConnectedToNetwork() {
            let urlSession = URLSession.init(configuration: URLSessionConfiguration.default)
            let urlRequest = URLRequest.init(url: URL.init(string:url)!)
            let urlSessionDataTask = urlSession.dataTask(with: urlRequest) { (data, response, err) in
                if err == nil && data != nil{
                    completionHandler(true,data!)
                }else{
                    completionHandler(false,nil)
                }
            }
            urlSessionDataTask.resume()
        } else{
            completionHandler(false,nil)
        }
    }
}
