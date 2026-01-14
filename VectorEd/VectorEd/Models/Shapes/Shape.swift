//
//  Shape.swift
//  VectorEd
//
//  Created by alf on 14.01.2026.
//

import UIKit

/// Core protocol that all drawable shapes must conform to
protocol Shape: Codable, Identifiable {
    var id: UUID { get }
    var creationDate: Date { get }
    var bounds: CGRect { get set }
    var style: DrawingStyle { get set }
    var shapeType: ShapeType { get }

    func draw(in context: CGContext)
    func createLayer() -> CAShapeLayer
    func path() -> UIBezierPath
}

enum ShapeType: String, Codable {
    case circle
    case rectangle
    case triangle
    case freehand
}
