# tests/config.py
class AHBConfig:
    def __init__(self):
        # 信号映射 (方式 C)
        self.signal_map = {
            "hclk":   "HCLK",
            "hresetn":"HRESETn",
            "haddr":  "HADDR",
            "hwrite": "HWRITE",
            "htrans": "HTRANS",
            "hsize":  "HSIZE",
            "hwdata": "HWDATA",
            "hrdata": "HRDATA",
            "hready": "HREADYOUT",
            "hresp":  "HRESP",
            "hsel":   "HSELx"
        }
        # 业务参数
        self.clock_period_ns = 10
        self.reset_cycles = 5
        self.timeout_cycles = 200
        self.base_addr = 0x1000
        self.data_width_bytes = 4
