//
//  HealthKitTask.swift
//  OCKSample
//
//  Created by Corey Baker on 5/9/21.
//  Copyright © 2021 Network Reconnaissance Lab. All rights reserved.
//

import CareKitStore
import SwiftUI

class HealthKitTask: ObservableObject {
    /// The UUID of the care plan to which this task belongs.
    @State var carePlanUUID: UUID?

    // MARK: OCKAnyTask
    @State var id = ""
    @State var title = ""
    @State var instructions = ""
    @State var impactsAdherence = true
    var schedule: OCKSchedule {
        willSet {
            scheduleElements = newValue.elements.map { ScheduleElement(element: $0) }
        }
    }
    @State var scheduleElements: [ScheduleElement]
    @State var groupIdentifier: String?
    @State var tags: [String]?

    // MARK: OCKVersionable
    @State var effectiveDate: Date?
    @State var deletedDate: Date?
    @State var uuid: UUID?
    @State var nextVersionUUIDs: [UUID]?
    @State var previousVersionUUIDs: [UUID]?

    // MARK: OCKObjectCompatible
    @State var createdDate: Date?
    @State var updatedDate: Date?
    @State var schemaVersion: OCKSemanticVersion?
    @State var remoteID: String?
    @State var source: String?
    @State var userInfo: [String: String]?
    @State var asset: String?
    @State var notes: [OCKNote]?
    @State var timezone: TimeZone?
    @State var healthKitLinkage: OCKHealthKitLinkage
    
    init (task: OCKHealthKitTask) {
        carePlanUUID = task.carePlanUUID
        id = task.id
        if let taskTitle = task.title {
            title = taskTitle
        }
        if let taskInstructions = task.instructions {
            instructions = taskInstructions
        }
        impactsAdherence = task.impactsAdherence
        schedule = task.schedule
        scheduleElements = task.schedule.elements.map { ScheduleElement(element: $0) }
        groupIdentifier = task.groupIdentifier
        tags = task.tags
        effectiveDate = task.effectiveDate
        deletedDate = task.deletedDate
        uuid = task.uuid
        nextVersionUUIDs = task.nextVersionUUIDs
        previousVersionUUIDs = task.previousVersionUUIDs
        createdDate = task.createdDate
        updatedDate = task.updatedDate
        deletedDate = task.deletedDate
        remoteID = task.remoteID
        source = task.source
        userInfo = task.userInfo
        asset = task.asset
        notes = task.notes
        timezone = task.timezone
        healthKitLinkage = task.healthKitLinkage
    }

    func convertToCareKit() -> OCKHealthKitTask {
        var task = OCKHealthKitTask(id: id, title: title, carePlanUUID: carePlanUUID, schedule: schedule, healthKitLinkage: healthKitLinkage)
        task.title = title
        task.instructions = instructions
        task.impactsAdherence = impactsAdherence
        task.schedule = OCKSchedule(composing: scheduleElements.map { $0.convertToCareKit() })
        task.groupIdentifier = groupIdentifier
        task.tags = tags
        if let effectiveDate = effectiveDate {
            task.effectiveDate = effectiveDate
        }
        task.remoteID = remoteID
        task.source = source
        task.userInfo = userInfo
        task.asset = asset
        task.notes = notes
        task.healthKitLinkage = healthKitLinkage
        return task
    }
}
