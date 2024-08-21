//
//  EdgePathResolver.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-20.
//

import Foundation

class EdgePathResolver {
    var allNodeBounds: [Node.ID : CGRect]
    private var allIntermidiatePoints: [Int : [CGPoint]]
    
    init() {
        self.allNodeBounds = [:]
        self.allIntermidiatePoints = [:]
    }
    
    func resolvePath(from start: EdgeAnchor, to end: EdgeAnchor, layerIndex: Int) -> [CGPoint] {
        var result: [CGPoint] = []
//        guard start.adjustedPoint.y != end.adjustedPoint.y else { return [start.adjustedPoint, end.adjustedPoint] }
        result.append(start.adjustedPoint)
        var firstPoint = nextPoint(start.adjustedPoint, end.adjustedPoint, start.placement)
        while aNodeIntersect(with: firstPoint) {
            firstPoint.x += 16
        }
        
        var edgeIntersection = anEdgeIntersect(with: firstPoint, at: layerIndex)
       
        while edgeIntersection.hasSameX {
            firstPoint.x += 8
            edgeIntersection = anEdgeIntersect(with: firstPoint, at: layerIndex)
        }
        
        while edgeIntersection.hasSameY {
            firstPoint.y += 8
            edgeIntersection = anEdgeIntersect(with: firstPoint, at: layerIndex)
        }
        
        result.append(firstPoint)
        
        // calcuate the second intermidiate point
        if firstPoint.y != end.adjustedPoint.y {
            result.append(end.adjustedPoint)
        }
        
        result.append(end.adjustedPoint)
        
        addIntermidiatePoint(firstPoint, to: layerIndex)
        addIntermidiatePoint(end.adjustedPoint, to: layerIndex)
        return result
    }
    
    private func aNodeIntersect(with point: CGPoint) -> Bool {
        for (_, value) in allNodeBounds {
            if value.contains(point) { return true }
            else { continue }
        }
        return false
    }
    
    private func nextPoint(
        _ start: CGPoint,
        _ end: CGPoint,
        _ placement: EdgeAnchorPlacement
    ) -> CGPoint {
        let xStart = start.x
        let yStart = start.y
        let yEnd = end.y
        let hOffset = placement.horizontalOffset()
        let vOffset = placement.verticalOffset
        switch placement {
        case .topTrailing:
            return CGPoint(x: xStart, y: yEnd)
        case .trailing, .leading:
            return CGPoint(x: xStart + hOffset, y: yStart)
        case .bottomTrailing:
            return CGPoint(x: xStart, y: yEnd)
        case .bottom, .bottomLeading:
            return CGPoint(x: xStart, y: yEnd)
        case .topLeading:
            return CGPoint(x: xStart + hOffset, y: yStart)
        case .top:
            return CGPoint(x: xStart, y: yStart + vOffset)
        }
    }
    
    private func anEdgeIntersect(with point: CGPoint, at layerIndex: Int) -> (hasSameX: Bool, hasSameY: Bool) {
        let hasSameX = allIntermidiatePoints[layerIndex, default: []].contains { $0.x == point.x }
        let hasSameY = allIntermidiatePoints[layerIndex, default: []].contains { $0.y == point.y }
        return (hasSameX, hasSameY)
    }
    
    func addIntermidiatePoint(_ point: CGPoint, to layerIndex: Int) {
        if !allIntermidiatePoints[layerIndex, default: []].contains(point) {
            allIntermidiatePoints[layerIndex, default: []].append(point)
        }
    }
    
    func clearAll() {
        allNodeBounds.removeAll(keepingCapacity: true)
        allIntermidiatePoints.removeAll(keepingCapacity: true)
    }
}
