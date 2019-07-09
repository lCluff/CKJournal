//
//  EntryController.swift
//  CK_Journal_27
//
//  Created by Leah Cluff on 7/8/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    
    //MARK: - Singleton
    static let sharedInstance = EntryController()
    
    //Mark: - Source of Truth
    var entries: [Entry] = []
    
    //Mark: - Private Database
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //Mark: - Functions
    func createEntry(title: String, body: String, completion: @escaping(Bool)-> Void) {
        let entry = Entry(body: body, title: title, timestamp: Date())
        saveEntry(entry: entry, completion: completion)
    }
    
    func update(entryToUpdate: Entry, newTitle: String, newBody: String) {
        entryToUpdate.title = newTitle
        entryToUpdate.body = newBody
    }
    
    func delete(entry: Entry){
        guard let entryIndex = entries.firstIndex(of: entry) else {return}
        entries.remove(at: entryIndex)
    }
    
    
    func removeEntry(entry: Entry, completion: @escaping(Bool) -> ()) {
        // remove locally
        guard let index = EntryController.sharedInstance.entries.firstIndex(of:entry) else {return}
        EntryController.sharedInstance.entries.remove(at: index)
        //remove from the cloud, specifically the private database
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
    
    //update
    func updateEntries() {
        
        
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
