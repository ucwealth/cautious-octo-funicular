//
//  ViewController.swift
//  WeatherApp
//
//  Created by Decagon on 23/04/2021.
//
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var table: UITableView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var topTemp: UILabel!
    @IBOutlet weak var topDesc: UILabel!
    
    var models = [dailyWeather]()
    var currentWeather = [currentWeatherObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.register(WeatherTableViewCell.Nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        requestWeatherForLocation()
    }
    
    // Fetch Api data
    func requestWeatherForLocation(){
        
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=6.020&lon=6.915&exclude=minutely,hourly&appid=f67c7bca234119325128bab94e8f7dbc&units=metric"
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            
            //Validation
            guard let data = data, error == nil else {
                print("Something went wrong")
                return
            }
            
            //convert data to models
            var json: WeatherResponse?
            do {
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
            } catch {
                print("Error: \(error)")
            }
            
            guard let result = json else {
                return
            }
            
            let dailyEntries = result.daily
            self.models.append(contentsOf: dailyEntries)
            
            let currentEntry = result.current
            self.currentWeather.append(currentEntry)
            
            //update UI
            DispatchQueue.main.async {
                self.table.reloadData()
                self.topTemp.text = "\(Int(self.currentWeather[0].temp))°"
                self.topDesc.text = self.currentWeather[0].weather[0].description

                if (( self.topDesc.text?.contains("clouds") ) != nil) {
                    let backgroundImageView = UIImageView(image: UIImage(named: "forest_cloudy"))
                    backgroundImageView.frame = self.topView.frame
                    backgroundImageView.contentMode = .scaleAspectFill
                    self.topView.addSubview(backgroundImageView)
                    self.topView.sendSubviewToBack(backgroundImageView)
                }
                
                self.table.tableHeaderView = self.createTableHeader()
            }
        }).resume()
    }
    
    //Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    //Table Header
    func createTableHeader() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 70))
        
        let border = UIView(frame: CGRect(x: 0,y: 70,width: self.view.bounds.width,height: 1))
        border.backgroundColor = .white
        headerView.addSubview(border)
        
        let minLabel = UILabel(frame: CGRect(x: 20, y: 10, width: view.frame.size.width/3, height: 70))
        let currentLabel = UILabel(frame: CGRect(x: 40+(view.frame.size.width/3), y: 10, width: view.frame.size.width/3, height: 70))
        let maxLabel = UILabel(frame: CGRect(x: 50+(2*(view.frame.size.width/3)), y: 10, width: view.frame.size.width/3, height: 70))
        
        minLabel.text = "\(models[0].temp.min) °"
        minLabel.textColor = .white
        
        currentLabel.text = "\(self.currentWeather[0].temp) °"
        currentLabel.textColor = .white
        
        maxLabel.text = "\(models[0].temp.max) °"
        maxLabel.textColor = .white

        headerView.addSubview(minLabel)
        headerView.addSubview(currentLabel)
        headerView.addSubview(maxLabel)
        return headerView
    }

}


