# tests/config.py
class AHBConfig:
    def __init__(self):
        # 信号映射 (方式 C)
        self.signal_map = {
            #"hclk":   "HCLK",
            #"hresetn":"HRESETn",
            "haddr":  "HADDR",
            "hwrite": "HWRITE",
            "htrans": "HTRANS",
            "hsize":  "HSIZE",
            "hwdata": "HWDATA",
            "hrdata": "HRDATA",
            "hready": "HREADY",
            "hresp":  "HRESP"
            #"hsel":   "HSELx"
        }
        self.optional_signals_map = {
            "hsel": "HSELx"
        }
        # ✅ 新增独立属性用于时钟和复位
        self.clk_name = "HCLK"
        self.rst_name = "HRESETn"
        # 业务参数
        self.clock_period_ns = 10
        self.reset_cycles = 5
        self.timeout_cycles = 200
        self.base_addr = 0x1000
        self.data_width_bytes = 4
