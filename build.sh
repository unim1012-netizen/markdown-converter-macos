#!/bin/bash
# ============================================================
# Markdown Converter for macOS —— 一键构建脚本
# 用法: ./build.sh
# 产物: dist/Markdown 转换器.app
# 依赖: macOS (osacompile/iconutil), Python 3.10+
# ============================================================
set -euo pipefail

APP_NAME="Markdown 转换器"
OUT_DIR="dist"
mkdir -p "$OUT_DIR"

echo "==> 检查 Python 与 markitdown 依赖"

PY_BIN="${PYTHON:-}"
if [ -z "$PY_BIN" ]; then
  if [ -x "$HOME/.venvs/markitdown/bin/python" ]; then
    PY_BIN="$HOME/.venvs/markitdown/bin/python"
  elif command -v python3 >/dev/null 2>&1; then
    PY_BIN="$(command -v python3)"
  else
    echo "错误：未找到 python3，请先安装 Python 3.10+" >&2
    exit 1
  fi
fi

if ! "$PY_BIN" -c "import markitdown" >/dev/null 2>&1; then
  echo "==> 未检测到 markitdown，正在安装（含 PDF / Word / PPT / Excel 支持）..."
  "$PY_BIN" -m pip install --user "markitdown[pdf,docx,pptx,xlsx]"
fi

echo "==> 编译 AppleScript 拖放应用"
APP_BUNDLE="$OUT_DIR/$APP_NAME.app"
rm -rf "$APP_BUNDLE"
TMP_AS="$OUT_DIR/main_tmp.applescript"
# 把 AppleScript 中的 Python 路径占位符替换为实际路径
sed "s|__PYTHON_PATH__|$PY_BIN|" main.applescript > "$TMP_AS"
# osacompile 对含空格/中文的输出路径不稳定，先编译为无空格名再重命名
osacompile -o "$OUT_DIR/MarkdownConverter.app" "$TMP_AS"
rm -f "$TMP_AS"
mv "$OUT_DIR/MarkdownConverter.app" "$APP_BUNDLE"

echo "==> 组装资源（转换脚本 + 图标）"
cp convert.py "$APP_BUNDLE/Contents/Resources/convert.py"
cp icon/icon.icns "$APP_BUNDLE/Contents/Resources/icon.icns"

echo "==> 修正 Info.plist（图标 / 应用名 / Bundle ID）"
python3 - "$APP_BUNDLE" <<'PY'
import plistlib, sys
p = sys.argv[1] + "/Contents/Info.plist"
with open(p, "rb") as f:
    d = plistlib.load(f)
d["CFBundleIconFile"] = "icon"
d["CFBundleIconName"] = "icon"
d["CFBundleIdentifier"] = "com.local.markdown-converter"
d["CFBundleName"] = "Markdown 转换器"
d["CFBundleDisplayName"] = "Markdown 转换器"
with open(p, "wb") as f:
    plistlib.dump(d, f)
print("  Info.plist OK")
PY

echo ""
echo "✅ 构建完成：$APP_BUNDLE"
echo "   把 PDF / Word / PPT / Excel 文件拖到图标上即可转换为 .md"
