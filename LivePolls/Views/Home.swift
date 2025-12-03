//
//  Home.swift
//  LivePolls
//
//  Created by Balogun Kayode on 05/11/2025.
//

import SwiftUI

struct Home: View {
    @Bindable var vm = HomeViewModel()
    
    var body: some View {
        List {
            livePollsSection
            createPollsSection
        }
        .navigationTitle("My Live Polls")
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
    
    var createPollSection: some View {
        Section {
            TextField("Enter poll name", text: $vm.newPollName, axis: .vertical)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            Button("Submit") {
                Task {await vm.createNewPoll()}
            }.disabled(vm.isCreateNewPollButtonDisabled)
            if vm.isLoading {
                ProgressView()
            }
            
        } header: {
            Text("create a poll")
        } footer : {
            Text("Enter poll name & add 2-4 options to submit")
        }
    }
    
    var addOptionSection: some View {
        Section("Options") {
            TextField("Enter option name", text: $vm.newOptionName)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            Button("+ Add Option") {
                vm.addOption()
            }.disabled(vm.isAddOptionsButtonDiabled)
            
            ForEach(vm.newPollOptions) { option in
                Text($0)
            }.onDelete { indexSet in
                vm.newPollOptions.remove(atOffsets: indexSet)
            }
            
        }
    }
}

extension String: Identifiable {
    public var id: Self {self}
}

#Preview {
    Home()
}
