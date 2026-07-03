import Foundation
import Combine

/// 负责房间数据的读取、保存（本地 JSON 文件持久化，无需数据库/服务器）
final class RoomStore: ObservableObject {
    @Published var rooms: [Room] = []

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent("rooms.json")
    }()

    init() {
        load()
        if rooms.isEmpty {
            rooms = [Room(name: "我的第一个小屋")]
            persist()
        }
    }

    func createRoom() -> Room {
        let newRoom = Room(name: "新的小屋")
        rooms.append(newRoom)
        persist()
        return newRoom
    }

    func save(_ room: Room) {
        if let idx = rooms.firstIndex(where: { $0.id == room.id }) {
            rooms[idx] = room
        }
        persist()
    }

    func delete(_ room: Room) {
        rooms.removeAll { $0.id == room.id }
        persist()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([Room].self, from: data) {
            rooms = decoded
        }
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(rooms) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
