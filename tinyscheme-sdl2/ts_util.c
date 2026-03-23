#include "log.h"
#include "scm.h"

#include <stdlib.h>
#include <time.h>

static pointer ts_util_time(scheme *sc, pointer args) {
	return scm_mk_int(sc, time(NULL));
}

static pointer ts_util_srand(scheme *sc, pointer args) {
	int seed=0;

    if (scm_unpack(sc, &args, "d", &seed)) {
        log_error("%s: %s\n", __FUNCTION__, scm_get_error());
        return sc->NIL;
    }

    srand(seed);

	return sc->T;
}

static pointer ts_util_rand(scheme *sc, pointer args) {
	return scm_mk_int(sc, rand());
}

void init_ts_util(scheme *sc) {
	scm_define_api_call(sc, "util-time", ts_util_time);
	scm_define_api_call(sc, "util-srand", ts_util_srand);
	scm_define_api_call(sc, "util-rand", ts_util_rand);
}


