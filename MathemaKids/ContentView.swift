//
//  ContentView.swift
//  MathemaKids
//
//  Created by Purnaman Rai on 28/08/2025.
//

import SwiftUI

struct QuestionAnswer {
    let question: String
    let answer: Int
    
    static func generateQuestions(count: Int, level: Int) -> [Self] {
        var questionAnswers = [Self]()
        for _ in 0..<count {
            let numberA = Int.random(in: 2...level)
            let numberB = Int.random(in: 1...12)
            let question = "\(numberA) x \(numberB) = ?"
            let answer = numberA * numberB
            questionAnswers.append(QuestionAnswer(question: question, answer: answer))
        }
        return questionAnswers
    }
}

struct ContentView: View {
    @State private var questionsToAsk = 5
    @State private var difficultyLevel = 5
    @State private var isConfiguringGame = true
    var isGameOn: Bool { !isConfiguringGame }
    
    @FocusState private var isAnswerFieldFocused: Bool
    @State private var userAnswer = ""
    @State private var userScore = 0
    
    @State private var allQuestions = [QuestionAnswer]()
    @State private var currentQuestionNumber = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    if isConfiguringGame {
                        Stepper("Ask me \(questionsToAsk) questions", value: $questionsToAsk, in: 5...20, step: 5)
                        Picker("From multiplication tables up to", selection: $difficultyLevel) {
                            ForEach(2..<13) { number in
                                Text(number.formatted())
                                    .tag(number)
                            }
                        }
                    }
                    
                    Button {
                        withAnimation {
                            if isConfiguringGame {
                                allQuestions = QuestionAnswer.generateQuestions(count: questionsToAsk, level: difficultyLevel)
                            }
                            isConfiguringGame.toggle()
                        }
                    } label: {
                        HStack {
                            if isGameOn {
                                Image(systemName: "chevron.backward")
                            }
                            Text(isConfiguringGame ? "Play" : "Back")
                                .contentTransition(.numericText())
                            if isConfiguringGame {
                                Image(systemName: "chevron.forward")
                            }
                        }
                    }
                }
                
                if isGameOn {
                    VStack {
                        HStack {
                            Spacer()
                            Text("Score: \(userScore)/\(questionsToAsk)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary.opacity(0.6))
                                .contentTransition(.numericText())
                        }
                        Text(allQuestions[currentQuestionNumber].question)
                            .font(.largeTitle.monospaced().bold())
                            .padding(.vertical, 100)
                            .contentTransition(.numericText())
                        TextField("Enter Your Answer", text: $userAnswer)
                            .keyboardType(.numberPad)
                            .focused($isAnswerFieldFocused)
                    }
                    .toolbar {
                        if isAnswerFieldFocused {
                            Button("Check") {
                                checkAnswer()
                                isAnswerFieldFocused = false
                            }
                        }
                    }
                }
            }
            .navigationTitle("MathemaKids")
        }
    }
    
    func checkAnswer() {
        withAnimation {
            if Int(userAnswer) == allQuestions[currentQuestionNumber].answer {
                userScore += 1
            }
            
            if currentQuestionNumber != (questionsToAsk - 1) {
                currentQuestionNumber += 1
            } else {
                isConfiguringGame = true
            }
            
            userAnswer = ""
        }
    }
}

#Preview {
    ContentView()
}
