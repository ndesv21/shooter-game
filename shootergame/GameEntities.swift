import SwiftUI

struct Player {
    var position: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100)
    let size: CGFloat = 60
    let color: Color = .blue
}

struct Enemy {
    var position: CGPoint
    let size: CGFloat = 50
    let color: Color = .red
    var speed: CGFloat = 2.0
    
    mutating func update() {
        // Move down
        position.y += speed
    }
}

struct Projectile {
    var position: CGPoint
    let size: CGFloat = 20
    let color: Color = .yellow
    let speed: CGFloat = 10.0
    
    init(position: CGPoint) {
        // Start from player position
        self.position = position
    }
    
    mutating func update() {
        // Move up
        position.y -= speed
    }
}