#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""MarkItDown 转换器核心逻辑：把拖入的文件转成同名 .md"""
import os
import sys

from markitdown import MarkItDown


def convert_one(md, path):
    """转换单个文件，返回 (状态, 消息)。"""
    if not os.path.isfile(path):
        return "跳过", "不是文件"
    try:
        result = md.convert(path)
        text = result.text_content or ""
        base, ext = os.path.splitext(path)
        out = base + ".md"
        n = 1
        while os.path.exists(out):
            out = f"{base}_{n}.md"
            n += 1
        with open(out, "w", encoding="utf-8") as f:
            f.write(text)
        return "成功", f"{os.path.basename(path)} → {os.path.basename(out)}"
    except Exception as e:
        return "失败", f"{os.path.basename(path)}：{e}"


def main():
    paths = sys.argv[1:]
    if not paths:
        print("没有收到文件。请把文件拖到图标上。")
        return
    md = MarkItDown()
    lines = []
    ok = fail = 0
    for p in paths:
        status, msg = convert_one(md, p)
        if status == "成功":
            ok += 1
        else:
            fail += 1
        lines.append(f"[{status}] {msg}")
    print(f"转换完成：成功 {ok} 个，失败 {fail} 个")
    for line in lines:
        print(line)


if __name__ == "__main__":
    main()
