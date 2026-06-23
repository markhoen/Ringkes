//
//  AppHeaderView.swift
//  Ringkes
//
//  Created by mardiansyah on 09/06/26.
//

import SwiftUI

struct AppHeaderView: View {

    @Binding var overwriteExisting: Bool
    let selectedMode: RingkesMode

    var body: some View {

        HStack(alignment: .center) {

            Spacer()
                .frame(width: 30)

            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .shadow(radius: 8)

            VStack(alignment: .leading, spacing: 5) {

                Text("Ringkes")
                    .font(.largeTitle)
                    .bold()

                VStack(alignment: .leading, spacing: 0) {

                    Text("Cilik Ukurane,")

                    Text("Gedhe Manfaate")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }

            Spacer()

            if selectedMode == .compress {

                Toggle(
                    "Overwrite Original File(s)",
                    isOn: $overwriteExisting
                )
                .toggleStyle(.checkbox)
                .frame(width: 200)
            }
        }
        .padding(.horizontal)
    }
}
