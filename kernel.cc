#include <stddef.h>
#include <stdint.h>

/* Hardware text mode color constants. */
enum class VGAColor : uint8_t {
	BLACK         = 0,
	BLUE          = 1,
	GREEN         = 2,
	CYAN          = 3,
	RED           = 4,
	MAGENTA       = 5,
	BROWN         = 6,
	LIGHT_GREY    = 7,
	DARK_GREY     = 8,
	LIGHT_BLUE    = 9,
	LIGHT_GREEN   = 10,
	LIGHT_CYAN    = 11,
	LIGHT_RED     = 12,
	LIGHT_MAGENTA = 13,
	LIGHT_BROWN   = 14,
	WHITE         = 15,
};

static inline uint8_t vga_entry_color
(const enum VGAColor fg, const enum VGAColor bg) {
  return (uint8_t)fg | ((uint8_t)bg << 4);
}

static inline uint16_t vga_entry
(const unsigned char uc, const uint8_t color) {
  return (uint16_t) uc | ((uint16_t) color << 8);
}

size_t strlen(const char* str) {
  size_t len = 0;
  while (str[len])
    ++len;
  return len;
}

/* Global variables */
static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;
static const uintptr_t VGA_TERMINAL_ADDR = 0xB8000;

size_t terminal_row;
size_t terminal_column;
uint8_t terminal_color;
uint16_t* terminal_buffer;

void terminal_putentryat
(const char c, const uint8_t color, const size_t x, const size_t y) {
  const size_t index = y * VGA_WIDTH + x;
  terminal_buffer[index] = vga_entry(c, color);
}

void terminal_initialize(void) {
  terminal_row = 0;
  terminal_column = 0;
  terminal_color = vga_entry_color(VGAColor::LIGHT_GREY, VGAColor::BLACK);
  terminal_buffer = (uint16_t*) VGA_TERMINAL_ADDR;
  for (size_t y = 0; y < VGA_HEIGHT; ++y)
    for (size_t x = 0; x < VGA_WIDTH; ++x)
      terminal_putentryat(' ', terminal_color, x, y);
}

inline void terminal_setcolor(const uint8_t color) {
  terminal_color = color;
}

void terminal_putchar(const char c) {
  terminal_putentryat(c, terminal_color, terminal_column, terminal_row);
  if (++terminal_column == VGA_WIDTH) {
    terminal_column = 0;
    if (++terminal_row == VGA_HEIGHT)
      terminal_row = 0;
  }
}

void terminal_write(const char* data, const size_t size) {
  for (size_t i = 0; i < size; ++i)
    terminal_putchar(data[i]);
}

void terminal_writestring(const char* data) {
  terminal_write(data, strlen(data));
}

/* Entry point */
#if defined(__cplusplus) // Use C linkage for kernel_main.
extern "C"
#endif
void kernel_main(void) {
  terminal_initialize();
  terminal_writestring("Hello world!\n");
}
