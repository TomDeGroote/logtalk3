%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  This file is part of Logtalk <http://logtalk.org/>
%  Copyright 1998-2016 Paulo Moura <pmoura@logtalk.org>
%  
%  Licensed under the Apache License, Version 2.0 (the "License");
%  you may not use this file except in compliance with the License.
%  You may obtain a copy of the License at
%  
%      http://www.apache.org/licenses/LICENSE-2.0
%  
%  Unless required by applicable law or agreed to in writing, software
%  distributed under the License is distributed on an "AS IS" BASIS,
%  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%  See the License for the specific language governing permissions and
%  limitations under the License.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- object(help).

	:- info([
		version is 0.6,
		author is 'Paulo Moura',
		date is 2016/05/07,
		comment is 'Command-line help for Logtalk built-in control constructs, predicates, non-terminals, and methods.'
	]).

	:- initialization((nl, write('For help on Logtalk, type help::help.'), nl, nl)).

	:- public(help/0).
	:- mode(help, one).
	:- info(help/0, [
		comment is 'Prints instructions on how to use the help tool.'
	]).

	help :-
		nl,
		write('On-line help is available for Logtalk built-in control constructs, built-in'), nl,
		write('directives, built-in predicates, built-in non-terminals, built-in methods,'), nl,
		write('and the standard library:'), nl, nl,
		write('    help::Functor/Arity.'), nl,
		write('    help::Functor//Arity. '), nl,
		write('    help::library.'), nl,
		write('    help::library(Entity).'), nl, nl,
		write('The manual page for the selected built-in feature will open in your default'), nl,
		write('web browser. To consult the Logtalk User and Reference manuals:'), nl, nl,
		write('    help::manuals.'), nl, nl,
		write('To compile and load source files the following shortcut can be used:'), nl, nl,
		write('    {File1, File2, ...}'), nl, nl,
		write('To recompile and reload all source files that have been changed since they'), nl,
		write('were loaded the following shortcut can be used:'), nl, nl,
		write('    {*}'), nl, nl,
		write('To debug your code, first load the debugger tool and turn on the debug flag:'), nl, nl,
		write('    {debugger(loader)}, set_logtalk_flag(debug, on).'), nl, nl,
		write('Second, load the source files you want to debug and start the debugger tracer:'), nl, nl,
		write('    debugger::trace.'), nl, nl.

	:- public(('/')/2).
	:- mode('/'(+atom, +integer), zero_or_one).
	:- info(('/')/2, [
		comment is 'Provides help on the Functor/Arity built-in control construct, directive, predicate, or method.',
		argnames is ['Functor', 'Arity']
	]).

	Functor/Arity :-
		forall(
			(	built_in_directive(Functor, Arity, Path, File)
			;	built_in_method(Functor, Arity, Path, File)
			;	built_in_predicate(Functor, Arity, Path, File)
			;	control(Functor, Arity, Path, File)
			),
			open(Path, File)
		).

	:- public(('//')/2).
	:- mode('//'(+atom, +integer), zero_or_one).
	:- info(('//')/2, [
		comment is 'Provides help on the Functor//Arity built-in non-terminal.',
		argnames is ['Functor', 'Arity']
	]).

	NonTerminalFunctor//Arity :-
		forall(
			built_in_non_terminal(NonTerminalFunctor, Arity, Path, File),
			open(Path, File)
		).

	:- public(completion/2).
	:- mode(completion(+atom, -pair), zero_or_more).
	:- info(completion/2, [
		comment is 'Provides a completion pair (Completion-Page) for a given prefix.',
		argnames is ['Prefix', 'Completion']
	]).

	completion(Prefix, Completion-Page) :-
		(	built_in_directive(Functor, Arity, Path, File),
			Completion = Functor/Arity
		;	built_in_method(Functor, Arity, Path, File),
			Completion = Functor/Arity
		;	built_in_predicate(Functor, Arity, Path, File),
			Completion = Functor/Arity
		;	built_in_non_terminal(Functor, Arity, Path, File),
			Completion = Functor//Arity
		;	control(Functor, Arity, Path, File),
			Completion = Functor/Arity
		),
		sub_atom(Functor, 0, _, _, Prefix),
		atom_concat('$LOGTALKHOME', Path, Page0),
		atom_concat(Page0, File, Page1),
		os::expand_path(Page1, Page).

	:- public(completions/2).
	:- mode(completions(+atom, -lists(pair)), zero_or_more).
	:- info(completions/2, [
		comment is 'Provides a list of completions pairs (Completion-Page) for a given prefix.',
		argnames is ['Prefix', 'Completions']
	]).

	completions(Prefix, Completions) :-
		findall(Completion, completion(Prefix, Completion), Completions).

	:- public(built_in_directive/4).
	:- mode(built_in_directive(?atom, ?integer, -atom, -atom), zero_or_more).
	:- info(built_in_directive/4, [
		comment is 'Provides access to the HTML documenting files describing built-in directives.',
		argnames is ['Functor', 'Arity', 'Directory', 'Basename']
	]).

	built_in_directive(encoding, 1, '/manuals/refman/directives/', 'encoding_1.html').
	built_in_directive(initialization, 1, '/manuals/refman/directives/', 'initialization_1.html').
	built_in_directive(op, 3, '/manuals/refman/directives/', 'op_3.html').
	built_in_directive(set_logtalk_flag, 2, '/manuals/refman/directives/', 'set_logtalk_flag_2.html').

	built_in_directive(if, 1, '/manuals/refman/directives/', 'if_1.html').
	built_in_directive(elif, 1, '/manuals/refman/directives/', 'elif_1.html').
	built_in_directive(else, 0, '/manuals/refman/directives/', 'else_0.html').
	built_in_directive(endif, 0, '/manuals/refman/directives/', 'endif_0.html').

	built_in_directive(calls, 1, '/manuals/refman/directives/', 'calls_1.html').
	built_in_directive(category, N, '/manuals/refman/directives/', 'category1_3.html') :-
		between(1, 3, N).
	built_in_directive(dynamic, 0, '/manuals/refman/directives/', 'dynamic_0.html').
	built_in_directive(end_category, 0, '/manuals/refman/directives/', 'end_category_0.html').
	built_in_directive(end_object, 0, '/manuals/refman/directives/', 'end_object_0.html').
	built_in_directive(end_protocol, 0, '/manuals/refman/directives/', 'end_protocol_0.html').
	built_in_directive(include, 1, '/manuals/refman/directives/', 'include_1.html').
	built_in_directive(info, 1, '/manuals/refman/directives/', 'info_1.html').
	built_in_directive(initialization, 1, '/manuals/refman/directives/', 'initialization_1.html').
	built_in_directive(object, N, '/manuals/refman/directives/', 'object_1_5.html') :-
		between(1, 5, N).
	built_in_directive(protocol, N, '/manuals/refman/directives/', 'protocol1_2.html') :-
		between(1, 2, N).
	built_in_directive(threaded, 0, '/manuals/refman/directives/', 'threaded_0.html').
	built_in_directive(uses, 1, '/manuals/refman/directives/', 'uses_1.html').

	built_in_directive(alias, 2, '/manuals/refman/directives/', 'alias_2.html').
	built_in_directive(coinductive, 1, '/manuals/refman/directives/', 'coinductive_1.html').
	built_in_directive(discontiguous, 1, '/manuals/refman/directives/', 'discontiguous_1.html').
	built_in_directive(dynamic, 1, '/manuals/refman/directives/', 'dynamic_1.html').
	built_in_directive(info, 2, '/manuals/refman/directives/', 'info_2.html').
	built_in_directive(meta_predicate, 1, '/manuals/refman/directives/', 'meta_predicate_1.html').
	built_in_directive(meta_non_terminal, 1, '/manuals/refman/directives/', 'meta_non_terminal_1.html').
	built_in_directive(mode, 2, '/manuals/refman/directives/', 'mode_2.html').
	built_in_directive(multifile, 1, '/manuals/refman/directives/', 'multifile_1.html').
	built_in_directive(op, 3, '/manuals/refman/directives/', 'op_3.html').
	built_in_directive(private, 1, '/manuals/refman/directives/', 'private_1.html').
	built_in_directive(protected, 1, '/manuals/refman/directives/', 'protected_1.html').
	built_in_directive(public, 1, '/manuals/refman/directives/', 'public_1.html').
	built_in_directive(synchronized, 1, '/manuals/refman/directives/', 'synchronized_1.html').
	built_in_directive(uses, 2, '/manuals/refman/directives/', 'uses_2.html').
	built_in_directive(use_module, 2, '/manuals/refman/directives/', 'use_module_2.html').

	:- public(built_in_predicate/4).
	:- mode(built_in_predicate(?atom, ?integer, -atom, -atom), zero_or_more).
	:- info(built_in_predicate/4, [
		comment is 'Provides access to the HTML documenting files describing built-in predicates.',
		argnames is ['Functor', 'Arity', 'Directory', 'Basename']
	]).

	built_in_predicate(current_category, 1, '/manuals/refman/predicates/', 'current_category_1.html').
	built_in_predicate(current_object, 1, '/manuals/refman/predicates/', 'current_object_1.html').
	built_in_predicate(current_protocol, 1, '/manuals/refman/predicates/', 'current_protocol_1.html').

	built_in_predicate(category_property, 2, '/manuals/refman/predicates/', 'category_property_2.html').
	built_in_predicate(object_property, 2, '/manuals/refman/predicates/', 'object_property_2.html').
	built_in_predicate(protocol_property, 2, '/manuals/refman/predicates/', 'protocol_property_2.html').

	built_in_predicate(create_category, 4, '/manuals/refman/predicates/', 'create_category_4.html').
	built_in_predicate(create_object, 4, '/manuals/refman/predicates/', 'create_object_4.html').
	built_in_predicate(create_protocol, 3, '/manuals/refman/predicates/', 'create_protocol_3.html').

	built_in_predicate(abolish_category, 1, '/manuals/refman/predicates/', 'abolish_category_1.html').
	built_in_predicate(abolish_object, 1, '/manuals/refman/predicates/', 'abolish_object_1.html').
	built_in_predicate(abolish_protocol, 1, '/manuals/refman/predicates/', 'abolish_protocol_1.html').

	built_in_predicate(extends_object, 2, '/manuals/refman/predicates/', 'extends_object_2_3.html').
	built_in_predicate(extends_object, 3, '/manuals/refman/predicates/', 'extends_object_2_3.html').
	built_in_predicate(extends_protocol, 2, '/manuals/refman/predicates/', 'extends_protocol_2_3.html').
	built_in_predicate(extends_protocol, 3, '/manuals/refman/predicates/', 'extends_protocol_2_3.html').
	built_in_predicate(extends_category, 2, '/manuals/refman/predicates/', 'extends_category_2_3.html').
	built_in_predicate(extends_category, 3, '/manuals/refman/predicates/', 'extends_category_2_3.html').
	built_in_predicate(implements_protocol, 2, '/manuals/refman/predicates/', 'implements_protocol_2_3.html').
	built_in_predicate(implements_protocol, 3, '/manuals/refman/predicates/', 'implements_protocol_2_3.html').
	built_in_predicate(imports_category, 2, '/manuals/refman/predicates/', 'imports_category_2_3.html').
	built_in_predicate(imports_category, 3, '/manuals/refman/predicates/', 'imports_category_2_3.html').
	built_in_predicate(instantiates_class, 2, '/manuals/refman/predicates/', 'instantiates_class_2_3.html').
	built_in_predicate(instantiates_class, 3, '/manuals/refman/predicates/', 'instantiates_class_2_3.html').
	built_in_predicate(specializes_class, 2, '/manuals/refman/predicates/', 'specializes_class_2_3.html').
	built_in_predicate(specializes_class, 3, '/manuals/refman/predicates/', 'specializes_class_2_3.html').
	built_in_predicate(complements_object, 2, '/manuals/refman/predicates/', 'complements_object_2.html').

	built_in_predicate(abolish_events, 5, '/manuals/refman/predicates/', 'abolish_events_5.html').
	built_in_predicate(current_event, 5, '/manuals/refman/predicates/', 'current_event_5.html').
	built_in_predicate(define_events, 5, '/manuals/refman/predicates/', 'define_events_5.html').

	built_in_predicate(threaded, 1, '/manuals/refman/predicates/', 'threaded_1.html').
	built_in_predicate(threaded_call, 1, '/manuals/refman/predicates/', 'threaded_call1_2.html').
	built_in_predicate(threaded_call, 2, '/manuals/refman/predicates/', 'threaded_call1_2.html').
	built_in_predicate(threaded_once, 1, '/manuals/refman/predicates/', 'threaded_once1_2.html').
	built_in_predicate(threaded_once, 2, '/manuals/refman/predicates/', 'threaded_once1_2.html').
	built_in_predicate(threaded_ignore, 1, '/manuals/refman/predicates/', 'threaded_ignore_1.html').
	built_in_predicate(threaded_exit, 1, '/manuals/refman/predicates/', 'threaded_exit1_2.html').
	built_in_predicate(threaded_exit, 2, '/manuals/refman/predicates/', 'threaded_exit1_2.html').
	built_in_predicate(threaded_peek, 1, '/manuals/refman/predicates/', 'threaded_peek1_2.html').
	built_in_predicate(threaded_peek, 2, '/manuals/refman/predicates/', 'threaded_peek1_2.html').
	built_in_predicate(threaded_wait, 1, '/manuals/refman/predicates/', 'threaded_wait_1.html').
	built_in_predicate(threaded_notify, 1, '/manuals/refman/predicates/', 'threaded_notify_1.html').

	built_in_predicate(logtalk_compile, 1, '/manuals/refman/predicates/', 'logtalk_compile_1.html').
	built_in_predicate(logtalk_compile, 2, '/manuals/refman/predicates/', 'logtalk_compile_2.html').
	built_in_predicate(logtalk_load, 1, '/manuals/refman/predicates/', 'logtalk_load_1.html').
	built_in_predicate(logtalk_load, 2, '/manuals/refman/predicates/', 'logtalk_load_2.html').
	built_in_predicate(logtalk_make, 0, '/manuals/refman/predicates/', 'logtalk_make_0.html').
	built_in_predicate(logtalk_make, 1, '/manuals/refman/predicates/', 'logtalk_make_1.html').
	built_in_predicate(logtalk_library_path, 2, '/manuals/refman/predicates/', 'logtalk_library_path_2.html').
	built_in_predicate(logtalk_load_context, 2, '/manuals/refman/predicates/', 'logtalk_load_context_2.html').

	built_in_predicate(current_logtalk_flag, 2, '/manuals/refman/predicates/', 'current_logtalk_flag_2.html').
	built_in_predicate(set_logtalk_flag, 2, '/manuals/refman/predicates/', 'set_logtalk_flag_2.html').
	built_in_predicate(create_logtalk_flag, 3, '/manuals/refman/predicates/', 'create_logtalk_flag_3.html').

	:- public(built_in_method/4).
	:- mode(built_in_method(?atom, ?integer, -atom, -atom), zero_or_more).
	:- info(built_in_method/4, [
		comment is 'Provides access to the HTML documenting files describing built-in methods.',
		argnames is ['Functor', 'Arity', 'Directory', 'Basename']
	]).

	built_in_method(parameter, 2, '/manuals/refman/methods/', 'parameter_2.html').
	built_in_method(self, 1, '/manuals/refman/methods/', 'self_1.html').
	built_in_method(sender, 1, '/manuals/refman/methods/', 'sender_1.html').
	built_in_method(this, 1, '/manuals/refman/methods/', 'this_1.html').

	built_in_method(current_op, 3, '/manuals/refman/methods/', 'current_op_3.html').
	built_in_method(current_predicate, 1, '/manuals/refman/methods/', 'current_predicate_1.html').
	built_in_method(predicate_property, 2, '/manuals/refman/methods/', 'predicate_property_2.html').

	built_in_method(abolish, 1, '/manuals/refman/methods/', 'abolish_1.html').
	built_in_method(asserta, 1, '/manuals/refman/methods/', 'asserta_1.html').
	built_in_method(assertz, 1, '/manuals/refman/methods/', 'assertz_1.html').
	built_in_method(clause, 2, '/manuals/refman/methods/', 'clause_2.html').
	built_in_method(retract, 1, '/manuals/refman/methods/', 'retract_1.html').
	built_in_method(retractall, 1, '/manuals/refman/methods/', 'retractall_1.html').

	built_in_method(call, N, '/manuals/refman/methods/', 'call_N.html') :-
		between(1, 8, N).
	built_in_method(once, 1, '/manuals/refman/methods/', 'once_1.html').
	built_in_method((\+), 1, '/manuals/refman/methods/', 'not_1.html').

	built_in_method(catch, 3, '/manuals/refman/methods/', 'catch_3.html').
	built_in_method(throw, 1, '/manuals/refman/methods/', 'throw_1.html').

	built_in_method(bagof, 3, '/manuals/refman/methods/', 'bagof_3.html').
	built_in_method(findall, 3, '/manuals/refman/methods/', 'findall_3.html').
	built_in_method(findall, 4, '/manuals/refman/methods/', 'findall_4.html').
	built_in_method(forall, 2, '/manuals/refman/methods/', 'forall_2.html').
	built_in_method(setof, 3, '/manuals/refman/methods/', 'setof_3.html').

	built_in_method(before, 3, '/manuals/refman/methods/', 'before_3.html').
	built_in_method(after, 3, '/manuals/refman/methods/', 'after_3.html').

	built_in_method(forward, 1, '/manuals/refman/methods/', 'forward_1.html').

	built_in_method(phrase, 2, '/manuals/refman/methods/', 'phrase_2.html').
	built_in_method(phrase, 3, '/manuals/refman/methods/', 'phrase_3.html').

	built_in_method(expand_term, 2, '/manuals/refman/methods/', 'expand_term_2.html').
	built_in_method(term_expansion, 2, '/manuals/refman/methods/', 'term_expansion_2.html').
	built_in_method(expand_goal, 2, '/manuals/refman/methods/', 'expand_goal_2.html').
	built_in_method(goal_expansion, 2, '/manuals/refman/methods/', 'goal_expansion_2.html').

	built_in_method(coinductive_success_hook, N, '/manuals/refman/methods/', 'coinductive_success_hook_1_2.html') :-
		between(1, 2, N).

	built_in_method(ask_question, 5, '/manuals/refman/methods/', 'ask_question_5.html').
	built_in_method(message_hook, 4, '/manuals/refman/methods/', 'message_hook_4.html').
	built_in_method(message_prefix_stream, 4, '/manuals/refman/methods/', 'message_prefix_stream_4.html').
	built_in_method(print_message, 3, '/manuals/refman/methods/', 'print_message_3.html').
	built_in_method(print_message_tokens, 3, '/manuals/refman/methods/', 'print_message_tokens_3.html').
	built_in_method(print_message_token, 4, '/manuals/refman/methods/', 'print_message_token_4.html').
	built_in_method(question_hook, 6, '/manuals/refman/methods/', 'question_hook_6.html').
	built_in_method(question_prompt_stream, 4, '/manuals/refman/methods/', 'question_prompt_stream_4.html').

	:- public(control/4).
	:- mode(control(?atom, ?integer, -atom, -atom), zero_or_more).
	:- info(control/4, [
		comment is 'Provides access to the HTML documenting files describing built-in control constructs.',
		argnames is ['Functor', 'Arity', 'Directory', 'Basename']
	]).

	control((::), 2, '/manuals/refman/control/', 'send_to_object_2.html').
	control('[]', 1, '/manuals/refman/control/', 'delegate_message_1.html').
	control((::), 1, '/manuals/refman/control/', 'send_to_self_1.html').
	control((^^), 1, '/manuals/refman/control/', 'call_super_1.html').
	control(({}), 1, '/manuals/refman/control/', 'external_call_1.html').
	control((<<), 2, '/manuals/refman/control/', 'context_switch_2.html').

	:- public(built_in_non_terminal/4).
	:- mode(built_in_non_terminal(?atom, ?integer, -atom, -atom), zero_or_more).
	:- info(built_in_non_terminal/4, [
		comment is 'Provides access to the HTML documenting files describing built-in DCG non-terminals.',
		argnames is ['Functor', 'Arity', 'Directory', 'Basename']
	]).

	built_in_non_terminal(call, N, '/manuals/refman/methods/', 'call_1.html') :-
		between(1, 6, N).
	built_in_non_terminal(eos, 0, '/manuals/refman/methods/', 'eos_0.html').
	built_in_non_terminal(phrase, 1, '/manuals/refman/methods/', 'phrase_1.html').

	built_in_non_terminal(message_tokens, 2, '/manuals/refman/methods/', 'message_tokens_2.html').

	:- public(library/0).
	:- mode(library, one).
	:- info(library/0, [
		comment is 'Provides help on the standard Logtalk library.'
	]).

	library :-
		open('/docs/', 'library.html').

	:- public(library/1).
	:- mode(library(+entity_identifier), zero_or_one).
	:- info(library/1, [
		comment is 'Provides help on the standard Logtalk library.',
		argnames is ['Entity']
	]).

	library(Entity) :-
		nonvar(Entity),
		callable(Entity),
		functor(Entity, Functor, Arity),
		atom_concat(Functor, '_', File0),
		number_chars(Arity, ArityChars),
		atom_chars(ArityAtom, ArityChars),
		atom_concat(File0, ArityAtom, File1),
		atom_concat(File1, '.html', File),
		open('/docs/', File).

	:- public(manuals/0).
	:- mode(manuals, one).
	:- info(manuals/0, [
		comment is 'Provides access to the Logtalk User and Reference manuals.'
	]).

	manuals :-
		open('/manuals/', 'index.html').

	open(Path, File) :-
		(	\+ os::environment_variable('LOGTALKHOME', _) ->
			write('The environment variable LOGTALKHOME must be defined and pointing to your'), nl,
			write('Logtalk installation folder in order for on-line help to be available.'), nl, nl
		;	os::environment_variable('COMSPEC', _) ->
			% assume we're running on Windows
			convert_file_path(Path, ConvertedPath),
			atom_concat('%LOGTALKHOME%', ConvertedPath, FullPath),
			atom_concat('cmd /c start /D"', FullPath, Command0),
			atom_concat(Command0, '" ', Command1),
			atom_concat(Command1, File, Command),
			os::shell(Command)
		;	os::shell('uname -s | grep Darwin 1> /dev/null') ->
			% assume we're running on MacOS X
			atom_concat('open "$LOGTALKHOME', Path, Command0),
			atom_concat(Command0, File, Command1),
			atom_concat(Command1, '" > /dev/null 2>&1', Command),
			os::shell(Command)
		;	os::shell('uname -s | grep Linux 1> /dev/null') ->
			% assume we're running on Linux
			atom_concat('xdg-open "$LOGTALKHOME', Path, Command0),
			atom_concat(Command0, File, Command1),
			atom_concat(Command1, '" > /dev/null 2>&1', Command),
			os::shell(Command)
		;	% we couldn't find which operating-system are we running on
			write('Unsupported operating-system.'), nl
		).

	convert_file_path(Path, ConvertedPath) :-
		% we cannot use atom_chars/2 as Quintus definition returns codes
		atom_codes(Path, PathCodes),
		char_code('/', SlashCode),
		char_code('\\', BackslashCode),
		reverse_slashes(PathCodes, SlashCode, BackslashCode, ConvertedPathCodes),
		atom_codes(ConvertedPath, ConvertedPathCodes).

	reverse_slashes([], _, _, []).
	reverse_slashes([Code| Codes], SlashCode, BackslashCode, ConvertedCodes) :-
		(	Code =:= SlashCode ->
			ConvertedCodes = [BackslashCode| ConvertedCodesTail]
		;	ConvertedCodes = [Code| ConvertedCodesTail]
		),
		reverse_slashes(Codes, SlashCode, BackslashCode, ConvertedCodesTail).

	% we use a simplified version of the integer::between/3
	% predicate in order to minimize this tool dependencies
	between(Lower, _, Lower).
	between(Lower, Upper, Integer) :-
		Lower < Upper,
		Next is Lower + 1,
		between(Next, Upper, Integer).

:- end_object.
