//
//  PDFConverterService.swift
//  Ringkes
//
//  Created by mardiansyah on 09/06/26.
//

import Foundation
import PDFKit
import AppKit

final class PDFConverterService {

    static let shared = PDFConverterService()

    private init() {}

    func imageToPDF(
        imageURL: URL
    ) -> PDFItem? {

        guard let image = NSImage(contentsOf: imageURL),
              let page = PDFPage(image: image)
        else {
            return nil
        }

        let document = PDFDocument()

        document.insert(page, at: 0)

        let tempPDFURL =
            imageURL
                .deletingLastPathComponent()
                .appendingPathComponent(
                    UUID().uuidString + ".pdf"
                )

        document.write(to: tempPDFURL)

        let attributes =
            try? FileManager.default
                .attributesOfItem(
                    atPath: imageURL.path
                )

        let size =
            attributes?[.size]
                as? UInt64 ?? 0

        return PDFItem(
            url: tempPDFURL,
            originalURL: imageURL,
            progress: 0,
            status: "Converting...",
            isTemporary: true,
            originalSize: size
        )
    }
}
