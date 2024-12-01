main               START   0
                   LDA     #0
                   STA     am_of_str
                   STA     am_of_out

                   LDA     #0
                   LDX     #0
                   JSUB    qinit

                   LDX     #0
                   J       ASSIGNMENT1

ASSIGNMENT1        LDA     #30
                   ADD     #queue
                   COMP    next_idx
                   JEQ     next_idx_reset

                   LDA     #30
                   ADD     #queue
                   COMP    next_idx_out
                   JEQ     next_idx_out_reset

                   LDA     #0
                   LDX     #0
                   JSUB    wr_loop1

                   LDX     #0
                   LDA     #0
                   JSUB    rd_loop1

                   LDA     #0
                   LDX     #0
                   JSUB    strcmp

                   J       ASSIGNMENT1

wr_loop1           TD      output
                   JEQ     wr_loop1
                   LDCH    greeting,X
                   WD      output
                   TIX     #20
                   JLT     wr_loop1
                   LDCH    #10
                   WD      output
                   RSUB

wr_loop2           TD      output
                   JEQ     wr_loop2
                   LDCH    @rear
                   WD      output
                   COMP    #32
                   JEQ     clear_q_init

                   LDA     rear
                   ADD     #1
                   STA     rear

                   TIX     #10
                   JLT     wr_loop2

                   LDCH    #10
                   WD      output
                   J       clear_q_init

wr_loop3           TD      output
                   JEQ     wr_loop3
                   LDCH    terminated,X
                   WD      output
                   TIX     #10
                   JLT     wr_loop3
                   LDCH    #10
                   WD      output
                   J       fin


rd_loop1           TD      input
                   JEQ     rd_loop1
                   RD      input
                   COMP    ASEN
                   JEQ     exit

                   STCH    user_ipt,X
                   TIX     #4
                   JLT     rd_loop1
                   
                   RSUB

rd_loop2           TD      input
                   JEQ     rd_loop2
                   RD      input
                   COMP    ASEN
                   JEQ     change_loop_init

                   STCH    @front

                   LDA     front
                   ADD     #1
                   STA     front

                   TIX     #11
                   LDA     #0
                   JEQ     change_loop_init
                   JLT     rd_loop2

rd_fin             LDA     next_idx
                   ADD     #10
                   STA     front
                   STA     next_idx

                   LDA     #queue
                   ADD     #30
                   COMP    front

                   JEQ     front_reset

                   J       ASSIGNMENT1

change_loop_init   LDX     #0
                   LDA     next_idx
                   STA     front

                   J       change_loop

change_loop        TIX     #11
                   JEQ     rd_fin

                   LDCH    @front
                   COMP    #0
                   JEQ     rd_fin

                   LDA     #0
                   LDCH    @front
                   COMP    #96
                   JLT     upper
                   JGT     lower

upper              LDCH    @front
                   ADD     #32
                   STCH    @front

                   LDA     front
                   ADD     #1
                   STA     front

                   J       change_loop

lower              LDCH    @front
                   SUB     #32
                   STCH    @front

                   LDA     front
                   ADD     #1
                   STA     front

                   J       change_loop

clear_q_init       LDA     next_idx_out
                   STA     rear
                   LDX     #0

                   J       clear_q

clear_q            LDCH    #0
                   STCH    @rear

                   LDA     rear
                   ADD     #1
                   STA     rear

                   TIX     #10
                   JLT     clear_q

                   J       wr_fin

wr_fin             LDA     next_idx_out
                   ADD     #10
                   STA     rear
                   STA     next_idx_out

                   LDA     #queue
                   ADD     #30
                   COMP    rear
                   JEQ     rear_reset
                   J       ASSIGNMENT1

front_reset        LDA     #queue
                   STA     front
                   J       exit

rear_reset         LDA     #queue
                   STA     rear
                   J       exit

next_idx_reset     LDA     #queue
                   STA     next_idx
                   J       exit

next_idx_out_reset LDA     #queue
                   STA     next_idx_out
                   J       exit

strcmp             LDCH    user_ipt
                   COMP    #105
                   JEQ     enqueue

                   COMP    #111
                   JEQ     dequeue

                   COMP    #101
                   LDA     #0
                   LDX     #0
                   JEQ     wr_loop3

                   J       ASSIGNMENT1

qinit              LDA     #queue
                   STA     front
                   STA     rear
                   STA     next_idx
                   STA     next_idx_out

                   RSUB

enqueue            LDX     #0
                   LDA     am_of_str
                   COMP    #3
                   JEQ     full_print

                   LDA     am_of_str
                   ADD     #1
                   STA     am_of_str

                   LDA     am_of_out
                   ADD     #1
                   STA     am_of_out

                   LDA     #0
                   LDX     #0
                   J       rd_loop2

dequeue            LDA     am_of_out
                   LDX     #0
                   COMP    #0
                   JEQ     empty_print

                   LDA     am_of_str
                   SUB     #1
                   STA     am_of_str

                   LDA     am_of_out
                   SUB     #1
                   STA     am_of_out

                   LDA     #0
                   LDX     #0
                   J       wr_loop2


full_print         TD      output
                   JEQ     full_print
                   LDCH    full,X
                   WD      output
                   TIX     #4
                   JLT     full_print
                   LDCH    #10
                   WD      output
                   J       ASSIGNMENT1

empty_print        TD      output
                   JEQ     empty_print
                   LDCH    empty,X
                   WD      output
                   TIX     #5
                   JLT     empty_print
                   LDCH    #10
                   WD      output
                   J       ASSIGNMENT1


exit               RSUB

fin                J       fin

ASEN               WORD    10
greeting           BYTE    C'waiting your command'
empty              BYTE    C'EMPTY'
full               BYTE    C'FULL'
terminated         BYTE    C'Terminated'
input              BYTE    0
output             BYTE    1
queue              RESB    30
front              RESW    1
rear               RESW    1
next_idx           RESW    1
next_idx_out       RESW    1
am_of_str          RESW    1
am_of_out          RESW    1
user_ipt           RESW    3
