# pyuvm learn

## 参考链接
  1. [coctb 资源](https://github.com/cocotb/cocotb/wiki/Further-Resources)
  2. [coctb user guide](https://docs.cocotb.org/en/stable/quickstart.html)
  3. [pyuvm](https://github.com/pyuvm/pyuvm)
  4. [pyuvm_deepwiki](https://deepwiki.com/pyuvm/pyuvm/1-pyuvm-overview)

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
