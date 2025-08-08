class fifo_seq extends uvm_sequence #(fifo_transaction);
  `uvm_object_utils(fifo_seq)
  
  function new(string name = "fifo_seq");
    super.new(name);
  endfunction
  
  fifo_transaction ft1;
  virtual task body();
    ft1 = new();
    
    //reseting the dut
    reset(ft1);
    #10;
    `uvm_info("FIFO_SEQ","random write read operation",UVM_MEDIUM);
    random_read_write(ft1);
	#10;
    `uvm_info("FIFO_SEQ","single write read operation",UVM_MEDIUM);
    single_write_read(ft1);
    #10;
    `uvm_info("FIFO_SEQ","write fifi full operation",UVM_MEDIUM);
    write_full(ft1);
    #10;
    `uvm_info("FIFO_SEQ","read fifo empty operation",UVM_MEDIUM);
    read_full(ft1);
    #10;
    `uvm_info("FIFO_SEQ","wrapper around fifo pointer operation",UVM_MEDIUM);
    wrap_around_ptr(ft1);
    #10;
    `uvm_info("FIFO_SEQ","Simultaneous Write Read Operation",UVM_MEDIUM);
    wr_rd_simultaneous(ft1);
    #10;
  endtask
  
  task reset(fifo_transaction ft1);
    
    start_item(ft1);
    ft1.rst <= 1;
   	ft1.wr  <= 0;
    ft1.rd  <= 0;
    ft1.w_data   <= 0;
    finish_item(ft1);
    
    // Hold reset for a few cycles
    repeat (2) begin
      start_item(ft1);
      finish_item(ft1);
    end
    
    // Deassert reset
    start_item(ft1);
    ft1.rst <= 0;
    ft1.oper <= 0;
    finish_item(ft1);
  endtask
  
   task random_read_write(fifo_transaction ft1);
     repeat(5)begin
       start_item(ft1);
       assert(ft1.randomize);
       ft1.rst <= 1'b0;
       finish_item(ft1);
     end
   endtask
  
  task single_write_read(fifo_transaction ft1);
    reset(ft1);
    #10;
    //write operation
    start_item(ft1);
    assert(ft1.randomize with {oper == 1;});
    finish_item(ft1);
    #10;
    //read operation
    start_item(ft1);
    assert(ft1.randomize with {oper == 2;});
    finish_item(ft1);
  endtask
  
  task burst_write_read(fifo_transaction ft1);
  endtask
  
  task write_full(fifo_transaction ft1);
    reset(ft1);
    #10;
    repeat(8)begin
      start_item(ft1);
      assert(ft1.randomize with {oper == 1;});
      finish_item(ft1);
    end
  endtask
  
  task read_full(fifo_transaction ft1);
    repeat(8)begin
      start_item(ft1);
      assert(ft1.randomize with {oper == 2;});
      finish_item(ft1);
    end
  endtask
  
  task wr_rd_simultaneous(fifo_transaction ft1);
    reset(ft1);
    #10;
    repeat(2)begin
      start_item(ft1);
      assert(ft1.randomize with {oper == 1;});
      finish_item(ft1);
    end
    #10;
    repeat(1)begin
      start_item(ft1);
      assert(ft1.randomize with {oper == 3;});
      finish_item(ft1);
    end
  endtask
  
  task wrap_around_ptr(fifo_transaction ft1);
    reset(ft1);
    #10;
    //write fifo full
    repeat(8)begin
      start_item(ft1);
      assert(ft1.randomize with {oper == 1;});
      finish_item(ft1);
    end
    #10;
    //read fifo full
    repeat(8)begin
      start_item(ft1);
      assert(ft1.randomize with {oper == 2;});
      finish_item(ft1);
    end
    #10;
    //write 2 item to check wrapper around pointer
    repeat(2)begin
      start_item(ft1);
      assert(ft1.randomize with {oper == 1;});
      finish_item(ft1);
    end
  endtask
  
  //writing fifo at FULL and reading fifo at empty
  task illegal_operation(fifo_transaction ft1);
    reset(ft1);
    #10;
    //write fifo full
    repeat(9)begin
      start_item(ft1);
      assert(ft1.randomize with {oper == 1;});
      finish_item(ft1);
    end
    #10;
    //read fifo full
    repeat(1)begin
      start_item(ft1);
      assert(ft1.randomize with {oper == 2;});
      finish_item(ft1);
    end   
  endtask
endclass
  