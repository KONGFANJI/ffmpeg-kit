# FFmpeg Kit macOS Pod 发布工具

本目录包含了用于自动化打包和发布 `ffmpeg-kit-macos` CocoaPods 依赖库的脚本和生成产物。

## 目录结构
- `publish_macos_pod.sh`: 自动化打包并发布到 GitHub Release 的核心脚本。
- `ffmpeg-kit-macos-xcframeworks.zip`: (运行脚本后生成) 包含了所有 macOS `.xcframework` 的压缩包，供 CocoaPods 下载。

## 使用方法

当你重新编译了底层的库（例如运行了 `./macos.sh`），并且需要发布一个新版本的 CocoaPods 依赖时，请按照以下步骤操作：

### 1. 修改版本号
如果这是一次版本更新（比如从 `6.0.3` 升级到 `6.0.4`）：
1. 修改本项目根目录下的 `ffmpeg-kit-macos.podspec` 文件，将 `s.version` 更新为新版本号。
2. 修改本目录下的 `publish_macos_pod.sh` 脚本，将其中的 `VERSION="6.0.3"` 更新为对应的新版本号。

### 2. 运行自动化发布脚本
在终端中，你可以直接运行这个脚本（无论你在项目根目录还是本目录下执行都可以）：

```bash
./pod_release/publish_macos_pod.sh
```

**脚本会自动完成以下所有极其繁琐的步骤：**
- 进入 `prebuilt` 目录收集你刚刚编译出的各个 `.xcframework`。
- 使用 `zip -y` 将它们压缩为 `ffmpeg-kit-macos-xcframeworks.zip`，并**原生保留所有 macOS 框架必须的软连接 (Symlinks)** 以防止签名损坏。
- 在本地 Git 仓库打上对应的版本标签（如 `v6.0.3`）并 `push` 到远程。
- 自动调用 `gh` (GitHub CLI) 在远程仓库创建一个新的 Release，并将压缩后的 `.zip` 作为资源附件上传。

### 3. 在你的 Xcode 项目中使用
一旦脚本执行提示 `--- Done! ---`，在你的主工程端只需要：
1. 修改 `Podfile`（如果版本号变了，可能需要 `pod update` 取消版本锁定）。
2. 执行：
```bash
pod cache clean ffmpeg-kit-macos --all
rm -rf Pods/ffmpeg-kit-macos
pod install
```
即可拉取到你刚刚新鲜出炉的最新音视频处理库！
