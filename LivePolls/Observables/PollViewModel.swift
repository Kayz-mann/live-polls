//
//  PollViewModel.swift
//  LivePolls
//
//  Created by Balogun Kayode on 04/12/2025.
//

import Foundation
import FirebaseFirestore
import SwiftUI
import Observation

@Observable

class PollViewModel {
    let db =  Firestore.firestore()
    let pollId: String
    
    var poll: Poll? =   nil
    
    init(pollId: String, poll: Poll? = nil) {
        self.pollId = pollId
        self.poll = poll
    }
    
    @MainActor
    func listenToPoll() {
        db.document("polls/\(pollId)")
            .addSnapshotListener { snapshot, error in
                guard let snapshot else {return}
                
                do {
                    let poll =  try snapshot.data(as: Poll.self)
                    withAnimation {
                        self.poll = poll
                    }
                } catch {
                    print("Failed to fetch poll")
                }
            }
    }
    
    func incrementOption(_ option: Option) {
        guard let index =  poll?.options.firstIndex(where: {$0.id == option.id}) else {return}
        db.document("polls/\(pollId)")
            .updateData([
                "totalCount": FieldValue.increment(Int64(1)),
                "options.\(index).count": FieldValue.increment(Int64(1)),
                "lastUpdatedOptionId": option.id,
                "updatedAt": FieldValue.serverTimestamp()
            ]) {
                error in
                print(error?.localizedDescription ?? "")
            }
    }
    
}
