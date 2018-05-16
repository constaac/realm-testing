//
//  PersistenceService.swift
//  realm-testing
//
//  Created by Alex Constantine on 5/16/18.
//  Copyright © 2018 Alex Constantine. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService {
    
    // Disable Initializing an Instance of this Service
    private init() {}
    
    // Realm Service Singleton
    static let shared = RealmService()
    
    // Initializes Default Realm File - Can Implement Do/Catch
    var realm = try! Realm()
    
    /*
        Realm CRUD Functions are leveraging generics to accept any object subclassed from Realm's Object class
     
        Each Action throws, so our Post function will handle each error by posting to the Notification Center
        An observer can be attactched within any View Controller to monitor for RealmErrors
    */
    
    func create<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            post(error)
        }
    }
    
//    func read() {
//
//    }
    
    func update<T: Object>(_ object: T, with dictionary: [String: Any?]) {
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            post(error)
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            post(error)
        }
    }
    
    
    // Posts Error to Notification Center
    func post(_ error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
    }
    
    // Adds Observer to Current VC to Listen for RealmErrors
    func observeRealmErrors(in vc: UIViewController, completion: @escaping (Error?) -> Void) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"), object: nil, queue: nil) { (notification) in
            completion(notification.object as? Error)
        }
    }
    
    // Removes Observer from Current VC
    func stopObservingRealmErrors(in vc: UIViewController) {
        NotificationCenter.default.removeObserver(vc, name: NSNotification.Name("RealmError"), object: nil)
    }
    
}
