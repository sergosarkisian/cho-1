

EXECUTE UTL_RECOMP.RECOMP_PARALLEL(NULL, 'E$&&scheme_uc');
exec rls.init();

##Check
exec kernel_int.make_logon('DIMIK', '');
