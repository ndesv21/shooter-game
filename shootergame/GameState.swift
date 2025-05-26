import SwiftUI
import Combine

class GameState: ObservableObject {
    @Published var player = Player()
    @Published var enemies: [Enemy] = []
    @Published var projectiles: [Projectile] = []
    @Published var score: Int = 0
    @Published var isGameOver = false
    @Published var health: Int = 100
    
    private var enemySpawnTimer: Timer?
    private var gameLoopTimer: Timer?
    private var lastEnemySpawnTime: Date = Date()
    
    init() {
        startGame()
    }
    
    func startGame() {
        // Reset game state
        player = Player()
        enemies = []
        projectiles = []
        score = 0
        health = 100
        isGameOver = false
        
        // Start game loop
        gameLoopTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] _ in
            self?.updateGameState()
        }
        
        // Start enemy spawner
        enemySpawnTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { [weak self] _ in
            self?.spawnEnemy()
        }
    }
    
    func restartGame() {
        startGame()
    }
    
    func fireProjectile(at position: CGPoint) {
        let projectile = Projectile(position: player.position)
        projectiles.append(projectile)
    }
    
    func movePlayer(to position: CGPoint) {
        player.position = position
    }
    
    private func spawnEnemy() {
        // Spawn from top with random x position
        let screenWidth = UIScreen.main.bounds.width
        let randomX = CGFloat.random(in: 50..<screenWidth-50)
        let enemy = Enemy(position: CGPoint(x: randomX, y: -50))
        enemies.append(enemy)
    }
    
    private func updateGameState() {
        // Update projectiles
        for i in (0..<projectiles.count).reversed() {
            projectiles[i].update()
            
            // Remove projectiles that went off-screen
            if projectiles[i].position.y < -20 {
                projectiles.remove(at: i)
            }
        }
        
        // Update enemies
        for i in (0..<enemies.count).reversed() {
            enemies[i].update()
            
            // Check if enemy went off-screen
            if enemies[i].position.y > UIScreen.main.bounds.height + 50 {
                enemies.remove(at: i)
                continue
            }
            
            // Check for collisions with player
            if checkCollision(player: player, enemy: enemies[i]) {
                health -= 20
                enemies.remove(at: i)
                
                if health <= 0 {
                    endGame()
                }
                continue
            }
            
            // Check for collisions with projectiles
            for j in (0..<projectiles.count).reversed() {
                if i < enemies.count && j < projectiles.count {
                    if checkCollision(projectile: projectiles[j], enemy: enemies[i]) {
                        score += 10
                        
                        if i < enemies.count {
                            enemies.remove(at: i)
                        }
                        
                        if j < projectiles.count {
                            projectiles.remove(at: j)
                        }
                        break
                    }
                }
            }
        }
    }
    
    private func checkCollision(projectile: Projectile, enemy: Enemy) -> Bool {
        let distance = sqrt(
            pow(projectile.position.x - enemy.position.x, 2) +
            pow(projectile.position.y - enemy.position.y, 2)
        )
        return distance < (projectile.size + enemy.size) / 2
    }
    
    private func checkCollision(player: Player, enemy: Enemy) -> Bool {
        let distance = sqrt(
            pow(player.position.x - enemy.position.x, 2) +
            pow(player.position.y - enemy.position.y, 2)
        )
        return distance < (player.size + enemy.size) / 2
    }
    
    private func endGame() {
        isGameOver = true
        enemySpawnTimer?.invalidate()
        gameLoopTimer?.invalidate()
    }
    
    deinit {
        enemySpawnTimer?.invalidate()
        gameLoopTimer?.invalidate()
    }
}