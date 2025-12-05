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
import ActivityKit
#if canImport(UIKit)
import UIKit
#endif

@Observable
class PollViewModel {
    let db = Firestore.firestore()
    let pollId: String

    var poll: Poll? = nil
    var activity: Activity<LivePollsWidgetAttributes>?

    init(pollId: String, poll: Poll? = nil) {
        self.pollId = pollId
        self.poll = poll
    }

    @MainActor
    func listenToPoll() {
        db.document("polls/\(pollId)")
            .addSnapshotListener { snapshot, error in
                guard let snapshot else { return }

                do {
                    let poll = try snapshot.data(as: Poll.self)
                    withAnimation {
                        self.poll = poll
                    }
                } catch {
                    print("Failed to fetch poll")
                }
            }
    }

    func incrementOption(_ option: Option) {
        guard let index = poll?.options.firstIndex(where: { $0.id == option.id }) else { return }
        db.document("polls/\(pollId)")
            .updateData([
                "totalCount": FieldValue.increment(Int64(1)),
                "options.\(index).count": FieldValue.increment(Int64(1)),
                "lastUpdatedOptionId": option.id,
                "updatedAt": FieldValue.serverTimestamp()
            ]) { error in
                print(error?.localizedDescription ?? "")
            }
    }

    func startActivityIfNeeded() {
        // Ensure we have a poll, no cached activity yet, and authorization is available.
        guard let poll = self.poll,
              activity == nil,
              ActivityAuthorizationInfo().frequentPushesEnabled
        else { return }

        // Try to find an existing Live Activity for this pollId.
        if let existing = Activity<LivePollsWidgetAttributes>.activities.first(where: { activity in
            activity.attributes.pollId == pollId
        }) {
            self.activity = existing
            return
        }

        // Otherwise, request a new Live Activity.
        do {
            let attributes = LivePollsWidgetAttributes(pollId: pollId)
            let content = ActivityContent(
                state: poll, // ContentState == Poll
                staleDate: Calendar.current.date(byAdding: .hour, value: 8, to: Date())
            )

            let newActivity = try Activity<LivePollsWidgetAttributes>.request(
                attributes: attributes,
                content: content,
                pushType: .token // Use .token if you plan to push updates; change to nil if not using push.
            )
            self.activity = newActivity
            print("Requested a live activity \(String(describing: newActivity.id))")
        } catch {
            print("Error requesting live activity \(error.localizedDescription)")
        }

        #if canImport(UIKit)
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        _ = deviceId // Use this if you intend to associate the push token with a device on your server.
        #endif

        // Listen for push token updates and store them under polls/{pollId}/push_tokens/{activityId}
        Task { [weak self] in
            guard let self, let activity = self.activity else { return }
            for await tokenData in activity.pushTokenUpdates {
                let tokenHex = tokenData.map { String(format: "%02.2hhx", $0) }.joined()
                print("Live Activity push token: \(tokenHex)")

                do {
                    try await self.db
                        .collection("polls/\(self.pollId)/push_tokens")
                        .document(activity.id) // stable doc keyed by activity id
                        .setData([
                            "token": tokenHex,
                            "activityId": activity.id,
                            "pollId": self.pollId,
                            "updatedAt": FieldValue.serverTimestamp()
                        ], merge: true)
                } catch {
                    print("Failed to update token: \(error.localizedDescription)")
                }
            }
        }
    }
}
