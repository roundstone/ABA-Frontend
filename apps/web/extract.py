import re

with open('/Users/macbookpro/Documents/Web/aba_project/template/fontend/index.html', 'r') as f:
    content = f.read()

# Find Trending Products
trending = content[content.find('<h2 class="title-inner2">trending products</h2>'):content.find('<!-- slider tab end -->')]

# Find Parallax banner
parallax = content[content.find('<!-- Parallax banner -->'):content.find('<!-- Parallax banner end -->')]

# Find Product slider (new product, season sale)
product_slider = content[content.find('<!-- product slider -->'):content.find('<!-- product slider end -->')]

with open('/Users/macbookpro/Documents/Web/aba_project/apps/web/scratch.md', 'w') as f:
    f.write("# Trending\n")
    f.write(trending[:1000] + "\n...\n")
    f.write("# Parallax\n")
    f.write(parallax[:1000] + "\n...\n")
    f.write("# Product Slider\n")
    f.write(product_slider[:1000] + "\n...\n")
