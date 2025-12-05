//
//  HomeViewModel.swift
//  LivePolls
//
//  Created by Balogun Kayode on 05/11/2025.
//

import Foundation
import FirebaseFirestore
import SwiftUI
import Observation

@Observable
class HomeViewModel {
    let db = Firestore.firestore()
    var polls  =  [Poll]()
    var modalPollId:  String?  =   nil
    var existingPollId:  String  =  ""
    
    var error: String? =  nil
    // Make this non-optional to avoid unwrapping everywhere
    var newPollName: String = ""
    var newOptionName: String =  ""
    var newPollOptions: [String] =  []
    var isLoading =  false

    var isCreateNewPollButtonDisabled: Bool {
        isLoading || newPollName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || newPollOptions.count < 2
    }
    
    var isAddOptionsButtonDiabled: Bool {
        isLoading || newOptionName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || newPollOptions.count == 4
    }
    
    var isJoinedPollButtonDisabled: Bool {
        isLoading ||
        existingPollId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    @MainActor
    func listenToLivePolls() {
        db.collection("polls")
            .order(by: "updatedAt", descending: true)
            .limit(toLast: 10)
            .addSnapshotListener { (snapshot, error) in
                guard let snapshot else {
                    print("Error fetching snapshot: \(error?.localizedDescription ?? "error")")
                    return
                }
                let docs =  snapshot.documents
                let polls =  docs.compactMap {
                    try? $0.data(as: Poll.self)
                }
                
                withAnimation {
                    self.polls =  polls
                }
            }
    }
    
    @MainActor
    func createNewPoll() async {
        isLoading =  true
        defer { isLoading = false }
        // Fixed: missing comma after totalCount: 0 and pass non-optional name
        let trimmedName = newPollName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedOptions = newPollOptions
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        // Ensure at least two options (UI already enforces this)
        let optionModels = trimmedOptions.map { Option(count: 0, name: $0) }
        guard optionModels.count >= 2 else {
            self.error = "Please add at least two options."
            return
        }
        
        // Satisfy Poll’s initializer by passing option0/option1 explicitly
        let poll = Poll(
            name: trimmedName,
            totalCount: 0,
            options: optionModels,
            option0: optionModels[0],
            option1: optionModels[1],
            option2: optionModels.count > 2 ? optionModels[2] : nil,
            option3: optionModels.count > 3 ? optionModels[3] : nil
        )
        
        do {
            try db.document("polls/\(poll.id)").setData(from: poll)
            self.newPollName = ""
            self.newOptionName = ""
            self.newPollOptions =  []
        } catch {
            self.error =  error.localizedDescription
        }
    }
    
    func addOption() {
        let trimmed = newOptionName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, newPollOptions.count < 4 else { return }
        self.newPollOptions.append(trimmed)
        self.newOptionName =  ""
    }
    
    @MainActor
    func joinExistingPoll() async {
        isLoading = true
        defer { isLoading = false }
        let trimmedId = existingPollId.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedId.isEmpty else {
            error = "Please enter a poll ID."
            return
        }
        do {
            // Use Firestore async API to fetch the document snapshot
            let snapshot = try await db.document("polls/\(trimmedId)").getDocument()
            guard snapshot.exists else {
                error = "Poll ID: \(trimmedId) doesn't exist"
                return
            }
            // If it exists, open the poll sheet
            withAnimation {
                self.modalPollId = existingPollId
            }
        } catch {
            self.error = error.localizedDescription
        }
    }
    
}
