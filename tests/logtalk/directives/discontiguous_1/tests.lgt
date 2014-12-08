%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  This file is part of Logtalk <http://logtalk.org/>
%  
%  Logtalk is free software. You can redistribute it and/or modify it under
%  the terms of the FSF GNU General Public License 3  (plus some additional
%  terms per section 7).        Consult the `LICENSE.txt` file for details.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- object(tests,
	extends(lgtunit)).

	:- info([
		version is 1.0,
		author is 'Paulo Moura',
		date is 2014/11/16,
		comment is 'Unit tests for the discontiguous/1 built-in directive.'
	]).

	% test all possible syntaxes for the directive

	:- private(a/1).
	:- discontiguous(a/1).

	:- private((b/1, c/1)).
	:- discontiguous((b/1, c/1)).

	:- private([d/3, e/4]).
	:- discontiguous([d/3, e/4]).

	% calls to predicates declared discontiguous but not defined
	% must fail instead of throwing an existence error

	:- discontiguous(f/5).

	a(1).
	b(1).
	d(1,2,3).
	a(2).
	e(a,e,i,o).
	d(4,5,6).
	c(1).
	b(2).
	c(2).
	e(x,y,z,t).

	test(discontiguous_1_1) :-
		findall(X, a(X), L),
		L = [1, 2].

	test(discontiguous_1_2) :-
		findall(X, b(X), L),
		L = [1, 2].

	test(discontiguous_1_3) :-
		findall(X, c(X), L),
		L = [1, 2].

	test(discontiguous_1_4) :-
		\+ f(_, _, _, _, _).

:- end_object.