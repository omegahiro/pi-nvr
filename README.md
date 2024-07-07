# Raspberry Pi RTSP Network Video Recorder (NVR)

RTSPで配信されるWebカメラ映像の自動録画を簡単に構築するスクリプトです。

簡易的なネットワークビデオレコーダーとして使用できます。

Raspberry Piでの使用を想定していますが、UbuntuなどDebian系のLinuxで利用可能です。
非常にシンプルで軽量に動作するため、廉価版であるRaspberry Pi Zero 2Wでも十分快適に動作します。


## 機能
- RTSPストリーム（Webカメラ映像）の録画
- 古い録画データの自動消去
- Webブラウザを経由した録画のダウンロード

![Example Image](https://github.com/omegahiro/pi-nvr/docs/images/webdashboard.png)

## 必要な機材
- Raspberry Pi (Zero 2 W, 3, 4, 5) または Debian系Linux

## インストール手順

1. **リポジトリのクローン**
    ```sh
    git clone https://github.com/omegahiro/pi-nvr.git
    cd pi-nvr
    ```

2. **インストールスクリプトの実行**
    ```sh
    chmod +x install.sh
    ./install.sh
    ```

3. **サービスの設定と開始**
    インストールスクリプトは以下の4つのサービスを設定し、開始します:
    - nvrrecord.service
    - nvrclean.service
    - nvrclean.timer
    - nvrweb.service

    インストールスクリプトの実行が完了すると、これらのサービスは自動的に開始されます。

## ログの確認方法
各サービスのログは次のコマンドで確認できます:
 - `sudo journalctl -u nvrrecord.service -f`
 - `sudo journalctl -u nvrclean.service -f`
 - `sudo journalctl -u nvrweb.service -f`

## 設定の変更方法
 service.confファイルを編集します。以下の設定を変更できます:
 - RTSP_URL: RTSPストリームのURL（例: rtsp://username:password@192.168.1.100/stream1）
 - SEGMENT_TIME: 録画データの分割時間（秒単位）
 - MAX_FILES: 保存する動画の最大数（録画データがこの数を超えると最も古いデータが順に消去されます）

## アンインストール手順
1. **アンインストールスクリプトの実行**
    ```sh
    chmod +x uninstall.sh
    ./uninstall.sh
    ```

## サービスの詳細

### nvrrecord.service
RTSPから動画を取得して保存するサービスです。

### nvrclean.service
古いビデオファイルをクリーンアップするサービスです。

### nvrclean.timer
定期的に`nvrclean.service`を実行するためのタイマーです。

### nvrweb.service
録画ファイルを配信するためのWebサーバーサービスです。
