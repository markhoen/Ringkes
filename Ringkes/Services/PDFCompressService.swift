//
//  PDFCompressService.swift
//  Ringkes
//
//  Created by mardiansyah on 09/06/26.
//

import Foundation

final class PDFCompressService {

    static let shared = PDFCompressService()

    private init() {}

    struct Result {

        let success: Bool
        let outputURL: URL?
        let errorMessage: String?
    }

    func compress(
        inputURL: URL,
        outputURL: URL,
        ghostscriptPath: String
    ) -> Result {

        let task = Process()

        task.launchPath = ghostscriptPath

        task.arguments = [
            "-sDEVICE=pdfwrite",
            "-dCompatibilityLevel=1.4",
            "-dPDFSETTINGS=/ebook",
            "-dDetectDuplicateImages=true",
            "-dCompressFonts=true",
            "-dSubsetFonts=true",
            "-dNOPAUSE",
            "-dBATCH",
            "-sOutputFile=\(outputURL.path)",
            inputURL.path
        ]

        let errorPipe = Pipe()

        task.standardError = errorPipe
        task.standardOutput = Pipe()

        do {

            try task.run()

        } catch {

            return Result(
                success: false,
                outputURL: nil,
                errorMessage: error.localizedDescription
            )
        }

        task.waitUntilExit()

        if task.terminationStatus == 0 {

            return Result(
                success: true,
                outputURL: outputURL,
                errorMessage: nil
            )
        }

        let errorData =
            errorPipe.fileHandleForReading
                .readDataToEndOfFile()

        let errorText =
            String(
                data: errorData,
                encoding: .utf8
            )

        return Result(
            success: false,
            outputURL: nil,
            errorMessage: errorText
        )
    }
}
