//
//  ContentView.swift
//  MathemaKids
//
//  Created by Purnaman Rai on 28/08/2025.
//

import AVFoundation
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

class AudioManager {
    static var shared = AudioManager()
    var player: AVAudioPlayer?

    func playMusic() {
        guard let url = Bundle.main.url(forResource: "Playful", withExtension: "mp3") else {
            print("Playful.mp3 not found")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.play()
        } catch {
            print("Could not play music: \(error.localizedDescription)")
        }
    }

    func stopMusic() {
        player?.stop()
    }
}

struct BackgroundView: View {
    let allBackgrounds: [ImageResource] = [
        .backgroundCastles,
        .backgroundColorDesert,
        .backgroundColorFall,
        .backgroundColorForest,
        .backgroundColorGrass,
        .backgroundDesert,
        .backgroundForest
    ]
    
    @State private var xAxis = 1300.0
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0 ..< 3) { _ in
                Image(.backgroundColorGrass)
            }
        }
        .scaledToFill()
        .ignoresSafeArea()
        .offset(x: xAxis, y: 0)
        .onAppear {
            AudioManager.shared.playMusic()
            withAnimation(.linear(duration: 300)) {
                xAxis = -1300.0
            }
        }
    }
}

struct GameSettingsView: View {
    @State private var questionsToAsk = 10
    @State private var difficultyLevel = 5
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                Spacer()
                Spacer()
                
                Text("MathemaKids")
                    .font(.custom("Jua-Regular", size: 50))
                    .foregroundStyle(.white)
                    .shadow(radius: 1)
                    .shadow(radius: 1)
                    .shadow(radius: 10)
                
                Spacer()
                
                VStack {
                    Text("Game Settings")
                        .font(.custom("Jua-Regular", size: 22))
                        .foregroundStyle(.secondary)
                        .padding(.top, 30)
                        .padding(.bottom, 20)
                    
                    HStack {
                        Button {
                            if questionsToAsk >= 10 {
                                questionsToAsk -= 5
                            }
                        } label: {
                            Image(.arrowLeft)
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        Text("Ask me \(questionsToAsk) questions")
                            .font(.custom("Jua-Regular", size: 20))
                            .frame(width: 220)
                        Button {
                            if questionsToAsk <= 15 {
                                questionsToAsk += 5
                            }
                        } label: {
                            Image(.arrowRight)
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                    .padding()
                
                    
                    HStack {
                        Button {
                            if difficultyLevel > 2 {
                                difficultyLevel -= 1
                            }
                        } label: {
                            Image(.arrowLeft)
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        Text("From multiplication tables up to \(difficultyLevel)")
                            .font(.custom("Jua-Regular", size: 20))
                            .frame(width: 220)
                            .multilineTextAlignment(.center)
                        Button {
                            if difficultyLevel < 12 {
                                difficultyLevel += 1
                            }
                        } label: {
                            Image(.arrowRight)
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                    .padding()
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 10)
                .background(.white)
                .clipShape(.rect(cornerRadius: 20))
                .shadow(radius: 1)
                
                Spacer()
                
                Button {
                    
                } label: {
                    ZStack {
                        Image(.buttonRectangleDepthFlat)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                        Text("Start Game")
                            .font(.custom("Jua-Regular", size: 30))
                            .foregroundStyle(.white)
                            .shadow(radius: 3)
                    }
                }
                .padding()
                
                Spacer()
                Spacer()
            }
        }
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
    
    @State private var alertTitle = ""
    @State private var isShowingAlert = false
    
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
                    .alert(alertTitle, isPresented: $isShowingAlert) {
                        Button(currentQuestionNumber < (questionsToAsk - 1) ? "Next" : "Back") {
                            withAnimation {
                                if currentQuestionNumber < (questionsToAsk - 1) {
                                    currentQuestionNumber += 1
                                } else {
                                    isConfiguringGame = true
                                }
                                
                                userAnswer = ""
                            }
                        }
                    }
                }
            }
            .navigationTitle("MathemaKids")
        }
    }
    
    func checkAnswer() {
        if Int(userAnswer) == allQuestions[currentQuestionNumber].answer {
            userScore += 1
            alertTitle = "Correct!"
        } else {
            alertTitle = "Oops, wrong..."
        }
        
        if currentQuestionNumber == (questionsToAsk - 1) {
            alertTitle = "Final Score: \(userScore)/\(questionsToAsk)"
        }
        
        isShowingAlert = true
    }
}

#Preview {
    GameSettingsView()
}
