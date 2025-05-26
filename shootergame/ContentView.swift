import SwiftUI

struct ContentView: View {
    @StateObject private var gameState = GameState()
    
    var body: some View {
        ZStack {
            // Background
            Color.black.edgesIgnoringSafeArea(.all)
            
            if gameState.isGameOver {
                GameOverView(score: gameState.score, onRestart: {
                    gameState.restartGame()
                })
            } else {
                GameView()
                    .environmentObject(gameState)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}