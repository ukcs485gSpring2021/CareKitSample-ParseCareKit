//
//  LogValue.swift
//  OCKSample
//
//  Created by Corey Baker on 5/6/21.
//  Copyright © 2021 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import CareKit
import CareKitStore
import UIKit

protocol LogValueDelegate: AnyObject {
    func save(_ value: String)
}

class LogValue: ObservableObject {
    @Published var value = ""
    var delegate: LogValueDelegate?

    func save() {
        delegate?.save(value)
    }
}

