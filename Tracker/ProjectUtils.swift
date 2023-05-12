//
//  ProjectUtils.swift
//  Tracker
//
//  Created by Branko Bjadov on 5/12/23.
//

import Foundation


func saveProjects(_ projects: [Project]) {
    let data = projects.map { try? JSONEncoder().encode($0) }
    UserDefaults.standard.set(data, forKey: "Projects")
}

/// Loads projects from user defaults.
/// - Returns: A array of projects.
func loadProjects() -> [Project] {
    guard let encodedData = UserDefaults.standard.array(forKey: "Projects") as? [Data] else {
        return []
    }
    return encodedData.map { try! JSONDecoder().decode(Project.self, from: $0) }
}


/// Returns a tuple of hours, minutes, seconds from seconds.
/// - Parameters:
///     - seconds: Int representing seconds
/// - Returns: Tuple (hours, minutes, seconds)
///
private func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}

/// Formats an given int into HH:MM:SS format.
/// - Parameters:
///     - seconds: Int representing seconds
///
func formattedTime(seconds: Int) -> String {
    let (hours, minutes, seconds) = secondsToHoursMinutesSeconds(seconds: seconds)
    let hoursString = hours
    var minutesString = "00"
    if minutes < 10 {
        minutesString = "0\(minutes)"
    } else {
        minutesString = String(minutes)
    }
    var secondsString = "00"
    if seconds < 10 {
        secondsString = "0\(seconds)"
    } else {
        secondsString = String(seconds)
    }
    if hours >= 1 {
        return "\(hoursString):\(minutesString):\(secondsString)"
    } else {
        return "\(minutesString):\(secondsString)"
    }
}

