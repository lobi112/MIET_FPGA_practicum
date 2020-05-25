
module stopwatch(
  input        clk100_i,
  input        rstn_i,
  input        start_stop_i,
  input        set_i,
  input        change_i,
  output [6:0] hex0_o,
  output [6:0] hex1_o,
  output [6:0] hex2_o,
  output [6:0] hex3_o
);
  reg          device_work     = 1'd1;
  wire         device_stopped;
  
  
//SYNCHRONIZER
  reg  [1:0] sync_start_stop;
  reg  [1:0] sync_set;
  reg  [1:0] sync_change;
  
  wire       push_start_stop;
  wire       push_set;
  wire       push_change;
  
  always @( posedge clk100_i ) begin
      sync_start_stop[0] <= ~start_stop_i;
      sync_start_stop[1] <= sync_start_stop[0];
  end
  assign push_start_stop = ~sync_start_stop[1] & sync_start_stop[0];
  
    always @( posedge clk100_i ) begin
      sync_set[0] <= ~start_stop_i;
      sync_set[1] <= sync_set[0];
  end
  assign push_set = ~sync_set[1] & sync_set[0];
  
    always @( posedge clk100_i ) begin
      sync_change[0] <= ~start_stop_i;
      sync_change[1] <= sync_change[0];
  end
  assign push_change = ~sync_change[1] & sync_change[0];
//END_SYNCHRONIZER


//COUNTER
//main pulse counter
  localparam PULSE_W = 20'd0;
  localparam PULSE_M = 20'd999999;
  localparam COUNT_W = 4'd0;
  localparam COUNT_M = 4'd9;
  
  reg  [19:0] pulse_counter      =  PULSE_W;
  reg  [3:0]  hundredth_counter  =  COUNT_W;
  reg  [3:0]  tenth_counter      =  COUNT_W;
  reg  [3:0]  second_counter     =  COUNT_W;
  reg  [3:0]  ten_second_counter =  COUNT_W;
  
  wire hundredth_second_passed    = ( pulse_counter == PULSE_M );
  wire tenth_second_passed        = ( ( hundredth_counter == COUNT_M ) & hundredth_second_passed );
  wire second_passed              = ( ( tenth_counter     == COUNT_M ) & tenth_second_passed );
  wire ten_second_passed          = ( ( second_counter    == COUNT_M ) & second_passed );

//pulses counter
  always @( posedge clk100_i or posedge rstn_i ) begin
    if (rstn_i) 
      begin
        pulse_counter       <= 0;
      end
    else if ( device_work | hundredth_second_passed ) 
    begin
      if ( hundredth_second_passed && device_work )
        pulse_counter <= 0;
      else 
        pulse_counter <= pulse_counter + 1;
    end
  end
  
//hundredths couter
  always @( posedge clk100_i or negedge rstn_i ) begin
    if ( !rstn_i ) 
      hundredth_counter <= 0;
    else if ( hundredth_second_passed && device_work ) 
      begin
        if ( tenth_second_passed )
          hundredth_counter <= 0;
        else
          hundredth_counter <= hundredth_counter + 1;
      end
end
  
//tenths counter
  always @( posedge clk100_i or negedge rstn_i ) begin
    if ( !rstn_i ) 
      tenth_counter <= 0;
    else if ( tenth_second_passed && device_work ) 
      begin
        if ( second_passed )
          tenth_counter <= 0;
        else
          tenth_counter <= tenth_counter + 1;
      end
  end
  
//seconds counter
  always @( posedge clk100_i or negedge rstn_i ) begin
    if ( !rstn_i ) 
      second_counter <= 0;
    else if ( second_passed ) 
      begin
        if ( ten_second_passed && device_work )
          second_counter <= 0;
        else
          second_counter <= second_counter + 1;
      end
  end
  
//ten seconds counter
  always @( posedge clk100_i or negedge rstn_i ) begin
    if ( !rstn_i ) 
      ten_second_counter <= 0;
    else if ( ten_second_passed && device_work ) 
      begin
        if ( ten_second_counter == COUNT_M )
          ten_second_counter <= 0;
        else
          ten_second_counter <= ten_second_counter + 1;
      end
  end
//END_COUNTER


//AUTOMAT

  localparam STATE_default     = 1'd0;
  localparam STATE_set         = 1'd1;
  reg        watch_state       = STATE_default;
  
  localparam SELECT_hundredth  = 3'd0;
  localparam SELECT_tenth      = 3'd1;
  localparam SELECT_second     = 3'd2;
  localparam SELECT_ten_second = 3'd3;
  reg [2:0]  hex_select        = SELECT_hundredth;
  
//set and change_set
  always @( posedge clk100_i ) begin
    case ( watch_state )
      STATE_default : if( push_set && device_work ) begin
                        watch_state   <= STATE_set;
                        hex_select  <= SELECT_hundredth;
                        device_work <= ~device_work;
                      end
                        
      STATE_set     : if(!rstn_i)
                        watch_state  <= STATE_default;
                      else if( push_set && ( hex_select == SELECT_ten_second ) )
                        hex_select <= SELECT_hundredth;
                      else
                        hex_select <= hex_select + 1;
    endcase
  end
  
//change
  always @( posedge clk100_i ) begin
    if ( push_change && watch_state ) begin
      case (hex_select)
        SELECT_hundredth  : if( ~( hundredth_counter  == COUNT_M ) )
                              hundredth_counter  <= hundredth_counter  + 1;
        SELECT_tenth      : if( ~( tenth_counter      == COUNT_M ) )
                              tenth_counter      <= tenth_counter      + 1;
        SELECT_second     : if( ~( second_counter     == COUNT_M ) )
                              second_counter     <= second_counter     + 1;
        SELECT_ten_second : if( ~( ten_second_counter == COUNT_M ) )
                              ten_second_counter <= ten_second_counter + 1;
      endcase
    end
  end
//END_AUTOMAT


//DEVISE_STOPPED
  always @( posedge clk100_i ) begin
    if ( push_start_stop ) begin
      device_work <= ~device_work;
      watch_state   <= STATE_set;
    end
  end
  
  assign device_stopped = ~device_work;
//END_DEVISE_STOPPED


//DECODER
  wire [6:0] decoder_ten_second;
  wire [6:0] decoder_second;
  wire [6:0] decoder_tenth;
  wire [6:0] decoder_hundredth;

  assign hex3_o = decoder_ten_second;
  assign hex2_o = decoder_second;
  assign hex1_o = decoder_tenth;
  assign hex0_o = decoder_hundredth;
  
  decoder decoder3(
    .counter_i ( ten_second_counter ),
    .hex_o     ( decoder_ten_second )
  );
  
  decoder decoder2(
    .counter_i ( second_counter ),
    .hex_o     ( decoder_second )
  );
  
  decoder decoder1(
    .counter_i ( tenth_counter ),
    .hex_o     ( decoder_tenth )
  );
  
  decoder decoder0(
    .counter_i ( hundredth_counter ),
    .hex_o     ( decoder_hundredth )
  );
//END_DECODER


endmodule