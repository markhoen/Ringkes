//
//  PDFMergeService.swift
//  Ringkes
//
//  Created by mardiansyah on 09/06/26.
//

import PDFKit
import AppKit

class PDFMergeService {
    
    static var lastMergedFileURL: URL?

    static func merge(
        files: [PDFItem]
    ) -> Bool {

        let mergedDocument =
            PDFDocument()

        var pageIndex = 0

        for item in files {

            guard let document =
                PDFDocument(url: item.url)
            else {
                continue
            }

            for i in 0..<document.pageCount {

                if let page =
                    document.page(at: i) {

                    mergedDocument.insert(
                        page,
                        at: pageIndex
                    )

                    pageIndex += 1
                }
            }
        }

        let savePanel =
            NSSavePanel()

        savePanel.title =
            "Save Merged PDF"

        let dateFormatter =
            DateFormatter()

        dateFormatter.dateFormat =
            "yyyy-MM-dd"

        let dateString =
            DateHelper.currentDateString()

        savePanel.nameFieldStringValue =
            "ringkes-merged-\(dateString).pdf"

        if savePanel.runModal() == .OK,
           let outputURL = savePanel.url {

            mergedDocument.write(
                to: outputURL
            )

            lastMergedFileURL = outputURL

            return true
        }

        return false
    }
}
