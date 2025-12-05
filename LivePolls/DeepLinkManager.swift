//
//  DeepLinkManager.swift
//  LivePolls
//
//  Created for deep linking support
//

import SwiftUI
import Observation

@Observable
class DeepLinkManager {
    var pendingPollId: String?

    func handleURL(_ url: URL) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return false
        }

        // Handle universal links: https://your-domain.com/poll/{pollId}
        // Handle custom URL scheme: livepolls://poll/{pollId}
        let pathComponents = components.path.split(separator: "/")

        if pathComponents.count >= 2 && pathComponents[0] == "poll" {
            let pollId = String(pathComponents[1])
            pendingPollId = pollId
            return true
        }

        // Also handle if host is "poll" for custom scheme
        if components.host == "poll", let pollId = pathComponents.first {
            pendingPollId = String(pollId)
            return true
        }

        return false
    }

    func clearPendingPollId() {
        pendingPollId = nil
    }
}
