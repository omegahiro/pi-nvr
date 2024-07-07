from flask import Flask, render_template, send_from_directory
import os

app = Flask(__name__)

# パスの設定
VIDEO_FOLDER = '../data'
app.config['VIDEO_FOLDER'] = VIDEO_FOLDER + "/records"
app.config['LIVE_FOLDER'] = VIDEO_FOLDER + "/live"

# ルートエンドポイント
@app.route('/')
def index():
    # static/videosフォルダの動画ファイルを取得
    video_files = os.listdir(app.config['VIDEO_FOLDER'])
    video_files = [file for file in video_files if file.endswith('.mp4')]
    video_files.sort(reverse=True)  # 最新のファイルを先頭に表示
    return render_template('index.html', videos=video_files)

# 動画ファイルを配信するエンドポイント
@app.route('/videos/<filename>')
def video(filename):
    return render_template('video.html', filename=filename)

# 動画ファイルを送信するエンドポイント
@app.route('/videos/file/<filename>')
def video_file(filename):
    return send_from_directory(app.config['VIDEO_FOLDER'], filename)


@app.route('/live')
def live():
    return render_template('live.html')

@app.route('/live/file/<filename>')
def live_file(filename):
    return send_from_directory(app.config['LIVE_FOLDER'], filename)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8081)
