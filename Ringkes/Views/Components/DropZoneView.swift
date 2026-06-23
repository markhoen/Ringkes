//
//  DropZoneView.swift
//  Ringkes
//
//  Created by mardiansyah on 09/06/26.
//

import SwiftUI

struct DropZoneView: View {

    let isTargeted: Bool
    let selectedMode: RingkesMode

    var body: some View {

        RoundedRectangle(cornerRadius: 20)
            .stroke(
                isTargeted ? .blue : .gray,
                style: StrokeStyle(
                    lineWidth: 3,
                    dash: [10]
                )
            )
            .frame(height: 120)
            .overlay(
                VStack(spacing: 8) {

                    Image(systemName: "arrow.down.doc")
                        .font(.system(size: 40))

                    Text(
                        selectedMode == .compress
                        ? "Drag & Drop PDFs or Images"
                        : "Drag & Drop PDFs"
                    )
                    .font(.title3)
                    
                    Text(
                        selectedMode == .compress
                        ? "PDF COMPRESS • IMAGE TO PDF"
                        : "DROP MULTIPLE PDF FILES TO MERGE"
                    )
                    .font(.caption2)
                    .tracking(1)
                    .foregroundStyle(.secondary)
                }
            )
    }
}
