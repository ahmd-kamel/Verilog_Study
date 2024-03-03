module arbiter(clk, rest_n, req_0, req_1, sig_0, sig_1);

    input wire clk, rest_n, req_0, req_1;

    output reg sig_0, sig_1;


    parameter IDLE = 2'b00, AGENT_0 = 2'b01, AGENT_1 = 2'b10;

    reg [1:0] state;

    always @(posedge clk or negedge rest_n) begin
        if (!rest_n) begin
            state <= IDLE;
            sig_0 <= 0;
            sig_1 <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (req_0) begin
                        state <= AGENT_0;
                    end
                    else if (!req_0 && req_1) begin
                        state <= AGENT_1;
                    end
                end
                AGENT_0: begin
                    if(!req_0) begin
                        state <= IDLE;
                    end
                end
                AGENT_1: begin
                    if(!req_1) begin
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase

        end

    end

    always@(posedge clk) begin
        case (state)
            AGENT_0: begin
                sig_0 <= 1;
                sig_1 <= 0;
            end
            AGENT_1: begin
                sig_0 <= 0;
                sig_1 <= 1;
            end
            default: begin
                sig_0 <= 0;
                sig_1 <= 0;
            end
        endcase
    end

endmodule

