//
//  AddProject.swift
//  Tracker
//
//  Created by Branko Bjadov on 5/12/23.
//

import SwiftUI

struct AddProject: View {
    
    @Binding var projects: [Project]
    @Binding var addProjectClicked: Bool
    
    @State var projectName: String = ""
    
    @State private var showAlert = false
    
    
    var body: some View {
        Form {
            TextField("Enter project name", text: $projectName)
            Button {
                if !projectName.isEmpty {
                    projects.append(Project(name: projectName, time: 0))
                    projectName = ""
                    saveProjects(projects)
                    addProjectClicked = false
                } else {
                    showAlert = true
                }
                
            } label: {
                Text("Save")
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Cannot add a project with no name")
                )
            }
        }
    }
}
