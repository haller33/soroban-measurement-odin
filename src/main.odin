package spawn_rune

import fmt "core:fmt"
import mem "core:mem"
import "core:runtime"
import "core:unicode/utf8"
import "core:unicode"
import qu "core:container/queue"

SHOW_LEAK :: true
TEST_MODE :: false
INTERFACE_RAYLIB :: true
DEBUG_PATH :: false
DEBUG_INTERFACE_WORD :: false

DEBUG_READ_ERRORN :: false
TEST_STATEMENT :: false


MAX_NUMBER_OF_BOARDS :: 64
MAX_ROD_PER_SOROBAN_BOARD :: 12
MAX_SOROBAN_INSTRUCTIONS :: 8192 // 2^13
MAX_SOROBAN_OPERATIONS_PER_BOARD :: 64
MAX_SOROBAN_OPERANDS :: 65536              // 2^16


Soroban_Board :: struct {
	board : i64,
	idx_current_local_rod : i8,
	scale_board : i32, // value to consider for scaling state eval
	current_instruction : Soroban_Instructions,
};

Soroban_Operands :: struct {
	current_operand_idx : i64,
	operand_numbers : [MAX_SOROBAN_OPERANDS]i64,
}

Infini_Soroban :: struct {
	boards : qu.Queue(Soroban_Board),
	total_state_of_boards : i64,
	idx_current_board : i64,
	operations : Soroban_Operation_Instructions,
	operands : Soroban_Operands,
}

Soroban_Operation_Instructions :: struct {
	current_idx_opins : i64,
	remain_value : i64,
	instructions : [MAX_SOROBAN_INSTRUCTIONS]Soroban_Instructions,
	rods_idx : [MAX_SOROBAN_INSTRUCTIONS]i64,
}

Soroban_Instructions :: union {

	INS_SB_ON_GO_DAMA_5,
	INS_SB_ON_ICHI_DAMA_1,
	INS_SB_ON_ICHI_DAMA_2,
	INS_SB_ON_ICHI_DAMA_3,
	INS_SB_ON_ICHI_DAMA_4,

	INS_SB_ZERO_GO_DAMA_5,
	INS_SB_ZERO_ICHI_DAMA_1,
	INS_SB_ZERO_ICHI_DAMA_2,
	INS_SB_ZERO_ICHI_DAMA_3,
	INS_SB_ZERO_ICHI_DAMA_4,

	INS_SB_CLEAR_ROD,

	INS_SB_NOP,
};


INS_SB_ON_GO_DAMA_5 :: struct {
	MACRO_MAGIC_NUMBER_INS_SB_ON_GO_DAMA_5 : i64,
}
INS_SB_ON_ICHI_DAMA_1 :: struct {
	MACRO_MAGIC_NUMBER_INS_SB_ON_ICHI_DAMA_1 : i64,
}
INS_SB_ON_ICHI_DAMA_2 :: struct {
	MACRO_MAGIC_NUMBER_INS_SB_ON_ICHI_DAMA_2 : i64,
}
INS_SB_ON_ICHI_DAMA_3 :: struct {
	MACRO_MAGIC_NUMBER_INS_SB_ON_ICHI_DAMA_3 : i64,
}
INS_SB_ON_ICHI_DAMA_4 :: struct {
	MACRO_MAGIC_NUMBER_INS_SB_ON_ICHI_DAMA_4 : i64,
}
INS_SB_ZERO_GO_DAMA_5 :: struct {
	MACRO_MAGIC_NUMBER_INS_SB_ZERO_GO_DAMA_5 : i64,
}
INS_SB_ZERO_ICHI_DAMA_1 :: struct {
	MACRO_MAGIC_NUMBER_INS_SB_ZERO_ICHI_DAMA_1 : i64,
}
INS_SB_ZERO_ICHI_DAMA_2 :: struct {
	MACRO_MAGIC_NUMBER_INS_SB_ZERO_ICHI_DAMA_2 : i64,
}
INS_SB_ZERO_ICHI_DAMA_3 :: struct {
	MACRO_MAGIC_NUMBER_INS_SB_ZERO_ICHI_DAMA_3 : i64,
}
INS_SB_ZERO_ICHI_DAMA_4 :: struct {
	MACRO_MAGIC_NUMBER_INS_SB_ZERO_ICHI_DAMA_4 : i64,
}
INS_SB_CLEAR_ROD :: struct {
	MACRO_MAGIC_NUMBER_INS_SB_CLEAR_ROD : i64,
}
INS_SB_NOP :: struct {
	MACRO_MAGIC_NUMBER_INS_SB_NOP : i64,
}


main_source :: proc() {
    fmt.println("Hello World!")
}

main_scheduler :: proc() {

  // put LUA stuff here

  // main_proc() // still not working propely

  main_source()
}

main :: proc() {

  when SHOW_LEAK {
    track: mem.Tracking_Allocator
    mem.tracking_allocator_init(&track, context.allocator)
    context.allocator = mem.tracking_allocator(&track)
  }

  when !TEST_MODE {
    main_scheduler()
  } else {
    testing()
  }

  when SHOW_LEAK {
    for _, leak in track.allocation_map {
      fmt.printf("%v leaked %v bytes\n", leak.location, leak.size)
    }
    for bad_free in track.bad_free_array {
      fmt.printf(
        "%v allocation %p was freed badly\n",
        bad_free.location,
        bad_free.memory,
      )
    }
  }
  return
}
