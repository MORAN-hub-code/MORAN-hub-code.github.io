#!/bin/bash

# 配置项
SITE_URL="https://yourdomain.com "        # 替换为你的实际域名
OUTPUT_FILE="sitemap.xml"
DEFAULT_CHANGEFREQ="weekly"
DEFAULT_PRIORITY="0.8"
DEFAULT_LASTMOD=$(date +%Y-%m-%d)

# 删除旧 sitemap
rm -f "$OUTPUT_FILE"

# 写入 XML 头部
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > "$OUTPUT_FILE"
echo "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">" >> "$OUTPUT_FILE"

# 查找所有 HTML 文件并写入 sitemap
find . -type f $ -name "*.html" -o -name "*.htm" $ | while read file; do
    # 获取相对路径并转换为 URL
    relpath="${file:2}"
    url="$SITE_URL/$relpath"

    # 如果是 index.html，则使用父目录作为路径
    if [[ "$relpath" == *"index.html" ]]; then
        dir=$(dirname "$relpath")
        url="$SITE_URL/${dir}"
    fi

    # 设置 lastmod（基于文件修改时间）
    lastmod=$(date -r "$file" +%Y-%m-%d 2>/dev/null || echo "$DEFAULT_LASTMOD")

    # 写入 URL 条目
    cat <<EOF >> "$OUTPUT_FILE"
  <url>
    <loc>$url</loc>
    <lastmod>$lastmod</lastmod>
    <changefreq>$DEFAULT_CHANGEFREQ</changefreq>
    <priority>$DEFAULT_PRIORITY</priority>
  </url>
EOF
done

# 写入尾部
echo "</urlset>" >> "$OUTPUT_FILE"

echo "✅ Sitemap 已生成：$OUTPUT_FILE"
