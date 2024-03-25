//
//  DailyTableViewCell.swift
//  WeatherTest
//
//  Created by Vladimir on 13.12.2023.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configur(with data: DailyWeatherList?) {
        contentView.backgroundColor = UIColor(red: 46/255, green: 60/255, blue: 180/255, alpha: 1.0)
        dayLabel.text = correctDate(from: data?.dtTxt)
        minTemperatureLabel.text = "\(Int(data?.main.tempMin ?? 0.0))º"
        maxTemperatureLabel.text = "\(Int(data?.main.tempMax ?? 0.0))º"
        
        iconImageView.contentMode = .scaleAspectFit
        
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
        dateFormatterPrint.dateFormat = "EEEE"
        
        guard let date = dateFormatterGet.date(from: string ?? "") else { return ""}
        
        return dateFormatterPrint.string(from: date)
    }
    
    static let identifier = "DailyTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "DailyTableViewCell", bundle: nil)
    }
    
}
