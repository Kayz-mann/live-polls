//
//  LivePollsWidgetAttributes.swift
//  LivePolls
//
//  Created by Balogun Kayode on 05/12/2025.
//

import Foundation
import ActivityKit


struct LivePollsWidgetAttributes: ActivityAttributes {
    typealias ContentState = Poll
    public var pollId: String
    init(pollId: String) {
        self.pollId =  pollId
    }
}
