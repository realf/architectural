//
//  DrawingState.swift
//  VectorEd
//
//  Created by alf on 14.01.2026.
//

import Foundation

/// Runtime state for the drawing session
struct DrawingState {
    var currentTool: Tool = .rectangle
    var currentStyle: DrawingStyle = DrawingStyle()
    var temporaryShape: (any Shape)?
    var touchStartPoint: CGPoint?
    var isDrawing: Bool = false
}
