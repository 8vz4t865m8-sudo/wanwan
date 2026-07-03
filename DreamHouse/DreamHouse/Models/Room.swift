import Foundation

/// 一个房间存档
struct Room: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var backgroundAssetId: String
    var placedStickers: [PlacedSticker]
    var createdAt: Date
    var updatedAt: Date

    init(id: UUID = UUID(),
         name: String = "我的梦想小屋",
         backgroundAssetId: String = "bg_default_room",
         placedStickers: [PlacedSticker] = [],
         createdAt: Date = Date(),
         updatedAt: Date = Date()) {
        self.id = id
        self.name = name
        self.backgroundAssetId = backgroundAssetId
        self.placedStickers = placedStickers
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
