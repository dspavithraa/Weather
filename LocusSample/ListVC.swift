//
//  ListVC.swift
//  LocusSample
//
//  Created by Pavi on 15/01/22.
//

import UIKit

class ListVC: UIViewController {
    
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var weatherTable: UITableView!
    @IBOutlet weak var navCityButton: UIButton!
    
    
    var descriptionArr = NSArray()
    var mainArr = NSArray()
    var temperatureArr = NSArray()
    var feelsLikeArr = NSArray()
    
    // parsing data
    var descriptionStr = String()
    var mainStr = String()
    var temperatureStr = String()
    var feelsLikeStr = String()
    var cityName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navCityButton.setTitle("  \(self.cityName)", for: .normal)
        weatherTable.register(UINib(nibName: "weatherCell", bundle: nil), forCellReuseIdentifier: "weatherCell")
    }
    
    @IBAction func navBackButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SegueToDetailsVC") {
            if let detailsVC = segue.destination as? DetailsVC {
                detailsVC.temperatureStr = self.temperatureStr
                detailsVC.descriptionStr = self.descriptionStr
                detailsVC.mainStr = self.mainStr
                detailsVC.feelsLikeStr = self.feelsLikeStr
                detailsVC.cityName = self.cityName
            }
        }
    }
    
}

extension ListVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.temperatureArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! weatherCell
        
        let weather = self.mainArr[indexPath.row] as! NSArray
        cell.weatherLabel.text = "\(weather[0])"
        let kelvinTemp = (self.temperatureArr[indexPath.row]) as! Double
        let celcius = (kelvinTemp - 273.15)  // ----> converting kelvin to celcius
        cell.temperatureLabel.text = "Temp: " + String(format: "%.0f", celcius)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let weather = self.mainArr[indexPath.row] as! NSArray
        self.mainStr = "\(weather[0])"
        
        let kelvinTemp = (self.temperatureArr[indexPath.row]) as! Double
        let celcius = (kelvinTemp - 273.15)  // ----> converting kelvin to celcius
        self.temperatureStr = String(format: "%.0f", celcius)
        
        let kelvin_feelsLike = (self.feelsLikeArr[indexPath.row]) as! Double
        let celcius_feelsLike = (kelvin_feelsLike - 273.15)  // ----> converting kelvin to celcius
        self.feelsLikeStr = String(format: "%.0f", celcius_feelsLike)
        
        let description = (self.descriptionArr[indexPath.row]) as! NSArray
        self.descriptionStr = "\(description[0])"
        
        self.performSegue(withIdentifier: "SegueToDetailsVC", sender: self)
        
    }
    
}
