module arbiter_tb;

    reg clk, rest_n, req_0, req_1;
    wire sig_0, sig_1;
    parameter PERIOD = 10;

    arbiter U0(
        .clk(clk),
        .rest_n(rest_n),
        .req_0(req_0),
        .req_1(req_1),
        .sig_0(sig_0),
        .sig_1(sig_1)
    );

    always #((PERIOD / 2)) clk = ~clk;


    initial begin
        $dumpfile("arbiter.vcd");
        $dumpvars(0, arbiter_tb);

        clk = 0;
        rest_n = 0;
        req_0 = 0;
        req_1 = 0;

        #6 rest_n = 1;
        //#15 rest_n = 0;
        #8 req_0 = 1;
        #8 req_0 = 0;
        #8 req_1 = 1;
        #4 {req_0, req_1} = 2'b11;
        #6 req_1 = 1;
        #4 {req_0, req_1} = 2'b00;
        #6 {req_0, req_1} = 2'b01;
        #20 $finish;
    end

    always @(posedge clk) begin
        $display("At time %0t : req_0 = %0b, req_1 = %0b, sig_0 = %0b, sig_1 = %0b", $time, req_0, req_1, sig_0, sig_1);
    end

endmodule