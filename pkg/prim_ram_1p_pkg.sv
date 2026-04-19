// Minimal prim_ram_1p_pkg stub for bring-up builds.
// Some OpenTitan IPs (e.g. i2c) instantiate prim_ram_1p_adv which imports prim_ram_1p_pkg.
// In the current minimal flow we tie off cfg inputs; only the type definitions are required.

package prim_ram_1p_pkg;
  typedef struct packed {
    logic en;
  } ram_1p_cfg_t;

  typedef struct packed {
    logic ack;
  } ram_1p_cfg_rsp_t;
endpackage : prim_ram_1p_pkg

