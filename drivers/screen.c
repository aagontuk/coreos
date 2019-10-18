#include "screen.h"

void print(char *msg){
    print_at(msg, -1, -1);
}

void print_at(char *msg, int col, int row){
    if(col >=0 && row >= 0){
        set_cursor(get_screen_offset(col, row));
    }

    int i = 0;
    while(msg[i] != 0){
        print_char(msg[i++], col, row, WHITE_ON_BLACK);
    }
}

void clear_screen(){
    int col, row;

    for(row = 0; row < MAX_ROWS; row++){
        for(col = 0; col < MAX_COLS; col++){
            print_char(' ', col, row, WHITE_ON_BLACK);
        }
    }

    set_cursor(get_screen_offset(0, 0));
}

void print_char(char character, int col, int row, char attr){
    unsigned char *vidmem = (unsigned char *) VIDEO_ADDRESS;

    if(!attr){
        attr = WHITE_ON_BLACK; 
    }

    int offset;

    if(col >= 0 && row >= 0){ 
        offset = get_screen_offset(col, row);
    }
    else{                       /* invalid offset, get current */
        offset = get_cursor();
    }

    /* newline characted. set offset to the end of the row */
    if(character == '\n'){
        int rows = offset / (2 * MAX_COLS);
        offset = get_screen_offset(79, rows);
    }
    else{   /* write on video memory */
        vidmem[offset] = character;
        vidmem[offset + 1] = attr;
    }

    /* update offset for next character */
    offset += 2;

    /* update cursor position */
    set_cursor(offset);
}

int get_cursor(){
    /* set reg 14, which is the high byte of cursor offset */
    port_byte_out(REG_SCREEN_CTRL, 14);
    /* read the data from reg 14 and shift it to 8 bits */
    int offset = port_byte_in(REG_SCREEN_DATA) << 8;
    /* set reg 15, which is the low byte of cursor offset */
    port_byte_out(REG_SCREEN_CTRL, 15);
    offset += port_byte_in(REG_SCREEN_DATA);

    /* multiplied by 2. As driver only keep count of character
     * printed so far
     */
    return 2*offset;
}

void set_cursor(int offset){
    offset /= 2;
    port_byte_out(REG_SCREEN_CTRL, 14);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
    port_byte_out(REG_SCREEN_CTRL, 15);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)offset);
}

int get_screen_offset(int col, int row){
    return (80 * row + col) * 2;
}
