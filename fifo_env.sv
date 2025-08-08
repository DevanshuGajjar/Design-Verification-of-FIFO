class fifo_env extends uvm_env;
  `uvm_component_utils(fifo_env)
  
  fifo_seqr sqr;
  fifo_drv drv;
  fifo_mon mon;
  fifo_scoreboard scb;
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
    
  function void build_phase(uvm_phase phase);
    `uvm_info("fifo","Env Build Phase",UVM_MEDIUM);
    super.build_phase(phase);
    scb = fifo_scoreboard::type_id::create("scb",this);
    mon = fifo_mon::type_id::create("mon",this);
    drv = fifo_drv::type_id::create("drv",this);
    sqr = fifo_seqr::type_id::create("seqr",this);
    
  endfunction
  
  function void connect_phase(uvm_phase phase);
    `uvm_info("fifo","Env Connect Phase",UVM_MEDIUM);
    drv.seq_item_port.connect(sqr.seq_item_export);
    mon.mon_ap.connect(scb.sb_imp);
  endfunction
  
  
endclass