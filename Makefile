# store output so is only executed once
ERL_LIBS=$(shell erl -eval 'io:format("~s~n", [code:lib_dir()])' -s init stop -noshell)
# get application vsn from app file
VSN=$(shell erl -pa ebin/ -eval 'application:load(erlaws), {ok, Vsn} = application:get_key(erlaws, vsn), io:format("~s~n", [Vsn])' -s init stop -noshell)

all:
	@erl -make

clean:
	@rm -rf erl_crash.dump ebin/*.beam

plt:
	@dialyzer --build_plt --output_plt .plt -q -r . -I include/

check: all
	@dialyzer --check_plt --plt .plt -q -r . -I include/

FORCE:
