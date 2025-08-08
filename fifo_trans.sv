class fifo_transaction extends uvm_sequence_item;
  rand int oper;
  bit rst;
  rand bit [3:0] w_data;
  bit wr;
  bit rd;
  bit [3:0] r_data;
  bit full;
  bit empty;
  
  constraint op1 {
//     oper dist {1:/50, 2:/50};
    oper inside {[1:3]};
  }
  
  function new(string name = "fifo_transaction");
    super.new(name);
  endfunction
  
endclass