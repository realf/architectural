//
//  DrawingStyle.swift
//  VectorEd
//
//  Created by alf on 14.01.2026.
//

import UIKit

/// Encapsulates all visual styling properties for a shape
struct DrawingStyle: Codable, Equatable {
    var fillColor: CodableColor?
    var strokeColor: CodableColor
    var lineWidth: CGFloat
    var mode: DrawingMode
    var lineCap: CodableLineCap
    var lineJoin: CodableLineJoin

    init(
        fillColor: UIColor? = nil,
        strokeColor: UIColor = .black,
        lineWidth: CGFloat = 2.0,
        mode: DrawingMode = .stroke,
        lineCap: CGLineCap = .round,
        lineJoin: CGLineJoin = .round
    ) {
        self.fillColor = fillColor.map { CodableColor($0) }
        self.strokeColor = CodableColor(strokeColor)
        self.lineWidth = lineWidth
        self.mode = mode
        self.lineCap = CodableLineCap(value: lineCap.rawValue)
        self.lineJoin = CodableLineJoin(value: lineJoin.rawValue)
    }

    func apply(to context: CGContext) {
        context.setLineWidth(lineWidth)
        context.setLineCap(lineCap.cgLineCap)
        context.setLineJoin(lineJoin.cgLineJoin)
        context.setStrokeColor(strokeColor.uiColor.cgColor)
        if let fillColor = fillColor {
            context.setFillColor(fillColor.uiColor.cgColor)
        }
    }
}


enum DrawingMode: String, Codable {
    case fill
    case stroke
    // Both fill and stroke
    case both
}

struct CodableColor: Codable, Equatable {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat

    init(_ color: UIColor) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.red = r
        self.green = g
        self.blue = b
        self.alpha = a
    }

    var uiColor: UIColor {
        UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

struct CodableLineCap: Codable, Equatable {
    let value: Int32

    var cgLineCap: CGLineCap {
        CGLineCap(rawValue: self.value) ?? CGLineCap.butt
    }
}

struct CodableLineJoin: Codable, Equatable {
    let value: Int32

    var cgLineJoin: CGLineJoin {
        CGLineJoin(rawValue: self.value) ?? CGLineJoin.miter
    }
}
