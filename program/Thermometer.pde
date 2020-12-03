/*
  D6T-44L test program for Processing
  2013/03/26 www.switch-science.com
*/
 
import processing.serial.*;
 
float[] tdata = new float[17]; // 温度を入れる配列(PTAT込みで来ることも考えて17要素分確保)
float tptat; // PTAT
String portName; // シリアルポート名
int serialport = 0; // 接続するシリアルポート番号を指定する
                    // Macの場合、/dev/tty.*のポートを選択してください。
String buf; // 受信バッファ
color[] tcolor = {#400040,#000080,#006060,#008000,#C0C000,#E0A000,#E00000,#F08080}; // 色テーブル
 
Serial myPort;  // Create object from Serial class
 
void setup() {
  size(640,640);
  println(Serial.list());
  portName = Serial.list()[serialport];
  myPort = new Serial(this, portName, 9600);
  myPort.clear();
 
}
void draw() {
  myPort.write(0x01); // データのリクエストをする
  delay(100); // 100ms待つ(すぐにシリアルポートの受信チェックをしないため)
  while (myPort.available() > 0) { // シリアルポートにデータが来ていたら
    delay(300); // 300ms待つ(データ全体が送信されるのを待つため)
    buf = myPort.readString(); // 受信
    myPort.clear();  // シリアルポート受信バッファのクリア
    tdata = float(split(buf, ','));  // データをカンマで分割し、floatで配列に格納
    for (int i = 0; i < 16; i++) { // 各エリアごとに色を設定し、四角を描画する
      if (tdata[i] < 0) {
        fill(tcolor[0]);
      } else if (tdata[i] < 5) {
        fill(tcolor[1]);
      } else if (tdata[i] < 10) {
        fill(tcolor[2]);
      } else if (tdata[i] < 15) {
        fill(tcolor[3]);
      } else if (tdata[i] < 20) {
        fill(tcolor[4]);
      } else if (tdata[i] < 25) {
        fill(tcolor[5]);
      } else if (tdata[i] < 30) {
        fill(tcolor[6]);
      } else  {
        fill(tcolor[7]);
      }
      rect((i % 4)*160, (i / 4)*160, (i % 4)*160+160, (i / 4)*160+160);
      if (tdata[i]<5) {fill(255);} else {fill(0);}
      textAlign(CENTER, CENTER);
      textSize(20);
      text(str(tdata[i]),(i % 4)*160+80, (i / 4)*160+80);
    }
  }
}
