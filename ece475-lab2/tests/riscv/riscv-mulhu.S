//========================================================================
// riscv-mulhu.S
//========================================================================

#include "riscv-macros.h"

        TEST_RISCV_BEGIN

        //--------------------------------------------------------------------
        // Arithmetic tests
        //--------------------------------------------------------------------

        // Zero and one operands

        TEST_RR_OP( mulhu,  0,  0, 0 )
        TEST_RR_OP( mulhu,  0,  1, 0 )
        TEST_RR_OP( mulhu,  1,  0, 0 )
        TEST_RR_OP( mulhu,  1,  1, 0 )
        TEST_RR_OP( mulhu,  0, -1, 0 )
        TEST_RR_OP( mulhu, -1,  0, 0 )
        TEST_RR_OP( mulhu, -1, -1, 0xfffffffe )
        TEST_RR_OP( mulhu, -1,  1, 0 )
        TEST_RR_OP( mulhu,  1, -1, 0 )

        // Positive operands

        TEST_RR_OP( mulhu,  0x7fffffff, 200,        0x00000063)
        TEST_RR_OP( mulhu,  0x001774cd, 0x00000d83, 0x00000001)

        // Negative operands (test to ensure they are treated as unsigned)

        TEST_RR_OP( mulhu, -10483, -1567890, 0xffe7ea7e)
        TEST_RR_OP( mulhu, -20154, -83300000, 0xfb08a42c)

        // Mixed operands (test to ensure they are treated as unsigned)

        TEST_RR_OP( mulhu, -10483, 1567890, 0x0017ec8e)
        TEST_RR_OP( mulhu, 20154, -83300000, 0x00004d33)

        TEST_RISCV_END