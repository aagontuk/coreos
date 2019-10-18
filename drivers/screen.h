#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80

/* Attributes */
#define WHITE_ON_BLACK 0x0f

/* Screen I/O ports */
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5 

extern unsigned char port_byte_in(unsigned short port);
extern void port_byte_out(unsigned short port, unsigned char data);

void print(char *msg);
void print_at(char *msg, int col, int row);
void clear_screen();
void print_char(char character, int col, int row, char attr);
int get_cursor(); 
void set_cursor(int offset);
int get_screen_offset(int col, int row);
