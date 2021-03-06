%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  This file is part of Logtalk <https://logtalk.org/>  
%  Copyright 1998-2019 Paulo Moura <pmoura@logtalk.org>
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
		version is 1.0,
		author is 'Paulo Moura',
		date is 2012/11/19,
		comment is 'Unit tests for the threaded_call/1-2 built-in predicate.'
	]).

	:- threaded.

	throws(threaded_call_1_1, error(instantiation_error, logtalk(threaded_call(_), _))) :-
		{threaded_call(_)}.

	throws(threaded_call_1_2, error(type_error(callable, 1), logtalk(threaded_call(_), _))) :-
		{threaded_call(1)}.

	throws(threaded_call_2_1, error(instantiation_error, logtalk(threaded_call(_,_), _))) :-
		{threaded_call(_, _)}.

	throws(threaded_call_2_2, error(type_error(callable, 1), logtalk(threaded_call(_,_), _))) :-
		{threaded_call(1, _)}.

	throws(threaded_call_2_3, error(type_error(variable, tag), logtalk(threaded_call(_,_), _))) :-
		{threaded_call(true, tag)}.

:- end_object.
