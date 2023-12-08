# Python 코드 (wordcloud_generator.py)

from flask import Flask, request, jsonify
from wordcloud import WordCloud
import base64
from io import BytesIO

app = Flask(__name__)

@app.route('/generate_wordcloud', methods=['POST'])
def generate_wordcloud():
    text = request.json.get('text', '')
    wordcloud = WordCloud(width=300, height=200, background_color='white').generate(text)

    # 이미지를 BytesIO 스트림으로 저장
    img = BytesIO()
    wordcloud.to_image().save(img, format='PNG')
    img.seek(0)

    # base64로 인코딩
    img_base64 = base64.b64encode(img.getvalue()).decode()

    return jsonify({'image': img_base64})

if __name__ == '__main__':
    app.run(debug=True)