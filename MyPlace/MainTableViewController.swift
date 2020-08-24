//
//  MainTableViewController.swift
//  MyPlace
//
//  Created by User on 10/08/2020.
//  Copyright © 2020 HomeMade. All rights reserved.
//

import UIKit
import RealmSwift


class MainTableViewController: UITableViewController {


    
    var places: Results<Place>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        places = realm.objects(Place.self)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 :  places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        let newPlaces = places[indexPath.row]

        cell.imageOfPlace.image = UIImage(data: newPlaces.imageData!)
        
        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2.5
        cell.imageOfPlace.clipsToBounds = true
        cell.nameLabel.text = newPlaces.name
        cell.locationLAbel.text = newPlaces.location
        cell.typeLabel.text = newPlaces.type

        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func unwingSegue(_ segue: UIStoryboardSegue) {
        guard  let newPlaceVC = segue.source as? AddPlaceTableViewController else { return }
        newPlaceVC.saveNewPlace()
        tableView.reloadData()
        
    }
}
