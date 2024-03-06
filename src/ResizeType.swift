import Foundation

enum ResizeTypeBasic: String, Codable, CaseIterable {
    case toLeftSide = "Left Side",
    toRightSide = "Right Side",
    toCenter = "Center"

    var type: String {
        switch self {
            case .toLeftSide:
                return "toLeftSide"
            case .toRightSide:
                return "toRightSide"
            case .toCenter:
                return "toCenter"
        }
    }
}

enum ResizeType: String, Codable, CaseIterable {
    case toLeftSide = "Left Side",
    toRightSide = "Right Side",
    toTopLeft = "Top Left Corner",
    toTopRight = "Top Right Corner",
    toBottomLeft = "Bottom Left Corner",
    toBottomRight = "Bottom Right Corner",
    toCenter = "Center"

    var type: String {
        switch self {
            case .toLeftSide:
                return "toLeftSide"
            case .toRightSide:
                return "toRightSide"
            case .toTopLeft:
                return "toTopLeftSide"
            case .toTopRight:
                return "toTopRightSide"
            case .toBottomLeft:
                return "toBottomLeftSide"
            case .toBottomRight:
                return "toBottomRightSide"
            case .toCenter:
                return "toCenter"
        }
    }
}
