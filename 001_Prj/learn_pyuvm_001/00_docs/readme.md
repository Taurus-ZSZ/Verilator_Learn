# 说明

## 文档
下面的这个连接中有关于AMBA 相关的文档的连接
https://www.arm.com/zh-cn/architecture/system-architectures/amba/amba-specifications

## APB 验证点

1. 寄存器写操作
2. 寄存器读操作
3. 正常的操作时序
  - 寄存器写操作
  - 寄存器读操作
4. 错误时序
  - 寄存器写操作
  - 寄存器读操作
5. 可选
  - PREADY 信号控制APB传输周期

6. 需要构建AHB读写控制函数

## AHB 
关键概念理解

关键实现点
1. master 可以在burst 传输中插入busy ,表示主机暂时无法进行下一次传输,当master 使用busy 时，地址和控制信号必须是正确的反应下一次的传输。
2. master 只有在未定义的burst 中，可以将busy 插入在burst的最后。
3. 每一个transfer 使用HBURST 控制传输的类型
4. 每一个read 或write 的transfer 的第一beat 中的HTRANS 是NONSEQ
5. 每个beat中都有一个HTRANS信号在地址阶段，
6. wait state 
