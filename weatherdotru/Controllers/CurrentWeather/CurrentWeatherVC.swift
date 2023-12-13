//
//  CurrentWeatherVC.swift
//  weatherdotru
//
//  Created by Pestrikov Anton 13.12.2023
//

import UIKit
import CoreLocation

class CurrentWeatherVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var changeUnitSegment: UISegmentedControl!
    @IBOutlet weak var weatherDataView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempHighLowLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    var weatherData: WeatherResponse!
    var lastFetchedLat: Double?
    var lastFetchedLon: Double?

    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialData()
    }
    
    //MARK: - Actions
    @IBAction func searchLocationClicked(_ sender: UIButton) {
        guard let aVC = storyboard?.instantiateViewController(withIdentifier: "SearchLocationVC") as? SearchLocationVC else {
            return
        }
        aVC.didSelectLocation = { [weak self] location in
            self?.getWeatherData(lat: location.lat, long: location.lon)
            LocationManager.shared.stopUpdatingLocation() //Stop updating data based on user's current location for custom location
        }
        present(aVC, animated: true, completion: nil)
    }
    
    @IBAction func changeUnitClicked(_ sender: Any) {
        TemperatureUnitManager.shared.toggleUnit()
        getWeatherData()
    }
    
    @IBAction func currentLocationClicked(_ sender: UIButton) {

        guard LocationManager.shared.checkLocationAccessibility() else {
            showAlert(title: AppStrings.locationDenied,
                      message: AppStrings.enableAccessInSetting,
                      buttonTitles: [AppStrings.cancel,AppStrings.settings]) { index in
                guard index == 1 else { return }
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }
            return
        }
        
        LocationManager.shared.startUpdatingLocation() //start updating data based on user's current location

        if LocationManager.shared.currentLocation.latitude == lastFetchedLat && LocationManager.shared.currentLocation.longitude == lastFetchedLon {
            showAlert(title: "", message: AppStrings.alreadyCurrentData)
        }

        getWeatherData(lat: LocationManager.shared.currentLocation.latitude,
                       long: LocationManager.shared.currentLocation.longitude)
    }
    
    //MARK: - Helper Methods
    private func setupInitialData() {
        setWeatherView()
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidUpdate(_:)), name: .locationDidUpdate, object: nil)
        self.collectionView.register(UINib(nibName: "wetherDataCollectionCell", bundle: nil), forCellWithReuseIdentifier: "wetherDataCollectionCell")
        LocationManager.shared.requestAuthorizationStatus()
    }
    
    func setWeatherView(isHidden: Bool = true) {
        weatherDataView.isHidden = isHidden
        changeUnitSegment.isHidden = isHidden
        (TemperatureUnitManager.shared.selectedUnit == .celsius) ? (changeUnitSegment.selectedSegmentIndex = 0) : (changeUnitSegment.selectedSegmentIndex = 1)
    }
    
    func populateData() {
        setWeatherView(isHidden: false)
        locationLabel.text = weatherData.name
        tempLabel.text = weatherData.main.tempString
        weatherDescriptionLabel.text = weatherData.weather[0].main
        tempHighLowLabel.text = "H:\(weatherData.main.tempMaxString)   L:\(weatherData.main.tempMinString)"
        
        collectionView.reloadData()
    }
    
    @objc func locationDidUpdate(_ notification: Notification) {
        if let location = notification.object as? CLLocation {
            getWeatherData(lat: location.coordinate.latitude, long: location.coordinate.longitude)
        }
    }
    
    func getWeatherData(lat: Double? = nil, long: Double? = nil) {
        let latitude = lat ?? lastFetchedLat
        let longitude = long ?? lastFetchedLon
        
        guard let lat = latitude, let lon = longitude else {
            return // Cannot fetch without coordinates
        }
        
        Task {
            do {
                weatherData = try await NetworkManager.shared.getWeatherData(lat: lat, long: lon)
                lastFetchedLat = lat // Update the last fetched coordinates
                lastFetchedLon = lon
                populateData()
            } catch {
                showAlert(title: AppStrings.error, message: error.localizedDescription)
            }
        }
    }
}
