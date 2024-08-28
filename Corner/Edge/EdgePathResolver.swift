//
//  EdgePathResolver.swift
//  Corner
//
//  Created by Mori Ahmadi on 2024-08-20.
//

import Foundation

class EdgePathResolver {
    private var allNodeBounds: [Node.ID : CGRect]
    private var allIntermidiatePoints: [Int : [CGPoint]]
    
    init() {
        self.allNodeBounds = [:]
        self.allIntermidiatePoints = [:]
    }
    
    func resolvePath(
        from start: EdgeAnchor,
        to end: EdgeAnchor,
        with direction: FlowDirection,
        layerIndex: Int
    ) -> [CGPoint] {
        var result: [CGPoint] = []
        result.append(start.adjustedPoint)
        if start.placement == .top || start.placement == .bottom {
            return [start.adjustedPoint, end.adjustedPoint]
        }
        // Calculate the first intermediate point
        let firstIntermediatePoint = calculateAdjustedPoint(
            initialPoint: firstPoint(
                start.adjustedPoint,
                end.adjustedPoint,
                start.placement
            ),
            with: direction,
            layerIndex: layerIndex
        )
        
        result.append(firstIntermediatePoint)
        
        // Calculate the second intermediate point if needed
        if firstIntermediatePoint.y != end.adjustedPoint.y {
            var secondIntermediatePoint = secondPoint(firstIntermediatePoint, end.adjustedPoint)
            secondIntermediatePoint = calculateAdjustedPoint(
                initialPoint: secondIntermediatePoint,
                with: direction,
                layerIndex: layerIndex
            )
            result.append(secondIntermediatePoint)
            addIntermediatePoint(secondIntermediatePoint, to: layerIndex)
        }
        
        result.append(end.adjustedPoint)
        
        addIntermediatePoint(firstIntermediatePoint, to: layerIndex)
        addIntermediatePoint(end.adjustedPoint, to: layerIndex)
        
        return result
    }

    private func calculateAdjustedPoint(
        initialPoint: CGPoint,
        with direction: FlowDirection,
        layerIndex: Int
    ) -> CGPoint {
        var point = initialPoint
        
        // Adjust for node intersection
        while aNodeIntersect(with: point) {
            point.x += direction.isTowardsEast ? 16 : -16
        }
        
        // Adjust for edge intersection
        var edgeIntersection = anEdgeIntersect(with: point, towards: direction, at: layerIndex)
        
        while edgeIntersection.hasSameX {
            point.x += direction.isTowardsEast ? 8 : -8
            edgeIntersection = anEdgeIntersect(with: point, towards: direction, at: layerIndex)
        }
        
        while edgeIntersection.hasSameY {
            point.y += direction.isTowardsNorth ? -16 : 16
            edgeIntersection = anEdgeIntersect(with: point, towards: direction, at: layerIndex)
        }
        
        return point
    }
    
    private func aNodeIntersect(with point: CGPoint) -> Bool {
        for (_, value) in allNodeBounds {
            if value.contains(point) { return true }
            else { continue }
        }
        return false
    }
    
    private func firstPoint(
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
        case .topTrailing, .bottomTrailing:
            return CGPoint(x: xStart + hOffset, y: yStart)
        case .trailing, .leading:
            return CGPoint(x: xStart + hOffset, y: yStart)
        case .bottom, .bottomLeading:
            return CGPoint(x: xStart, y: yEnd)
        case .topLeading:
            return CGPoint(x: xStart + hOffset, y: yStart)
        case .top:
            return CGPoint(x: xStart, y: yStart + vOffset)
        }
    }
    
    private func secondPoint(
        _ start: CGPoint,
        _ end: CGPoint
    ) -> CGPoint {
        return CGPoint(x: start.x, y: end.y)
    }

    private func anEdgeIntersect(
        with point: CGPoint,
        towards direction: FlowDirection,
        at layerIndex: Int
    ) -> (hasSameX: Bool, hasSameY: Bool) {
        let layerPoints = allIntermidiatePoints[layerIndex, default: []]
        let hasSameX = layerPoints.contains { layerPoint in
            if layerPoint.x == point.x {
                if direction.isTowardsNorth && layerPoint.y > point.y { return false }
                else if !direction.isTowardsNorth && layerPoint.y < point.y { return false }
                else { return true }
            } else { return false }
        }
        let hasSameY = layerPoints.contains { $0.y == point.y }
        return (hasSameX, hasSameY)
    }
        
    private func addIntermediatePoint(_ point: CGPoint, to layerIndex: Int) {
        if !allIntermidiatePoints[layerIndex, default: []].contains(point) {
            allIntermidiatePoints[layerIndex, default: []].append(point)
        }
    }
    
    func clearAll() {
        allNodeBounds.removeAll(keepingCapacity: true)
        allIntermidiatePoints.removeAll(keepingCapacity: true)
    }
    
    func setNodeBounds(_ nodeBounds: [Node.ID : CGRect]) {
        self.allNodeBounds = nodeBounds
    }
}
