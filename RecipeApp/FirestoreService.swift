//
//  FirestoreService.swift
//  RecipeApp
//
//  Created by Marcus Gardner on 22/06/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import Foundation
import Firebase

class FirestoreService {

    private init() {}
    
    static let shared = FirestoreService()
    
    let db = Firestore.firestore()
    
    private func reference(to collectionReference: FirebaseCollectionRef) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    func readRecipes<T: Decodable>(from collectionReference: FirebaseCollectionRef, returning objectType: T.Type, completetion: @escaping ([T]) -> Void){
        
        reference(to: collectionReference).addSnapshotListener { (snap, _) in
            guard let snapshot = snap else { return }
            
            do {
                var objects = [T]()
                for document in snapshot.documents {
                    let object = try document.decode(as: objectType.self)
                    objects.append(object)
                }
                completetion(objects)
            } catch {
                print(error)
            }
        }
            
        
        
        
        
        db.collection("Recipe").getDocuments { (snap, error) in
            if error != nil {
                print("error getting data")
            } else {
                guard let snapshot = snap else { return }
                for document in snapshot.documents {
                    print(document.data())
                    //self.recipeArray.append(document.data())
                }
            }
        }
    }
    
    
}
