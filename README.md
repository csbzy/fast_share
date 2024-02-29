# just_share

一个基于flutter和rust的跨平台本地局域网分享/传输数据工具

## Getting Started
## Flutter UI 层
- 使用 Flutter 框架提供用户界面
- 包括屏幕、小部件和用户交互的导航逻辑

## Rust 后端逻辑
- 使用 Rust 实现的文件分享核心逻辑
- 包括文件读写创建、网络、安全性和业务逻辑


# graph LR
    A[Flutter UI] -->|FFI| B[Rust Backend]
    B -->|FFI| A