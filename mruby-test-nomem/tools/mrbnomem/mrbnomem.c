#include <mruby.h>
#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>

enum {
    lifetime_default = 100,
    lifetime_limit = 10000
};

static size_t lifetime = lifetime_default;

static void *
nomem_alloc(mrb_state *mrb, void *addr, size_t size, void *opaque)
{
    if (size > 0) {
        if (lifetime > 0) {
            lifetime --;

            if (addr) {
                return realloc(addr, size);
            } else {
                return malloc(size);
            }
        }
    } else if (addr) {
        free(addr);
    }

    return NULL;
}

static void
set_lifetime(int argc, char *argv[])
{
    if (argc > 1) {
        lifetime = strtoul(argv[1], NULL, 0);
        if (lifetime > lifetime_limit) {
            fprintf(stderr, "%s: malloc lifetime is too big - %zu.\n", argv[0], lifetime);
            lifetime = lifetime_limit;
        }
        printf("%s: malloc lifetime to set %zu.\n", argv[0], lifetime);
    } else {
        printf("usage: %s <malloc lifetime>\n", argv[0]);
        printf("%s: malloc lifetime to set %zu (by default).\n", argv[0], lifetime);
    }

    fflush(stdout);
}

int
main(int argc, char *argv[])
{
    set_lifetime(argc, argv);

    mrb_state *mrb = mrb_open_allocf(nomem_alloc, NULL);
    if (!mrb) {
        fflush(stdout);
        fprintf(stderr, "%s: not allocated mruby context.\n", argv[0]);
    }
    mrb_close(mrb); /* mrb_close() is NULL safe */

    printf("%s: program is terminated normaly.\n", argv[0]);

    return 0;
}
