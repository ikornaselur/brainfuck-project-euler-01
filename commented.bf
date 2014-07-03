Brainfuck solution for the following Project Euler problem:
    Find the sum of all the multiples of 3 or 5 below 1000

I set myself some syntax rules to make the code more readable
and maintainable
Since commas_ dots_ and dashes are used in the actual source
code_ I am unable to use them in the comments
What I ended up doing is using underscore (_) for commas
For dots or full stop I just do a new line

Brainfuck uses a byte array and a pointer in that array
The following scheme is what I used for the first 30 or so
memory addresses:
     0  1  2        Counter from 999 down to 0
     3 to 15        Temporary bytes 
    16 and up       Solution 

Each line of code should end with semicolon and a number
the number after the semicolon indicates where the pointer
is after this line has been executed
Numbers within parenthesis indicate a memory address_ so
(3) means byte 3 in the memory array
(3)=2 means I'm setting byte 3 to the number 2 and
(3)=(4) means I'm setting byte 3 equal to byte 4
Lines that go between multiple memory addresses will also
have the memory address number after each memory address
shift has been done_ 

The solution is stored in byte 16 and up and in reverse_ 
that is if the solution is 123_ bytes 16 to 18 will be
3 2 1 respectively
This is because it's simpler to add a number like that 
in memory_ since I don't have to shift the number in 
memory when it grows in size

For example_ adding 10 to the number 98:
    8 9 X will become
    8 0 1

instead of
    9 8 X will become
    1 0 8

I also stored two bytes as boundaries_ at the end of the
solution will be the byte 254_ so i know when I reach the
end of the bytes representing the solution while doing
calculations on it_ because the size of the solution will
grow as the program runs
And the byte 253 before the solution_ so when I'm finished
doing calculations on the solution I can go back to the 253
byte and know where I am in memory before continuing on
I will be surrounding the comments with three quotation marks

And now for the actual brainfuck!


"""Set the counter in bytes 0_ 1_ and 2 to 999"""
>>>+++++++++[<<<+>+>+>-]    ;3

"""Set byte 20 to 254_ to indicate the end of the solution"""
>>>>>>>>>>>>>>>>>           ;20
--  (20)=254                ;20
<<<<<<<<<<<<<<              ;6

"""
(3) will be used as (0)plus(1)plus(2) to see if the counter
has reached 000 yet
I could cheat here and just set (3)=1 to start the loop_ but 
I wanted to do this "correctly" here
"""
<<[-]<[-]> (3) = (4) = 0   ;4

"""(3) = (3) plus (2)"""
<<[>+>+<<-] (3) = (4) = (2) and (2) = 0 ;2
>>[<<+>>-]  (2) = (4) and (4) = 0       ;4

"""(3) = (3) plus (1)"""
<<<[>>+>+<<<-]  (3) = (3) plus (1) and (4) = (1) and (1) = 0 ;1
>>>[<<<+>>>-]   (1) = (4) and (4) = 0   ;4

"""(3) = (3) plus (1)"""
<<<<[>>>+>+<<<<-] (3) = (3) plus (0) and (4) = (0) and (0) = 0 ;0
>>>>[<<<<+>>>>-] (0) = (4) and (4) = 0  ;4
< ;3

"""This is the "while (0)plus(1)plus(2)!=0 loop"""
[
    """
    First check to see if the current number in the counter
    is divisible by 5 
    I do this by checking if the last number is either 5 or 0
    """
    [-]>[-]>[-]             (5) = 0 and (4) = 0 and (3) = 0     ;5
    <<<2[>3+>4+>5+<<<2-]    (5) = (4) = (3) = (2) and (2) = 0   ;2
    >>>5[<<<2+>>>5-]        (2) = (5)   ;5
    +++++                   (5) = 5     ;5

    """Set (3) = (3) is 5"""
 
    >[-]>[-]                ;7
    <<<<3[>>>>7+<<<<3-]+    ;3
    >>5[>>7-<6+<5-]         ;5
    >6[<5+>6-]              ;6
    >7[<<<<3->>>>7[-]]      ;7

    """Set (4) = (4) is 0"""
    <<[-]   (5) = 0         ;5

    >6[-]>7[-]          ;7
    <<<4[>>>7+<<<4-]+   ;4
    >5[>>7-<6+<5-]      ;5
    >6[<5+>6-]          ;6
    >7[<<<4->>>7[-]]    ;7

    """Set (3) = (3) or (4)"""

    <<5[-]>6[-]         ;6
    <<<3[>>>6+<<<3-]    ;3
    >>>6[<<<3->>>6[-]]  ;6
    <<4[>>6+<5+<4-]>5[<4+>5-]   ;5
    >6[<<<3[-]->>>6[-]] ;6

    """
    If the last number was either 5 or 0 ((3) != 0) I 
    will add that number to the total sum
    If the last number was not 5 or 0 I need to check 
    if the number is divisible by 3
    """
    """if (3):"""
    <<4[-]>5[-]                 ;5
    <<3[>4+>5+<<3-]>4[<3+>4-]+  ;4
    >5[     ;5
        """The number did end on 5 or 0"""
        (16) = (16) plus (2)
        >6[-]   ;6
        <<<<2[>>>>>>>>>>>>>>16+<<<<<<<<<<6+<<<<2-]          ;2
        >>>>6[<<<<2+>>>>6-]         ;6

        (17) = (17) plus (1)
        <<<<<1[>>>>>>>>>>>>>>>>17+<<<<<<<<<<<6+<<<<<1-]     ;1
        >>>>>6[<<<<<1+>>>>>6-]      ;6

        (18) = (18) plus (0)
        <<<<<<0[>>>>>>>>>>>>>>>>>>18+<<<<<<<<<<<<+<<<<<<0-] ;0
        >>>>>>6[<<<<<<0+>>>>>>6-]   ;6
        <<-   ;4
    >5[-]]    ;5
    """else:"""
    <4[         ;3
        """
        The number did not end on 5 or 0
        Check to see if the number is divisible by 3
        Since I know that a number in the form xyz is divisible
        by 3 only if (x plus y plus z) is divisible by 3 I can
        take the three numbers of the counter and sum them 
        """
        >>>>>[-]   (9)=0   ;9
        
        """(9) = (9) plus (0)"""
        >10[-]  (10)=0      ;10
        <<<<<<<<<<0[>>>>>>>>>9+>10+<<<<<<<<<<0-]    ;0
        >>>>>>>>>>10[<<<<<<<<<<0+>>>>>>>>>>10-]     ;10

        """(9) = (9) plus (1)"""
        <<<<<<<<<1[>>>>>>>>9+>10+<<<<<<<<<1-]   ;1
        >>>>>>>>>10[<<<<<<<<<1+>>>>>>>>>10-]    ;10

        """(9) = (9) plus (2)"""
        <<<<<<<<2[>>>>>>>9+>10+<<<<<<<<2-]  ;2 
        >>>>>>>>10[<<<<<<<<2+>>>>>>>>10-]   ;10
        >[-]+++ (11)=3  ;11
        >[-]>[-]>[-]>[-]<<<<<< 12 to 15 = 0 ;9

        divmod from esolangs algos:
        """
        And now a divmod algorithm_ it will run (9)/(11) and
        store the remainder in (12) if there is one
        """
        [->+>-[>+>>]>[+[-<+>]>+>>]<<<<<<]   ;9
        
        if (12) == 0:
        """
        Now I check if (12) == 0_ if so the number was
        divisible by three and I can add it to the solution
        """
        [-]+>[-] (9)=1 and (10)=0       ;10
        >>12[<<<9->>>12[<<10+>>12-]]    ;12
        <<10[>>12-<<10-]                ;10
        <9[                             ;9
            """(12) was 0"""
            <<<    ;6

            """
            Add the counter numbers (0 to 2) to the solution
            numbers (16 to 18)
            """
            (16) = (16) plus (2)
            6[-]   ;6
            <<<<2[>>>>>>>>>>>>>>16+<<<<<<<<<<6+<<<<2-]          ;2
            >>>>6[<<<<2+>>>>6-]         ;6

            (17) = (17) plus (1)
            <<<<<1[>>>>>>>>>>>>>>>>17+<<<<<<<<<<<6+<<<<<1-]     ;1
            >>>>>6[<<<<<1+>>>>>6-]      ;6

            (18) = (18) plus (0)
            <<<<<<0[>>>>>>>>>>>>>>>>>>18+<<<<<<<<<<<<+<<<<<<0-] ;0
            >>>>>>6[<<<<<<0+>>>>>>6-]   ;6
        >>>9-]   ;9
    <<<<<4-]        ;4
                
    """
    Now I need to reduce the counter by one_ first I check if the
    last number in the counter is a 0_ if so I need to handle that
    correctly by setting the last number to 9 and the reduce the
    number before it by 1 instead
    """
            
    >[-] (5) = 0 (1)==0 check   ;5
   
    """if (2) == 0"""
    <<3[-]>4[-]                 ;4
    <<2[>3+>4+<<2-]>3[<2+>3-]+  ;3
    >4[<3->4[-]]                ;4
    <3[                         ;3
        """
        (2) was 0
        I start by copying the number from (1) to a temp (8)
        and check if that is also 0_ if it is I need to increase 
        it to 9 and reduce (0) by 1
        That is_ if I'm reducing the counter from 900 I check the
        last number and see it is a 0_ so I change it to 9 and 
        check the middle number_
        The middle number is also 0_ so I also change it to 9 and 
        then reduce the first number_ ending with 899               
        """
        <+++++++++  (2) = 9     ;2
        >>>>>>[-]   (8) = 0     ;8
        <<<<<<<[>>>>>>>+>+<<<<<<<<-] (8)=(9)=(1) and (1)=0  ;1
        >>>>>>>>[<<<<<<<<+>>>>>>>>-] (1)=(9) and (9)=0  ;9

        """If (8) != 0"""
        <<<6[-]+>7[-]     ;7
        >8[             ;8
            """It's not 0 so I can just reduce it by 1"""
            <<<<<<<-    ;1
            >>>>>6-     ;6
            >>8[<7+>8-] ;8
        ]
        """else:"""
        <7[>8+<7-]      ;7
        <6[            ;6
            """It was 0_ so set (1)=9 and reduce (0) by 1"""
            <<<<<1+++++++++ ;1
            <0-             ;0
        >>>>>>6-]           ;6

        <+   (5) = 1 do not reduce 2 ;5
    <<-3]                       ;3

    """
    I forgot to do an if/else on (2)==0 above_ so to reduce (2) 
    by 1 if (2)!=0 I simply set a temp number (5)=1 in that 
    block above and check here if (5)==0_ if it is 0 then the 
    (2)==0 block didn't run
    This of course could be rewritten into a if/else but I 
    apparently didn't notice this until writing this comment now
    """

    """if (5) == 0:"""
    >>>[-]+         ;6
    >[-]            ;7
    <<5[>6-<5[>>7+<<5-]]    ;5
    >>7[<<5+>>7-]   ;7
    <[              ;6
        """reduce (2)"""
        <<<<-       ;2
    >>>>-]          ;6


    """
    Now begins the hardest part of this solution in my opinion
    The sum is stored in few sequential memory addresses_ since
    each address can only hold up to 8 bits of information
    So if the solution is 1234 I need 4 memory addresses that
    each store one of the numbers of the solution
    When adding to the solution in the main loop I simply add
    the lowest unit of the counter to the lowest unit of the 
    solution and so on

    (Not that the solution is stored in reverse_ so 1234 is 4321
    in the memory)

    Example:
        I have the number 789 in memory_ it is stored like this:
            9 8 7
        now I want to add the number 432 to the solution_ ending
        up with 1221
        I sum the lowest units:         9plus2=11
        Then the "unit of tens":        8plus3=11
        and finally "unit of hundreds": 7plus4=11
        The memory now looks like this:
            11 11 11

    Now I don't want any number in memory to be over 9_ so I need
    to fix the numbers in memory after adding the counter
    What I do is simply running through all the memory addresses
    containing the sum and if one address contains a number 
    larger than 9 I reduce that number by 10 and increase the 
    next one by 1
    
    Example:
        From the last example we now have in memory:
            11 11 11
        First I check the first number in memoryand see that it 
        is over 9_ so I reduce it by 10 and increase the next one:
            1  12 11
        And then check the next one and do the same:
            1  2  12
        And again:
            1  2  2  1
        And end up with a "fixed" sum in the memory
    
    Since I didn't know how long the sum was going to be in the 
    end and I didn't want to just chuck lots of space for it to 
    be safe I decided on doing a kind of sled that goes over the 
    numbers in the solution until it hits a "End of sum" character
    (the byte 254) and then slides back to the "sled park" character
    (the byte 255) that's located right before the sum
    
    The sled starts by checking if the first number
    of the sum is the EOS_ that is go to C=(16) and
    increment by 2 (since EOS is 254)
    Since the sled is dynamic_ I cant always say what 
    memory address a part of the code is going to_
    So what I will be using is the following characters:
        C = current
        N = next
        T = third
        temp0   10 T(o) T(he) R(ight)
        temp1   11 TTR
        temp2   12 TTR
        temp3   13 TTR
    Current is the first memory address of the sled_ the first
    time the sled is running C is (16)
    Next and Third are simply the next (17) and third (18) memory
    address based on C
    
    The temp numbers are actually just going 10 or more addresses
    the the right from C each time
    I know I said I didn't just want to chuck enough memory to be
    safe and wanted to have everything more dynamic_ but I simply 
    wanted to get this working
    The plan was to change all the temp numbers to be EOSplus1 and 
    so on_ It should actually not be difficult at all to replace it
    """

    (14)=11 to park sled after running
    goto (15)=1 and and start sled
    >>>>>>>>[-]-    (14)=255    ;14
    >>++ set first C (16) to be plusplus to check for EOS
    """
    If C is EOS then 254plus2 will be 0 and the following
    loop will not start
    """
    [
        """
        Since C wasn't EOS we decrement C by 2 again
        """ 
        -- set back to what it was since it wasn't 254
        
        """
        Now we goto temp0 and set it to 10_ we need to
        use an algorithm to check if C is currently 10 or
        more so we can reduce C by 10 and then increment
        N by 1
        We set temp0 as 10_ temp1 as C since the algorithm
        is destructive and finally use the algorithm:
            temp2 = temp1 more or equal to temp0
        """

        temp0 = 10
        >>>>>>>>>>t0[-]+++++++++=9  ;t0
        
        temp1 = C
        >>[-]t2<[-]t1       ;t1
        <<<<<<<<<<<C[>>>>>>>>>>>+>+<<<<<<<<<<<<-]   ;C
        >>>>>>>>>>>>[<<<<<<<<<<<<+>>>>>>>>>>>>-]    ;t2
        
        temp2 = temp1 more than temp0
        t2[-]>t3[-]>t4[-]           ;t4
        <<<t1[>>t3+                 ;t3
        <<<t0[->>>t3[-]>t4+<<<<t0]  ;t0
        >>>t3[-<t2+>t3]             ;t3
        >t4[-<<<<t0+>>>>t4]         ;t4
        <<<<t0->t1-]                ;t1
        
        """
        Now if temp2 is true (that is C is more or equal to 10)
        we need to reduce C by 10 and increment N by 1
        """
        """if temp2:"""
        t1[-]<t0[-]                 ;t0
        >>t2[<<t0+>t1+>t2-]<<t0[>>t2+<<t0-] ;t0
        >t1[    ;t1
            """
            C was more or equal to 10
            """
            <<<<<<<<<<<                 ;C
            ----------  C minus 10      ;C

            """
            Before we increment N by 1 we first need to check N
            is EOS_ if it is EOS we move EOS to T and set N to 0
            We do this by setting temp0 to EOS_ temp2 to N and then 
            using and algorithm that does temp0 = temp0 == temp2
            """
            >>>>>>>>>>[-]-- t0=EOS=254  ;t0
            t2 = N
            >>[-]<<<<<<<<<<<[>>>>>>>>>>>+>+<<<<<<<<<<<<-]   ;N
            >>>>>>>>>>>>t3[<<<<<<<<<<<<N+>>>>>>>>>>>>-]<   ;t2

            t0 = t0 == t2
            <<t0[->>t2-<<t0]+>>t2[<<t0->>t2[-]]<<       ;t0
            
            """
            If temp0 is true_ that means that N was EOS and we 
            need to shift it to the right
            """
            if t0:
            
            >>t2[-]>t3[-]                   ;t3
            <<<t0[>>t2+>t3+<<<t0-]>>t2[<<t0+>>t2-]  ;t2
            >t3[
                """
                Here we simply increment N by 2 since 254 plus 2 = 0
                and decrement set T=0 and decrement it by 2 to get
                0 minus 2 = 254
                """
                T=N & N=0
                <<<t0<<<<<<<<<N++   ;N
                >T[-]--             ;T
            >>>>>>>>>>>t3[-]]       ;t3
            """
            We finally increase N by one and end the work for the 
            'if C is more or equal to 10' part of the sled
            """
            <<<<<<<<<<<<N+  ;N
            >>>>>>>>>>t1[-]
        ]
        """
        We end the last loop on temp1 and need to go back to N
        and increase it by 2_ that is_ we're shifting C to N
        (simply moving the sled by 1 to the right) and checking
        if the current C (last N) is EOS
        """
        <<<<<<<<<<++
    ]     ;C
    --  fix EOS

    """
    Goto the sled park located at (14) so I know where I am
    in memory before continuing on
    """
    +[-<+]-     ;14

    """
    Check to see if the counter has reached 0
    """
    <<<<<<<<<<<[-]>[-] (3) = (4) = 0   ;4

    (3) = (3) plus (2)
    <<[>+>+<<-] (3) = (4) = (2) and (2) = 0 ;2
    >>[<<+>>-]  (2) = (4) and (4) = 0       ;4

    (3) = (3) plus (1)
    <<<[>>+>+<<<-]  (3) = (3) plus (1) and (4) = (1) and (1) = 0    ;1
    >>>[<<<+>>>-]   (1) = (4) and (4) = 0   ;4

    (3) = (3) plus (1)
    <<<<[>>>+>+<<<<-] (3) = (3) plus (0) and (4) = (0) and (0) = 0  ;0
    >>>>[<<<<+>>>>-] (0) = (4) and (4) = 0  ;4
<] ;3

"""
Print out the sum from memory
"""

>>>>>>>>>>>>[-]     ;15
++++++++++
++++++++++
++++++++++
++++++++++
++++++++    (15)=48 ;15

[>+>+>+>+>+>+<<<<<<-]   ;15
>>>>>>               ;20
.<.<.<.<.<.<.         ;15
<14[-]++++++++++.   ;14
