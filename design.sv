// // Code your design here
module fifo #(parameter width = 4,parameter depth = 8)(input clk,
            input rst,
            input [width-1:0] w_data,
           	input wr,
           	input rd,
            output logic [width-1:0] r_data,
            output logic full,
            output logic empty
            );
  
  logic [width-1:0] mem [depth-1:0];
  logic [$clog2(depth)-1:0] wr_ptr,wr_ptr_next;
  logic [$clog2(depth)-1:0] rd_ptr,rd_ptr_next;
  logic [width-1:0] mem_out;
  
  enum logic [1:0] {Empty,Partial,Full} current_state, next_state;
  
  //reset and next state logic 
  always@(posedge clk or posedge rst)begin
    if(rst)begin
        current_state <= Empty;
    end
    else begin 
      current_state <= next_state;
    end
  end
  
  //states of fifo
  always@(*)begin
    case(current_state)
      Empty:
        next_state =  (wr == 1 ) ? Partial : Empty;
      Partial:
        if(wr == 1'b1 && rd == 1'b1) next_state = Partial;
        else if(wr == 1'b1) next_state = (wr_ptr_next == rd_ptr) ? Full : Partial;
        else if(rd == 1'b1) next_state = (rd_ptr_next == wr_ptr) ? Empty : Partial;
        else next_state = Partial;
        
      Full:
        next_state = (rd == 1'b1) ? Partial : Full;
      default: next_state = Full;
    endcase
  end
        
  
  //logic for wr pointer
  always@(posedge clk or posedge rst)begin
    if(rst)begin
      wr_ptr <=  4'b0;
    end
    else begin
       if(current_state != Full)begin
       	wr_ptr <= (wr == 1) ? wr_ptr_next : wr_ptr;     
       end
       else wr_ptr <= wr_ptr;
    end
   end 

  //logic for rd pointer
  always@(posedge clk or posedge rst)begin
    if(rst) rd_ptr <=  4'b0;
     else begin
       if(current_state != Empty)begin
         rd_ptr <= (rd == 1) ? rd_ptr_next : rd_ptr;
       end
       else rd_ptr <= rd_ptr;
     end
   end 
      

  //write to the mem logic
  always@(posedge clk or posedge rst)begin
     if(rst) mem <= '{8{4'd0}};
     else begin
       if((wr == 1) && (full == 1'b0))begin
         mem[wr_ptr] <= w_data;
        end
  	 end
  end
    
  //read logic
    always@(posedge clk or posedge rst)begin
      if(rst)begin
        mem_out <= 4'b0;
        r_data <= 4'b0;
      end
      else begin
        if((rd == 1) && (empty == 1'b0))begin
          r_data <= mem[rd_ptr];
        end
      end 
    end


  assign wr_ptr_next = (wr_ptr == (depth - 1)) ? 4'd0 : (wr_ptr + 4'd1);
  assign rd_ptr_next = (rd_ptr == (depth - 1)) ? 4'd0 : (rd_ptr + 4'd1);
  
  assign full = (current_state == Full) ? 1'b1 : 1'b0;
  assign empty = (current_state == Empty) ? 1'b1 : 1'b0;

  //SVA
  //reset condition check
  property rst1;
    @(posedge clk) rst |-> (wr_ptr==0 && rd_ptr==0 && empty); 
  endproperty
  
  assert property(rst1)
    else $display("reset assertion failed at startup");
    
  //check whether we are able to read the same data that we are writing to 
   sequence rd_check(ptr);
      ##[0:$] (rd && !empty && (rd_ptr == ptr));
   endsequence
    
    property wr_rd_data_check(wr_ptr);
     int ptr,data;
     @(posedge clk) disable iff(rst)
      (wr && !full, ptr = wr_ptr,data = w_data,$display($time,"wr_ptr=%b,w-data=%b",wr_ptr,w_data))
      |-> first_match(rd_check(ptr),$display($time,"rd_ptr=%h, o_fifo=%h",rd_ptr, r_data)) ##1 r_data == data;
     
   endproperty
    assert property (wr_rd_data_check(wr_ptr)) else $error("RD WR Data Check Assertion Failed");
    cover property (wr_rd_data_check(wr_ptr)) $display("wr_rd_data_check assertion passed");
    
    //Full Condition check
      property full_condition;
        @(posedge clk) disable iff(rst)
        (wr == 1'b1 && wr_ptr == rd_ptr && current_state!= Empty,$display("current_sate:%b,full:%b",current_state,full)) |-> ((current_state == Full) && (full == 1'b1));
      endproperty
      
      assert property (full_condition) 
        else $error("full condition check failed");
      cover property (full_condition) $display("full condition passed");
      
      //check empty condition 
      property empty_condition;
        @(posedge clk) disable iff(rst)
        (rd == 1'b1 && rd_ptr == wr_ptr && current_state!=Full, $display("current state:%b,empty:%b",current_state,empty)) |-> ((current_state == empty) && (empty == 1'b1));  
      endproperty
        assert property (empty_condition) 
          else $error("Empty Conditin Failed");
      
      //Dont write if fifo is full
      property dont_write_if_full;
        @(posedge clk) disable iff(rst)
        (wr == 1'b1 && full == 1'b1) |=> wr_ptr == $past(wr_ptr);
      endproperty
      
        assert property (dont_write_if_full) else $error("Dont write if fifo full condition failed");
       
       //Dont read fifo when empty
          property dont_read_fifo_empty;
            @(posedge clk) disable iff(rst)
            (rd == 1'b1 && current_state == Empty) |-> rd_ptr == $past(rd_ptr);
          endproperty
          
          assert property (dont_read_fifo_empty) else $error("Dont read fifo if empty condition failed");

endmodule

