package stx.log;

using stx.log.Test;
using stx.fs.Path;
import haxe.unit.TestCase;

import stx.log.filter.term.Level in LevelFilter;

class Test{
	static public function main(){
		__.test([
			new StartTest()
		]);
	}
}
class StartTest extends TestCase{
	public function _test(){
		var track = "stx.log".split(".");
		var pred 	= Log._.Logic().pack(track);
		var ok 		= pred.opine(Value.make(null,__.here()));
		trace(ok);
	}
	public function test_default(){
		var facade 				= Log._.Facade();
		var track 				= "stx.log".split(".");
		var logic  				= Log._.Logic();

		var pred 					= logic.pack(track);
				facade.logic 	= pred;

		var tag 					= logic.tag("tagged");
				facade.logic 	= pred && tag;

				facade.level	= INFO;
				facade.includes.push("tagged");

		__.log().trace("hello");
		__.log().tag("tagged").debug("heroo");
		__.log().debug("heroo");
		__.log().tag("tagged").info("ROO");


				facade.logic 	= logic.always();
				facade.includes.clear();

		__.log().info("hello");
		__.log().tag("test").info("hello");
				facade.includes.push('tes');
		__.log().tag("test").info("hello");
	}
	public function test_custom_log(){
		var facade = stx.log.Facade.unit();
				facade.reset();
				facade.includes.push("testy");
		__.clog()("Test");
	}
}
@:callable abstract TestyLog(Log){
	static public function clog(wildcard:Wildcard){
		return new TestyLog();
	}
	public function new(){
		this = __.log().tag("testy");
	}
}