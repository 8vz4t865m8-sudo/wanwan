import SwiftUI

struct HomeView: View {
    @StateObject private var store = RoomStore()
    @State private var selectedRoomId: UUID? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(store.rooms) { room in
                        roomCard(room)
                    }
                    newRoomCard
                }
                .padding(16)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("白日梦想屋")
            .navigationDestination(item: $selectedRoomId) { roomId in
                if let index = store.rooms.firstIndex(where: { $0.id == roomId }) {
                    RoomEditorView(
                        room: $store.rooms[index],
                        onSave: { updated in store.save(updated) }
                    )
                }
            }
        }
    }

    private func roomCard(_ room: Room) -> some View {
        Button {
            selectedRoomId = room.id
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                RoomBackgroundView(assetId: room.backgroundAssetId)
                    .frame(height: 110)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        Text("\(room.placedStickers.count) 件物品")
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(.thinMaterial, in: Capsule())
                            .padding(6),
                        alignment: .bottomTrailing
                    )
                Text(room.name)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
    }

    private var newRoomCard: some View {
        Button {
            let newRoom = store.createRoom()
            selectedRoomId = newRoom.id
        } label: {
            VStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 32))
                Text("新建房间")
                    .font(.subheadline)
            }
            .foregroundStyle(.pink)
            .frame(height: 110)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                    .foregroundStyle(.pink.opacity(0.4))
            )
        }
        .buttonStyle(.plain)
    }
}
