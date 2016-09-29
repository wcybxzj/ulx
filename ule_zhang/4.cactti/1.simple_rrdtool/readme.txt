简单测试下rrd_tool手动绘图
自己作图注意要用当前或者附近的时间戳子
或者用rrd数据库中的时间否则太老的时间创建的图片看不到图


rrdtool graph mysql.png -s  1466125560 -t "mysql select" -v "select/3" DEF:select3=mysql.rrd:myselect:AVERAGE:step=3 LINE2:select3#FF0000:"SELECT"




