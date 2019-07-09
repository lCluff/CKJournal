//
//  File.swift
//  CK_Journal_27
//
//  Created by Leah Cluff on 7/8/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import Foundation
import CloudKit

struct Constants {
    static let titleKey = "title"
    static let bodyKey = "body"
    static let timestampKey = "timestamp"
    static let recordKey = "entry"
}

class Entry: Equatable {
    
    var body: String
    var title: String
    var timestamp: Date
    let ckRecordID: CKRecord.ID
    
    init(body: String, title: String, timestamp: Date, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.body = body
        self.title = title
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
    // Failable Initializer
    convenience init?(ckRecord: CKRecord) {
        guard let body = ckRecord[Constants.bodyKey] as? String, let title = ckRecord[Constants.titleKey] as? String, let timestamp = ckRecord[Constants.timestampKey] as? Date
            else {return nil}
        self.init(body: body, title: title, timestamp: timestamp, ckRecordID:ckRecord.recordID)
    }
    
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.body == rhs.body && lhs.timestamp == rhs.timestamp && lhs.title == rhs.title
    }
    
}

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: Constants.recordKey, recordID: entry.ckRecordID)
        self.setValue(entry.body, forKey: Constants.bodyKey)
        self.setValue(entry.title, forKey: Constants.titleKey)
        self.setValue(entry.timestamp, forKey: Constants.timestampKey)
    }
}
