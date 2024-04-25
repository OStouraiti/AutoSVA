//========================================================================
// riscv-mulh.S
//========================================================================

#include "riscv-macros.h"

        TEST_RISCV_BEGIN

        //--------------------------------------------------------------------
        // Arithmetic tests
        //--------------------------------------------------------------------

        // Zero and one operands

        TEST_RR_OP( mulh,  0,  0, 0 )
        TEST_RR_OP( mulh,  0,  1, 0 )
        TEST_RR_OP( mulh,  1,  0, 0 )
        TEST_RR_OP( mulh,  1,  1, 0 )
        TEST_RR_OP( mulh,  0, -1, 0 )
        TEST_RR_OP( mulh, -1,  0, 0 )
        TEST_RR_OP( mulh, -1, -1, 0 )
        TEST_RR_OP( mulh, -1,  1, 0xffffffff )
        TEST_RR_OP( mulh,  1, -1, 0xffffffff )

        // Positive operands

        TEST_RR_OP( mulh,  0x7fffffff, 200,        0x00000063)
        TEST_RR_OP( mulh,  0x001774cd, 0x00000d83, 0x00000001)

        // Negative operands
        TEST_RR_OP( mulh, -10483, -1567890, 0x00000003)
        TEST_RR_OP( mulh, -20154, -83300000, 0x00000186)

        // Mixed operands

        TEST_RR_OP( mulh, 0x7fffffff, -200, 0xffffff9c)
        TEST_RR_OP( mulh, -200, 0x7fffffff, 0xffffff9c)
        TEST_RR_OP( mulh, -10483, 1567890, 0xfffffffc)

        TEST_RISCV_END