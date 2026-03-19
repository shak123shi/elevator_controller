module elevator_controller_tb;

reg clk;
reg reset;
reg [3:0] floor_req;
reg emergency_stop;

wire move_up;
wire move_down;
wire motor_stop;
wire [1:0] current_floor;

elevator_controller uut (
    .clk(clk),
    .reset(reset),
    .floor_req(floor_req),
    .emergency_stop(emergency_stop),
    .move_up(move_up),
    .move_down(move_down),
    .motor_stop(motor_stop),
    .current_floor(current_floor)
);

always #5 clk = ~clk;

initial
begin
    clk = 0;
    reset = 1;
    floor_req = 4'b0000;
    emergency_stop = 0;

    #20;
    reset = 0;

    // Request floor 3
    #20;
    floor_req = 4'b1000;
    #10;
    floor_req = 4'b0000;

    // Request floor 1
    #80;
    floor_req = 4'b0010;
    #10;
    floor_req = 4'b0000;

    // Emergency stop
    #70;
    emergency_stop = 1;

    #40;
    emergency_stop = 0;

    // Multiple requests
    #40;
    floor_req = 4'b1010;
    #10;
    floor_req = 4'b0000;

    #100;
    $stop;
end

endmodule
