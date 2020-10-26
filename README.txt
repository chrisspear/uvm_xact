UVM transaction examples
Chris Spear 10/26/2020

This shows 3 different styles of writing a UVM transaction class. For
this transaction, don't compare if the cmd field is NOOP.

fm.svh: Has field macros to control how properties are copied,
compared, printed, etc.

Advantage: Short, easy to write.

Disadvantage: Can be hard to add fine control, such as conditional
comparison based on certain field values. (This example does not have
that conditional compare.) Slightly slower performance compared with
do-style. Macro syntax less clear than code.


do.svh: Had do methods to control how properties are copied,
compared, printed, etc.

Advantage: Easy to specify exact behavior, especially for compare and
print. Best performance.

Disadvantage: More code to write, more chance of a bug


hybrid.svh: Similar to the do methods, with additional code in
do_compare() that prints extra messages for miscompares. Also has
conditional compare.

Advantage: Allows more control for comparison. Additional helpful
compare messages help new users, compared to do methods. Less code
than do methods.

Disadvantage: More code than field macro


top.sv: Testbench for three styles. 


How to run examples:

Questa:

% qrun -quiet top.sv +define+DO
# t1.sprint():
# tx_item: cmd=READ(0) src=0x0 dst=0x3 result=0x9
# t2.sprint():
# tx_item: cmd=READ(0) src=0x0 dst=0x3 result=0x9
# 
#  Comparing identical objects
# t1.compare(t2) = 1, expected 1
# 
#  Comparing objects with different src, WRITE command, should fail
# t1.compare(t2) = 0, expected 0
# 
#  Comparing objects with different src, NOOP command, should succeed
# t1.compare(t2) = 1, expected 1


% qrun -quiet top.sv +define+FM
# t1.sprint():
# --------------------------------
# Name      Type       Size  Value
# --------------------------------
# t1        tx_item    -     @466 
#   src     integral   32    'h0  
#   dst     integral   32    'h3  
#   cmd     command_t  32    READ 
#   result  integral   32    'h9  
# --------------------------------
# 
# t2.sprint():
# --------------------------------
# Name      Type       Size  Value
# --------------------------------
# t1        tx_item    -     @470 
#   src     integral   32    'h0  
#   dst     integral   32    'h3  
#   cmd     command_t  32    READ 
#   result  integral   32    'h9  
# --------------------------------
# 
# 
#  Comparing identical objects
# t1.compare(t2) = 1, expected 1
# 
#  Comparing objects with different src, WRITE command, should fail
# UVM_INFO @ 0: reporter [MISCMP] Miscompare for t1.src: lhs = 'h1 : rhs = 'h2
# UVM_INFO @ 0: reporter [MISCMP] 1 Miscompare(s) for object t1@470 vs. t1@466
# t1.compare(t2) = 0, expected 0
# 
#  Comparing objects with different src, NOOP command, should succeed
# UVM_INFO @ 0: reporter [MISCMP] Miscompare for t1.src: lhs = 'h1 : rhs = 'h2
# UVM_INFO @ 0: reporter [MISCMP] 1 Miscompare(s) for object t1@470 vs. t1@466
# t1.compare(t2) = 0, expected 1


% qrun -quiet top.sv +define+HYBRID
# t1.sprint():
# --------------------------------
# Name      Type       Size  Value
# --------------------------------
# t1        tx_item    -     @466 
#   src     integral   32    'h0  
#   dst     integral   32    'h3  
#   cmd     command_t  32    READ 
#   result  integral   32    'h9  
# --------------------------------
# 
# t2.sprint():
# --------------------------------
# Name      Type       Size  Value
# --------------------------------
# t1        tx_item    -     @470 
#   src     integral   32    'h0  
#   dst     integral   32    'h3  
#   cmd     command_t  32    READ 
#   result  integral   32    'h9  
# --------------------------------
# 
# 
#  Comparing identical objects
# t1.compare(t2) = 1, expected 1
# 
#  Comparing objects with different src, WRITE command, should fail
# UVM_INFO @ 0: reporter [MISCMP] Miscompare for t1.src: lhs = 'h1 : rhs = 'h2
# UVM_INFO @ 0: reporter [MISCMP] 1 Miscompare(s) for object t1@470 vs. t1@466
# t1.compare(t2) = 0, expected 0
# 
#  Comparing objects with different src, NOOP command, should succeed
# t1.compare(t2) = 1, expected 1
