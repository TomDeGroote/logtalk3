%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  This file is part of Logtalk <http://logtalk.org/>
%  
%  Logtalk is free software. You can redistribute it and/or modify it under
%  the terms of the FSF GNU General Public License 3  (plus some additional
%  terms per section 7).        Consult the `LICENSE.txt` file for details.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- if((	current_logtalk_flag(prolog_dialect, Dialect),
		(Dialect == eclipse; Dialect == sicstus; Dialect == swi; Dialect == yap)
)).

	:- initialization((
		logtalk_load_context(directory, Directory),
		atom_concat(Directory, module, Path),
		use_module(Path)
	)).

	:- initialization((
		set_logtalk_flag(report, warnings),
		logtalk_load(lgtunit(loader)),
		logtalk_load(tests, [hook(lgtunit)]),
		tests::run
	)).

:- else.

	:- initialization((
		write('(not applicable)'), nl
	)).

:- endif.