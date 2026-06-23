//
//  MergeManagerView.swift
//  Ringkes
//
//  Created by mardiansyah on 09/06/26.
//

import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct MergeManagerView: View {

    @Binding var pdfs: [PDFItem]

    @Environment(\.dismiss)
    private var dismiss
    @State private var isTargeted = false
    @State private var showDuplicateAlert = false
    @State private var previewURL: URL?
    
    var totalFiles: Int {
        pdfs.count
    }
    
    var totalSize: UInt64 {
        pdfs.reduce(0) {
            $0 + $1.originalSize
        }
    }
    
    var estimatedMergedSize: UInt64 {
        totalSize
    }

    var body: some View {

        VStack {

            Text("Merge PDF Manager")
                .font(.title2)
                .bold()
            
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    isTargeted ? .blue : .gray,
                    style: StrokeStyle(
                        lineWidth: 2,
                        dash: [8]
                    )
                )
                .frame(height: 120)
                .overlay {

                    VStack {

                        Image(systemName: "doc.badge.plus")
                            .font(.system(size: 32))

                        Text("Drop PDF Here")
                    }
                }
                .onDrop(
                    of: [UTType.fileURL],
                    isTargeted: $isTargeted
                ) { providers in

                    handleDrop(providers)

                    return true
                }
            
            HStack {

                Button("Add Files") {

                    addFiles()
                }

                Button("Clear All") {

                    pdfs.removeAll()
                }

                Spacer()
            }
            
            HStack(spacing: 20) {

                VStack(alignment: .leading) {

                    Label(
                        "\(totalFiles) Files Ready",
                        systemImage: "doc.on.doc"
                    )
                    .font(.headline)

                    Text("Ready to merge")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing) {

                    Text("Estimated Output")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(
                        FileSizeHelper.format(
                            estimatedMergedSize
                        )
                    )
                    .font(.title3)
                    .bold()
                }
            }
            .padding()
            .background(.quaternary.opacity(0.5))
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 12
                )
            )
            
            List {

                ForEach(
                    Array(pdfs.enumerated()),
                    id: \.element.id
                ) { index, item in

                    HStack {

                        Text("\(index + 1)")
                            .frame(width: 30)

                        VStack(
                            alignment: .leading
                        ) {

                            Text(
                                item.url.lastPathComponent
                            )

                            Text(
                                FileSizeHelper.format(
                                    item.originalSize
                                )
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }

                        Spacer()
                        
                        Button {
                            previewURL = item.url
                        } label: {
                            Image(systemName: "eye")
                        }
                        .buttonStyle(.borderless)
                        .help("Preview")

                        Button {

                            moveUp(index)

                        } label: {

                            Image(systemName: "chevron.up")
                        }
                        .buttonStyle(.borderless)
                        .help("Move Up")

                        Button {

                            moveDown(index)

                        } label: {

                            Image(systemName: "chevron.down")
                        }
                        .buttonStyle(.borderless)
                        .help("Move Down")

                        Button {

                            deleteItem(index)

                        } label: {

                            Image(systemName: "trash")
                        }
                        .buttonStyle(.borderless)
                    }
                }
                .onMove(
                    perform: moveItems
                )
            }

            HStack {

                Spacer()

                Button("Done") {

                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding()
        .frame(
            minWidth: 700,
            minHeight: 500
        )
        .alert(
            "File Already Added",
            isPresented: $showDuplicateAlert
        ) {

            Button("OK") { }

        } message: {

            Text(
                "PDF tersebut sudah ada dalam daftar merge."
            )
        }
        .sheet(
            isPresented: Binding(
                get: {
                    previewURL != nil
                },
                set: { value in

                    if !value {
                        previewURL = nil
                    }
                }
            )
        ) {

            if let url = previewURL {

                PDFPreviewView(
                    pdfURL: url
                )
            }
        }
    }

    func moveUp(
        _ index: Int
    ) {

        guard index > 0 else {
            return
        }

        pdfs.swapAt(
            index,
            index - 1
        )
    }

    func moveDown(
        _ index: Int
    ) {

        guard index <
                pdfs.count - 1
        else {
            return
        }

        pdfs.swapAt(
            index,
            index + 1
        )
    }

    func deleteItem(
        _ index: Int
    ) {

        pdfs.remove(
            at: index
        )
    }
    
    func moveItems(
        from source: IndexSet,
        to destination: Int
    ) {

        pdfs.move(
            fromOffsets: source,
            toOffset: destination
        )
    }
    
    func handleDrop(
        _ providers: [NSItemProvider]
    ) {

        PDFDropService.shared
            .extractURLs(
                from: providers
            ) { urls in

                DispatchQueue.main.async {

                    for url in urls {

                        guard
                            FileTypeHelper.isPDF(url)
                        else {
                            continue
                        }

                        let size =
                            FileSizeHelper.fileSize(
                                at: url
                            )

                        if pdfs.contains(
                            where: { $0.url == url }
                        ) {
                            showDuplicateAlert = true
                        } else {

                            self.pdfs.append(
                                PDFItem(
                                    url: url,
                                    originalSize: size
                                )
                            )
                        }
                    }
                }
            }
    }
    
    func addFiles() {

        let panel = NSOpenPanel()

        panel.allowedContentTypes = [.pdf]
        panel.allowsMultipleSelection = true

        if panel.runModal() == .OK {

            for url in panel.urls {

                let size =
                    FileSizeHelper.fileSize(
                        at: url
                    )

                if pdfs.contains(
                    where: { $0.url == url }
                ) {
                    showDuplicateAlert = true
                } else {

                    pdfs.append(
                        PDFItem(
                            url: url,
                            originalSize: size
                        )
                    )
                }
            }
        }
    }
}
