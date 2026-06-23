//
//  FileSizeHelper.swift
//  Ringkes
//
//  Created by mardiansyah on 10/06/26.
//

import Foundation

enum FileSizeHelper {

    static func fileSize(
        at url: URL
    ) -> UInt64 {

        let attr =
            try? FileManager.default
                .attributesOfItem(
                    atPath: url.path
                )

        return attr?[.size] as? UInt64 ?? 0
    }

    static func format(
        _ bytes: UInt64
    ) -> String {

        ByteCountFormatter
            .string(
                fromByteCount:
                    Int64(bytes),
                countStyle: .file
            )
    }
}
