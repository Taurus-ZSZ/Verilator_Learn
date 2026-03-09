#include "Vtop.h"
#include "memory.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

double sc_time_stamp() {return 0;}


int main(int argc,char**argv){
    Verilated::mkdir("logs");



    const std::unique_ptr<VerilatedContext> contextp { new VerilatedContext};

    contextp->debug(0);
    contextp->threads(1);
    contextp->randReset(2);
    contextp->traceEverOn(true);
    contextp->commandArgs(argc,argv);

    const std::unique_ptr<Vtop> top {new Vtop{contextp.get(),"TOP"}};

    VerilatedVcdC* tfp = nullptr;
    const char* flag = contextp->commandArgsPlusMatch("trace");

    if(flag && 0 == std::strcmp(flag,"+trace")){
        contextp->traceEverOn(true);
        VL_PRINTF("Enabling waves into logs/vlt_dump.vcd..\n");
        tfp = new VerilatedVcdC;
        top->trace(tfp,99);
        tfp->open("logs/vlt_dump.vcd");
    }


    top->rst_n=0;
    top->clk  =0;
    top->i_a  =0;
    top->i_b  =0;

    while( !contextp->gotFinish()){
        contextp->timeInc(1);

        top->clk = !top->clk;
        if (!top->clk) {
            if(contextp->time() > 1 && contextp->time() <10) {
                top->rst_n = 0;
            } else {
                top->rst_n = 1;
            }

            if(contextp->time() == 20){
                top->i_a = 16;
                top->i_b = 80;
            } else if(contextp->time() == 40){
                top->i_a = 53;
                top->i_b = 90;
            } else if(contextp->time() == 60){
                top->i_a = -3;
                top->i_b = 8;
            } else if(contextp->time() == 80){
                top->i_a = -64;
                top->i_b = -30;
            } 
        }
        top->eval();
        if (tfp) tfp->dump(contextp->time());
        // Read outputs
        VL_PRINTF("[%" PRId64 "] clk=%x rst_n=%x i_a=%d + i_b=%d = sum =%4d,co=%2d\n",
                  contextp->time(), top->clk, top->rst_n, top->i_a, top->i_b,
                  top->o_sum, top->o_co);

        if (contextp->time() > 200) {
            break;
        }
    }
    // Final model cleanup
    top->final();

    if (tfp) {
        tfp->close();
        tfp = nullptr;
    }

    contextp->coveragep()->write("logs/coverage.dat");
    // Final simulation summary
    contextp->statsPrintSummary();

    return 0;

}