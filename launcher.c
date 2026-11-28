#include <stdio.h>
#include <stdlib.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <errno.h>
#include <limits.h>
#include <string.h>
#include <sys/stat.h>

int luaopen_readline(lua_State *L);

static int make_dirs(const  char *path) {
    char buffer[PATH_MAX];

    if (strlen(path) >= sizeof(buffer))
    return -1;

    strcpy(buffer, path);

    for (char *p = buffer + 1; *p; p++) {
        if (*p == '/') {
            *p = '\0';
        
        if (mkdir(buffer, 0700) != 0 && errno != EEXIST)
           return -1;
        
        *p = '/';
      }
    }
    if (mkdir(buffer, 0700) != 0 && errno != EEXIST)
    return -1;

    return 0;
}

static int setup_data_dir(char *output, size_t size) {
    const char *xdg = getenv("XDG_DATA_HOME");
    const char *home = getenv("HOME");

    char base [PATH_MAX];

    if (xdg && xdg[0] == '/') {
        snprintf(base, sizeof(base), "%s", xdg);
    } else  {
        if (!home) 
        return -1;

        snprintf(base, sizeof(base), "%s/.local/share", home);
    }
    if (snprintf(output, size, "%s/dead-frequency", base) >= (int)size)
    return -1;

    if (make_dirs(output) != 0)
    return -1;

    char saves [PATH_MAX];

    if (snprintf(saves, sizeof(saves), "%s/saves", output) >= 
   (int)sizeof(saves))
   return -1; 

   return make_dirs(saves);
}

int main(void) {
    lua_State *L = luaL_newstate();

    if (L == NULL) {
        fprintf(stderr, "Failed to init Lua.");
        return EXIT_FAILURE;
    }

    luaL_openlibs(L);
    luaL_requiref(L, "C-readline", luaopen_readline, 0);
    lua_pop(L, 1);

    char data_dir[PATH_MAX];

    if (setup_data_dir(data_dir, sizeof(data_dir)) != 0) {
        fprintf(stderr, "Failed to create game data dir.\n");
        lua_close(L);
        return EXIT_FAILURE;
    }

    if (setenv("DEAD_FREQUENCY_DATA_DIR", data_dir, 1) != 0) {
        fprintf(stderr, "Failed to configure game dir.\n");
        return EXIT_FAILURE;
    }

    if (luaL_dofile(L, "main.lua") != LUA_OK) {
        fprintf(stderr, "Game err: %s\n", lua_tostring(L, -1));
        lua_close(L);
        return EXIT_FAILURE;
    }

    lua_close(L);
    return EXIT_SUCCESS;
}