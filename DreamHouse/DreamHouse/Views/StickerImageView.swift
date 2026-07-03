import SwiftUI

/// 统一的贴纸渲染视图
/// - 如果 Assets.xcassets 中存在对应名字的图片，优先显示图片
/// - 否则回退成一个手绘风格的占位图标，方便在没有美术素材时先跑通交互逻辑
struct StickerImageView: View {
    let assetId: String
    var size: CGFloat = 80

    var body: some View {
        if UIImage(named: assetId) != nil {
            Image(assetId)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        let asset = StickerLibrary.asset(for: assetId)
        return ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(placeholderColor.opacity(0.25))
            RoundedRectangle(cornerRadius: 16)
                .stroke(placeholderColor, lineWidth: 2)
            VStack(spacing: 4) {
                Image(systemName: placeholderIcon)
                    .font(.system(size: size * 0.32))
                    .foregroundStyle(placeholderColor)
                if let name = asset?.displayName {
                    Text(name)
                        .font(.system(size: size * 0.13, weight: .medium))
                        .foregroundStyle(placeholderColor)
                        .lineLimit(1)
                }
            }
        }
        .frame(width: size, height: size)
    }

    private var placeholderIcon: String {
        switch StickerLibrary.asset(for: assetId)?.category {
        case .furniture: return "sofa.fill"
        case .plants: return "leaf.fill"
        case .items: return "cup.and.saucer.fill"
        case .none: return "square.dashed"
        }
    }

    private var placeholderColor: Color {
        switch StickerLibrary.asset(for: assetId)?.category {
        case .furniture: return .brown
        case .plants: return .green
        case .items: return .pink
        case .none: return .gray
        }
    }
}
