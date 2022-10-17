package stx.log;

import stx.log.test.*;

using stx.log.Test;
using stx.Test;

import stx.log.filter.term.Level in LevelFilter;

class Test{
	static public function main(){
		trace("test");
		#if !macro
			__.test().run([
				//new ConsoleTest(),
				new GlobTest()
			],[GlobTest]);
		#end
	}
}
class GlobTest extends TestCase{
	public function test(){
		var log 		= __.log().tag("some/deep/package");
		var logger 	= Logger.ZERO;
		 		logger.includes.push("some/deep/*");
				log.trace("test");
	}
}
#if nodejs
@:rtti class ColumnTest extends TestCase{
	public function test(){
		// stx.log.Signal.ZERO.attach(
			
		// );
		try{
			var logger = new stx.log.logger.Linux(); 
			var string = "sodmfdbt suyfgusbfd u7nsfoiubhoub sdfi sd";
			var entry  = Entry.fromString(string);
			var value  = Value.make(entry);
			logger.apply(value)(Logger.spur);
		}catch(e:Dynamic){
			trace(e);
			throw(e);
		} 
	}
}
#end
@:rtti class StartTest extends TestCase{
	public function test_basic_effect(){
		__.log().global.reset();
		__.log().debug("test");
	}
	public function _test(){
		var track = "stx.log".split(".");
		var pred 	= Log._.Logic().pack(track);
		var ok 		= pred.opine(Value.make(null,__.here()));
		trace(ok);
	}
	public function test_default(){
		trace('test_default');
		var facade 				= __.log().global;
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
				facade.includes.push('test');
		__.log().tag("test").info("hello");
	}
	public function test_custom_log(){
		var facade = __.log().global;
				facade.reset();
				facade.includes.push("testy");
		__.clog().debug("Test");
	}
}
@:forward @:callable abstract TestyLog(LogDef) to Log{
	static public function clog(wildcard:Wildcard):Log{
		return Log.lift(new TestyLog().prj());
	}
	public function new(){
		this = __.log().tag("testy").prj();
	}
	public function prj():LogDef{
		return this;
	}
}