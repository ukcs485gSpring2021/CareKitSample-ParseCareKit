//
//  UpdateTasksView.swift
//  OCKSample
//
//  Created by Corey Baker on 5/9/21.
//  Copyright © 2021 Network Reconnaissance Lab. All rights reserved.
//

import SwiftUI
import CareKitStore

struct UpdateTasksView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = UpdateTasks()
    let date: Date
    var body: some View {
        Form {
            ForEach(viewModel.healthKitTasks, id: \.self) { task in
                Section(header: Text(task.id)) {
                    TextField("Title", text: task.$title)
                    TextField("Instructions", text: task.$instructions)
                    Picker(selection: task.$impactsAdherence, label: Text("Impacts Adherence"), content: {
                        Text("True").tag(true)
                        Text("False").tag(false)
                    })
                    //Only show first and last elements
                    if task.scheduleElements.first != nil {
                    TextField("Text", text: task.scheduleElements.first!.$text)
                        DatePicker("Start", selection: task.scheduleElements.first!.$start, displayedComponents: [DatePickerComponents.date])
                    }
                    if task.scheduleElements.count > 1 {
                        TextField("Text", text: task.scheduleElements.last!.$text)
                        DatePicker("Start", selection: task.scheduleElements.last!.$start, displayedComponents: [DatePickerComponents.date])
                    }
                }
            }
        }.onAppear(perform: {
            viewModel.date = date
        })
    }
}

struct UpdateTasksView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateTasksView(date: Date())
    }
}

