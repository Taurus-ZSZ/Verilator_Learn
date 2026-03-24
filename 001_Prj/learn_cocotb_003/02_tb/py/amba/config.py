# tests/config.py
class AHBConfig:
    def __init__(self):
        # 信号映射 (方式 C)
        self.signal_map = {
            "hclk": "clk_sys",
            "hresetn": "rst_n",
            "haddr": "h_addr",
            "hwrite": "h_write",
            "htrans": "h_trans",
            "hsize": "h_size",
            "hwdata": "h_wdata",
            "hrdata": "h_rdata",
            "hready": "h_ready_out",
            "hresp": "h_resp",
            "hsel": "h_sel"
        }
        # 业务参数
        self.clock_period_ns = 10
        self.reset_cycles = 5
        self.timeout_cycles = 200
        self.base_addr = 0x1000
        self.data_width_bytes = 4
