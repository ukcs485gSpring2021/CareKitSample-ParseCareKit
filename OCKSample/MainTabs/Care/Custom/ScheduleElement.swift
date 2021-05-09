//
//  ScheduleElement.swift
//  OCKSample
//
//  Created by Corey Baker on 5/9/21.
//  Copyright © 2021 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import SwiftUI
import CareKitStore

class ScheduleElement: ObservableObject {
    /// An text about the time this element represents.
    /// e.g. before breakfast on Tuesdays, 5PM every day, etc.
    @State var text = ""

    /// The amount of time that the event should take, in seconds.
    var duration: OCKScheduleElement.Duration

    /// The date and time the first event occurs.
    // Note: This must remain a constant because its value is modified by the `isAllDay` flag during initialization.
    @State var start = Date()

    /// The latest possible time for an event to occur.
    /// - Note: Depending on the interval chosen, it is not guaranteed that an event
    ///         will fall on this date.
    /// - Note: If no date is provided, the schedule will repeat indefinitely.
    @State var end: Date?

    /// The amount of time between events specified using `DateCoponents`.
    /// - Note: `DateComponents` are chose over `TimeInterval` to account for edge
    ///         edge cases like daylight savings time and leap years.
    @State var interval: DateComponents

    /// An array of values that specify what values the user is expected to record.
    /// For example, for a medication, it may be the dose that the patient is expected to take.
    var targetValues: [OCKOutcomeValue]
    
    init(element: OCKScheduleElement) {
        if let elementText = element.text {
            text = elementText
        }
        start = element.start
        end = element.end
        interval = element.interval
        duration = element.duration
        targetValues = element.targetValues
    }

    func convertToCareKit() -> OCKScheduleElement {
        OCKScheduleElement(start: start, end: end, interval: interval, text: text, targetValues: targetValues, duration: duration)
    }
}
