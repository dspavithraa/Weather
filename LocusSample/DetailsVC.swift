//
//  DetailsVC.swift
//  LocusSample
//
//  Created by Pavi on 15/01/22.
//

import UIKit

class DetailsVC: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var navCityButton: UIButton!
    
    var descriptionStr = String()
    var mainStr = String()
    var temperatureStr = String()
    var feelsLikeStr = String()
    var cityName = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navCityButton.setTitle("  \(self.cityName)", for: .normal)
        temperatureLabel.text = "\(temperatureStr)"
        feelsLikeLabel.text = "Feels like: \(feelsLikeStr)"
        weatherLabel.text = "\(mainStr)"
        descriptionLabel.text = "\(descriptionStr)"
    }
    
    @IBAction func navBackButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
