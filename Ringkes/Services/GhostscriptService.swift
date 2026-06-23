//
//  GhostscriptService.swift
//  Ringkes
//
//  Created by mardiansyah on 09/06/26.
//

import Foundation

final class GhostscriptService {

    static let shared = GhostscriptService()

    private init() {}

    struct Result {

        let available: Bool
        let usingEmbedded: Bool
        let path: String
        let displayName: String
    }

    func detect() -> Result {

        let arch = currentArchitecture()

        // ============================
        // PRIORITY 1 : EMBEDDED GS
        // ============================

        var embeddedName = ""

        if arch == "arm64" {

            embeddedName = "gs-arm64"

        } else if arch == "x86_64" {

            embeddedName = "gs-x86_64"
        }

        if let embeddedGS =
            Bundle.main.path(
                forResource: embeddedName,
                ofType: nil
            ) {

            return Result(
                available: true,
                usingEmbedded: true,
                path: embeddedGS,
                displayName: "Embedded \(arch)"
            )
        }

        // ============================
        // PRIORITY 2 : SYSTEM GS
        // ============================

        let systemGSPaths = [

            "/opt/homebrew/bin/gs",
            "/usr/local/bin/gs",
            "/opt/local/bin/gs"
        ]

        if let foundGS =
            systemGSPaths.first(where: {

                FileManager.default
                    .fileExists(atPath: $0)

            }) {

            return Result(
                available: true,
                usingEmbedded: false,
                path: foundGS,
                displayName: "System GS"
            )
        }

        // ============================
        // NOT FOUND
        // ============================

        return Result(
            available: false,
            usingEmbedded: false,
            path: "",
            displayName: "Ghostscript not found"
        )
    }

    func homebrewInstalled() -> Bool {

        let paths = [

            "/opt/homebrew/bin/brew",
            "/usr/local/bin/brew"
        ]

        return paths.contains {

            FileManager.default
                .fileExists(atPath: $0)
        }
    }

    private func currentArchitecture() -> String {

        #if arch(arm64)
        return "arm64"
        #elseif arch(x86_64)
        return "x86_64"
        #else
        return "unknown"
        #endif
    }
}
