# 白日梦想屋（DreamHouse）

一个手绘风治愈系造景贴纸小游戏 MVP。拖拽贴纸到房间里，自由布置你的梦想小屋。

## 当前功能

- 首页：房间列表 + 新建房间
- 房间编辑页：
  - 底部贴纸抽屉，按分类切换（家具/植物/小物件）
  - 点贴纸即可添加到画布中央
  - 单指拖拽移动
  - 双指捏合缩放
  - 双指旋转
  - 点击贴纸自动置顶
  - 拖到右下角垃圾桶删除
  - 保存到本地（JSON 文件持久化，无需服务器/账号）

当前贴纸是**占位图形**（彩色圆角方块+图标+文字），因为还没有真实美术素材。
一旦你准备好真实的贴纸 PNG，只需把图片拖进 `DreamHouse/Assets.xcassets/Stickers/`，
命名和 `StickerLibrary.swift` 里的 `id` 保持一致（比如 `furniture_bed.png` → id 是 `furniture_bed`），
代码会自动识别并显示真实图片，不需要改任何代码。

## 如何用 GitHub 自动编译出 ipa（无需 Mac）

1. 把这个项目所有文件推送到你的 GitHub 仓库
2. 进入仓库的 **Actions** 标签页
3. 找到 "Build Unsigned IPA" 这个 workflow，点击 **Run workflow** 手动触发
   （或者你 push 代码到 main 分支时会自动触发）
4. 等待几分钟编译完成（第一次可能要 5-10 分钟）
5. 编译成功后，进入这次运行的详情页，下拉到底部 **Artifacts** 区域
6. 下载 `DreamHouse-unsigned-ipa`，解压出 `DreamHouse-unsigned.ipa`
7. 用轻松签（或类似工具）导入这个 ipa，重新签名后安装到你的 iPhone

## 后续可以做的事

- 替换占位贴纸为真实 AI 生成的 PNG 素材
- 加房间背景图（放进 Assets，命名 `bg_default_room`）
- 加关卡/任务系统
- 加更多房间模板

## 项目结构

```
DreamHouse/
├── DreamHouseApp.swift          # App 入口
├── Models/
│   ├── StickerItem.swift        # 贴纸数据结构
│   ├── Room.swift                # 房间数据结构
│   ├── StickerLibrary.swift     # 贴纸素材总表（在这里加新贴纸）
│   └── RoomStore.swift          # 本地存储读写
└── Views/
    ├── HomeView.swift            # 首页
    ├── RoomEditorView.swift     # 房间编辑主页面
    ├── DraggableStickerView.swift  # 单个贴纸的拖拽/缩放/旋转交互
    ├── StickerDrawerView.swift  # 底部贴纸选择抽屉
    └── StickerImageView.swift   # 贴纸渲染（有图用图，没图用占位）
```
