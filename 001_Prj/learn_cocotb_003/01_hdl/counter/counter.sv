module counter #(
    parameter D_WIDTH = 8
) (
    input logic clk     ,
    input logic rst_n   ,

    output logic                o_flag
);

    logic [D_WIDTH-1:0] cnt;
    always_ff @( posedge clk or negedge rst_n ) begin 
        if (!rst_n)begin
            cnt <= 'd0;
            o_flag <= 1'b0;
        end else begin
            if (cnt == 8'h80) begin
                cnt <= 'd0;
                o_flag <= 1'b1;
            end else begin
                o_flag <= 1'b0;
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule