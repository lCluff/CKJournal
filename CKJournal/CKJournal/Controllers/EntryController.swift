//
//  JournalController.swift
//  CKJournal
//
//  Created by Leah Cluff on 6/3/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    
    //singleton
    static let sharedInstance = EntryController()
    
    //landing pad
    var entries: [Entry] = []
    
    //public or private database
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //CRUD Functions
    
    //create
    func createEntry(title: String, body: String, completion: @escaping(Bool)-> Void) {
        let entry = Entry(body: body, title: title, timestamp: Date())
        saveEntry(entry: entry, completion: completion)
        
    }
    //couldn't figure out how to finish the delete function, leaving the code in to show the attempt
    //remove/delete
    func removeEntry(entry: Entry, completion: @escaping(Bool) -> ()) {
        // remove locally
        guard let index = EntryController.sharedInstance.entries.firstIndex(of:entry) else {return}
        EntryController.sharedInstance.entries.remove(at: index)
        //remove the cloud
        privateDB.delete(withRecordID: entry.ckRecordID){ (_, error) in
            if let error = error {
                print("there was an error \(#function) ; \(error) ; \(error.localizedDescription)" )
                completion (false)
                return
            } else {
                print("entry deleted")
                completion(true)
                
            }
        }
    }
    //save
    func saveEntry(entry: Entry, completion: @escaping (Bool) -> ()) {
        let record = CKRecord(entry: entry)
        CKContainer.default().privateCloudDatabase.save(record) { (record, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(false)
                return
            }
            guard let record = record,
                let entry = Entry(ckRecord: record) else { completion(false) ; return }
            self.entries.append(entry)
            completion(true)
        }
    }
    
    //fetch
    func fetchEntries(completion: @escaping (Bool) -> Void){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Constants.recordKey, predicate: predicate)
        CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(false)
                return
            }
            guard let records = records else { completion(false) ; return }
            let entries = records.compactMap{ Entry(ckRecord: $0) }
            self.entries = entries
            completion(true)
        }
        
    }
}// end
