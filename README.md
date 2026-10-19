# Markdown 转换器 · macOS 拖放式文档转换小工具

把 PDF、Word、PPT、Excel、HTML 等文件**直接拖到图标上**，自动转换成同名的 Markdown（`.md`）文件，保存在原文件旁边。

基于微软开源的 [markitdown](https://github.com/microsoft/markitdown)，用 AppleScript 拖放应用（droplet）+ Python 实现，无需打开终端。

## 功能

- 一键拖放转换：PDF / DOCX / PPTX / XLSX / XLS / HTML / CSV / 纯文本
- 转换结果与源文件同名（`.md`），保存在原文件旁
- 同名文件自动加 `_1`、`_2` 后缀，**不会覆盖已有文件**
- 支持一次拖入多个文件，逐个转换
- 转换完成后弹窗汇报成功 / 失败数量

## 效果

![icon](icon/icon_1024.png)

## 环境要求

- macOS（需要 `osacompile`、`iconutil`，系统自带）
- Python 3.10+

## 🚀 一键安装

**打开「终端」（按 `Command + 空格` 输入"终端"），把下面整段复制粘贴进去，回车即可自动完成安装：**

```bash
git clone https://github.com/unim1012-netizen/markdown-converter-macos.git && cd markdown-converter-macos && ./build.sh && cp -R "dist/Markdown 转换器.app" /Applications/
```

安装完成后：

1. 打开「应用程序」（`Command + Shift + A`），找到 **Markdown 转换器**
2. 把要转的 PDF / Word / PPT / Excel 文件**直接拖到图标上**松手
3. 转换好的同名 `.md` 文件自动出现在原文件旁边

> 第一次运行会自动安装 `markitdown` 依赖（含 PDF / Word / PPT / Excel 支持），需要 1-3 分钟，请耐心等待。

## 构建说明（分步）

上面的一行命令等价于：

```bash
git clone https://github.com/unim1012-netizen/markdown-converter-macos.git
cd markdown-converter-macos
./build.sh
cp -R "dist/Markdown 转换器.app" /Applications/
```

`build.sh` 会自动完成：

1. 检查 / 安装 `markitdown[pdf,docx,pptx,xlsx]`
2. 编译 AppleScript 拖放应用
3. 组装转换脚本与图标

## 手动构建（可选）

```bash
# 1. 安装依赖
python3 -m pip install --user "markitdown[pdf,docx,pptx,xlsx]"

# 2. 编译应用（把 __PYTHON_PATH__ 换成你的 python 路径）
sed "s|__PYTHON_PATH__|$(which python3)|" main.applescript > /tmp/main.applescript
osacompile -o /tmp/MarkdownConverter.app /tmp/main.applescript

# 3. 组装
cp convert.py /tmp/MarkdownConverter.app/Contents/Resources/
cp icon/icon.icns /tmp/MarkdownConverter.app/Contents/Resources/
```

## 使用

1. 双击图标会显示使用说明
2. 把一个或多个文件拖到图标上松手
3. 等待转换完成，点「好」关闭结果框
4. 在源文件旁边找到同名 `.md` 文件

## 工作原理

| 层 | 技术 |
|---|---|
| 拖放入口 | AppleScript droplet（`main.applescript`） |
| 转换引擎 | [microsoft/markitdown](https://github.com/microsoft/markitdown) |
| 文件类型识别 | magika（markitdown 内置） |
| 转换脚本 | `convert.py`（含重名保护、批量处理） |

## 项目结构

```
.
├── convert.py          # 核心转换脚本
├── main.applescript    # 拖放应用源码（AppleScript）
├── build.sh            # 一键构建脚本
├── icon/
│   ├── icon_1024.png   # 图标源文件（1024px）
│   └── icon.icns       # 编译后的 macOS 图标
├── LICENSE
└── README.md
```

## License

[MIT](LICENSE)
