//
//  DateHelper..swift
//  Ringkes
//
//  Created by mardiansyah on 09/06/26.
//

import Foundation

enum DateHelper {

    static func currentDateString() -> String {

        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy-MM-dd"

        return formatter.string(
            from: Date()
        )
    }
}
