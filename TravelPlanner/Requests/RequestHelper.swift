//
//  RequestHelper.swift
//  TravelPlanner
//
//  Created by Adriana Elizondo on 10/23/16.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import UIKit

private let baseUrl = "https://api.myjson.com/bins/"

class RequestHelper{
    typealias RequestResponse = (Bool, Any?, Error?) -> Void
    
    static func getDataWithDomain(domain: String, completion: RequestResponse){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let session = URLSession.init(configuration: URLSessionConfiguration.default)
        
        guard let url = URL.init(string: baseUrl+domain) else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return
        }
        
        session.dataTask(with: URLRequest.init(url: url)) { (data, response, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let code = (response as? HTTPURLResponse)?.statusCode , 200...299 ~= code{
                    completion(true, json, nil)
                }else{
                    completion(false, nil, error)
                }
            }
        }.resume()
    }
}
