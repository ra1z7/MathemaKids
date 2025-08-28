//
//  ContentView.swift
//  MathemaKids
//
//  Created by Purnaman Rai (College) on 28/08/2025.
//

import SwiftUI

struct GameSettingsView: View {
    @State private var difficultyLevel = 5
    @State private var questionsToAsk = 5
    
    var body: some View {
        Stepper("Ask me \(questionsToAsk) questions", value: $questionsToAsk, in: 5...20, step: 5)
        
        Picker("From multiplication tables up to", selection: $difficultyLevel) {
            ForEach(2..<13) { number in
                Text(number.formatted())
                    .tag(number)
            }
        }
    }
}

struct GameView: View {
    @State private var userAnswer = ""
    @FocusState private var isAnswerFocused: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            Text("12 x 12 = ?")
                .font(.largeTitle.monospaced().bold())
                .padding(.vertical, 80)
            TextField("Enter Your Answer", text: $userAnswer)
                .multilineTextAlignment(.center)
                .focused($isAnswerFocused)
                .keyboardType(.numberPad)
        }
        .toolbar {
            if isAnswerFocused {
                Button("Done") {
                    isAnswerFocused = false
                }
            }
        }
    }
}

struct ContentView: View {
    @State private var configuringGame = false
    
    var body: some View {
        NavigationStack {
            List {
                Section(configuringGame ? "Game Settings" : "") {
                    if configuringGame {
                        GameSettingsView()
                    }
                    playOrBackButtonView
                }
                
                if !configuringGame {
                    GameView()
                }
            }
            .navigationTitle("MathemaKids")
        }
    }
    
    var playOrBackButtonView: some View {
        Button {
            withAnimation {
                configuringGame.toggle()
            }
        } label: {
            HStack {
                if !configuringGame {
                    Image(systemName: "chevron.backward")
                }
                
                Text(configuringGame ? "Play" : "Back")
                    .contentTransition(.numericText())
                
                if configuringGame {
                    Image(systemName: "chevron.forward")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
