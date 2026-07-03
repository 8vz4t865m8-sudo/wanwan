import Foundation
import CoreGraphics

/// 贴纸分类
enum StickerCategory: String, CaseIterable, Codable {
    case furniture = "家具"
    case plants = "植物"
    case items = "小物件"

    var iconName: String {
        switch self {
        case .furniture: return "sofa.fill"
        case .plants: return "leaf.fill"
        case .items: return "cup.and.saucer.fill"
        }
    }
}

/// 贴纸素材库中的一个条目（未放置状态）
struct StickerAsset: Identifiable, Codable, Hashable {
    let id: String          // 对应 Asset Catalog 里的图片名
    let category: StickerCategory
    let displayName: String
}

/// 已放置到房间画布中的贴纸实例
struct PlacedSticker: Identifiable, Codable, Hashable {
    let id: UUID
    let assetId: String
    var position: CGPoint      // 中心点坐标，相对画布
    var scale: CGFloat
    var rotation: Double        // 角度（度）
    var zIndex: Double          // 层级，越大越靠上

    init(id: UUID = UUID(), assetId: String, position: CGPoint, scale: CGFloat = 1.0, rotation: Double = 0, zIndex: Double = 0) {
        self.id = id
        self.assetId = assetId
        self.position = position
        self.scale = scale
        self.rotation = rotation
        self.zIndex = zIndex
    }
}

// CGPoint 默认不遵循 Codable，手动扩展
extension CGPoint: Codable {
    enum CodingKeys: String, CodingKey {
        case x, y
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let x = try container.decode(CGFloat.self, forKey: .x)
        let y = try container.decode(CGFloat.self, forKey: .y)
        self.init(x: x, y: y)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
    }
}

// CGPoint 默认不遵循 Hashable，手动扩展（PlacedSticker 需要用到）
extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
