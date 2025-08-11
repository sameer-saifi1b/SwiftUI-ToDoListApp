//
//  ContentView.swift
//  ToDoListApp
//
//  Created by Sameer Saifi on 10/08/25.
//

import SwiftUI

struct Task: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool
}

struct ContentView: View {
    @State private var task = ""
    @State private var tasks = [Task]()

    var body: some View {
        VStack {
            TextField("Enter new task", text: $task)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: addTask) {
                Text("Add Task")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)

            List {
                ForEach($tasks) { $task in
                    HStack {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                task.isCompleted.toggle()
                                saveTasks()
                            }
                            .foregroundColor(task.isCompleted ? .green : .gray)

                        Text(task.title)
                            .strikethrough(task.isCompleted, color: .gray)
                    }
                }
                .onDelete(perform: deleteTask)
            }
        }
        .padding()
        .onAppear(perform: loadTasks)
    }

    func addTask() {
        if !task.isEmpty {
            let newTask = Task(title: task, isCompleted: false)
            tasks.append(newTask)
            task = ""
            saveTasks()
        }
    }

    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        saveTasks()
    }

    func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }

    func loadTasks() {
        if let savedData = UserDefaults.standard.data(forKey: "tasks") {
            if let decoded = try? JSONDecoder().decode([Task].self, from: savedData) {
                tasks = decoded
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
