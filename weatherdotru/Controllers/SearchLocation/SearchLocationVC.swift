//
//  SearchLocationVC.swift
//  weatherdotru
//
//  Created by Pestrikov Anton 13.12.2023
//


import UIKit

class SearchLocationVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Variables
    var locations = [LocationResponse]()
    var didSelectLocation: ((_ item: LocationResponse) -> Void)?

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "LocationTableCell", bundle: nil), forCellReuseIdentifier: "LocationTableCell")
    }
  }

//MARK: - Table delegate and datasource
extension SearchLocationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableCell", for: indexPath) as! LocationTableCell
        let data = locations[indexPath.row]
        cell.locationLabel.text = data.name + data.stateString + data.countryString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) { [self] in
            didSelectLocation?(locations[indexPath.row])
        }
    }
    
}
