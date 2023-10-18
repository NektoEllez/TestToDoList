//
//  TaskView.swift
//  TestToDoList
//
//  Created by Иван Марин on 18.10.2023.
//

import SwiftUI
import CoreHaptics

struct TaskView: View {
    @Binding var task: Task
    @State private var scale: CGFloat = 1.0

    var body: some View {
        HStack {
            TextField("Задача", text: $task.name)
            Spacer()
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 30))
                .scaleEffect(scale)
                .onTapGesture {
                    // Вибрация
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    
                    // Анимация
                    withAnimation {
                        scale += 0.1
                    }
                    
                    // Изменение статуса задачи
                    task.isCompleted.toggle()
                    
                    // Возвращаем анимацию к исходному состоянию
                    withAnimation {
                        scale = 1.0
                    }
                }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 15)
        .background(Color.white)
    }
}


#Preview {
    TaskView(task: .constant(Task(name: "Пример задачи", isCompleted: true)))
}
