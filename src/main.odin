package spawn_rune

import fmt "core:fmt"
import mem "core:mem"
import "core:runtime"
import "core:unicode/utf8"
import "core:unicode"

SHOW_LEAK :: true
TEST_MODE :: false
INTERFACE_RAYLIB :: true
DEBUG_PATH :: false
DEBUG_INTERFACE_WORD :: false

DEBUG_READ_ERRORN :: false
TEST_STATEMENT :: false

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
