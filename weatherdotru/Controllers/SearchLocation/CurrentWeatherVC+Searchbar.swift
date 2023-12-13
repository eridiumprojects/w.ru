//
//  CurrentWeatherVC+Searchbar.swift
//  weatherdotru
//
//  Created by Pestrikov Anton 13.12.2023
//

import UIKit
import CoreLocation

//MARK: - SearchBarDelegate
extension SearchLocationVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            locations = [] //empty response for blank search bar
            tableView.reloadData()
            return
        }
        
        Task {
            do {
                let locations = try await NetworkManager.shared.getLocation(location: searchText)
                self.locations = locations
                self.tableView.reloadData()
            }
            catch {
                showAlert(title: "Error!!", message: error.localizedDescription) // error from API call
            }
        }
    }
}
