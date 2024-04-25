//========================================================================
// riscv-mulhsu.S
//========================================================================

#include "riscv-macros.h"

        TEST_RISCV_BEGIN

        //--------------------------------------------------------------------
        // Arithmetic tests
        //--------------------------------------------------------------------

        // Zero and one operands

        TEST_RR_OP( mulhsu,  0,  0, 0 )
        TEST_RR_OP( mulhsu,  0,  1, 0 )
        TEST_RR_OP( mulhsu,  1,  0, 0 )
        TEST_RR_OP( mulhsu,  1,  1, 0 )
        TEST_RR_OP( mulhsu,  0, -1, 0 )
        TEST_RR_OP( mulhsu, -1,  0, 0 )
        TEST_RR_OP( mulhsu, -1, -1, 0xffffffff ) // (-1) * 0xffffffff = (-1) * 4294967295 = -4294967295 = 0xFFFFFFFF00000001
        TEST_RR_OP( mulhsu, -1,  1, 0xffffffff)  // (-1) * 1 = -1 = 0xffffffffffffffff
        TEST_RR_OP( mulhsu,  1, -1, 0)           // 1 * 0xffffffff = 0x00000000ffffffff

        // Positive operands

        TEST_RR_OP( mulhsu,  0x7fffffff, 200,        0x00000063)
        TEST_RR_OP( mulhsu,  0x001774cd, 0x00000d83, 0x00000001)

        // Negative operands
        TEST_RR_OP( mulhsu, -10483, -1567890, 0xffffd710)
        TEST_RR_OP( mulhsu, -20154, -83300000, 0xffffb2cc)

        // Mixed operands

        TEST_RR_OP( mulhsu, 0x7fffffff, -200, 0x7fffff9b)
        TEST_RR_OP( mulhsu, -200, 0x7fffffff, 0xffffff9c)

        TEST_RISCV_END