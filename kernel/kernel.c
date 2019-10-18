void main(){
    char *video_memory = (char *) 0xb8000;

    /* display X */
    *video_memory = 'X';
}
