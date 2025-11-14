//
//  Home.swift
//  LivePolls
//
//  Created by Balogun Kayode on 05/11/2025.
//

import SwiftUI

struct Home: View {
    @State var vm = HomeViewModel()
    
    var body: some View {
        List {
            livePollsSection
        }
        .onAppear{
            vm.listenToLivePolls()
        }
    }
    
    var livePollsSection: some View {
        Section {
            DisclosureGroup("Latest Live Polls") {
                ForEach(vm.polls) { poll in
                    VStack {
                        HStack(alignment: .top){
                            Text(poll.name)
                            Spacer()
                            Image(systemName: "chart.bar.xaxis")
                            Text(String(poll.totalCount))
                            if let updatedAt = poll.updatedAt {
                                Image(systemName: "clock.fill")
                                Text(updatedAt, style: .time)
                            }
                        }
                        if poll.options.map(\.count).reduce(0, +) > 0 {
                            PollChart(options: poll.options)
                                .frame(height: 160)
                        } else {
                            Text("No votes yet")
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, minHeight: 160, alignment: .center)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Home()
}
