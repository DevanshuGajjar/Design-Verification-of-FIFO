class fifo_mon extends uvm_monitor;
  `uvm_component_utils(fifo_mon)
  virtual fifo_itf vif;
  uvm_analysis_port#(fifo_transaction) mon_ap;
  
  fifo_transaction ft1;
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
    mon_ap = new("mon",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    `uvm_info("fifo","Monitor build phase",UVM_MEDIUM);
    super.build_phase(phase);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    `uvm_info("fifo","Monitor connect phase",UVM_MEDIUM);
    if(!uvm_config_db #(virtual fifo_itf)::get(null,"fifo","vif",vif)) `uvm_fatal("death","failed to get interface")
  endfunction 
  
   task run_phase(uvm_phase phase);
    `uvm_info("fifo","Mon Run Phase",UVM_MEDIUM);
	forever begin 
      @(posedge vif.clk);

     	 if (vif.wr || vif.rd || vif.rst) begin

       		ft1 = new();
    		ft1.rst = vif.rst;
    		ft1.w_data = vif.w_data;
    		ft1.wr = vif.wr;
    		ft1.rd = vif.rd;
    		ft1.r_data = vif.r_data;
    		ft1.full = vif.full;
    		ft1.empty  = vif.empty;
//            `uvm_info("FIFO_MON",$sformatf("w_data:%d, r_data:%d,wr:%d,rd:%d, full:%d,empty:%d,rst:%d",vif.w_data,vif.r_data,vif.wr,vif.rd,vif.full,vif.empty,vif.rst),UVM_MEDIUM)
    		mon_ap.write(ft1);
      	 end
    end
    
   endtask
  
  
      
endclass