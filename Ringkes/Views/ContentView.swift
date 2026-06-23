//
//  ContentView.swift
//  Ringkes
//
//  Created by mardiansyah on 17/05/26.
//

import SwiftUI
import UniformTypeIdentifiers
import AppKit
import PDFKit

struct ContentView: View {
    
    @StateObject private var vm = ContentViewModel()

    @State private var isTargeted = false
    
    @State private var selectedMode: RingkesMode = .compress
    @State private var showMergeManager = false

    var body: some View {

        VStack {
            VStack(spacing: 20) {
                
                AppHeaderView(
                    overwriteExisting: $vm.overwriteExisting,
                    selectedMode: selectedMode
                )
                .padding(.horizontal)
                
                Picker(
                    "Mode",
                    selection: $selectedMode
                ) {
                    ForEach(
                        RingkesMode.allCases,
                        id: \.self
                    ) { mode in

                        Text(mode.rawValue)
                            .tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                if selectedMode == .compress {
                    StatusBarView(
                        ghostscriptAvailable: vm.ghostscriptAvailable,
                        homebrewAvailable: vm.homebrewAvailable,
                        ghostscriptPath: vm.ghostscriptPath
                    )

                    .padding(.horizontal)

                }
                
                DropZoneView(
                    isTargeted: isTargeted,
                    selectedMode: selectedMode
                )
                .padding(.horizontal)
                .onDrop(
                    of: [UTType.fileURL],
                    isTargeted: $isTargeted
                ) { providers in

                    vm.handleDrop(
                        providers: providers,
                        selectedMode: selectedMode
                    )

                    return true
                }
                
                PDFListView(
                    pdfs: selectedMode == .compress
                        ? vm.processItems
                        : vm.mergeItems,
                    selectedMode: selectedMode
                )
                
                
                
                if selectedMode == .merge {

                    MergeToolbarView(
                        fileCount: vm.mergeItems.count,
                        onManage: {
                            showMergeManager = true
                        },
                        onMerge: {
                            vm.mergePDFs()
                        }
                    )
                }
            }
            Spacer()
        }
        .frame(
            minWidth: 500,
            maxWidth: .infinity,
            minHeight: 400,
            maxHeight: .infinity,
            alignment: .top
        )
        .padding()
        .onAppear {

            vm.loadSystemStatus()
        }
        
        .alert(
            "Merge Complete",
            isPresented: $vm.showMergeSuccessAlert
        ) {

            Button("Open in Finder") {

                if let url =
                    PDFMergeService.lastMergedFileURL {

                    NSWorkspace.shared.activateFileViewerSelecting(
                        [url]
                    )
                }
            }

            Button("OK") { }

        } message: {

            Text(
                "Merged PDF created successfully."
            )
        }
        
        .alert(
            "Ghostscript Required",
            isPresented: $vm.showGhostscriptAlert
        ) {

            Button("Open Website") {

                if let url = URL(string: "https://ghostscript.com/releases/gsdnld.html") {

                    NSWorkspace.shared.open(url)
                }
            }

            Button("OK", role: .cancel) { }

        } message: {

            Text("""
        Ringkes membutuhkan Ghostscript untuk memproses PDF.

        Install via Homebrew:

        brew install ghostscript
        """)
        }
        
        .sheet(isPresented: $showMergeManager) {

            MergeManagerView(
                pdfs: $vm.mergeItems
            )
        }
    }
}

#Preview {
    ContentView()
}
