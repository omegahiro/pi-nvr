# Raspberry Pi RTSP Network Video Recorder (NVR)

RTSPで配信されるWebカメラ映像の自動録画を簡単に構築するスクリプトです。<br>
This script simplifies the automatic recording of web camera footage streamed via RTSP.


簡易的なネットワークビデオレコーダーとして使用できます。<br>
It can be used as a basic network video recorder.

Raspberry Piでの使用を想定していますが、UbuntuなどDebian系のLinuxで利用可能です。<br>
It is designed for use with Raspberry Pi but is also compatible with Debian-based Linux distributions like Ubuntu.

非常にシンプルで軽量に動作するため、廉価版であるRaspberry Pi Zero 2Wでも十分快適に動作します。<br>
 Due to its simplicity and lightweight operation, it runs comfortably even on the cost-effective Raspberry Pi Zero 2 W.

## 機能 Features
- RTSPストリーム（Webカメラ映像）の録画<br>
  Recording of RTSP streams (web camera footage)
- 古い録画データの自動消去<br>
  Automatic deletion of old recording data
- Webブラウザを経由した録画のダウンロード<br>
  Downloading recordings via a web browser

![Example Image](https://github.com/omegahiro/pi-nvr/blob/master/docs/images/webdashboard.png)

## 必要な機材 Required Equipment
- Raspberry Pi (Zero 2 W, 3, 4, 5) または Debian系Linux<br>
  Raspberry Pi (Zero 2 W, 3, 4, 5) or Debian-based Linux
- RTSP配信に対応したWebカメラ (例: TP-Link Tapoシリーズ)<br>
  Webcam with RTSP support (e.g., TP-Link Tapo series)

## インストール手順 Installation Steps

1. **リポジトリのクローン Clone the Repository**

   Gitがインストールされていない場合は`sudo apt update && sudo apt install -y git`を先に実行してください。<br>
   If Git is not installed, please run `sudo apt update && sudo apt install -y git` first.
    ```sh
    git clone https://github.com/omegahiro/pi-nvr.git
    cd pi-nvr
    ```

2. **RTSP接続先の設定変更 Modify RTSP Connection Settings**
    ```sh
    nano service.conf
    # vim service.conf
    # WebカメラのURL,ユーザー名,パスワードをここで設定してください
    # Set the URL, username, and password for your web camera here
    ```

3. **インストールスクリプトの実行 Run the Installation Script**
    ```sh
    chmod +x install.sh
    ./install.sh
    ```
    インストールスクリプトの実行が完了すると、自動的にサービスが開始されます。<br>
    Once the installation script completes, the services will start automatically.

## ログの確認方法 Checking Logs
各サービスのログは次のコマンドで確認できます:<br>
You can check the logs for each service using the following commands:
 - `sudo journalctl -u nvrrecord.service -f`
 - `sudo journalctl -u nvrclean.service -f`
 - `sudo journalctl -u nvrweb.service -f`

## 設定の変更方法 Modifying Settings
 `service.conf`ファイルを編集します。以下の設定を変更できます:<br>
Edit the `service.conf` file to modify the following settings:

 - RTSP_URL: RTSPストリームのURL（例: rtsp://username:password@192.168.1.100/stream1)<br>
   URL of the RTSP stream (e.g., rtsp://username@192.168.1.100/stream1)
 - SEGMENT_TIME: 録画データの分割時間（秒単位)<br>
   Time interval for splitting recording data (in seconds)
 - IS_RASPBERRY_PI: Raspberry Piなら1、それ以外のOSでは0を設定してください。<br>
   Set this to 1 if you are using a Raspberry Pi, otherwise set it to 0
 - MAX_DISK_USAGE: ドライブの最大使用率（%）（ドライブ使用率がこの値を超えると最も古いデータが順に消去されます<br>
   Maximum drive usage threshould (%) (oldest data will be deleted in order once this limit is reached)

## アンインストール手順 Uninstallation Steps
1. **アンインストールスクリプトの実行 Run the Uninstallation Script**
    ```sh
    chmod +x uninstall.sh
    ./uninstall.sh
    ```

## サービスの詳細 Service Details
インストールスクリプトは以下の4つのサービスを設定し、開始します:<br>
The installation script configures and starts the following four services:

### nvrrecord.service
RTSPから動画を取得して保存するサービスです。<br>
Service to capture and save videos from RTSP streams.

### nvrclean.service
古いビデオファイルをクリーンアップするサービスです。<br>
Service to clean up old video files.

### nvrclean.timer
定期的に`nvrclean.service`を実行するためのタイマーです。<br>
Timer to periodically execute `nvrclean.service`.

### nvrweb.service
録画ファイルを配信するためのWebサーバーサービスです。<br>
Web server service to serve recorded files.
