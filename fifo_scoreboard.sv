class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)
  uvm_analysis_imp#(fifo_transaction,fifo_scoreboard) sb_imp;
  
  int data_qu[$]; 
  bit [3:0] act_rd_data,exp_rd_data;
  int count;
  int error_count;
  int full;
  int empty;
//   int empty_count;
  
  function new(string name="fifo_scoreboard",uvm_component parent);
    super.new(name,parent);
    sb_imp = new("sb_imp",this);
  endfunction
  
  
  function void build_phase(uvm_phase phase);
    `uvm_info("fifo","Scoreboard Build Phase",UVM_MEDIUM);
    super.build_phase(phase);
      count = 0;
      full = 0;
      empty = 0;
      act_rd_data = 4'b0;
      exp_rd_data = 4'b0;
      error_count = 0;
  endfunction
  
  function void write(fifo_transaction ft1);

    //reset_condition
    if(ft1.rst == 1)begin
      full = ft1.full;
      empty = ft1.empty;
      if(empty==1 && full==0)
        error_count = error_count;
      else 
        error_count++;
    end
    else begin
      //writing to the fifo
      if(ft1.oper == 1 && ft1.full!=1'b1)begin
        data_qu.push_front(ft1.w_data);
      end
      //operation read
      else if(ft1.oper == 2 && ft1.empty!=1'b1) begin

		act_rd_data = ft1.r_data;
        exp_rd_data = data_qu.pop_back();
        if(act_rd_data != exp_rd_data)begin
          `uvm_info("FIFO_Scoreboard",$sformatf("exp data:%b and act data:%b, empty:%b, full:%b",exp_rd_data,act_rd_data,ft1.empty,ft1.full),UVM_MEDIUM);
          error_count++;
        end
        
      end
      //operation write read simultaneous
      else if(ft1.oper == 3)begin
        if(ft1.wr == 1'b1 && ft1.full!=1'b1)begin
        	data_qu.push_front(ft1.w_data);
      	end
        else if(ft1.rd == 1'b1 && ft1.empty!=1'b1)begin
          act_rd_data = ft1.r_data;
          exp_rd_data = data_qu.pop_back();
          if(act_rd_data != exp_rd_data)begin
            `uvm_info("FIFO_Scoreboard",$sformatf("exp data:%b and act data:%b, empty:%b, full:%b",exp_rd_data,act_rd_data,ft1.empty,ft1.full),UVM_MEDIUM);
            error_count++;
          end
      	end
      end
    end
    
  endfunction
  

  
  virtual function void check_phase(uvm_phase phase);
    if(error_count > 1)begin
      `uvm_error("DATA_MISMATCH", $sformatf("Data mismatch detected! Expected: %0h, Actual: %0h", exp_rd_data, act_rd_data));
    end
      endfunction
  
endclass