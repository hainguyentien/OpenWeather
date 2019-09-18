//
//  WeatherViewController.swift
//  OpenWeather
//
//  Created by Rambo on 9/18/19.
//  Copyright © 2019 Rambo. All rights reserved.
//

import UIKit
import SearchTextField

class WeatherViewController: UIViewController {
    @IBOutlet weak var icoWeather: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet var bgrView: UIView!
    @IBOutlet weak var moreInfoView: UIView!
    @IBOutlet weak var txtSearchBar: SearchTextField!
    @IBOutlet weak var lblSunrise: UILabel!
    @IBOutlet weak var lblSunset: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var lblMinTemp: UILabel!
    @IBOutlet weak var lblMaxTemp: UILabel!
    
    let baseUrl = "https://api.openweathermap.org/data/2.5/weather?"
    let authKey = "&units=metric&lang=vi&APPID=0f17a750e711861498dc2d99cd03fa8d"
    var lat: Double = 0
    var lon: Double = 0

    var cityData: [CityModel]?
    var cityName: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        cityData = readJSONFromFile(fileName: "city")
        
        cityName = cityData!.map({ (city) -> String in
            return city.name
        })
        txtSearchBar.filterStrings(cityName!)
        
        moreInfoView.layer.cornerRadius = 20

        lon = 105.166672
        lat = 21.33333

        let fullUrl = URL(string: baseUrl + "lat=\(lat)&lon=\(lon)" + authKey)

        APIHandle.shared.fetchWeatherData(url: fullUrl!) { (weatherInfo) in
            if let tmp = weatherInfo {
                DispatchQueue.main.async {
                    self.processData(weatherInfo: tmp)
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func onEndEditing(_ sender: Any) {
        if cityName!.contains(txtSearchBar.text!){
            if let choosenCity = cityData!.first(where: { (city) -> Bool in
                return city.name == txtSearchBar.text!
            }) {
                lat = choosenCity.coord.lat
                lon = choosenCity.coord.lon
                
                let fullUrl = URL(string: baseUrl + "lat=\(lat)&lon=\(lon)" + authKey)
                print(fullUrl!)
                
                APIHandle.shared.fetchWeatherData(url: fullUrl!) { (weatherInfo) in
                    if let tmp = weatherInfo {
                        print(tmp)
                        DispatchQueue.main.async {
                            self.processData(weatherInfo: tmp)
                        }
                    }
                }
            }
        }
    }
    
    func processData(weatherInfo: WeatherInfoModel) -> Void {
        if(weatherInfo.weather!.count > 0) {
            switch weatherInfo.weather![0].main {
            case "Rain":
                icoWeather.image = UIImage(named: "rain")
            case "Clouds":
                icoWeather.image = UIImage(named: "cloudy")
            default:
                icoWeather.image = UIImage(named: "cloudy")
            }
            lblStatus.text = "Trời " + weatherInfo.weather![0].description!
            let temp = String(Int(weatherInfo.main.temp!))
            lblTemp.text = "\(temp)º"
            lblCity.text = weatherInfo.name!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let sunriseTime = Date(timeIntervalSince1970: weatherInfo.sys!.sunrise!)
            let strSunrise = dateFormatter.string(from: sunriseTime)
            lblSunrise.text = "Sunrise: " + strSunrise
            let sunsetTime = Date(timeIntervalSince1970: weatherInfo.sys!.sunset!)
            let strSunset = dateFormatter.string(from: sunsetTime)
            lblSunset.text = "Sunset: " + strSunset
            lblHumidity.text = "Humidity: \(weatherInfo.main.humidity!)%"
            lblPressure.text = "Pressure: \(weatherInfo.main.pressure!)"
            lblMinTemp.text = "Min Temp.: \(weatherInfo.main.temp_min!)ºC"
            lblMaxTemp.text = "Max Temp.: \(weatherInfo.main.temp_max!)ºC"
            icoWeather.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
    }


    func readJSONFromFile(fileName: String) -> [CityModel]? {
        var json: [CityModel]?
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                json =  try JSONDecoder().decode([CityModel].self, from: data)
            } catch {
                // Handle error here
            }
        }
        return json
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
