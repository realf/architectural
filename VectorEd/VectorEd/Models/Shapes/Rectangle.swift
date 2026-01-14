//
//  Rectangle.swift
//  VectorEd
//
//  Created by alf on 14.01.2026.
//

import UIKit

struct Rectangle: Shape {
    let id: UUID
    var bounds: CGRect
    var style: DrawingStyle
    let shapeType: ShapeType
    let creationDate: Date

    init(id: UUID = UUID(), bounds: CGRect, style: DrawingStyle) {
        self.id = id
        self.bounds = bounds
        self.style = style
        self.shapeType = .rectangle
        self.creationDate = Date()
    }

    func draw(in context: CGContext) {
        style.apply(to: context)
        let path = self.path()

        switch style.mode {
        case .fill:
            context.addPath(path.cgPath)
            context.fillPath()
        case .stroke:
            context.addPath(path.cgPath)
            context.strokePath()
        case .both:
            context.addPath(path.cgPath)
            context.drawPath(using: .fillStroke)
        }
    }

    func createLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = path().cgPath
        layer.fillColor = style.mode != .stroke ? style.fillColor?.uiColor.cgColor : nil
        layer.strokeColor = style.mode != .fill ? style.strokeColor.uiColor.cgColor : nil
        layer.lineWidth = style.lineWidth
        layer.lineCap = .round
        layer.lineJoin = .round
        return layer
    }

    func path() -> UIBezierPath {
        UIBezierPath(rect: bounds)
    }
}
