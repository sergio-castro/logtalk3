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
		version is 0.3,
		author is 'Paulo Moura',
		date is 2015/09/29,
		comment is 'Unit tests for the "cc" example.'
	]).

	test(cc_01) :-
		os::environment_variable('LOGTALKUSER', _).

	test(cc_02) :-
		os::expand_path('$LOGTALKUSER/examples/cc/', _).

	test(cc_03) :-
		os::working_directory(Current),
		os::expand_path(Current, Path),
		os::change_directory('/'),
		os::change_directory(Path).

	test(cc_04) :-
		os::expand_path('$LOGTALKUSER/examples/cc/', Path),
		os::change_directory(Path),
		os::directory_exists(tests),
		os::file_exists('tests/bar.txt').

	test(cc_05) :-
		os::expand_path('$LOGTALKUSER/examples/cc/', Path),
		os::change_directory(Path),
		os::change_directory(tests),
		os::file_exists('bar.txt'),
		os::file_size('bar.txt', 0).

	test(cc_06) :-
		os::expand_path('$LOGTALKUSER/examples/cc/', Path),
		os::change_directory(Path),
		os::rename_file('tests/bar.txt', 'tests/foo.txt'),
		os::file_exists('tests/foo.txt'),
		os::rename_file('tests/foo.txt', 'tests/bar.txt').

	test(cc_07) :-
		os::expand_path('$LOGTALKUSER/examples/cc/', Path),
		os::change_directory(Path),
		os::make_directory(bar),
		os::delete_directory(bar).

	test(cc_08) :-
		os::time_stamp(Time1),
		os::time_stamp(Time2),
		Time1 @=< Time2.

	test(cc_09) :-
		os::pid(PID),
		integer(PID).

	test(cc_10) :-
		os::decompose_file_name('/home/foo/bar.lgt', Directory, Name, Extension),
		Directory == '/home/foo/', Name == bar, Extension == '.lgt'.

	test(cc_11) :-
		os::decompose_file_name('/home/foo/bar', Directory, Name, Extension),
		Directory == '/home/foo/', Name == bar, Extension == ''.

	test(cc_12) :-
		os::decompose_file_name('/home/foo/', Directory, Name, Extension),
		Directory == '/home/foo/', Name == '', Extension == ''.

	test(cc_13) :-
		os::decompose_file_name('foo.lgt', Directory, Name, Extension),
		Directory == './', Name == 'foo', Extension == '.lgt'.

	test(cc_14) :-
		os::decompose_file_name('foo', Directory, Name, Extension),
		Directory == './', Name == 'foo', Extension == ''.

	test(cc_15) :-
		os::decompose_file_name('/', Directory, Name, Extension),
		Directory == ('/'), Name == '', Extension == ''.

:- end_object.
