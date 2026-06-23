//
//  FileTypeHelper.swift
//  Ringkes
//
//  Created by mardiansyah on 09/06/26.
//

import Foundation
import UniformTypeIdentifiers

enum FileTypeHelper {

    static func isPDF(_ url: URL) -> Bool {

        url.pathExtension.lowercased() == "pdf"
    }

    static func isImage(_ url: URL) -> Bool {

        guard let type =
            UTType(filenameExtension: url.pathExtension)
        else {
            return false
        }

        return type.conforms(to: .image)
    }
}
