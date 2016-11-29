//HDL Example 4-4
//----------------------------------------    
//Dataflow description of 4-bit adder 
module Adder1_16bit (A, B, Cin, S, Cout);
   input [15:0] A;
   input [15:0] B;
   input Cin;
   output [15:0] S;
   output Cout;
   wire [14:0] c ;
   FullAdder F0(A[0],B[0],Cin,S[0],c[0]);
   FullAdder F1(A[1],B[1],c[0],S[1],c[1]);
   FullAdder F2(A[2],B[2],c[1],S[2],c[2]);
   FullAdder F3(A[3],B[3],c[2],S[3],c[3]);
   FullAdder F4(A[4],B[4],c[3],S[4],c[4]);
   FullAdder F5(A[5],B[5],c[4],S[5],c[5]);
   FullAdder F6(A[6],B[6],c[5],S[6],c[6]);
   FullAdder F7(A[7],B[7],c[6],S[7],c[7]);
   FullAdder F8(A[8],B[8],c[7],S[8],c[8]);
   FullAdder F9(A[9],B[9],c[8],S[9],c[9]);
   FullAdder F10(A[10],B[10],c[9],S[10],c[10]);
   FullAdder F11(A[11],B[11],c[10],S[11],c[11]);
   FullAdder F12(A[12],B[12],c[11],S[12],c[12]);
   FullAdder F13(A[13],B[13],c[12],S[13],c[13]);
   FullAdder F14(A[14],B[14],c[13],S[14],c[14]);
   FullAdder F15(A[15],B[15],c[14],S[15],Cout);
 
endmodule

module FullAdder(A,B,Cin,S,Cout);
    output S,Cout;
    input A,B,Cin;
    wire n1 , n2 , n3 ;
    
    xor #(2) u1(n1,A,B);
    and #(2) u2(n2,A,B);
    xor #(2) u3(S,n1,Cin);
    and #(2) u4(n3,n1,Cin);
    or  #(2) u5(Cout,n2,n3);

endmodule

module CLA(A,B,Cin,S,Cout);
  output  [3:0]S;
  output Cout;
  input  [3:0] A;
  input [3:0] B;
  input Cin ;
   
  wire  [3:0] P ;
  wire [3:0] G ; 
  wire  C1 , C2 , C3  ; 
  wire [9:0] w;
  
  xor #(2) x1(P[0] , A[0] , B[0]);
  xor #(2) x2(P[1] , A[1] , B[1]);
  xor #(2) x3(P[2] , A[2] , B[2]);
  xor #(2) x4(P[3] , A[3] , B[3]);
  
  and #(2) a1(G[0] ,A[0],B[0]);
  and #(2) a2(G[1] ,A[1],B[1]);
  and #(2) a3(G[2] ,A[2],B[2]);
  and #(2) a4(G[3] ,A[3],B[3]);
  
  and #(2) ag1(w[0] ,P[0] , Cin );
  or #(2) og1(C1 , G[0] , w[0]);
  
  and #(2) ag2(w[1] , P[1] , G[0]);
  and #(2) ag3(w[2] , P[1] ,w[0]);
  or #(3) og2(C2 , G[1] , w[1] , w[2]);
  
  and #(2) ag4(w[3] , P[2] ,G[1]);
  and #(2) ag5(w[4] , P[2] ,w[1]);
  and #(2) ag6(w[5] , P[2] , w[2]);
  or #(4) og3(C3 , G[2] , w[3] , w[4] , w[5]);
  
  and #(2) ag7(w[6] , P[3] , G[2]);
  and #(2) ag8(w[7] , P[3] , w[3] );
  and #(2) ag9(w[8] , P[3] , w[4]);
  and #(2) ag10(w[9] ,P[3] , w[5]);
  or #(5) og4(Cout , G[3] , w[6] , w[7] , w[8] ,w[9]);
  
  xor #(2) xs1( S[0],P[0] , Cin);
  xor #(2) xs2( S[1], P[1] , C1);
  xor #(2) xs3( S[2], P[2] , C2);
  xor #(2) xs4( S[3], P[3] , C3);
  
endmodule

module Adder2_16bit (A,B,Cin,S,Cout);
   input [15:0] A;
   input [15:0] B;
   input Cin;
   output [15:0]S;
   output Cout;
   wire [2:0] w;
   
   CLA cla1(A[3:0],B[3:0],Cin,S[3:0] ,w[0]);
   CLA cla2(A[7:4],B[7:4],w[0],S[7:4] ,w[1]);
   CLA cla3(A[11:8],B[11:8],w[1],S[11:8],w[2]);
   CLA cla4(A[15:12],B[15:12] ,w[2],S[15:12],Cout);
   
endmodule 


module Adder16_TB;
  reg [15:0] A;
  reg [15:0] B;
  wire [15:0] SUM1;
  wire [15:0] SUM2;
  wire Cout1;
  wire Cout2;
  Adder1_16bit f16(A ,B , 1'b0, SUM1 , Cout1 ); 
  Adder2_16bit cla16(A , B, 1'b0, SUM2 , Cout2  );
  
  initial
    begin 
      #1
      A = 0 ;
      B = 0 ;
      #199
      A = 16'b0010010011010111;
      B = 16'b0000011100010010;
      #200
      A = 16'b1111110111101000;
      B = 16'b0000011100010010;
      #200 $stop;
    end
  initial
  $monitor("A = %d B = %b SUM1 = %d SUM2 = %d Cout1 = %d Cout = %d", A, B, SUM1, SUM2, Cout1, Cout2);
endmodule 