%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  This file is part of Logtalk <http://logtalk.org/>
%  
%  Logtalk is free software. You can redistribute it and/or modify it under
%  the terms of the FSF GNU General Public License 3  (plus some additional
%  terms per section 7).        Consult the `LICENSE.txt` file for details.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- object(context_switch_test_object).

	:- set_logtalk_flag(context_switching_calls, deny).

	p.

:- end_object.


:- object(context_switch_test_object(_)).

	:- set_logtalk_flag(context_switching_calls, allow).

	p(X) :-
		parameter(1, X).

:- end_object.


context_switch_test_object(1).
context_switch_test_object(2).
context_switch_test_object(3).


:- object(tests,
	extends(lgtunit)).

	:- info([
		version is 1.1,
		author is 'Paulo Moura',
		date is 2014/12/04,
		comment is 'Unit tests for the (<<)/2 built-in control construct.'
	]).

	throws(context_switch_2_01, error(instantiation_error, logtalk(_<<goal,user))) :-
		{_ << goal}.

	throws(context_switch_2_02, error(instantiation_error, logtalk(logtalk<<_,user))) :-
		{logtalk << _}.

	throws(context_switch_2_03, error(type_error(object_identifier, 3), logtalk(3<<goal,user))) :- 
		{3 << goal}.

	throws(context_switch_2_04, error(type_error(callable, 3), logtalk(object<<3,user))) :-
		{object << 3}.

	throws(context_switch_2_05, error(existence_error(procedure, goal/0), logtalk(This<<goal,user))) :-
		this(This),
		{This << goal}.

	throws(context_switch_2_06, error(existence_error(object, foo), logtalk(foo<<goal,user))) :-
		{foo << goal}.

	throws(context_switch_2_07, error(permission_error(access, database, p), logtalk(context_switch_test_object<<p,user))) :-
		{context_switch_test_object << p}.

	succeeds(context_switch_2_08) :-
		{user << true}.

	succeeds(context_switch_2_09) :-
		{logtalk << true}.

	succeeds(context_switch_2_10) :-
		this(This),
		findall(X, {This << a(X)}, Xs),
		Xs == [1,2,3].

	succeeds(context_switch_2_11) :-
		create_object(Object, [], [], [a(1),a(2),a(3)]),
		findall(X, {Object << a(X)}, Xs),
		Xs == [1,2,3],
		abolish_object(Object).

	succeeds(context_switch_2_12) :-
		findall(X, {context_switch_test_object(_)}<<p(X), Xs),
		Xs == [1,2,3].

	fails(context_switch_2_13) :-
		{user << fail}.

	fails(context_switch_2_14) :-
		{logtalk << fail}.

	fails(context_switch_2_15) :-
		this(This),
		{This << a(4)}.

	fails(context_switch_2_16) :-
		{context_switch_test_object(_)}<<p(4).

	a(1). a(2). a(3).

:- end_object.