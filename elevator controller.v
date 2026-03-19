module elevator_controller(
input clk,
input reset,
input [3:0] floor_req,
input emergency_stop,

output reg move_up,
output reg move_down,
output reg motor_stop,

output reg [1:0] current_floor
);

parameter idle = 2'b00;
parameter up = 2'b01;
parameter down = 2'b10;
parameter emergency = 2'b11;

reg [1:0] current_state, next_state;
reg [3:0] request_reg;

// REQUEST REGISTER

always @(posedge clk or posedge reset)
begin
    if(reset)
        request_reg <= 4'b0000;

    else if(!emergency_stop)
        request_reg <= (request_reg | floor_req) & ~(1 << current_floor);
end

// STATE REGISTER

always @(posedge clk or posedge reset)
begin
    if(reset)
        current_state <= idle;
    else
        current_state <= next_state;
end

// FLOOR COUNTER

always @(posedge clk or posedge reset)
begin
    if(reset)
        current_floor <= 2'b00;

    else if(!emergency_stop && current_state == up && current_floor < 2'b11)
        current_floor <= current_floor + 1'b1;

    else if(!emergency_stop && current_state == down && current_floor > 2'b00)
        current_floor <= current_floor - 1'b1;
end

// NEXT STATE LOGIC

always @(*)
begin
    next_state = current_state;

    if(emergency_stop)
        next_state = emergency;

    else
    begin
        case(current_state)

        idle:
        begin
            if(request_reg[current_floor])
                next_state = idle;
        
            else if( (current_floor == 0 && (request_reg[1] || request_reg[2] || request_reg[3])) ||
                     (current_floor == 1 && (request_reg[2] || request_reg[3])) ||
                     (current_floor == 2 && request_reg[3]) )
                next_state = up;
        
            else if( (current_floor == 3 && (request_reg[0] || request_reg[1] || request_reg[2])) ||
                     (current_floor == 2 && (request_reg[0] || request_reg[1])) ||
                     (current_floor == 1 && request_reg[0]) )
                next_state = down;
        end
        
        up:
        begin
            if(request_reg[current_floor])
                next_state = idle;
        end

        down:
        begin
            if(request_reg[current_floor])
                next_state = idle;
        end

        emergency:
        begin
            if(!emergency_stop)
                next_state = idle;
        end

        default:
            next_state = idle;

        endcase
    end
end

// OUTPUT LOGIC

always @(*)
begin
    move_up = 0;
    move_down = 0;
    motor_stop = 0;

    case(current_state)

        up: move_up = 1;

        down: move_down = 1;

        idle: motor_stop = 1;

        emergency: motor_stop = 1;

    endcase
end

endmodule
