class_name ConsoleCommand extends Resource

var name: String
var description: String
var args_schema: Array   # [{name="item", type="string"}, ...]

var execute_callable: Callable

func run(args: Array):
	execute_callable.call(args)
