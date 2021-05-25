//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Decagon on 26/04/2021.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor(red: 71/255.0, green: 171/255.0, blue: 47/255.0, alpha: 1.0)
        //47AB2F
        //71, 171, 47
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    static let identifier = "WeatherTableViewCell"
    
    static func Nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    func configure(with model: dailyWeather) {
        self.tempLabel.text = "\(Int(model.temp.day)) °"
        self.tempLabel.textColor = .white
        
        self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(model.dt) ))
        self.dayLabel.textColor = .white
        
        self.iconImage.image = UIImage(named: "clear")
        self.iconImage.tintColor = .white
        self.iconImage.contentMode = .scaleAspectFill
        
        let weatherValues = model.weather[0]
        if weatherValues.main == "Rain" {
            self.iconImage.image = UIImage(named: "rain")
        } else if weatherValues.main == "Cloud" {
            self.iconImage.image = UIImage(named: "cloud")
        } else {
            self.iconImage.image = UIImage(named: "clear")
        }
    }
    
    //format date
    func getDayForDate(_ date: Date?) -> String{
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: inputDate)
    }
}

