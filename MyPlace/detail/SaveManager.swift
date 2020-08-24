//
//  SaveManager.swift
//  MyPlace
//
//  Created by User on 24/08/2020.
//  Copyright © 2020 HomeMade. All rights reserved.
//

import RealmSwift

let realm = try! Realm ()

class  SaveManager {
    static func saveObject (_ place: Place) {
        try! realm.write {
            realm.add(place)
        }
    }
    static func deleteObject(_ place: Place) {
        try! realm.write {
            realm.delete(place)
        }
    }
}
