import SwiftUI

struct RoomEditorView: View {
    @Binding var room: Room
    let onSave: (Room) -> Void

    @State private var selectedStickerId: UUID? = nil
    @State private var isHoveringTrash = false
    @State private var canvasSize: CGSize = .zero
    @State private var showSavedToast = false

    private let trashSize: CGFloat = 56

    var body: some View {
        VStack(spacing: 0) {
            header
            canvas
            StickerDrawerView(onPick: addSticker)
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationBarHidden(true)
    }

    // MARK: - 顶部栏

    private var header: some View {
        HStack {
            TextField("房间名称", text: $room.name)
                .font(.headline)
                .textFieldStyle(.plain)

            Spacer()

            Button {
                selectedStickerId = nil
                room.updatedAt = Date()
                onSave(room)
                withAnimation { showSavedToast = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation { showSavedToast = false }
                }
            } label: {
                Label("保存", systemImage: "checkmark.circle.fill")
                    .font(.subheadline.weight(.semibold))
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .overlay(alignment: .bottom) {
            if showSavedToast {
                Text("已保存 ✓")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.thinMaterial, in: Capsule())
                    .offset(y: 20)
                    .transition(.opacity)
            }
        }
    }

    // MARK: - 画布

    private var canvas: some View {
        GeometryReader { geo in
            ZStack {
                // 房间背景
                RoomBackgroundView(assetId: room.backgroundAssetId)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .onTapGesture {
                        selectedStickerId = nil
                    }

                // 已放置的贴纸，按 zIndex 排序渲染
                ForEach($room.placedStickers.sorted(by: { $0.wrappedValue.zIndex < $1.wrappedValue.zIndex })) { $sticker in
                    DraggableStickerView(
                        sticker: $sticker,
                        isSelected: selectedStickerId == sticker.id,
                        canvasSize: geo.size,
                        trashFrame: trashFrame(in: geo.size),
                        onSelect: { selectSticker(sticker.id) },
                        onDelete: { deleteSticker(sticker.id) },
                        onDragChanged: { hovering in isHoveringTrash = hovering }
                    )
                }

                // 垃圾桶
                trashCan
                    .position(x: geo.size.width - 44, y: geo.size.height - 44)
            }
            .onAppear { canvasSize = geo.size }
            .onChange(of: geo.size) { canvasSize = $0 }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 10, y: 4)
        )
        .padding(.horizontal, 12)
    }

    private var trashCan: some View {
        ZStack {
            Circle()
                .fill(isHoveringTrash ? Color.red : Color.gray.opacity(0.7))
                .frame(width: trashSize, height: trashSize)
            Image(systemName: "trash.fill")
                .foregroundStyle(.white)
                .font(.system(size: 20))
        }
        .scaleEffect(isHoveringTrash ? 1.15 : 1.0)
        .animation(.easeOut(duration: 0.15), value: isHoveringTrash)
    }

    private func trashFrame(in size: CGSize) -> CGRect {
        let center = CGPoint(x: size.width - 44, y: size.height - 44)
        return CGRect(x: center.x - trashSize, y: center.y - trashSize,
                       width: trashSize * 2, height: trashSize * 2)
    }

    // MARK: - 操作

    private func addSticker(_ asset: StickerAsset) {
        let maxZ = room.placedStickers.map(\.zIndex).max() ?? 0
        let center = CGPoint(x: canvasSize.width / 2, y: canvasSize.height / 2)
        let newSticker = PlacedSticker(assetId: asset.id, position: center, zIndex: maxZ + 1)
        room.placedStickers.append(newSticker)
        selectedStickerId = newSticker.id
    }

    private func selectSticker(_ id: UUID) {
        selectedStickerId = id
        // 置顶
        if let idx = room.placedStickers.firstIndex(where: { $0.id == id }) {
            let maxZ = room.placedStickers.map(\.zIndex).max() ?? 0
            if room.placedStickers[idx].zIndex < maxZ {
                room.placedStickers[idx].zIndex = maxZ + 1
            }
        }
    }

    private func deleteSticker(_ id: UUID) {
        room.placedStickers.removeAll { $0.id == id }
        if selectedStickerId == id {
            selectedStickerId = nil
        }
    }
}

/// 房间背景视图，同样支持"有图用图，没图用占位色块"的回退逻辑
struct RoomBackgroundView: View {
    let assetId: String

    var body: some View {
        if UIImage(named: assetId) != nil {
            Image(assetId)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            LinearGradient(
                colors: [Color(red: 1.0, green: 0.94, blue: 0.9), Color(red: 0.96, green: 0.88, blue: 0.95)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}
