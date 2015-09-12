%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  This file is part of Logtalk <http://logtalk.org/>
%  Copyright 1998-2015 Paulo Moura <pmoura@logtalk.org>
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


:- object(tests,
	extends(lgtunit)).

	:- info([
		version is 1.01,
		author is 'Paulo Moura',
		date is 2015/02/16,
		comment is 'Unit tests for the "logtalk" built-in object.'
	]).

	test(logtalk_1) :-
		current_object(logtalk),
		object_property(logtalk, built_in).

	test(logtalk_2) :-
		logtalk::entity_prefix(foo, Prefix),
		logtalk::entity_prefix(Entity, Prefix),
		Entity == foo.

	test(logtalk_3) :-
		logtalk::entity_prefix(foo(_), Prefix),
		logtalk::entity_prefix(Entity, Prefix),
		nonvar(Entity),
		Entity = foo(_).

	test(logtalk_4) :-
		logtalk::compile_predicate_heads(bar(_), logtalk, Compiled, _),
		logtalk::decompile_predicate_heads(Compiled, Entity, Type, Decompiled),
		Entity == logtalk,
		Type == object,
		nonvar(Decompiled),
		Decompiled = bar(_).

	test(logtalk_5) :-
		logtalk::compile_predicate_indicators(bar/1, logtalk, Compiled),
		logtalk::decompile_predicate_indicators(Compiled, Entity, Type, Decompiled),
		Entity == logtalk,
		Type == object,
		Decompiled == bar/1.

	test(logtalk_6) :-
		logtalk::loaded_file_property(SourceFile, basename('tests.lgt')), !,
		logtalk::loaded_file_property(SourceFile, directory(Directory)), atom(Directory),
		logtalk::loaded_file_property(SourceFile, mode(Mode)), atom(Mode), mode(Mode),
		logtalk::loaded_file_property(SourceFile, flags(Flags)), ground(Flags), flags(Flags),
		logtalk::loaded_file_property(SourceFile, text_properties(Properties)), ground(Properties), text_properties(Properties),
		logtalk::loaded_file_property(SourceFile, target(ObjectFile)), atom(ObjectFile),
		logtalk::loaded_file_property(SourceFile, modified(TimeStamp)),	ground(TimeStamp),
		logtalk::loaded_file_property(SourceFile, parent(ParentFile)), atom_concat(_, 'tester.lgt', ParentFile),
		(	logtalk::loaded_file_property(SourceFile, library(Library)) ->
			Library == startup
		;	true
		),
		logtalk::loaded_file_property(SourceFile, object(Object)), Object == tests.

	mode(debug).
	mode(normal).
	mode(optimal).

	flags([]).
	flags([Flag| Flags]) :-
		flag(Flag),
		flags(Flags).

	flag(Flag) :-
		functor(Flag, Functor, 1),
		atom(Functor).

	text_properties([]).
	text_properties([Property| Properties]) :-
		text_property(Property),
		text_properties(Properties).

	text_property(bom(BOM)) :-
		(BOM == true -> true; BOM == false).
	text_property(encoding(Encoding)) :-
		atom(Encoding).

:- end_object.
