//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController
{
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextFled: UITextField!
    
    var weatherManager = WeatherManager()
        let locationManager = CLLocationManager()
     
        override func viewDidLoad() {
            super.viewDidLoad()
     
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
     
            weatherManager.delegate = self
            searchTextFled.delegate = self
        }
     
    }
    extension WeatherViewController: UITextFieldDelegate{
        @IBAction func searchButton(_ sender: UIButton) {
            searchTextFled.endEditing(true)
            print(searchTextFled.text!)
        }
     
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     
            print(searchTextFled.text!)
            searchTextFled.endEditing(true)
            return true
        }
     
        func textFieldDidEndEditing(_ textField: UITextField) {
            if let city = searchTextFled.text{
                weatherManager.fecthWeather(cityName: city)
            }
            searchTextFled.text = ""
        }
     
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            if textField.text != ""{
                return true
            }else{
                textField.placeholder = "Wajib Isi"
                return false
            }
        }
    }
     
    extension WeatherViewController: WeatherManagerDelegate{
     
        func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
            DispatchQueue.main.async {
                self.temperatureLabel.text = weather.temperatureString // suhu
                self.conditionImageView.image = UIImage(systemName: weather.conditionName) //gambar awan
                self.cityLabel.text = weather.cityName // nama kota
     
            }
        }
     
        func didFailWithError(error: Error){
            print(error)
       }
     
    }
     
    extension  WeatherViewController: CLLocationManagerDelegate{
     

    @IBAction func locationPressed(_ sender : UIButton)
    {
        locationManager.requestLocation()
    }
    
    
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
               if let location = locations.last{
                   locationManager.stopUpdatingLocation()
                   let lat = location.coordinate.latitude
                   let lon = location.coordinate.longitude
                   weatherManager.fecthWeather(latitude: lat, longitude: lon)
               }
           }
           func locationManager(_ manager : CLLocationManager, didFailWithError error: Error){
               print(error)
           }

}

