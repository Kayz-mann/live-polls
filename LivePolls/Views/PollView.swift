//
//  PollView.swift
//  LivePolls
//
//  Created by Balogun Kayode on 04/12/2025.
//

import SwiftUI

struct PollView: View {
    var vm: PollViewModel
    
    var body: some View {
        List{
            Section{
                VStack(alignment: .leading, spacing: 10){
                    Text("Poll ID")
                    Text(vm.pollId)
                        .font(.caption)
                        .textSelection(.enabled)
                }
                
                HStack {
                    Text("Updated At")
                    Spacer()
                    if let updatedAt =  vm.poll?.updatedAt {
                        Text(updatedAt, style: .time)
                    }
                }
                
                HStack {
                    Text("Total Vote Count")
                    Spacer()
                    if let totalCount =  vm.poll?.totalCount {
                        Text(String(totalCount))
                    }
                }
            }
            
            if let options =  vm.poll?.options {
                Section {
                    PollChart(options: options)
                        .frame(height: 200)
                        .padding(.vertical)
                }
                
                Section("Vote") {
                    ForEach(options) {option in
                        Button(action: {
                            vm.incrementOption(option)
                        }, label: {
                            HStack{
                                Text("+1")
                                Text(option.name)
                                Spacer()
                                Text(String(option.count))
                            }
                        })}
                }
            }
        }.navigationTitle(vm.poll?.name ?? "")
            .onAppear {
                vm.listenToPoll()
            }
    }
}

#Preview {
    PollView(vm: .init(pollId: "123456"))
}
