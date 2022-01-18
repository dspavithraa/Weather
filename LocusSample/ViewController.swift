//
//  ViewController.swift
//  LocusSample
//
//  Created by Pavi on 15/01/22.
//

import UIKit
import GooglePlaces

class ViewController: UIViewController {
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var lookupButton: UIButton!
    
    
    // Parsing variables
    var cityName = String()
    var descriptionArr = NSArray()
    var weatherMainArr = NSArray()
    var temperatureArr = NSArray()
    var feelsLikeArr = NSArray()
    
    var typedLat = Int()
    var typedLong = Int()
    
    var responseLat = Int()
    var responseLong = Int()
    var responseCityName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupViews()
    }
    
    //MARK: - Methods
    func setupViews()
    {
        cityTextField.attributedPlaceholder = NSAttributedString(
            string: "City Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        lookupButton.layer.cornerRadius = 10
        lookupButton.layer.borderWidth = 1
        lookupButton.clipsToBounds = true
        lookupButton.layer.borderColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func validateCityName()
    {
        let address = self.cityName
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemark = placemarks?.first
            else {
                self.alertControl(message: "Please enter valid city name !")
                return
            }
            let lat = placemark.location?.coordinate.latitude
            let lon = placemark.location?.coordinate.longitude
            self.typedLat = Int(lat ?? 0)
            self.typedLong = Int(lon ?? 0)
            
            if (self.typedLat == self.responseLat) && (self.typedLong == self.responseLong)
            {
                self.cityTextField.resignFirstResponder()
                self.performSegue(withIdentifier: "SegueToListVC", sender: self)
            }
            else
            {
                self.alertControl(message: "Please enter valid city name !")
            }
        }
    }
    
    func alertControl(message: String)
    {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SegueToListVC") {
            if let listVC = segue.destination as? ListVC {
                listVC.temperatureArr = self.temperatureArr
                listVC.descriptionArr = self.descriptionArr
                listVC.mainArr = self.weatherMainArr
                listVC.feelsLikeArr = self.feelsLikeArr
                listVC.cityName = self.responseCityName
            }
        }
    }
    
    
    //MARK: - Actions
    @IBAction func lookupButtonAction(_ sender: Any) {
        self.cityName = self.cityTextField.text ?? ""
        guard !(self.cityName == "") else {
            alertControl(message: "Please enter valid city name !")
            return
        }
        callWeatherApi()
        
        
        // autocompleteClicked(lookupButton)   // --> not able to call since billing not provided
    }
    
    // Present the Autocomplete view controller when the button is pressed.
    @objc func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                    UInt(GMSPlaceField.placeID.rawValue))
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
}

//MARK: - Google Services
extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name ?? "")")
        print("Place ID: \(place.placeID ?? "")")
        print("Place attributions: \(String(describing: place.attributions))")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

//MARK: - Web services
extension ViewController
{
    func callWeatherApi()
    {
        let apiKey = "65d00499677e59496ca2f318eb68c049"
        let url = "http://api.openweathermap.org/data/2.5/forecast?q=\(self.cityName)&appid=\(apiKey)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate:nil , delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if (error != nil){
                print("Error : ", error as Any)
            }
            else{
                do{
                    let fetchData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSDictionary
                    
                    // fetching data
                    let listData = fetchData.object(forKey: "list") as? NSArray
                    let main = listData?.value(forKey: "main") as? NSArray ?? []
                    self.temperatureArr = main.value(forKey: "temp") as? NSArray ?? []
                    self.feelsLikeArr = main.value(forKey: "feels_like") as? NSArray ?? []
                    let weather = listData?.value(forKey: "weather") as? NSArray ?? []
                    self.descriptionArr = weather.value(forKey: "description") as? NSArray ?? []
                    self.weatherMainArr = weather.value(forKey: "main") as? NSArray ?? []
                    
                    
                    // to validate whether the given city name is valid or not
                    let cityData = fetchData.object(forKey: "city") as? NSDictionary
                    self.responseCityName = cityData?.object(forKey: "name") as? String ?? ""
                    let coord = cityData?.object(forKey: "coord") as? NSDictionary
                    let lat = coord?.object(forKey: "lat") as? Double
                    let long = coord?.object(forKey: "lon") as? Double
                    self.responseLat = Int(lat ?? 0.0)
                    self.responseLong = Int(long ?? 0.0)
                    self.validateCityName()
                }
                
                catch{
                    print("Error 2", error)
                }
            }
        }
        task.resume()
    }
    
}
