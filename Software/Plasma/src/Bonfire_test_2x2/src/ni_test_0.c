#include "bonfire.h"
#include "packets.h"
#include "uart.h"

BONFIRE_MAIN()
{
    uart_puts("Node 0 started.\n");
    int test = 0;

    BONFIRE_LOOP()
    {
        bonfire_send(build_header(1,3));
        test++;
        bonfire_send(test);
        test++;
        bonfire_send(test);
    }

    BONFIRE_RET();
}
