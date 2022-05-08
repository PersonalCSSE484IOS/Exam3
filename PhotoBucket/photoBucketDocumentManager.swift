//
//  photoBucketDocumentManager.swift
//  PhotoBucket
//
//  Created by Yujie Zhang on 4/12/22.
//

import Foundation
import Firebase

class photoBucketDocumentManager{
    var _latestDocument: DocumentSnapshot?

    var latestPhoto: photoBucket?
    static let shared = photoBucketDocumentManager()
    var _collectionRef: CollectionReference
    //var photoducumenturl: String?
    private init(){
        _collectionRef = Firestore.firestore().collection(kPhotoCollectionPath)
    }
    
    func startListening(for documentId: String, changeListener: @escaping (()-> Void))->ListenerRegistration{
        let query = _collectionRef.document(documentId)
        return query.addSnapshotListener{documentSnapshot, error in
            guard let document = documentSnapshot else{
                return
            }
            guard let data = document.data() else{
                return
            }
            self.latestPhoto = photoBucket(documentSnapshot:document)
            self._latestDocument = document

            changeListener()
        }
    }
    func stopListening(_ listenerRegistration: ListenerRegistration?){
        listenerRegistration?.remove()
    }
    
//    func startListeningForMainPhoto(for documentID: String, changeListener: @escaping (() -> Void)) -> ListenerRegistration{//it is documentID and Uid
//        
//        let query = _collectionRef.document(documentID)// order the collection
//        
//        return query.addSnapshotListener { documentSnapshot, error in
//            self.latestPhoto = nil
//            guard let document = documentSnapshot else {
//                print("Error fetching document: \(error!)")
//                return
//            }
//            guard document.data() != nil else {
//                print("Document data was empty.")
//                return
//              }
//
//            self.latestPhoto = document
//            changeListener()
//            }
//        
//    }
    
    func update(url: String, caption: String){

        _collectionRef.document(latestPhoto!.documentId!).updateData([
            kPhotoURL: url,
            kPhotoCaption: caption,
            kCreateTime: Timer.init(),]){
                err in
                if let err = err{
                    //print("Error uodateing: \(err)")
                }else{
                   // print("Document updated")
                }
            }
    }
    
    func updateCaption(caption: String){

        _collectionRef.document(latestPhoto!.documentId!).updateData([
            kPhotoCaption: caption,
            kCreateTime: Timer.init(),]){
                err in
                if let err = err{
                    //print("Error uodateing: \(err)")
                }else{
                   // print("Document updated")
                }
            }
    }
    
    
    func updatePhotoUrl(documentID: String, PhotoUrl: String){
        _collectionRef.document(documentID).updateData([
            kPhotoURL: PhotoUrl
        ]){err in
            if let err = err{
                print("Error updating document:\(err)")
            }else{
                print("Name successfully updated")
            }
        }
        self.latestPhoto?.url = PhotoUrl
        //self.photoducumenturl = PhotoUrl
    }
    
    var photoURL: String{
        if let photoURL = _latestDocument?.get(kPhotoURL) {
            return photoURL as! String
        }
        return ""
    }
}
