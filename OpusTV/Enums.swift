//
//  Enums.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 09/03/25.
//

enum axis {
    case x
    case y
}

enum SceneState {
    case sala
    case cucina
    case libreria
    case laboratorio
    case minigame
    case title
}

enum MinigameState {
    case hidden
    case pozione
    case labirinto
}

enum deviceType {
    case iphone
    case watch
}

enum deviceState {
    case connected
    case disconnected
}
