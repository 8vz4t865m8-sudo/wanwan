import SwiftUI

/// 已放置在画布上的单个贴纸：支持拖拽、双指缩放、双指旋转、点击置顶、拖到垃圾桶删除
struct DraggableStickerView: View {
    @Binding var sticker: PlacedSticker
    let isSelected: Bool
    let canvasSize: CGSize
    let trashFrame: CGRect

    let onSelect: () -> Void
    let onDelete: () -> Void
    let onDragChanged: (Bool) -> Void  // 是否正悬停在垃圾桶上方

    @GestureState private var dragOffset: CGSize = .zero
    @GestureState private var pinchScale: CGFloat = 1.0
    @GestureState private var rotationAngle: Angle = .zero
    @State private var isHoveringTrash = false

    private let baseSize: CGFloat = 90

    var body: some View {
        StickerImageView(assetId: sticker.assetId, size: baseSize)
            .scaleEffect(sticker.scale * pinchScale)
            .rotationEffect(.degrees(sticker.rotation) + rotationAngle)
            .shadow(color: .black.opacity(isSelected ? 0.25 : 0.12),
                    radius: isSelected ? 8 : 4, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.accentColor, lineWidth: isSelected ? 3 : 0)
                    .frame(width: baseSize * sticker.scale * pinchScale,
                           height: baseSize * sticker.scale * pinchScale)
            )
            .position(
                x: sticker.position.x + dragOffset.width,
                y: sticker.position.y + dragOffset.height
            )
            .opacity(isHoveringTrash ? 0.4 : 1.0)
            .gesture(dragGesture)
            .simultaneousGesture(magnificationGesture)
            .simultaneousGesture(rotateGesture)
            .onTapGesture {
                onSelect()
            }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .updating($dragOffset) { value, state, _ in
                state = value.translation
            }
            .onChanged { value in
                onSelect()
                let currentPos = CGPoint(
                    x: sticker.position.x + value.translation.width,
                    y: sticker.position.y + value.translation.height
                )
                let hovering = trashFrame.contains(currentPos)
                if hovering != isHoveringTrash {
                    isHoveringTrash = hovering
                    onDragChanged(hovering)
                }
            }
            .onEnded { value in
                if isHoveringTrash {
                    onDelete()
                } else {
                    var newX = sticker.position.x + value.translation.width
                    var newY = sticker.position.y + value.translation.height
                    // 限制不拖出画布太多
                    newX = min(max(newX, 0), canvasSize.width)
                    newY = min(max(newY, 0), canvasSize.height)
                    sticker.position = CGPoint(x: newX, y: newY)
                }
                isHoveringTrash = false
                onDragChanged(false)
            }
    }

    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .updating($pinchScale) { value, state, _ in
                state = value
            }
            .onChanged { _ in onSelect() }
            .onEnded { value in
                let newScale = sticker.scale * value
                sticker.scale = min(max(newScale, 0.4), 3.0)
            }
    }

    private var rotateGesture: some Gesture {
        RotationGesture()
            .updating($rotationAngle) { value, state, _ in
                state = value
            }
            .onChanged { _ in onSelect() }
            .onEnded { value in
                sticker.rotation += value.degrees
            }
    }
}
