//
//  MainTableViewController.swift
//  MyPlace
//
//  Created by User on 10/08/2020.
//  Copyright © 2020 HomeMade. All rights reserved.
//

import UIKit
import RealmSwift


class MainTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var places: Results<Place>!
    private var filteredPlaces: Results<Place>!
    private var ascendingSorting = true
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reversedSort: UIBarButtonItem!
    @IBOutlet weak var segmentSort: UISegmentedControl!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)
        // Setup Search Bar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Тут найдешь ты искомое"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.becomeFirstResponder() 
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPlaces.count
        }
        return places.count
    }
    
    //MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var place = Place()
        
        if isFiltering{
            place = filteredPlaces[indexPath.row]
        } else {
            place = places[indexPath.row]
        }
        
        let shareAction = UIContextualAction(style: .normal, title: "Поделиться") {_, _, complete in
            let defaultText = "Я сейчас в " + place.name
            let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            self.present(activityController, animated: true)
        }
        
        let deleteAction = UIContextualAction(style: .normal, title: "Удалить")  {_, _, complete in
            
            SaveManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            complete(true)
            
        }
        shareAction.backgroundColor = #colorLiteral(red: 0.3559710608, green: 0.7054162485, blue: 1, alpha: 1)
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.20458019, blue: 0.1013487829, alpha: 1)
        
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction,shareAction])
        
        return swipeAction
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
        
        cell.imageOfPlace.image = UIImage(data: place.imageData!)
        //cell.mainTableRating.rating = Int(place.rating)
        cell.nameLabel.text = place.name
        cell.locationLAbel.text = place.location
        cell.typeLabel.text = place.type
        cell.cosmocView.rating = place.rating
        return cell
    }
    
        
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let place = isFiltering ? filteredPlaces[indexPath.row] : places[indexPath.row]
            let newPlaceVC = segue.destination as! AddPlaceTableViewController
            newPlaceVC.currentPlace = place
        }
    }
    
    @IBAction func unwingSegue(_ segue: UIStoryboardSegue) {
        guard  let newPlaceVC = segue.source as? AddPlaceTableViewController else { return }
        newPlaceVC.savePlace()
        tableView.reloadData()
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        sortingPlaces()
    }
    
    @IBAction func reversedAction(_ sender: Any) {
        ascendingSorting.toggle()
        if ascendingSorting {
            reversedSort.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedSort.image = #imageLiteral(resourceName: "ZA")
        }
        sortingPlaces()
    }
    private func sortingPlaces() {
        if segmentSort.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        tableView.reloadData()
    }
}

extension MainTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredResult(searchController.searchBar.text!)
        tableView.reloadData()
    }
    
    private func filteredResult(_ searchText: String) {
        filteredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText , searchText)
        tableView.reloadData()
    }
}

extension MainTableViewController: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    if searchBar.text == "" {
      navigationController?.hidesBarsOnSwipe = false
    }
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    navigationController?.hidesBarsOnSwipe = true
  }
}
