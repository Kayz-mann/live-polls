//
//  Home.swift
//  LivePolls
//
//  Created by Balogun Kayode on 05/11/2025.
//

import SwiftUI

struct Home: View {
    @Bindable var vm = HomeViewModel()
    @Environment(DeepLinkManager.self) private var deepLinkManager

    var body: some View {
        List {
            existingPollSection
            livePollsSection
            createPollSection
            addOptionSection
        }
        .alert("Error", isPresented: .constant(vm.error != nil)) {

        } message: {
            Text(vm.error ?? "an error occured")
        }
        .sheet(item: $vm.modalPollId) { id in
            NavigationStack{
                PollView(vm: .init(pollId: id))
            }
        }
        .navigationTitle("My Live Polls")
        .onAppear{
            vm.listenToLivePolls()
        }
        .onChange(of: deepLinkManager.pendingPollId) { oldValue, newValue in
            if let pollId = newValue {
                vm.modalPollId = pollId
                deepLinkManager.clearPendingPollId()
            }
        }
    }
    
    var livePollsSection: some View {
        Section {
            DisclosureGroup("Latest Live Polls") {
                ForEach(vm.polls) { item in
                    VStack {
                        HStack(alignment: .top){
                            Text(item.name)
                            Spacer()
                            Image(systemName: "chart.bar.xaxis")
                            Text(String(item.totalCount))
                            if let updatedAt = item.updatedAt {
                                Image(systemName: "clock.fill")
                                Text(updatedAt, style: .time)
                            }
                        }
                        if item.options.map(\.count).reduce(0, +) > 0 {
                            PollChart(options: item.options)
                                .frame(height: 160)
                        } else {
                            Text("No votes yet")
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, minHeight: 160, alignment: .center)
                        }
                    }
                    .padding(.vertical)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        vm.modalPollId = item.id
                    }
                }
            }
        }
    }
    
    var existingPollSection: some View {
        Section {
            DisclosureGroup("Join a Poll") {
                TextField("Enter poll id", text: $vm.existingPollId)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                Button("Join") {
                    Task { await vm.joinExistingPoll()}
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
                Text(option)
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
