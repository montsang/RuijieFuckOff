# RuijieFuckOff

这是一个专为 CSNUer 准备的小玩意儿（适用于Pandavan路由的Shell脚本），一定程度上可以协助对付该死的校园网多设备共享限制。  
—— 受水平/设备限制，使用网线连接校园网AP，Apple设备未能进行/通过测试（TTL默认255，接入共享网络会炸）   
—— 使用无线桥接接入校园网，Apple设备可正常接入并使用，可正常登录电脑QQ（更新于 2022.2.22）   
—— 学习交流使用，在校园网环境下请合理进行测试，请勿违反校园网络使用规范及相关条例    
—— 您熟知因使用本脚本所带来的一切后果将由自己承担，作者与相关引用内容创作者将不承担任何责任  

<!-- PROJECT SHIELDS -->

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

#### 使用前请务必阅读以下内容

## 目录

- [安装说明](#安装说明)
  - [安装前准备](#安装前准备)
  - [安装步骤](#安装步骤)
    - [配置路由](#配置路由)
    - [配置联网设备](#配置联网设备)
    - [配置脚本](#配置脚本)
- [下载](#下载)
- [原理与推想](#原理与推想)
- [版权说明](#版权说明)
- [鸣谢](#鸣谢)

### 安装说明

由于软、硬件环境等存在诸多差异，请依据自身情况与需求调整、配置脚本以达到预期效果。

#### 安装前准备

1. 刷入Padavan的路由器一台；（注意！此处建议选择自带 *自定义脚本* 功能的Padavan固件。也可另作修改，但本教程不再保证教程内容适用性）
2. CAT6网线一根；（其实CAT5也够用，截至2021，CSNU网速也很少有上100Mbps的时候。CAT6战未来嘛哈哈哈哈）
3. CSNU有线/无线通用校园网账号一份；（死贵还默认限制一台设备在线，这河里吗？）
4. [WinSCP](https://winscp.net/eng/docs/lang:chs)软件；（上传文件至路由，同类可替代）
5. 具备DevTools的浏览器一枚；（例如Google Chrome按F12即可呼出 *DevTools*）
5. 跟校园网斗智斗勇的决心 + 乐于探索与发现的耐心；（要是不具备这些还幻想着拿来就能用的话，建议直接退出本页面，把时间花在对自己更有意义的地方）

#### 安装步骤

##### 配置路由
1. 用网线连接路由器【WAN】口与锐捷AP【LAN】口；
2. 启动路由器；
3. 进入路由管理页，选择左侧菜单栏【外部网络(WAN)】-【外网设置】：**<路由转发不减小 TTL (Time to Live)>** 修改为 ```针对所有包```；**<路由器TTL值>** 修改为 ```64(Unix)```；

##### 配置联网设备
* **所有内网设备统一修改TTL至64**

##### 配置脚本
1. 下载 ```RuijieFuckOff.sh``` 至本地；
2. 参考 [Shell脚本认证校园网](https://www.right.com.cn/forum/forum.php?mod=viewthread&tid=958200) 抓取登录请求的curl内容；
3. 修改curl内容格式并替换脚本内 ```### 两面包夹之内容，自行替换 ###``` 之间的对应内容；
4. 使用[WinSCP](https://winscp.net/eng/docs/lang:chs)登录路由器并将脚本上传至 ```/etc/storage/``` 路径下；
5. 进入路由管理页，选择左侧菜单栏【自定义设置】-【脚本】，在
**<在路由器启动后执行:>** 末尾添加
```
#RuijieFuckOff
sleep 2s
logger -t "【锐捷给爷爬】" "程序开始执行" #提示信息可自行修改
/etc/storage/RuijieFuckOff.sh
```
　　接着点击【**应用本页面设置**】，正常情况下在日志里可以看到路由会将 /etc/storage/ 下内容保存至闪存，此时耐心等待保存完成；


###### 路由刷机、修改TTL、配置启动脚本、计划任务等操作请自行查阅相关教程。（路由相关知识推荐前往[恩山无线论坛](https://www.right.com.cn/forum/)深入学习）



### 下载

- [RuijieFUCKOFF](https://github.com/montsang/RuijieFuckOff/blob/main/RuijieFuckOff.sh)

### 原理与推想

#### 原理
***首先得感谢互联网上各路素不相识的大佬们无私奉献的相关技术经验，鄙人方才得以写出此脚本。实际上这个脚本也没什么特别之处，也没有什么高深之理，不过是依据几年的使用经验写的简单脚本罢了。***
* CSNUer在分享网络被检测到的时候，锐捷会把你的一切**HTTP流量**劫持到一个 *禁止共享网络* 的提示页面。  
这点启发了我利用 http://google.cn/generate_204 返回 *空内容* 的特性作为判断网络状态的依据。
* 在使用CSNU校园网期间发现，出现 *HTTP劫持警告页面* 后，若及时**刷新路由WAN口**与 *DHCP服务（尚不明确是否有效，保险起见）* 并重新登录**可逃掉ban**。  
这就是为啥每隔1分钟检查一次的原因所在，以及之前设定3分钟，反应过慢依旧被ban。（最后感谢谷歌老大哥）
* CSNU校园网虽然显示ban你 *10分钟*，其实过 ***7分钟左右*** 就解开了。故脚本检测到网络异常时休眠7分钟。  
  
* 脚本流程图：```pm.png```

　![流程图](https://raw.githubusercontent.com/montsang/RuijieFuckOff/main/pm.png "流程图")

#### 推想
坊间所流传的校园网检测手法层出不穷：
```
“目前已知的（可能）存在的有：
基于 IPv4 数据包包头内的 TTL 字段的检测
基于 HTTP 数据包请求头内的 User-Agent 字段的检测
基于 IPv4 数据包包头内的 Identification 字段的检测
基于网络协议栈时钟偏移的检测技术
Flash Cookie 检测技术
DPI (Deep Packet Inspection) 深度包检测技术”

———— 引用自 [关于某大学校园网共享上网检测机制的研究与解决方案 - SunBK201](链接见下文)
```
* 不过就个人使用经验来看，CSNU校园网确实存在*TTL检测*、且或许存在有*DPI深度包检测*（通过网线接入校园网，路由共享下**电脑登录QQ**就会被ban，参考[校园网防私接技术研究 - 兰陵美酒郁金香](https://www.xhyonline.com/?p=1308)）。  
* 目前可以确定的是，坊间流传的 *MAC地址检测*、*UA检测*、*时钟偏移检测*、*Flash Cookie* 在CSNU校园网上并不存在。（让我康康谁还在2021用Flash？）  
* *ID字段检测* 无奈水平有限未能进行测试。

### 版权说明

该项目签署了GPL 3.0授权许可，详情请参阅 [LICENSE](https://github.com/montsang/RuijieFuckOff/blob/main/LICENSE)

### 鸣谢


- [shell脚本认证校园网 - 1520393158](https://www.right.com.cn/forum/forum.php?mod=viewthread&tid=958200)
- [关于校园网上网认证设置OpenWrt路由器自动登录 - 桂工划船全靠浪](https://www.bilibili.com/read/cv4211352)
- [关于某大学校园网共享上网检测机制的研究与解决方案 - SunBK201](https://www.sunbk201.site/posts/%E6%90%9E%E4%BA%8B%E6%83%85/%E5%85%B3%E4%BA%8E%E6%9F%90%E5%B7%A5%E4%B8%9A%E5%A4%A7%E5%AD%A6%E6%A0%A1%E5%9B%AD%E7%BD%91%E5%85%B1%E4%BA%AB%E4%B8%8A%E7%BD%91%E6%A3%80%E6%B5%8B%E6%9C%BA%E5%88%B6%E7%9A%84%E7%A0%94%E7%A9%B6%E4%B8%8E%E8%A7%A3%E5%86%B3%E6%96%B9%E6%A1%88/)
- [校园网防私接技术研究 - 兰陵美酒郁金香](https://www.xhyonline.com/?p=1308)

<!-- links -->
[your-project-path]:montsang/RuijieFuckOff
[contributors-shield]: https://img.shields.io/github/contributors/montsang/RuijieFuckOff.svg?style=flat-square
[contributors-url]: https://github.com/montsang/RuijieFuckOff/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/montsang/RuijieFuckOff.svg?style=flat-square
[forks-url]: https://github.com/montsang/RuijieFuckOff/network/members
[stars-shield]: https://img.shields.io/github/stars/montsang/RuijieFuckOff.svg?style=flat-square
[stars-url]: https://github.com/montsang/RuijieFuckOff/stargazers
[issues-shield]: https://img.shields.io/github/issues/montsang/RuijieFuckOff.svg?style=flat-square
[issues-url]: https://img.shields.io/github/issues/montsang/RuijieFuckOff.svg
[license-shield]: https://img.shields.io/github/license/montsang/RuijieFuckOff.svg?style=flat-square
[license-url]: https://github.com/montsang/RuijieFuckOff/blob/master/LICENSE.txt
