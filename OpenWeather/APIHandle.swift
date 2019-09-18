//
//  APIHandle.swift
//  OpenWeather
//
//  Created by Rambo on 9/18/19.
//  Copyright © 2019 Rambo. All rights reserved.
//

import Foundation


class APIHandle {
    
    static let shared = APIHandle()
    
    
    func fetchWeatherData(url: URL, completion: ((WeatherInfoModel?) -> Void)?) {
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if(err != nil){
                print("Error")
                return
            }
            
            let response = res as? HTTPURLResponse
            
            if(response?.statusCode != 200){
                print("Connection Corupted")
                return
            }
            
            
            do {
                let location = try JSONDecoder().decode(WeatherInfoModel.self, from: data!)
                completion?(location)
            } catch {
                print("Some Error Occured: \(error)")
                completion?(nil)
            }
            
            }.resume()
    }
    
    
    
}
