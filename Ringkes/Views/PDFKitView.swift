//
//  PDFKitView.swift
//  Ringkes
//
//  Created by mardiansyah on 10/06/26.
//

import SwiftUI
import PDFKit

struct PDFKitView: NSViewRepresentable {

    let pdfURL: URL

    func makeNSView(
        context: Context
    ) -> PDFView {

        let pdfView = PDFView()

        pdfView.autoScales = true

        pdfView.document =
            PDFDocument(url: pdfURL)

        return pdfView
    }

    func updateNSView(
        _ nsView: PDFView,
        context: Context
    ) {

        nsView.document =
            PDFDocument(url: pdfURL)
    }
}
