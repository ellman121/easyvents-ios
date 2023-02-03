//
//  Event.swift
//  easyvents-ios
//
//  Created by Elliott Rarden on 23.01.23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Event: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var startTime: Date
    var endTime: Date?
    var description: String
}

class EventsViewModel: ObservableObject {
    @Published var events = [Event]()
    private var db = Firestore.firestore()
    
    func fetchEvents() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("events")
            .whereField("createdBy", isEqualTo: uid)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("ERROR: no events found for user")
                    return
                }
                
                let events = documents.map { docSnapshot -> Event in
                    do {
                        return try docSnapshot.data(as: Event.self)
                    } catch {
                        print("ERROR: Couldn't parse doc snapshot into Event")
                        print(error)
                    }
                    return Event(name: "fake", startTime: Date(timeIntervalSince1970: 0), endTime: nil, description: "fake")
                }
                self.events = events
            }
    }
}
