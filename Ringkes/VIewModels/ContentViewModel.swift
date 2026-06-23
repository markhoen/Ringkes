//
//  ContentViewModel.swift
//  Ringkes
//
//  Created by mardiansyah on 10/06/26.
//

import Foundation
import SwiftUI
import Combine

final class ContentViewModel: ObservableObject {

    @Published var processItems: [PDFItem] = []
    @Published var mergeItems: [PDFItem] = []
    @Published var overwriteExisting = false
    @Published var ghostscriptAvailable = false
    @Published var homebrewAvailable = false
    @Published var ghostscriptPath = "-"
    @Published var actualGhostscriptPath = ""
    @Published var showGhostscriptAlert = false
    @Published var showMergeSuccessAlert = false
    @Published var mergedFileURL: URL?
    
    func loadSystemStatus() {
        let result =
        GhostscriptService.shared.detect()
        
        ghostscriptAvailable =
            result.available
        
        actualGhostscriptPath =
            result.path
        
        ghostscriptPath =
            result.displayName
        
        homebrewAvailable =
            GhostscriptService.shared
                .homebrewInstalled()
        
        if !result.available {
            showGhostscriptAlert = true
        }
    }
    
    func handleDrop(
        providers: [NSItemProvider],
        selectedMode: RingkesMode
    ) {

        PDFDropService.shared
            .extractURLs(
                from: providers
            ) { urls in

                for url in urls {

                    // =====================
                    // COMPRESS MODE
                    // =====================

                    if selectedMode == .compress {

                        if FileTypeHelper.isPDF(url) {

                            let attributes =
                                try? FileManager.default
                                    .attributesOfItem(
                                        atPath: url.path
                                    )

                            let size =
                                attributes?[.size]
                                    as? UInt64 ?? 0

                            self.processItems.append(
                                PDFItem(
                                    url: url,
                                    originalSize: size
                                )
                            )

                            let index =
                                self.processItems.count - 1

                            self.processPDF(at: index)
                        }

                        else if FileTypeHelper.isImage(url) {

                            guard let item =
                                PDFConverterService.shared
                                    .imageToPDF(
                                        imageURL: url
                                    )
                            else {
                                continue
                            }

                            self.processItems.append(item)

                            let index =
                                self.processItems.count - 1

                            self.processPDF(at: index)
                        }

                        else {

                            print(
                                "Unsupported file:",
                                url
                            )
                        }
                    }

                    // =====================
                    // MERGE MODE
                    // =====================

                    else if selectedMode == .merge {

                        guard
                            FileTypeHelper.isPDF(url)
                        else {
                            continue
                        }

                        let attributes =
                            try? FileManager.default
                                .attributesOfItem(
                                    atPath: url.path
                                )

                        let size =
                            attributes?[.size]
                                as? UInt64 ?? 0

                        self.mergeItems.append(
                            PDFItem(
                                url: url,
                                originalSize: size
                            )
                        )
                    }
                }
            }
    }

    func processPDF(at index: Int) {
        
        //let itemID = processItems[index].id

        guard ghostscriptAvailable else {

            processItems[index].status =
                "Ghostscript not installed"

            return
        }

        DispatchQueue.global(
            qos: .userInitiated
        ).async {

            DispatchQueue.main.async {

                self.processItems[index].status =
                    "Processing..."

                self.processItems[index].progress = 0.1
            }

            let result =
                PDFProcessService.shared.process(
                    item: self.processItems[index],
                    overwriteExisting: self.overwriteExisting,
                    ghostscriptPath: self.actualGhostscriptPath
                )

            DispatchQueue.main.async {

                if result.success {

                    if let finalURL = result.finalURL {

                        let attributes =
                            try? FileManager.default
                                .attributesOfItem(
                                    atPath: finalURL.path
                                )

                        let outputSize =
                            attributes?[.size]
                                as? UInt64 ?? 0

                        self.processItems[index]
                            .outputSize = outputSize
                    }

                    self.processItems[index].progress = 1.0

                    self.processItems[index].status =
                        "Finished → \(result.finalURL?.lastPathComponent ?? "")"

                } else {

                    self.processItems[index].status =
                        result.errorMessage
                        ?? "Ghostscript failed"

                    self.processItems[index].progress = 0
                }
            }
        }
    }
    
    func mergePDFs() {

        let success =
            PDFMergeService.merge(
                files: mergeItems
            )

        if success {

            showMergeSuccessAlert = true

            mergeItems.removeAll()
        }
    }

}
