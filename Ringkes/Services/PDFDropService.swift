//
//  PDFDropService.swift
//  Ringkes
//
//  Created by mardiansyah on 09/06/26.
//

import UniformTypeIdentifiers
import Foundation

final class PDFDropService {

    static let shared = PDFDropService()

    private init() {}

    func extractURLs(
        from providers: [NSItemProvider],
        completion: @escaping ([URL]) -> Void
    ) {

        var urls: [URL] = []

        let group = DispatchGroup()

        for provider in providers {

            group.enter()

            provider.loadItem(
                forTypeIdentifier:
                    UTType.fileURL.identifier,
                options: nil
            ) { item, error in

                defer {
                    group.leave()
                }

                guard let data = item as? Data,
                      let url = URL(
                        dataRepresentation: data,
                        relativeTo: nil
                      )
                else {
                    return
                }

                urls.append(url)
            }
        }

        group.notify(
            queue: .main
        ) {
            completion(urls)
        }
    }
}
