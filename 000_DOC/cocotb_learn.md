# Cocotb 学习

## 安装
### python 虚拟环境配置

```bash
sudo apt install python3-venv

python3 -m venv ~/my_py_env

#激活环境
source ~/my_py_env/bin/activate
#激活后terminal 前面显示 my_py_env

#安装cocotb
#cocotb 目前最高支持python13 但是我的是python14 所以需要

#export COCOTB_IGNORE_PYTHON_REQUIRES=1

pip install cocotb

#退出虚拟环境
deactivate
```
## Cocotb 仿真整体流程

    cocotb 是一个基于 Python 的协同仿真框架，它的核心思想是：将 Python 测试代码嵌入到硬件仿真器中运行，通过仿真器提供的编程接口（如 Verilog 的 VPI、VHDL 的 VHPI/FLI）来控制仿真时间、读写信号。整个流程通常由以下步骤组成：

1. 编译硬件设计：调用仿真器（如 Verilator、Icarus Verilog、Questa 等）将你的 Verilog/VHDL 代码编译成可执行文件或库。

2. 启动仿真：运行编译后的仿真可执行文件，并加载 cocotb 的 Python 库。

3. 执行 Python 测试：cocotb 会自动发现并运行你编写的测试用例（被 @cocotb.test() 装饰的函数）。

4. 生成波形：如果配置了波形输出，仿真器会在仿真过程中生成波形文件（如 FST、VCD）。

5. 返回结果：测试通过或失败的信息会输出到终端，并影响 make 的返回值。

cocotb 提供了一套 Makefile 规则（Makefile.sim），将上述步骤封装成简单的 make 目标，你只需要在项目的 Makefile 中设置必要的变量，然后 include 它即可。


## 基础语法

关于await 和 start_soon()
### 疑问:
1. await 是阻塞的吗？
    await 会“暂停”当前协程的执行，但不会阻塞整个程序（即不会阻塞事件循环）。在 cocotb 中，await 通常用于等待仿真时间前进或某个事件发生。
    所以 await 是 “非阻塞暂停”：它只阻塞当前协程的继续执行，但不会阻塞整个进程，其他协程仍可并发运行。
2. start_soon 是什么
    cocotb.start_soon() 是一个函数，用于在后台启动一个协程，类似于创建了一个“任务”，但不等待它完成，当前协程会继续执行。
    这在需要并行执行多个操作时非常有用，例如同时运行时钟生成器、监控协程和激励协程
3. @cocotb.test() 这个是什么？
    这是一个装饰器，用于将普通的 async 函数标记为 cocotb 的测试用例。cocotb 的运行器会自动发现并执行这些函数。
    当你在函数定义前加上 @cocotb.test()，cocotb 就会把这个函数识别为一个测试
4. 在main 中有多个@cocotb.test()这是什么意思。
    一个文件中可以包含多个用 @cocotb.test() 装饰的函数，这表示该文件定义了多个独立的测试用例
5. async def xxx() 这个async 是什么？
    async def 定义一个异步函数，也称为协程（coroutine）。这样的函数可以在内部使用 await 来等待其他异步操作，并且它本身也是可等待的。
6.  start_soon(check_counter(dut, start_value=0)) 与 await start_soon(enable_counter(dut, cycles=10))
   1.  在start_soon 前面加入了await 表明需要等待他执行完成。
   2. 默认的start_soon 是在后台执行的
   start_soon(check_counter(dut, start_value=0))    
    作用：在后台启动 check_counter 协程，不等待它完成。

    check_counter 是一个无限循环的监控协程，我们希望它一直运行，同时主测试流程继续执行后续代码（如使能计数器、等待等）。
    这里没有 await，所以当前测试协程会继续向下执行，而 check_counter 在后台并发运行。
    await start_soon(enable_counter(dut, cycles=10))
    作用：启动 enable_counter 协程，并等待它执行完毕再继续当前协程。
    start_soon 返回一个 Task 对象，它本身是可等待的。await 这个 Task 会暂停当前协程，直到 enable_counter 完成（即它内部的循环结束）。

    这样保证了在使能计数器的整个过程中，主测试协程处于等待状态，完成后再执行后续操作（如等待 100 ns 或再次使能）
    3. 总结
        - 不加 await：任务在后台运行，当前协程不等待，继续执行。

        - 加 await：任务启动后，当前协程等待该任务结束，然后才继续。

### Cocotb 的并发模型
cocotb 基于 Python 的 asyncio 实现，但针对硬件仿真做了优化。在 cocotb 测试中：

所有用 @cocotb.test() 标记的测试函数都是协程。

你可以在一个测试函数内通过 start_soon 启动多个并发协程，它们会在仿真时间推进时交错执行。

await 是协程之间协作的关键：遇到 await 时，当前协程让出控制权，事件循环调度其他就绪的协程运行，直到被等待的事件发生。
