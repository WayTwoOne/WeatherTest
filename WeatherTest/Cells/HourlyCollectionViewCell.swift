//
//  HourlyCollectionViewCell.swift
//  WeatherTest
//
//  Created by Vladimir on 13.12.2023.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configur(with data: DailyWeatherList?) {
        
        hourLabel.text = "\(correctDate(from: data?.dtTxt))"
        currentTemperatureLabel.text = "\(Int(data?.main.temp ?? 0.0))º"
        
        data?.weather.forEach { main in
            switch main.main {
            case .clear:
                iconImageView.image = UIImage(named: "sunny")
            case .clouds:
                iconImageView.image = UIImage(named: "cloud")
            case .rain:
                iconImageView.image = UIImage(named: "rain")
            }
        }
    }
    
    private func correctDate(from string: String?) -> String {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH"
        
        guard let date = dateFormatterGet.date(from: string ?? "") else { return ""}
        
        return dateFormatterPrint.string(from: date)
    }
    
    static let identifier = "HourlyCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "HourlyCollectionViewCell", bundle: nil)
    }

}
