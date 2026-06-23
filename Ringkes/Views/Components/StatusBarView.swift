//
//  StatusBarView.swift
//  Ringkes
//
//  Created by mardiansyah on 09/06/26.
//

import SwiftUI

struct StatusBarView: View {

    let ghostscriptAvailable: Bool
    let homebrewAvailable: Bool
    let ghostscriptPath: String

    var body: some View {

        HStack(spacing: 20) {

            Label {

                Text("Ghostscript")
                    .font(.caption)

            } icon: {

                Circle()
                    .fill(
                        ghostscriptAvailable
                        ? .green
                        : .red
                    )
                    .frame(width: 10, height: 10)
            }

            Label {

                Text("Homebrew")
                    .font(.caption)

            } icon: {

                Circle()
                    .fill(
                        homebrewAvailable
                        ? .green
                        : .red
                    )
                    .frame(width: 10, height: 10)
            }

            Spacer()

            Text(ghostscriptPath)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
    }
}
