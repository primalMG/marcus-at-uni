//
//  FirestoreExtentions.swift
//  RecipeApp
//
//  Created by Marcus Gardner on 23/06/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension DocumentSnapshot {
    
    func decode<T: Decodable>(as objectType: T.Type, includingId: Bool = true) throws  -> T {
        
        var documentJson = data()
        if includingId {
            documentJson?["id"] = documentID
        }
        
        let documentData = try JSONSerialization.data(withJSONObject: documentJson, options: [])
        let decodedObject = try JSONDecoder().decode(objectType, from: documentData)
        
        return decodedObject
    }
    
}
