import Foundation

/// 贴纸素材总表
/// 注意：这里的 id 必须和 Assets.xcassets 中的图片名一一对应
/// 目前用系统占位素材（SF Symbol 生成的方块），后续把真正的贴纸 PNG 拖进 Assets.xcassets 后
/// 把下面的 id 换成对应的图片名即可，无需改动其他代码
enum StickerLibrary {

    static let all: [StickerAsset] = furniture + plants + items

    static let furniture: [StickerAsset] = [
        StickerAsset(id: "furniture_bed", category: .furniture, displayName: "小床"),
        StickerAsset(id: "furniture_sofa", category: .furniture, displayName: "沙发"),
        StickerAsset(id: "furniture_desk", category: .furniture, displayName: "书桌"),
        StickerAsset(id: "furniture_shelf", category: .furniture, displayName: "书架"),
        StickerAsset(id: "furniture_rug", category: .furniture, displayName: "地毯"),
        StickerAsset(id: "furniture_window", category: .furniture, displayName: "窗户"),
    ]

    static let plants: [StickerAsset] = [
        StickerAsset(id: "plant_pot", category: .plants, displayName: "盆栽"),
        StickerAsset(id: "plant_vase", category: .plants, displayName: "花瓶"),
        StickerAsset(id: "plant_hanging", category: .plants, displayName: "吊篮绿植"),
        StickerAsset(id: "plant_cactus", category: .plants, displayName: "仙人掌"),
    ]

    static let items: [StickerAsset] = [
        StickerAsset(id: "item_lamp", category: .items, displayName: "台灯"),
        StickerAsset(id: "item_frame", category: .items, displayName: "相框"),
        StickerAsset(id: "item_mug", category: .items, displayName: "马克杯"),
        StickerAsset(id: "item_book", category: .items, displayName: "书本"),
        StickerAsset(id: "item_pillow", category: .items, displayName: "抱枕"),
        StickerAsset(id: "item_clock", category: .items, displayName: "时钟"),
    ]

    static func asset(for id: String) -> StickerAsset? {
        all.first { $0.id == id }
    }
}
