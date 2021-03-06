// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Fabian Schuiki <fschuiki@iis.ee.ethz.ch>
// Florian Zaruba <zarubaf@iis.ee.ethz.ch>
//
// AUTOMATICALLY GENERATED by occamygen.py; edit the script instead.

`include "axi/typedef.svh"
`include "register_interface/typedef.svh"

package occamy_pkg;

  // Re-exports
  localparam int unsigned AddrWidth = occamy_cluster_pkg::AddrWidth;
  localparam int unsigned NarrowDataWidth = occamy_cluster_pkg::NarrowDataWidth;
  localparam int unsigned NarrowIdWidth = occamy_cluster_pkg::NarrowIdWidthOut;
  localparam int unsigned WideDataWidth = occamy_cluster_pkg::WideDataWidth;
  localparam int unsigned WideIdWidth = occamy_cluster_pkg::WideIdWidthOut;
  localparam int unsigned UserWidth = occamy_cluster_pkg::UserWidth;

  localparam int unsigned NrClustersS1Quadrant = 4;
  localparam int unsigned NrCoresCluster = occamy_cluster_pkg::NrCores;
  localparam int unsigned NrCoresS1Quadrant = NrClustersS1Quadrant * NrCoresCluster;

  localparam int unsigned NrS1Quadrants = 8;

  typedef logic [5:0] tile_id_t;

  typedef logic [AddrWidth-1:0]         addr_t;
  typedef logic [NarrowDataWidth-1:0]   narrow_data_t;
  typedef logic [NarrowDataWidth/8-1:0] narrow_strb_t;
  typedef logic [NarrowIdWidth-1:0]     narrow_id_t;
  typedef logic [WideDataWidth-1:0]     wide_data_t;
  typedef logic [WideDataWidth/8-1:0]   wide_strb_t;
  typedef logic [WideIdWidth-1:0]       wide_id_t;
  typedef logic [UserWidth-1:0]         user_t;

  typedef struct packed {
    int unsigned idx;
    addr_t start_addr;
    addr_t end_addr;
  } xbar_rule_t;

  `AXI_TYPEDEF_ALL(axi_narrow, addr_t, narrow_id_t, narrow_data_t, narrow_strb_t, user_t)
  `AXI_TYPEDEF_ALL(axi_narrow_wide_id, addr_t, wide_id_t, narrow_data_t, narrow_strb_t, user_t)
  `AXI_TYPEDEF_ALL(axi_wide, addr_t, wide_id_t, wide_data_t, wide_strb_t, user_t)

  typedef struct packed {
    axi_narrow_req_t narrow_in_req;
    axi_narrow_resp_t narrow_out_rsp;
    axi_wide_req_t wide_in_req;
    axi_wide_resp_t wide_out_rsp;
  } quadrant_in_t;

  typedef struct packed {
    axi_narrow_resp_t narrow_in_rsp;
    axi_narrow_req_t narrow_out_req;
    axi_wide_resp_t wide_in_rsp;
    axi_wide_req_t wide_out_req;
  } quadrant_out_t;

  // PCIe
  typedef struct packed {
    axi_wide_req_t pcie_in_req;
    axi_wide_resp_t pcie_out_rsp;
  } pice_in_t;

  typedef struct packed {
    axi_wide_req_t pcie_out_req;
    axi_wide_resp_t pcie_in_rsp;
  } pice_out_t;

  /// The base offset for each cluster.
  localparam addr_t ClusterBaseOffset = 'h1000_0000;
  /// The address space set aside for each slave.
  localparam addr_t ClusterAddressSpace = 'h10_0000;
  /// The address space of a single S1 quadrant.
  localparam addr_t S1QuadrantAddressSpace = ClusterAddressSpace * NrClustersS1Quadrant;

  // AXI-Lite bus with 34 bit address and 32 bit data.
  `AXI_LITE_TYPEDEF_ALL(axi_lite_a34_d32, logic [33:0], logic [31:0], logic [3:0])

  /// Inputs of the `io_periph_xbar` crossbar.
  typedef enum int {
    IO_PERIPH_XBAR_IN_SOC,
    IO_PERIPH_XBAR_NUM_INPUTS
  } io_periph_xbar_inputs_e;

  /// Outputs of the `io_periph_xbar` crossbar.
  typedef enum int {
    IO_PERIPH_XBAR_OUT_SOC_CTRL,
    IO_PERIPH_XBAR_OUT_DEBUG,
    IO_PERIPH_XBAR_OUT_BOOTROM,
    IO_PERIPH_XBAR_OUT_CLINT,
    IO_PERIPH_XBAR_OUT_PLIC,
    IO_PERIPH_XBAR_OUT_UART,
    IO_PERIPH_XBAR_OUT_GPIO,
    IO_PERIPH_XBAR_OUT_I2C,
    IO_PERIPH_XBAR_NUM_OUTPUTS
  } io_periph_xbar_outputs_e;

  /// Configuration of the `io_periph_xbar` crossbar.
  localparam axi_pkg::xbar_cfg_t IoPeriphXbarCfg = '{
    NoSlvPorts:         IO_PERIPH_XBAR_NUM_INPUTS,
    NoMstPorts:         IO_PERIPH_XBAR_NUM_OUTPUTS,
    MaxSlvTrans:        4,
    MaxMstTrans:        4,
    FallThrough:        0,
    LatencyMode:        axi_pkg::CUT_ALL_PORTS,
    AxiIdWidthSlvPorts: 0,
    AxiIdUsedSlvPorts:  0,
    AxiAddrWidth:       34,
    AxiDataWidth:       32,
    NoAddrRules:        8
  };

  /// Address map of the `io_periph_xbar` crossbar.
  localparam xbar_rule_34_t [7:0] IoPeriphXbarAddrmap = '{
    '{ idx: 0, start_addr: 34'h00020000, end_addr: 34'h00021000 },
    '{ idx: 1, start_addr: 34'h00000000, end_addr: 34'h00001000 },
    '{ idx: 2, start_addr: 34'h00010000, end_addr: 34'h00020000 },
    '{ idx: 3, start_addr: 34'h00040000, end_addr: 34'h00050000 },
    '{ idx: 4, start_addr: 34'h00024000, end_addr: 34'h00025000 },
    '{ idx: 5, start_addr: 34'h00030000, end_addr: 34'h00031000 },
    '{ idx: 6, start_addr: 34'h00031000, end_addr: 34'h00032000 },
    '{ idx: 7, start_addr: 34'h00033000, end_addr: 34'h00034000 }
  };

  // AXI plugs of the `io_periph_xbar` crossbar.

  typedef axi_lite_a34_d32_req_t io_periph_xbar_in_req_t;
  typedef axi_lite_a34_d32_req_t io_periph_xbar_out_req_t;
  typedef axi_lite_a34_d32_rsp_t io_periph_xbar_in_rsp_t;
  typedef axi_lite_a34_d32_rsp_t io_periph_xbar_out_rsp_t;
  typedef axi_lite_a34_d32_aw_t io_periph_xbar_in_aw_t;
  typedef axi_lite_a34_d32_aw_t io_periph_xbar_out_aw_t;
  typedef axi_lite_a34_d32_w_t io_periph_xbar_in_w_t;
  typedef axi_lite_a34_d32_w_t io_periph_xbar_out_w_t;
  typedef axi_lite_a34_d32_b_t io_periph_xbar_in_b_t;
  typedef axi_lite_a34_d32_b_t io_periph_xbar_out_b_t;
  typedef axi_lite_a34_d32_ar_t io_periph_xbar_in_ar_t;
  typedef axi_lite_a34_d32_ar_t io_periph_xbar_out_ar_t;
  typedef axi_lite_a34_d32_r_t io_periph_xbar_in_r_t;
  typedef axi_lite_a34_d32_r_t io_periph_xbar_out_r_t;

endpackage
