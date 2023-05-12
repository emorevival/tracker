//
//  ContentView.swift
//  Tracker
//
//  Created by Branko Bjadov on 5/12/23.
//

import SwiftUI
import AppIntents

struct ContentView: View {
    
    @State var projects: [Project] = []
    
    @State private var addButtonClicked: Bool = false
    
    var body: some View {
        VStack {
            Text("Tracker").font(.largeTitle).bold()
            Spacer()
            
            ForEach(projects, id: \.id) { project in
                HStack {
                    Text("Project name:")
                    Spacer()
                    Text(project.projectName)
                }
                HStack {
                    Text("Spent time:")
                    Spacer()
                    Text("\(project.spentTime) seconds")
                }

                .padding(.bottom)
                Divider()
            }
            

            Button(action: {addButtonClicked.toggle()}, label: {
                Image(systemName: "plus.circle.fill")
                    .resizable(resizingMode: .stretch)
                    
            })
            .frame(width: 50.0, height: 50.0)
        }
        .sheet(isPresented: $addButtonClicked, content: {
            AddProject(projects: $projects, addProjectClicked: $addButtonClicked)
        })
        .onAppear {
            projects = loadProjects()
        }
        
        .navigationBarTitle("Time Tracker")
        .padding(.all)
    }
}

class Project: ObservableObject, Codable, Equatable {
    var id = UUID()
    var projectName: String = ""
    var spentTime: Int = 0
    init(name: String, time: Int) {
        self.projectName = name
        self.spentTime = time
    }
    func addTime(_ time: Int) {
        self.spentTime += time
    }
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        if lhs.projectName == rhs.projectName {
            return true
        } else {
            return false
        }
    }
    
}

@available(iOS 16, *)
struct SiriTrackMinutesOnProject: AppIntent {
    
    @Parameter(title: "Project name")
    var projectName: String
    
    @Parameter(title: "Spent time")
    var spentTimeInMinutes: Int
    
    static var title: LocalizedStringResource = "Add X minutes on Y project"
    static var description = IntentDescription("Adds X minutes on Y project to the tracker")
    
    static var openAppWhenRun: Bool = true
    
    static var parameterSummary: some ParameterSummary {
        Summary("Adds X minutes on Y project to the tracker")
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let projects: [Project] = loadProjects()
        print(projectName)
        projects.forEach { project in
            if project.projectName == projectName {
                project.addTime(spentTimeInMinutes*60)
            }
            print("logged \(spentTimeInMinutes) min to \(projectName)")
        }
        saveProjects(projects)
        return .result(dialog: "Okay, logged \(spentTimeInMinutes) minutes to \(projectName)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
