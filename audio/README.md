# 音效文件说明

这个文件夹用于存放太鼓达人游戏的音效文件。

## 需要的音效文件

请将以下音效文件放入此文件夹：

### 必需的音效文件：

1. **don_hit.wav** - 红色音符（咚）击中音效
   - 建议：低沉的鼓声，类似"咚"的声音
   - 格式：WAV 或 OGG
   - 时长：0.1-0.3秒

2. **ka_hit.wav** - 蓝色音符（咔）击中音效
   - 建议：清脆的鼓边声，类似"咔"的声音
   - 格式：WAV 或 OGG
   - 时长：0.1-0.3秒

3. **miss.wav** - 错过音符音效
   - 建议：失败提示音，比较低沉或沉闷的声音
   - 格式：WAV 或 OGG
   - 时长：0.2-0.5秒

4. **perfect.wav** - 完美击中音效
   - 建议：清脆悦耳的成功音效
   - 格式：WAV 或 OGG
   - 时长：0.1-0.3秒

### 可选的背景音乐：

5. **bgm.ogg** - 背景音乐
   - 建议：节奏感强的音乐，适合太鼓达人游戏
   - 格式：OGG（推荐）或 MP3
   - 时长：2-5分钟，可循环播放

## 音效文件来源建议

### 免费音效资源：
- **Freesound.org** - 大量免费音效，需要注册
- **Zapsplat** - 高质量音效库
- **Adobe Audition** - 内置音效库
- **GarageBand** - Mac用户可以使用内置音效

### 太鼓音效关键词搜索：
- "taiko drum"
- "japanese drum"
- "don ka"
- "drum hit"
- "percussion"

### 自制音效：
你也可以使用 Audacity（免费）录制或生成简单的音效：
1. 生成音调：生成 → 音调
2. 添加效果：效果 → 回声/混响
3. 导出为 WAV 格式

## 文件格式要求

- **音效文件**：WAV 格式（推荐）或 OGG 格式
- **背景音乐**：OGG 格式（推荐）或 MP3 格式
- **采样率**：44.1kHz 或 48kHz
- **位深度**：16-bit 或 24-bit

## 添加文件后

1. 将音效文件复制到此文件夹
2. 确保文件名与上述列表完全匹配
3. 重新运行游戏，音效会自动加载
4. 查看控制台输出确认音效是否成功加载

## 注意事项

- 文件名必须完全匹配（区分大小写）
- 如果某个音效文件不存在，游戏会使用占位符音调
- 音效文件大小建议控制在 1MB 以内
- 背景音乐文件大小建议控制在 10MB 以内 