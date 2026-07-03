import SwiftUI

/// 底部贴纸选择抽屉：分类 tab + 横向滚动素材列表
/// 用户点击某个贴纸即"添加一个新实例到画布中央"
struct StickerDrawerView: View {
    @State private var selectedCategory: StickerCategory = .furniture
    let onPick: (StickerAsset) -> Void

    var body: some View {
        VStack(spacing: 0) {
            categoryPicker
            stickerGrid
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
        )
    }

    private var categoryPicker: some View {
        HStack(spacing: 12) {
            ForEach(StickerCategory.allCases, id: \.self) { category in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedCategory = category
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: category.iconName)
                            .font(.system(size: 18))
                        Text(category.rawValue)
                            .font(.caption2)
                    }
                    .foregroundStyle(selectedCategory == category ? Color.accentColor : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedCategory == category ? Color.accentColor.opacity(0.15) : .clear)
                    )
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 12)
    }

    private var stickerGrid: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(itemsForSelectedCategory) { asset in
                    Button {
                        onPick(asset)
                    } label: {
                        VStack(spacing: 4) {
                            StickerImageView(assetId: asset.id, size: 60)
                            Text(asset.displayName)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .frame(height: 100)
    }

    private var itemsForSelectedCategory: [StickerAsset] {
        StickerLibrary.all.filter { $0.category == selectedCategory }
    }
}
