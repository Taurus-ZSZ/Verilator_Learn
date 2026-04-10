# pyuvm learn

## 参考链接
  1. [coctb 资源](https://github.com/cocotb/cocotb/wiki/Further-Resources)
  2. [coctb user guide](https://docs.cocotb.org/en/stable/quickstart.html)
  3. [pyuvm](https://github.com/pyuvm/pyuvm)
  4. [pyuvm_deepwiki](https://deepwiki.com/pyuvm/pyuvm/1-pyuvm-overview)

\newpage

## 相关知识点
### configDB 
  ConfigDB().set(context, path, key, value) 的参数含义：
  context: 设置者的句柄（通常是 self），决定了路径的相对起点。
  path: 目标组件的层级路径（支持通配符 *）。
  key: 配置项的键名（这里是 "MSG"）。
  value: 配置项的值。

  configDB().set() 中可以使用通配符“*”进行匹配，匹配中有有优先级：
  优先级顺序通常是：
  1. 精确路径 (如 env.loga)
  2. 带通配符的局部路径 (如 env.t*)
  3. 全局通配符 (如 *)
    如果高优先级的会覆盖低优先级的匹配。

\newpage

### 关于接口与BFM 
- 协议时序BFM 是否在Driver 中
在早期的、或者编写不够严谨的 SV UVM 环境中，BFM 任务确实常常直接写在 Driver 类中。但更现代、更推荐的做法，是将它们封装在 interface 内部。
💎 总结：一张表彻底理清

| 职责 | SV UVM(传统) | SV UVM(现代/推荐) | pyuvm |
| --------------- | --------------- | --------------- | --------------- |
| 信号定义 | interface | interface | TinyAluBfm 类内持有的dut 句柄  |
| 协议时序(BFM任务) | Driver 类 | interface 内部 | TinyAluBfm 类的协程 |
| 事务调度(Driver职责) | Driver类 | Driver类(极简) | Driver类(极简) |
|评价|❌ 耦合、难复用|✅ 解耦、高复用 | ✅ 语言级强制分离，更清晰 |


所以，你之前的疑惑完全正确：在不少 SV 代码中，你确实会看到 Driver 承担了 BFM 的职责。
但当你转向 pyuvm 时，它帮你一步到位，直接跨进了现代验证方法学的最佳实践。

需要考虑到在单个模块与系统集成验证时关于信号路径的问题，这里推荐两种方案：
- 小规模的模块: 在bfm 的参数列表中，定义对应的信号，然后再例化时通过指定对应信号的路径，可以理解成向函数传递参数，只不过参数时信号的句柄，可以时dut.core.valid 等等。
- 大规模的设计:
利用 ConfigDB 传递信号映射表（最灵活，用于复杂环境）
创建一个配置对象，其中包含一个信号映射字典，BFM 根据字典中的名字去获取信号。
```python
# bfm_config.py
class BfmConfig:
    def __init__(self):
        self.signal_map = {}  # 逻辑信号名 -> DUT信号句柄的映射

# 在 BFM 中
class TinyAluBfm:
    def __init__(self, config: BfmConfig):
        self.cfg = config
        self.A = self.cfg.signal_map["A"]
        self.B = self.cfg.signal_map["B"]
        # ...
```
## 疑问
