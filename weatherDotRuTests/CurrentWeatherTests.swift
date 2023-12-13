//
//  CurrentWeatherTests.swift
//  weatherdotru
//
//  Created by Pestrikov Anton 13.12.2023
//

import XCTest
@testable import weatherdotru
import CoreLocation

final class CurrentWeatherTests: XCTestCase {
    
    var currentWeatherVC: CurrentWeatherVC!
    var networkExpectation: XCTestExpectation!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        currentWeatherVC = storyboard.instantiateViewController(withIdentifier: "CurrentWeatherVC") as? CurrentWeatherVC
        currentWeatherVC.loadViewIfNeeded() // Load the view
    }

    override func tearDownWithError() throws {
        currentWeatherVC = nil
        try super.tearDownWithError()
    }
    
    func testSetWeatherViewHidden() {
        currentWeatherVC.setWeatherView(isHidden: true)
        
        XCTAssertEqual(currentWeatherVC.weatherDataView.isHidden, true)
        XCTAssertEqual(currentWeatherVC.changeUnitSegment.isHidden, true)
    }
    
    func testSetWeatherView() {
        currentWeatherVC.setWeatherView(isHidden: false)
        
        XCTAssertEqual(currentWeatherVC.weatherDataView.isHidden, false)
        XCTAssertEqual(currentWeatherVC.changeUnitSegment.isHidden, false)
    }
    
    func testPopulateData() {
        // Prepare mock WeatherResponse data
        let mockWeatherResponse = WeatherResponse(weather: [WeatherResponse.Weather(main: "Clear")], main: WeatherResponse.Main(temp: 296.86, feelsLike: 297.14, tempMin: 295.36, tempMax: 299.14, pressure: 1013, humidity: 71), visibility: 10000, wind: WeatherResponse.Wind(speed: 5.14), sys: WeatherResponse.Sys(sunrise: 1692937837, sunset: 1692987728), name: "Böblingen")

        currentWeatherVC.weatherData = mockWeatherResponse
        
        currentWeatherVC.populateData()
        
        XCTAssertEqual(currentWeatherVC.locationLabel.text, "Böblingen")
        XCTAssertEqual(self.currentWeatherVC.weatherDataView.isHidden, false)
        XCTAssertEqual(self.currentWeatherVC.changeUnitSegment.isHidden, false)
    }
    
    func testSearchLocationClickedWithNilCoordinates() {
        // Simulate stopping location updates (if applicable)
        LocationManager.shared.stopUpdatingLocation()
        
        // Call getWeatherData without coordinates
        currentWeatherVC.getWeatherData()
        
        // Assert the appropriate behavior when coordinates are nil
        XCTAssertEqual(self.currentWeatherVC.weatherDataView.isHidden, true)
        XCTAssertEqual(self.currentWeatherVC.changeUnitSegment.isHidden, true)
    }
    
    func testSearchLocationClicked() {
        // Simulate stopping location updates (if applicable)
        LocationManager.shared.stopUpdatingLocation()
        
        // Call getWeatherData with specific coordinates
        currentWeatherVC.getWeatherData(lat: 48.685669, long: 9.015250)
        
        XCTAssertTrue(self.currentWeatherVC.isViewLoaded)
    }
    
    func testPrepareCollectionViewData_NilWeatherData() {
        let currentWeatherVC = CurrentWeatherVC()
        currentWeatherVC.weatherData = nil
        
        let collectionViewData = currentWeatherVC.prepareCollectionViewData()
        
        XCTAssertTrue(collectionViewData.isEmpty)
    }
    
    func testNumberOfRowsInSection_ReturnsZeroWhenLocationsIsEmpty() {
        let searchLocationVC = SearchLocationVC()
        searchLocationVC.locations = []

        let numberOfRows = searchLocationVC.tableView(UITableView(), numberOfRowsInSection: 0)

        XCTAssertEqual(numberOfRows, 0)
    }
    
    func testNumberOfRowsInSection_ReturnsCountOfLocations() {
        let searchLocationVC = SearchLocationVC()
        searchLocationVC.locations = [LocationResponse(name: "Böblingen (Stadt)", lat: 48.67951155, lon: 9.029467736742069)]

        let numberOfRows = searchLocationVC.tableView(UITableView(), numberOfRowsInSection: 0)

        XCTAssertEqual(numberOfRows, 1)
    }

    func testDidSelectRowAt_DismissesViewControllerAndCallsDidSelectLocation() {
        let searchLocationVC = SearchLocationVC()
        searchLocationVC.locations = [LocationResponse(name: "Böblingen (Stadt)", lat: 48.67951155, lon: 9.029467736742069)]

        let didSelectLocationExpectation = expectation(description: "didSelectLocation")
        searchLocationVC.didSelectLocation = { location in
            didSelectLocationExpectation.fulfill()
        }

        searchLocationVC.tableView(UITableView(), didSelectRowAt: IndexPath(row: 0, section: 0))

        wait(for: [didSelectLocationExpectation], timeout: 1)
    }

}

