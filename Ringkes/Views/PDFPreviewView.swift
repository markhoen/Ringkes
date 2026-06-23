//
//  PDFPreviewView.swift
//  Ringkes
//
//  Created by mardiansyah on 10/06/26.
//

import SwiftUI
import PDFKit

struct PDFPreviewView: View {

    let pdfURL: URL

    @Environment(\.dismiss)
    private var dismiss

    var body: some View {

        VStack {

            HStack {

                Text(
                    pdfURL.lastPathComponent
                )
                .font(.headline)

                Spacer()

                Button("Close") {

                    dismiss()
                }
            }
            .padding()

            PDFKitView(
                pdfURL: pdfURL
            )
        }
        .frame(
            minWidth: 900,
            minHeight: 700
        )
    }
}
