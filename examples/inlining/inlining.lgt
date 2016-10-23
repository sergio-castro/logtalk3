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


:- object(inlining).

	:- info([
		version is 1.0,
		author is 'Paulo Moura',
		date is 2016/10/21,
		comment is 'Simple object for illustrating and testing inlining of predicate definitions.'
	]).

	:- public([
		between/3, map/2
	]).

	% the following clause defining the local predicate between/3
	% simply calls the same predicate in "user" as Logtalk ensures
	% that is available there as it is a de facto standard predicate;
	% these linking clauses are common when writing portable code and
	% when abstracting foreign library resources

	% the compiler generates a predicate definition table entry that
	% directly calls user::between/2, thus inlining the predicate
	% definition, and discars the clause (assuming compilation with
	% the "optimize" flag turned on)

	between(Lower, Upper, Value) :-
		user::between(Lower, Upper, Value).

	% another common case occurs with meta-predicate definitions like
	% map/N that take a list on its second argument but uses a linking
	% clause to move the list to the first argument to better exploit
	% indexing

	map(Closure, List) :-
		map_(List, Closure).

	map_(_, _).	

:- end_object.