//
//  HomeWidget.swift
//  HomeWidget
//
//  Created by Davide Ceresa on 20.11.2024.
//

import WidgetKit
import SwiftUI
import Foundation

struct Task: Identifiable, Decodable {
    let id: Int
    let title: String
    let due: String

    static func toWidgetMap(_ task: Task) -> [String: Any] {
        let timeFormatted = "\(task.due)"
        return [
            "id": task.id,
            "title": task.title,
            "due": timeFormatted
        ]
    }

    static func decodeTasks(from json: String) -> [Task]? {
        let decoder = JSONDecoder()
        if let jsonData = json.data(using: .utf8) {
            return try? decoder.decode([Task].self, from: jsonData)
        }
        return nil
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let tasks: [Task]
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            tasks: [Task(id: 1, title: "Placeholder Task 1", due: "Tomorrow"),
                    Task(id: 2, title: "Placeholder Task 2", due: "Next Week")]
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let prefs = UserDefaults(suiteName: "group.com.ceredavide.moblab.widget")
        
        guard let savedTasksString = prefs?.string(forKey: "tasks") else {
            let entry = SimpleEntry(
                date: Date(),
                tasks: [Task(id: 1, title: "No tasks available", due: "N/A")]
            )
            completion(entry)
            return
        }
        
        if let decodedTasks = Task.decodeTasks(from: savedTasksString) {
            let entry = SimpleEntry(date: Date(), tasks: decodedTasks)
            completion(entry)
        } else {
            let entry = SimpleEntry(
                date: Date(),
                tasks: [Task(id: 1, title: "Failed to load tasks", due: "N/A")]
            )
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct HomeWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack() {
            Text("Today Tasks:")
                .font(.headline)
                .fontWeight(.bold)
                .padding([.top, .leading], 10)
            Spacer().frame(width: 0, height: 10)
            VStack(spacing: 8) {
                ForEach(entry.tasks) { task in
                    Text("• \(task.title) (Due: \(task.due))")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding(.leading, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding([.leading, .bottom], 10)
            Spacer()
        }
    }
}

struct HomeWidget: Widget {
    let kind: String = "HomeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HomeWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    HomeWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        tasks: [Task(id: 1, title: "Task 1", due: "Today"),
                Task(id: 2, title: "Task 2", due: "Tomorrow")]
    )
    SimpleEntry(
        date: .now,
        tasks: [Task(id: 3, title: "Another Task", due: "Next Week")]
    )
}
