# SmartLamp



## Smart Lamp 要点概述

- 核心：中心设备（CBCentralManager）、外设（CBPeripheral）。
- 中心设备模型通过代理获取中心设备与周边设备之间的各种状态信息。
- 自定义了主页头视图支持滑动切换页面，并封装成工具类（详见GitHub）。
- 对第三方库进行了二次封装，减少内部代码对第三方库的依赖，便于后期维护。
- 中心设备模型对多个页面间的传值采用了Rac信号传值。
- 中心设备模型使用了链式语法封装，使用方便快捷。
- 封装了轮播图控件，并自适应header高度的变化。





## 分析问题 解决问题

- 蓝牙通信的流程？中心设备设置代理、开启扫描、停止扫描、获取周边对象、获取服务、获取特征、发送数据、接收返回数据。
- 如何实现多连？用数组存储多个设备及其特征，发送数据时分别向每个连接的设备发送数据，或单独向选中的设备发送数据。
- 蓝牙灯硬件响应的极限时间大概在20ms，如果手指滑动取色器太快导致蓝牙灯反应迟钝滞后，这个问题通过定时器来解决，定义一个flag，每隔50ms使其置为1，只有当flag为1的时候才可以发送数据，每次发送完数据使其置为0，这样就保证了发送数据的时间间隔不会小于50ms。
- 如何选择最合适的传值方式？最常用的三种Block、代理、通知。通知的特点是一对多，而代理和block是一对一传值，代理可以批量传递更多的信息，注重过程信息的传递，但是单例不能使用代理。block写法简练，功能强大，可以封装一段代码传递。
- 开灯时瞬间变亮太刺眼如何进行体验优化？创建一个定时器，每次开灯的时候设置亮度为0，每隔50ms左右调用一次增加一点亮度，直至亮度达到关灯前的状态。
- 关于丢包问题如何解决？可以对每一包发送的数据添加到数组里，每次从中取出一包发送，一定时间内没有收到返回值就重发。
- 如何防止数据被拦截？通常采取加密措施。拟定一份加密协议，对数据进行打乱、插值、重组等。



## 截图

#### iPhone 4寸



![IMG_0010](resources/screenshot/iphone,4.0/IMG_0010.PNG)


![IMG_0010](resources/screenshot/iphone,4.0/IMG_0001.PNG)


![IMG_0010](resources/screenshot/iphone,4.0/IMG_0011.PNG)






![IMG_0010](resources/screenshot/iphone,4.0/IMG_0016.PNG)
![IMG_0010](resources/screenshot/iphone,4.0/IMG_0017.PNG)

![IMG_0010](resources/screenshot/iphone,4.0/IMG_0013.PNG)

![IMG_0010](resources/screenshot/iphone,4.0/IMG_0014.PNG)



#### iPhone 4.7寸

![](resources/screenshot/iphone,4.7/screenshotiphone,4.7-1.png)
![](resources/screenshot/iphone,4.7/screenshotiphone,4.7-2.png)

![](resources/screenshot/iphone,4.7/screenshotiphone,4.7-3.png)

![](resources/screenshot/iphone,4.7/screenshotiphone,4.7-4.png)

![](resources/screenshot/iphone,4.7/screenshotiphone,4.7-5.png)






#### iPhone 5.5寸

![](resources/screenshot/iphone,5.5/screenshotiphone,5.5-1.png)
![](resources/screenshot/iphone,5.5/screenshotiphone,5.5-2.png)
![](resources/screenshot/iphone,5.5/screenshotiphone,5.5-3.png)
![](resources/screenshot/iphone,5.5/screenshotiphone,5.5-4.png)
![](resources/screenshot/iphone,5.5/screenshotiphone,5.5-5.png)

