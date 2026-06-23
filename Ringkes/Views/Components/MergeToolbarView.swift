//
//  MergeToolbarView.swift
//  Ringkes
//
//  Created by mardiansyah on 09/06/26.
//

import SwiftUI

struct MergeToolbarView: View {

    let fileCount: Int

    let onManage: () -> Void
    let onMerge: () -> Void

    var body: some View {

        HStack {

            Button {

                onManage()

            } label: {

                HStack {

                    Image(systemName: "list.number")

                    Text("Manage Files")

                    if fileCount > 0 {

                        Text("(\(fileCount))")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .disabled(fileCount == 0)

            Button {

                onMerge()

            } label: {

                Label(
                    "Merge PDF",
                    systemImage:
                        "square.stack.3d.up.fill"
                )
            }
            .disabled(fileCount < 2)
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal)
    }
}
