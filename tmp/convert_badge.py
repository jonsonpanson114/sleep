from PIL import Image
import sys

def convert_to_transparent(input_path, output_path):
    img = Image.open(input_path)
    img = img.convert("RGBA")
    
    datas = img.getdata()
    newData = []
    
    # シンプルな閾値処理：暗い部分（背景）を透明にする
    for item in datas:
        # R, G, B すべてが100以下（暗い色）の場合、または特定のグレー背景を透明化
        if item[0] < 100 and item[1] < 100 and item[2] < 100:
            newData.append((255, 255, 255, 0))
        else:
            newData.append(item)
            
    img.putdata(newData)
    img.save(output_path, "PNG")

if __name__ == "__main__":
    convert_to_transparent(sys.argv[1], sys.argv[2])
