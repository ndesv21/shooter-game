import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameState: GameState
    @State private var dragLocation: CGPoint = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Player
                Circle()
                    .fill(gameState.player.color)
                    .frame(width: gameState.player.size, height: gameState.player.size)
                    .position(gameState.player.position)
                
                // Enemies
                ForEach(0..<gameState.enemies.count, id: \.self) { index in
                    Circle()
                        .fill(gameState.enemies[index].color)
                        .frame(width: gameState.enemies[index].size, height: gameState.enemies[index].size)
                        .position(gameState.enemies[index].position)
                }
                
                // Projectiles
                ForEach(0..<gameState.projectiles.count, id: \.self) { index in
                    Circle()
                        .fill(gameState.projectiles[index].color)
                        .frame(width: gameState.projectiles[index].size, height: gameState.projectiles[index].size)
                        .position(gameState.projectiles[index].position)
                }
                
                // Score and health display
                VStack {
                    HStack {
                        Text("Score: \(gameState.score)")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                        
                        Spacer()
                        
                        Text("Health: \(gameState.health)")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .background(Color.black)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let newPosition = CGPoint(x: value.location.x, y: gameState.player.position.y)
                        gameState.movePlayer(to: newPosition)
                    }
            )
            .onTapGesture {
                gameState.fireProjectile(at: gameState.player.position)
            }
        }
    }
}