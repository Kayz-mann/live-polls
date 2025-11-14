//
//  PollChart.swift
//  LivePolls
//
//  Created by Balogun Kayode on 06/11/2025.
//

import SwiftUI
import Charts

struct PollChart: View {
    let options: [Option]
    
    
    var body: some View {
        Chart {
            ForEach(options) {option in
                SectorMark(angle: .value("Count", option.count), innerRadius: .ratio(0.618), angularInset: 1.5)
                    .foregroundStyle(by: .value("Name", option.name))
            }
         
        }
    }
}

#Preview {
    PollChart(options: [
        .init(count: 2, name: "PS5"),
        .init(count: 1, name: "Xbox SX"),
        .init(count: 2, name: "Switch"),
        .init(count: 1, name: "PC")
    ])
}
