//
//  LivePollsWidgetLiveActivity.swift
//  LivePollsWidget
//
//  Created by Balogun Kayode on 05/12/2025.
//

import ActivityKit
import WidgetKit
import SwiftUI


struct LivePollsWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LivePollsWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                HStack {
                    
                }
            }
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    Text("\(context.state.totalCount)")
                        .font(.title2).bold()
                }
                DynamicIslandExpandedRegion(.trailing) {
                    if let updated = context.state.updatedAt {
                        Text(updated, style: .time)
                            .font(.caption2)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.name)
                        .font(.subheadline)
                        .lineLimit(1)
                }
            } compactLeading: {
                Text("\(min(context.state.totalCount, 99))")
            } compactTrailing: {
                Text("🗳️")
            } minimal: {
                Text("🗳️")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension LivePollsWidgetAttributes {
    fileprivate static var preview: LivePollsWidgetAttributes {
        LivePollsWidgetAttributes(pollId: "1234")
    }
}

extension LivePollsWidgetAttributes.ContentState {
    // Since ContentState == Poll, construct Polls for previews.

    // Example 1: Favorite Console with four options and counts 150, 120, 100, 30
    fileprivate static var first: LivePollsWidgetAttributes.ContentState {
        let opts = [
            Option(count: 150, name: "PS5"),
            Option(count: 120, name: "Xbox Series X|S"),
            Option(count: 100, name: "Switch"),
            Option(count: 30, name: "PC")
        ]
        return Poll(
            name: "Favorite Console",
            totalCount: opts.map(\.count).reduce(0, +),
            options: opts,
            option0: opts[0],
            option1: opts[1],
            option2: opts[2],
            option3: opts[3]
        )
    }

    // Example 2: Another distribution
    fileprivate static var second: LivePollsWidgetAttributes.ContentState {
        let opts = [
            Option(count: 200, name: "PS5"),
            Option(count: 80, name: "Xbox Series X|S"),
            Option(count: 140, name: "Switch"),
            Option(count: 50, name: "PC")
        ]
        return Poll(
            name: "Favorite Console (Alt)",
            totalCount: opts.map(\.count).reduce(0, +),
            options: opts,
            option0: opts[0],
            option1: opts[1],
            option2: opts[2],
            option3: opts[3]
        )
    }
}

#Preview("Notification", as: .content, using: LivePollsWidgetAttributes.preview) {
   LivePollsWidgetLiveActivity()
} contentStates: {
    LivePollsWidgetAttributes.ContentState.first
    LivePollsWidgetAttributes.ContentState.second
}
