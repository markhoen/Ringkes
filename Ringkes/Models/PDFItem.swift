//
//  PDFItem.swift
//  Ringkes
//
//  Created by mardiansyah on 09/06/26.
//

import Foundation

struct PDFItem: Identifiable {

    let id = UUID()
    let url: URL

    var originalURL: URL? = nil

    var progress: Double = 0
    var status: String = "Waiting"

    var isTemporary: Bool = false
    
    var originalSize: UInt64 = 0

    var compressedSize: UInt64 = 0
    
    var outputSize: UInt64 = 0
}
