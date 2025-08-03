# 🎮 MoonBit 火柴人物理游戏

基于 MoonBit 语言和 Matter.js 物理引擎开发的2D火柴人物理游戏。通过 FFI（Foreign Function Interface）将 JavaScript 的 Matter.js 物理引擎与 MoonBit 的类型安全特性完美结合。

## � 项目特点

### 技术架构
- **🚀 MoonBit 语言**: 现代函数式编程语言，提供类型安全和高性能
- **⚡ Matter.js 物理引擎**: 成熟的2D物理仿真引擎
- **🔗 JavaScript FFI**: 无缝集成 JavaScript 生态系统
- **🎨 Canvas 渲染**: 基于 HTML5 Canvas 的高性能渲染

### 游戏特性
- **🏃 真实物理仿真**: 重力、碰撞、关节约束等完整物理效果
- **🎮 多种控制方式**: 键盘控制 + 鼠标拖拽交互
- **🎨 彩色火柴人**: 多关节身体结构，头部、躯干、手臂、腿部
- **🏗️ 丰富环境**: 地面、墙壁、跳跃平台
- **📊 实时状态**: 显示火柴人位置和速度信息

## 🎯 控制说明

### 键盘控制
- **A / ←**: 向左移动
- **D / →**: 向右移动  
- **W / ↑**: 跳跃
- **S / ↓**: 向下用力/蹲下
- **空格键**: 跳跃
- **R**: 重置火柴人位置

### 鼠标控制
- **拖拽**: 可以用鼠标拖拽火柴人的任意身体部位

## 🚀 运行项目

### 前置要求
- [MoonBit CLI 工具](https://moonbitlang.com/download/)
- 现代 Web 浏览器

### 安装与运行

1. **克隆项目**
   ```bash
   git clone <repository-url>
   cd stickman-adventure
   ```

2. **构建项目**
   ```bash
   moon build --target js
   ```

3. **启动本地服务器**
   ```bash
   # 使用 Python（推荐）
   python3 -m http.server 8000
   
   # 或使用 Node.js
   npx serve .
   ```

4. **打开游戏**
   在浏览器中访问: `http://localhost:8000/`

## � 项目结构

```
stickman-adventure/
├── src/                           # MoonBit 源代码
│   ├── main.mbt                   # 游戏入口点
│   ├── matter/                    # Matter.js FFI 封装
│   │   ├── matter_types.mbt       # 类型定义
│   │   ├── matter_ffi.mbt         # FFI 绑定
│   │   ├── stickman.mbt          # 游戏逻辑
│   │   └── moon.pkg.json         # 包配置
│   └── external/                  # 外部 API 封装
├── js/                           # JavaScript 胶水代码
│   └── matter_ffi.js             # FFI 实现
├── index.html                    # 游戏页面
├── moon.mod.json                 # 项目配置
└── target/                       # 构建输出
    └── js/release/build/
        └── stickman-adventure.js # 编译后的 JS
```

## 🔧 技术实现

### FFI 架构设计

#### 1. 类型定义层 (`matter_types.mbt`)
定义 Matter.js 对象的 MoonBit 类型映射：
- `Engine`, `World`, `Body`, `Constraint` 等核心类型
- `Position`, `Velocity`, `BodyInfo` 等数据结构
- `StickmanParts`, `GameState` 等游戏专用类型

#### 2. FFI 绑定层 (`matter_ffi.mbt`)
提供 MoonBit 到 JavaScript 的函数绑定：
```moonbit
pub extern "js" fn create_engine() -> Engine = "matter_ffi.createEngine"
pub extern "js" fn create_rectangle(...) -> Body = "matter_ffi.createRectangle"
```

#### 3. JavaScript 实现层 (`matter_ffi.js`)
实现具体的 Matter.js 操作：
```javascript
const matter_ffi = {
  createEngine() { return Engine.create(); },
  createRectangle(x, y, w, h, ...) { return Bodies.rectangle(x, y, w, h, ...); }
};
```

#### 4. 高级封装层 (`stickman.mbt`)
提供游戏逻辑和用户友好的 API：
- `StickmanGame::new()`: 创建游戏实例
- `start()`: 启动游戏循环
- `update_controls()`: 处理输入控制

### 火柴人身体结构

火柴人由10个刚体组成，通过约束连接：

```
    头部 (圆形)
      |
   躯干 (矩形)
   /  |  
上臂   |  上臂
  |    |    |
下臂   |  下臂
      / 
   大腿  大腿
    |     |
   小腿  小腿
```

每个关节都使用 `Constraint` 进行物理连接，具有适当的刚度和长度参数。

### 物理参数调优

- **密度**: 0.001 (轻量化身体部件)
- **约束刚度**: 0.8 (平衡稳定性和自然度)
- **力度**: 0.005 (横向移动), -0.015 (跳跃)

## 🎨 渲染系统

- **背景**: 天蓝色渐变 (#87CEEB)
- **头部**: 金色 (#FFD700)
- **躯干/手臂**: 红色 (#FF6B6B)
- **腿部**: 蓝色 (#4834D4)
- **地面**: 棕色 (#8B4513)
- **平台**: 绿色 (#228B22)

## 📈 性能优化

- **更新频率**: 60 FPS 物理更新
- **状态更新**: 10 FPS UI 状态显示
- **轻量化**: 最小密度设置减少计算负载
- **约束优化**: 合理的刚度参数保证稳定性

## 🔄 开发工作流

1. **修改 MoonBit 代码** → 编辑 `src/` 目录下的 `.mbt` 文件
2. **重新构建** → `moon build --target js`
3. **刷新浏览器** → 查看效果
4. **调试** → 使用浏览器开发者工具

## 🌈 扩展可能

这个项目展示了 MoonBit 的强大能力，可以继续扩展：

- **🎯 游戏机制**: 添加目标、得分、关卡
- **👾 多角色**: 创建不同类型的角色
- **🌍 复杂环境**: 动态障碍物、可交互对象
- **🎵 音效**: 集成 Web Audio API
- **🏆 成就系统**: 添加成就和解锁内容
- **🔧 关卡编辑器**: 可视化关卡设计工具

## 📚 学习价值

这个项目是学习以下技术的绝佳实例：

- **函数式编程**: MoonBit 的现代语法和类型系统
- **FFI 设计**: 跨语言接口设计模式
- **物理仿真**: 2D 物理引擎的应用
- **游戏架构**: 模块化游戏开发
- **Web 技术**: Canvas 渲染和浏览器 API

---

**享受你的 MoonBit 火柴人冒险之旅！** 🚀✨
