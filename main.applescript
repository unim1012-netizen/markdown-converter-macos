-- MarkItDown 转换器：把文件拖到图标上，自动转成同名 .md
-- 构建时 __PYTHON_PATH__ 会被 build.sh 替换为实际的 Python 路径

on run
	display dialog "把 PDF、Word、PPT、Excel 等文件拖到这个图标上，" & return & "就会自动转换成同名 .md 文件，保存在原文件旁边。" buttons {"好"} default button 1 with title "MarkItDown 转换器" with icon note
end run

on open droppedItems
	set pyPath to "__PYTHON_PATH__"
	set appPath to POSIX path of (path to me)
	set convPath to appPath & "Contents/Resources/convert.py"
	set argList to ""
	repeat with anItem in droppedItems
		set argList to argList & " " & quoted form of (POSIX path of anItem)
	end repeat
	try
		set summary to do shell script quoted form of pyPath & " " & quoted form of convPath & argList
	on error errMsg number errNum
		display dialog "转换出错：" & errMsg buttons {"知道了"} default button 1 with title "MarkItDown 转换器" with icon stop
		return
	end try
	display dialog summary buttons {"知道了"} default button 1 with title "MarkItDown 转换器" with icon note
end open
