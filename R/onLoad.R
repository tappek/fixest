


.onLoad <- function(libname, pkgname){
	# setting some options


	options("fixest_dict" = c())
	options("fixest_notes" = TRUE)
	options("fixest_print" = list(type = "table"))
	options("fixest_fl_authorized" = FALSE)

	setFixest_coefplot("all", reset = TRUE)
	setFixest_ssc()

	# # To include later
	# cpp_setup_fork_presence()

	# nthreads
	setFixest_nthreads()

	# Setup of builtin VCOVs
	vcov_setup()

	# Aliases must come after the VCOV
    create_aliases()

	invisible()
}



.onAttach = function(libname, pkgname) {

    # The startup message mechanism ends up being a bit complex because I try to avoid
    # annoyance as much as possible.
    # I also want to keep track of all the breaking changes so that someone that didn't update for
    # a while is fully informed on how to change his/her old code

    startup_msg = c(
        "0.10.0" = "fixest 0.10.0:\n- vcov: new argument 'vcov' that replaces 'se' and 'cluster' in all functions (retro compatibility is ensured)\n- breaking change: function 'dof()' has been renamed into 'ssc()' (which stands for small sample correction). No retro-compatibility.",
        "0.9.0" = "From fixest 0.9.0 onward: BREAKING changes! \n- In i():\n    + the first two arguments have been swapped! Now it's i(factor_var, continuous_var) for interactions. \n    + argument 'drop' has been removed (put everything in 'ref' now).\n- In feglm(): \n    + the default family becomes 'gaussian' to be in line with glm(). Hence, for Poisson estimations, please use fepois() instead.")

    fixest_startup_msg = initialize_startup_msg(startup_msg)

    if(isTRUE(fixest_startup_msg)){
        msg = startup_msg

    } else if(isFALSE(fixest_startup_msg)){
        msg = NULL

    } else {
        v = version2num(fixest_startup_msg)
        msg = c()
        for(i in seq_along(startup_msg)){
            if(version2num(names(startup_msg)[i]) > v){
                msg = c(msg, startup_msg[i])
            }
        }
    }

    if(length(msg) > 0) {
        msg = c("(Permanently remove the following message with fixest_startup_msg(FALSE).)", msg)
        packageStartupMessage(fit_screen(paste(msg, collapse = "\n"), .95))
    }

}


