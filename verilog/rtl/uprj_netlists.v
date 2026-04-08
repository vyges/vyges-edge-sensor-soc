// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

// Include caravel global defines for the number of the user project IO pads 
`include "defines.v"
`define USE_POWER_PINS

`ifdef GL
    // Assume default net type to be wire because GL netlists don't have the wire definitions
    `default_nettype wire
    `include "gl/user_project_wrapper.v"
    `include "gl/edge_sensor_glue.v"
    `include "gl/xbar_main.v"
    `include "gl/rv_core_ibex_tlul.v"
    `include "gl/uart.v"
    `include "gl/spi_host_lite.v"
    `include "gl/rv_plic_lite.v"
    `include "gl/fft_ctrl_tlul.v"
`else
    `include "user_project_wrapper.v"
    `include "edge_sensor_glue.v"
    `include "soc_conv.v"
`endif