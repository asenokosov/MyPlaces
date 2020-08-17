//
//  MainTableViewController.swift
//  MyPlace
//
//  Created by User on 10/08/2020.
//  Copyright © 2020 HomeMade. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {


    
    let places = Place.getPlaces()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let newPlaces = places[indexPath.row]
        
        cell.nameLabel.text = newPlaces.name
        cell.locationLAbel.text = newPlaces.location
        cell.typeLabel.text = newPlaces.type
        cell.imageOfPlace.image = UIImage(named: newPlaces.image)
        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2.5
        cell.imageOfPlace.clipsToBounds = true
        return cell
    }
    
    // Mark - Table View delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}
