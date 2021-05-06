//
//  LogValueView.swift
//  OCKSample
//
//  Created by Corey Baker on 5/6/21.
//  Copyright © 2021 Network Reconnaissance Lab. All rights reserved.
//

import SwiftUI

struct LogValueView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var model: LogValue
    @State var value = ""

    var body: some View {
        TextField("Value", text: $model.value)

        Button(action: {
            model.save()
            presentationMode.wrappedValue.dismiss()
        }, label: {
            
            Text("Save")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 300, height: 50)
        })
        .background(Color(.green))
        .cornerRadius(15)
        
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            
            Text("Cancel")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 300, height: 50)
        })
        .background(Color(.red))
        .cornerRadius(15)
    }
}

struct LogValueView_Previews: PreviewProvider {
    static var previews: some View {
        LogValueView(model: LogValue())
    }
}
