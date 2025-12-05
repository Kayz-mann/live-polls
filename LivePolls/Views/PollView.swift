//
//  PollView.swift
//  LivePolls
//
//  Created by Balogun Kayode on 04/12/2025.
//

import SwiftUI

struct PollView: View {
    var vm: PollViewModel
    @State private var showShareSheet = false

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

                Button(action: {
                    showShareSheet = true
                }, label: {
                    Label("Share Poll", systemImage: "square.and.arrow.up")
                })
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
            .sheet(isPresented: $showShareSheet) {
                if let poll = vm.poll {
                    ShareSheet(
                        pollId: vm.pollId,
                        pollName: poll.name
                    )
                }
            }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let pollId: String
    let pollName: String

    func makeUIViewController(context: Context) -> UIActivityViewController {
        // TODO: Replace with your actual Firebase Hosting domain
        let shareURL = URL(string: "https://your-project-id.web.app/poll/\(pollId)")!
        let message = "Vote on my poll: \(pollName)"

        let activityViewController = UIActivityViewController(
            activityItems: [message, shareURL],
            applicationActivities: nil
        )

        return activityViewController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update needed
    }
}

#Preview {
    PollView(vm: .init(pollId: "123456"))
}
