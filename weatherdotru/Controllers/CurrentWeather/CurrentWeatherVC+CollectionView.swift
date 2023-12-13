//
//  CurrentWeatherVC+CollectionView.swift
//  weatherdotru
//
//  Created by Pestrikov Anton 13.12.2023
//

import UIKit

//MARK: - Generate CollectionView Data
extension CurrentWeatherVC {
    
    func prepareCollectionViewData() -> [WeatherCollectionViewItem] {
        guard let weatherData = weatherData else {
            return []
        }
        
        return [
            WeatherCollectionViewItem(imageName: appImages.thermometer, title: AppStrings.feelslike, value: weatherData.main.feelsLikeString),
            WeatherCollectionViewItem(imageName: appImages.wind, title: AppStrings.wind, value: weatherData.wind.windString),
            WeatherCollectionViewItem(imageName: appImages.humidity, title: AppStrings.humidity, value: weatherData.main.humidityString),
            WeatherCollectionViewItem(imageName: appImages.eye, title: AppStrings.visibility, value: weatherData.visibilityString),
            WeatherCollectionViewItem(imageName: appImages.pressure, title: AppStrings.pressure, value: weatherData.main.pressureString),
            getSunSetOrRise()
        ].filter { $0.imageName != nil }
    }
    
    // Get what's next, sunset or sunrise
    func getSunSetOrRise() -> WeatherCollectionViewItem {
        guard let sys = weatherData?.sys else {
            return WeatherCollectionViewItem(imageName: "", title: "", value: "")
        }
        
        let sunrise = Date(timeIntervalSince1970: TimeInterval(sys.sunrise))
        let sunset = Date(timeIntervalSince1970: TimeInterval(sys.sunset))
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        
        let sunriseComponents = Calendar.current.dateComponents([.hour, .minute], from: sunrise)
        let sunsetComponents = Calendar.current.dateComponents([.hour, .minute], from: sunset)
        
        let isPastSunrise = currentDate > sunrise
        let isPastSunset = currentDate > sunset
        
        if isPastSunrise && !isPastSunset {
            if let sunsetTimeDate = Calendar.current.date(from: sunsetComponents) {
                let sunsetTime = dateFormatter.string(from: sunsetTimeDate)
                return WeatherCollectionViewItem(imageName: appImages.sunset, title: AppStrings.sunset, value: "\(sunsetTime)")
            }
        }
        else {
            if let sunriseTimeDate = Calendar.current.date(from: sunriseComponents) {
                let sunriseTime = dateFormatter.string(from: sunriseTimeDate)
                return WeatherCollectionViewItem(imageName: appImages.sunrise, title: AppStrings.sunrise, value: "\(sunriseTime)")
            }
        }
        
        return WeatherCollectionViewItem(imageName: "", title: "", value: "")
    }
    
}

//MARK: - CollectionView Methods
extension CurrentWeatherVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacingRowCell = 10.0
        let width = (collectionView.frame.size.width - (spacingRowCell * 2)) / 3
        collectionViewHeight.constant = (width * 2) + spacingRowCell
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        prepareCollectionViewData().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wetherDataCollectionCell", for: indexPath) as! wetherDataCollectionCell
        
        let item = (prepareCollectionViewData())[indexPath.item]
                
        if let imageName = item.imageName {
            cell.imageview.image = UIImage(systemName: imageName)
            cell.imageview.tintColor = appColors.accentColor // Set the tintColor to white
        }
        cell.titleLabel.text = item.title
        cell.dataLabel.text = item.value
        
        return cell
    }
    
}
