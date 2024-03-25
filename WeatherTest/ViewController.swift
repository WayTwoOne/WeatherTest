//
//  ViewController.swift
//  WeatherTest
//
//  Created by Vladimir on 13.12.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    private var currentWeatherData: CurrentWeatherWelcome?
    private var dailyWeatherData: DailyWeatherWelcome?
    
    @IBOutlet weak var myLocationLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentDescriptionLabel: UILabel!
    @IBOutlet weak var minAndMaxTemperatureLabel: UILabel!
    
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var weatherTableView: UITableView!
    
    var manager: CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
        weatherCollectionView.register(HourlyCollectionViewCell.nib(), forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.register(DailyTableViewCell.nib(), forCellReuseIdentifier: DailyTableViewCell.identifier)
        
        view.backgroundColor = UIColor(red: 46/255, green: 60/255, blue: 180/255, alpha: 1.0)
        weatherCollectionView.backgroundColor = UIColor(red: 46/255, green: 60/255, blue: 180/255, alpha: 1.0)
        weatherTableView.backgroundColor = UIColor(red: 46/255, green: 60/255, blue: 180/255, alpha: 1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }
    
    @IBAction func RuEngPressed() {
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else { return }
        
        fetchCurrentWeatherData(with: "https://api.openweathermap.org/data/2.5/weather?lat=\(first.coordinate.latitude)&lon=\(first.coordinate.longitude)&введите свой ключ")
        
        fetchDailyWeatherData(with: "https://api.openweathermap.org/data/2.5/forecast?lat=\(first.coordinate.latitude)&lon=\(first.coordinate.longitude)&введите свой ключ")
    }


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sortedWeather(with: dailyWeatherData, and: "hour").count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as! HourlyCollectionViewCell
        cell.configur(with: sortedWeather(with: dailyWeatherData, and: "hour")[indexPath.item])
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedWeather(with: dailyWeatherData, and: "day").count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.identifier, for: indexPath) as! DailyTableViewCell
        cell.configur(with: sortedWeather(with: dailyWeatherData, and: "day")[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}

extension ViewController {
    private func fetchCurrentWeatherData(with url: String) {
        NetworkManager.shared.fetch(CurrentWeatherWelcome.self, from: url) { [weak self] result in
            switch result {
            case .success(let currentWeather):
                self?.currentWeatherData = currentWeather
                self?.textInLabels()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchDailyWeatherData(with url: String) {
        NetworkManager.shared.fetch(DailyWeatherWelcome.self, from: url) { [weak self] result in
            switch result {
            case .success(let dailyWeather):
                self?.dailyWeatherData = dailyWeather
                self?.weatherCollectionView.reloadData()
                self?.weatherTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func textInLabels() {
        myLocationLabel.text = "My Location"
        currentLocationLabel.text = currentWeatherData?.name
        currentTemperatureLabel.text = "\(Int(currentWeatherData?.main.temp ?? 0.0))º"
        currentWeatherData?.weather.forEach({ currentMain in
            currentDescriptionLabel.text = currentMain.main
        })
        
        minAndMaxTemperatureLabel.text = "L:\(Int(currentWeatherData?.main.tempMin ?? 0.0))º H:\(Int(currentWeatherData?.main.tempMax ?? 0.0))º"
    }
    
    private func sortedWeather(with model: DailyWeatherWelcome?, and how: String) -> [DailyWeatherList?] {
        
        var newArray: [DailyWeatherList?] = []
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "HH"
         
        if how == "hour" {
            for h in 0..<7 {
                    if newArray.isEmpty {
                        newArray.append(model?.list[h])
                    } else {
                        
                        let dateInArray = dateFormatterGet.date(from: newArray.last??.dtTxt ?? "")
                        let dateInDay = dateFormatterGet.date(from: model?.list[h].dtTxt ?? "")
                        
                        let stringInArray = dateFormatterPrint.string(from: dateInArray ?? Date())
                        let stringInDay = dateFormatterPrint.string(from: dateInDay ?? Date())
                        
                        if stringInDay != stringInArray {
                            newArray.append(model?.list[h])
                        }
                    }
                }
        } else if how == "day" {
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "EEEE"
            
            for d in 0..<(model?.list.count ?? 10) {
                    if newArray.isEmpty {
                        newArray.append(model?.list[d])
                    } else {
                        
                        let dateInArray = dateFormatterGet.date(from: newArray.last??.dtTxt ?? "")
                        let dateInDay = dateFormatterGet.date(from: model?.list[d].dtTxt ?? "")
                        
                        let stringInArray = dateFormatterPrint.string(from: dateInArray ?? Date())
                        let stringInDay = dateFormatterPrint.string(from: dateInDay ?? Date())
                        
                        if stringInDay != stringInArray {
                            newArray.append(model?.list[d])
                        }
                    }
                }
        }
        return newArray
        }
}
