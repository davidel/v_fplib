/* verilator lint_off WIDTH */

`ifndef SEED
 `define SEED 17
`endif


module conv_test;
  parameter integer NX = 8;
  parameter integer NM = 23;
  parameter integer N = 5000;
  parameter real    K = 10000.0;

  fpu #(.NX (NX), .NM (NM)) f();
  fp_utils #(.NX (NX), .NM (NM)) fu();

  logic [NX + NM: 0] ff, vff;

  integer              i, seed = `SEED;
  real                 rv, xrv;

  initial
    begin
      for (i = 0; i < N; i = i + 1) begin
        rv = fu.rand_real(seed) * K;

        ff = fu.from_real(rv);
        xrv = fu.to_real(ff);
        vff = fu.from_real(xrv);

        if (!fu.icloseto(ff, vff)) begin
          fu.show_real("BAD = ", xrv);
          fu.show_real("OK  = ", rv);

          $finish(1);
        end
      end

      $display("conv_test OK!");
    end
endmodule


module fp_conv_test;
  parameter integer NX = 8;
  parameter integer NM = 23;
  parameter integer N = 5000;
  parameter real    K = 10000.0;

  parameter integer INX = NX;
  parameter integer INM = NM;

  fp_conv #(.INX (INX), .INM (INM), .ONX(NX), .ONM(NM)) f1();
  fp_conv #(.INX (NX), .INM (NM), .ONX(INX), .ONM(INM)) f2();

  fp_utils #(.NX (INX), .NM (INM)) fu1();
  fp_utils #(.NX (NX), .NM (NM)) fu2();

  logic [INX + INM: 0] ff1, xff1;
  logic [NX + NM: 0] off1;

  integer              i, seed = `SEED;
  real                 rv, xrv;

  initial
    begin
      for (i = 0; i < N; i = i + 1) begin
        rv = fu1.rand_real(seed) * K;

        ff1 = fu1.from_real(rv);
        off1 = f1.convert(ff1);
        xff1 = f2.convert(off1);

        if (ff1 != xff1) begin
          xrv = fu1.to_real(xff1);
          fu1.show_real("BAD = ", xrv);
          fu1.show_real("OK  = ", rv);
          $finish(1);
        end
      end

      $display("fp_conv_test OK!");
    end
endmodule


module to_integer_test;
  parameter integer NX = 8;
  parameter integer NM = 23;
  parameter integer N = 5000;
  parameter real    K = 10000.0;

  fpu #(.NX (NX), .NM (NM)) f();
  fp_utils #(.NX (NX), .NM (NM)) fu();

  logic [NX + NM: 0] ff, ffi, irv;

  integer              i, seed = `SEED;
  real                 rv;

  initial
    begin
      for (i = 0; i < N; i = i + 1) begin
        rv = fu.rand_real(seed) * K;

        ff = fu.from_real(rv);
        ffi = f.to_integer(ff);

        irv = (1 + NX + NM)'($rtoi(rv));

        if (ffi != irv) begin
          $display("%d != %d", ffi, irv);
          $display("  %b", ffi);
          $display("  %b", irv);
          $finish(1);
        end
      end

      $display("to_integer_test OK!");
    end
endmodule


module from_integer_test;
  parameter integer NX = 8;
  parameter integer NM = 23;
  parameter integer N = 5000;
  parameter integer K = 100000000;

  localparam integer NB = 1 + NX + NM;

  fpu #(.NX (NX), .NM (NM)) f();
  fp_utils #(.NX (NX), .NM (NM)) fu();

  logic signed [NB - 1: 0] ff;
  logic [N - 1: 0]        ffi;

  integer                 i, iv, irv;

  initial
    begin
      for (i = 0; i < N; i = i + 1) begin
        iv = $random % K;
        ff = NB'(iv);

        ffi = f.from_integer(ff);

        irv = $rtoi(fu.to_real(ffi));

        if (iv != irv) begin
          $display("%d != %d", iv, irv);
          $display("  iv  = %b", iv);
          $display("  irv = %b", irv);
          $finish(1);
        end
      end

      $display("from_integer_test OK!");
    end
endmodule


module add_test;
  parameter integer NX = 8;
  parameter integer NM = 23;
  parameter integer N = 5000;
  parameter real    K = 10000.0;

  fpu #(.NX (NX), .NM (NM)) f();
  fp_utils #(.NX (NX), .NM (NM)) fu();

  logic [NX + NM: 0] ff1, ff2, ff, vff;

  integer              i, seed = `SEED;
  real                 rv1, rv2, rrv;

  initial
    begin
      for (i = 0; i < N; i = i + 1) begin
        rv1 = fu.rand_real(seed) * K;
        rv2 = fu.rand_real(seed) * K;

        ff1 = fu.from_real(rv1);
        ff2 = fu.from_real(rv2);
        vff = fu.from_real(rv1 + rv2);

        ff = f.add(ff1, ff2);

        rrv = fu.to_real(ff);

        if (!fu.icloseto(ff, vff)) begin
          $display("OP = %f + %f", rv1, rv2);
          fu.show_real("BAD = ", rrv);
          fu.show_real("OK  = ", rv1 + rv2);
          $finish(1);
        end
      end

      $display("add_test OK!");
    end
endmodule


module sub_test;
  parameter integer NX = 8;
  parameter integer NM = 23;
  parameter integer N = 5000;
  parameter real    K = 10000.0;

  fpu #(.NX (NX), .NM (NM)) f();
  fp_utils #(.NX (NX), .NM (NM)) fu();

  logic [NX + NM: 0] ff1, ff2, ff, vff;

  integer              i, seed = `SEED;
  real                 rv1, rv2, rrv;

  initial
    begin
      for (i = 0; i < N; i = i + 1) begin
        rv1 = fu.rand_real(seed) * K;
        rv2 = fu.rand_real(seed) * K;

        ff1 = fu.from_real(rv1);
        ff2 = fu.from_real(rv2);
        vff = fu.from_real(rv1 - rv2);

        ff = f.sub(ff1, ff2);

        rrv = fu.to_real(ff);

        if (!fu.icloseto(ff, vff)) begin
          $display("OP = %f - %f", rv1, rv2);
          fu.show_real("BAD = ", rrv);
          fu.show_real("OK  = ", rv1 - rv2);
          $finish(1);
        end
      end

      $display("sub_test OK!");
    end
endmodule


module mul_test;
  parameter integer NX = 8;
  parameter integer NM = 23;
  parameter integer N = 5000;
  parameter real    K = 10000.0;

  fpu #(.NX (NX), .NM (NM)) f();
  fp_utils #(.NX (NX), .NM (NM)) fu();

  logic [NX + NM: 0] ff1, ff2, ff, vff;

  integer              i, seed = `SEED;
  real                 rv1, rv2, rrv;

  initial
    begin
      for (i = 0; i < N; i = i + 1) begin
        rv1 = fu.rand_real(seed) * K;
        rv2 = fu.rand_real(seed) * K;

        ff1 = fu.from_real(rv1);
        ff2 = fu.from_real(rv2);
        vff = fu.from_real(rv1 * rv2);

        ff = f.mul(ff1, ff2);

        rrv = fu.to_real(ff);

        if (!fu.icloseto(ff, vff)) begin
          $display("OP = %f * %f", rv1, rv2);
          fu.show_real("BAD = ", rrv);
          fu.show_real("OK  = ", rv1 * rv2);
          $finish(1);
        end
      end

      $display("mul_test OK!");
    end
endmodule


module div_test;
  parameter integer NX = 8;
  parameter integer NM = 23;
  parameter integer N = 5000;
  parameter real    K = 10000.0;

  fpu #(.NX (NX), .NM (NM)) f();
  fp_utils #(.NX (NX), .NM (NM)) fu();

  logic [NX + NM: 0] ff1, ff2, ff, vff;

  integer              i, seed = `SEED;
  real                 rv1, rv2, rrv;

  initial
    begin
      for (i = 0; i < N; i = i + 1) begin
        rv1 = fu.rand_real(seed) * K;
        do begin
          rv2 = fu.rand_real(seed) * K;
        end while (FABS(rv2) < 1e-5);

        ff1 = fu.from_real(rv1);
        ff2 = fu.from_real(rv2);
        vff = fu.from_real(rv1 / rv2);

        ff = f.div(ff1, ff2);

        rrv = fu.to_real(ff);

        if (!fu.icloseto(ff, vff)) begin
          $display("OP = %f / %f", rv1, rv2);
          fu.show_real("BAD = ", rrv);
          fu.show_real("OK  = ", rv1 / rv2);
          $finish(1);
        end
      end

      $display("div_test OK!");
    end
endmodule


module clz_test;
  parameter integer CLZ_N = 32;

  clz_mod #(.N (CLZ_N)) clz();

  logic [CLZ_N - 1: 0] v;
  integer               i, res;

  initial
    begin
      for (i = 0; i < clz.N; i = i + 1) begin
        v = 1 << i;
        res = clz.clz(v);
        if (res != clz.N - 1 - i) begin
          $display("CLZ(%d) = %d", v, res);
          $finish(1);
        end
      end

      $display("clz_test OK!");
    end
endmodule


`define NX 11
`define NM 52
`define CLZ_N 32
`define TEST_N 100000

module main;
  conv_test #(.NX(`NX), .NM(`NM)) ct();
  fp_conv_test #(.NX(`NX), .NM(`NM)) fct();
  clz_test #(.CLZ_N(`CLZ_N)) cz();
  add_test #(.NX(`NX), .NM(`NM), .N(`TEST_N)) at();
  sub_test #(.NX(`NX), .NM(`NM), .N(`TEST_N)) st();
  mul_test #(.NX(`NX), .NM(`NM), .N(`TEST_N)) mt();
  div_test #(.NX(`NX), .NM(`NM), .N(`TEST_N)) dt();
  to_integer_test #(.NX(`NX), .NM(`NM), .N(`TEST_N)) tit();
  from_integer_test #(.NX(`NX), .NM(`NM), .N(`TEST_N)) fit();

  initial
    begin
      $display("SEED = %6d", `SEED);
      $finish;
    end
endmodule

