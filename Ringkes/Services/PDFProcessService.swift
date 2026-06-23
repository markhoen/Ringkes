//
//  PDFProcessService.swift
//  Ringkes
//
//  Created by mardiansyah on 10/06/26.
//

import Foundation

final class PDFProcessService {

    static let shared = PDFProcessService()

    private init() {}
    
    struct Result {

        let success: Bool
        let finalURL: URL?
        let errorMessage: String?
    }
    
    func process(
        item: PDFItem,
        overwriteExisting: Bool,
        ghostscriptPath: String
    ) -> Result {

        let inputURL = item.url

        let originalAttributes =
            try? FileManager.default.attributesOfItem(
                atPath: inputURL.path
            )

        let originalModifiedDate =
            originalAttributes?[.modificationDate] as? Date

        let isRealPDF =
            item.originalURL == nil

        let allowOverwrite =
            overwriteExisting && isRealPDF

        let namingSource =
            item.originalURL ?? inputURL

        let outputURL: URL
        let finalURL: URL

        if allowOverwrite {

            finalURL = inputURL

            outputURL = inputURL
                .deletingLastPathComponent()
                .appendingPathComponent(
                    UUID().uuidString + ".pdf"
                )

        } else {

            finalURL = namingSource
                .deletingPathExtension()
                .appendingPathExtension(
                    "ringkes.pdf"
                )

            outputURL = finalURL
        }

        let result =
            PDFCompressService.shared.compress(
                inputURL: inputURL,
                outputURL: outputURL,
                ghostscriptPath: ghostscriptPath
            )

        guard result.success else {

            return Result(
                success: false,
                finalURL: nil,
                errorMessage: result.errorMessage
            )
        }

        do {

            if allowOverwrite {

                let backupURL =
                    finalURL
                        .appendingPathExtension(
                            "backup"
                        )

                try? FileManager.default
                    .removeItem(at: backupURL)

                try FileManager.default.copyItem(
                    at: finalURL,
                    to: backupURL
                )

                try FileManager.default
                    .removeItem(at: finalURL)

                try FileManager.default.moveItem(
                    at: outputURL,
                    to: finalURL
                )

                try? FileManager.default
                    .removeItem(at: backupURL)
            }

            if isRealPDF,
               let modifiedDate =
                originalModifiedDate {

                try? FileManager.default
                    .setAttributes(
                        [
                            .modificationDate:
                                modifiedDate
                        ],
                        ofItemAtPath:
                            finalURL.path
                    )
            }

            if item.isTemporary {

                try? FileManager.default
                    .removeItem(at: inputURL)
            }

            return Result(
                success: true,
                finalURL: finalURL,
                errorMessage: nil
            )

        } catch {

            return Result(
                success: false,
                finalURL: nil,
                errorMessage:
                    error.localizedDescription
            )
        }
    }
}
