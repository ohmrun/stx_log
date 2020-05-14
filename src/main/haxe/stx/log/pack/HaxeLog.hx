package stx.log.pack;


/**
	Log primarily provides the trace() method, which is invoked upon a call to
	trace() in haxe code.
**/
class HaxeLog {

	/**
		Outputs `v` in a platform-dependent way.

		The second parameter `infos` is injected by the compiler and contains
		information about the position where the trace() call was made.

		This method can be rebound to a custom function:
			var oldTrace = haxe.Log.trace; // store old function
			haxe.Log.trace = function(v,infos) { // handle trace }
			...
			haxe.Log.trace = oldTrace;

		If it is bound to null, subsequent calls to trace() will cause an
		exception.
	**/
	static function note(str){
		#if stx_log_config_show
      trace(str);
    #end
	}
	public static dynamic function trace( v : Dynamic, ?infos : PosInfos ) : Void {
		note('haxelog $infos');
		#if flash
			note('flash');
			#if (fdb || native_trace)
			note('fdb || native_trace ');
				//var pstr = infos == null ? "(null)" : infos.fileName + ":" + infos.lineNumber;
				var str = FlashLog.__string_rec(v, "");
				//if( infos != null && infos.customParams != null ) for( v in infos.customParams ) str += "," + flash.Boot.__string_rec(v, "");
				untyped __global__["trace"](pstr+": "+str);
			#else
				untyped FlashLog.__trace(v,infos);
			#end
		#elseif neko
			note('neko');
			untyped {
				$print(v);
				$print("\n");
			}
		#elseif js
			note('js');
			untyped JsLog.__trace(v,infos);
		#elseif php
			note('php');
				untyped _call__('_hx_trace', v, null);
		#elseif cpp
			note('cpp');
				untyped __trace(v,infos);
		#elseif (cs || java)
			var str:String  = v;
			#if cs
				note('cs');
				cs.system.Console.WriteLine(str);
			#elseif java
				note('java');
				untyped __java__("java.lang.System.out.println(str)");
			#end
		#elseif (python)
			note('python');
			var str:String = v;
			python.Lib.println(str);
		#else
			note('default');
			Sys.println(Std.string(v));
		#end
	}

	#if (flash || js)
	/**
		Clears the trace output.
	**/
	public static dynamic function clear() : Void {
		#if flash
		untyped flash.Boot.__clear_trace();
		#elseif js
		untyped js.Boot.__clear_trace();
		#end
	}
	#end

	#if flash
	/**
		Sets the color of the trace output to `rgb`.
	**/
	public static dynamic function setColor( rgb : Int ) {
		untyped flash.Boot.__set_trace_color(rgb);
	}
	#end

}