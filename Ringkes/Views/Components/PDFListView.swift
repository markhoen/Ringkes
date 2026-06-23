//
//  PDFListView.swift
//  Ringkes
//
//  Created by mardiansyah on 09/06/26.
//

import SwiftUI

struct PDFListView: View {

    let pdfs: [PDFItem]
    let selectedMode: RingkesMode

    var body: some View {

        List {

            ForEach(
                pdfs.indices,
                id: \.self
            ) { index in

                VStack(
                    alignment: .leading,
                    spacing: 8
                ) {

                    Text(
                        pdfs[index]
                            .url
                            .lastPathComponent
                    )
                    .font(.headline)
                    if pdfs[index].originalSize > 0 {

                        if pdfs[index].outputSize > 0 {

                            let original =
                                Double(
                                    pdfs[index].originalSize
                                )

                            let output =
                                Double(
                                    pdfs[index].outputSize
                                )

                            let saved =
                                max(
                                    0,
                                    Int(
                                        (
                                            1 -
                                            (output / original)
                                        ) * 100
                                    )
                                )

                            Text(
                                "\(FileSizeHelper.format(pdfs[index].originalSize)) → \(FileSizeHelper.format(pdfs[index].outputSize)) (-\(saved)%)"
                            )
                            .font(.caption)

                        } else {

                            Text(
                                FileSizeHelper.format(
                                    pdfs[index]
                                        .originalSize
                                )
                            )
                            .font(.caption)
                        }
                    }

                    if selectedMode == .compress {

                        ProgressView(
                            value: pdfs[index].progress
                        )

                        Text(
                            pdfs[index].status
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 5)
            }
        }
    }
}
