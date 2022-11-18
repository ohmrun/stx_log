package stx.log.output.term;

#if (sys || nodejs)
	using stx.System;
#end

class Full implements OutputApi extends Debugging{
  private function render( v : Dynamic, infos : LogPosition ) : Void {
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
				untyped new Flash().render(v,infos.pos);
			#end
		#elseif neko
			note('neko');
			untyped {
				$print(v);
				$print("\n");
			}
		#elseif js
			note('js');
			untyped new Js().render(v,infos);
		#elseif php
			note('php');
				untyped _call__('_hx_trace', v, null);
		#elseif cpp
			note('cpp');
				untyped __trace(v,infos.pos);
		#elseif (cs || java)
			var str:String  = v;
			#if cs
				note('cs');
				cs.system.Console.WriteLine(str);
			#elseif java
			note('java');
				Sys.print("java.lang.System.out.println(str)");
			#end
		#elseif (python)
			note('python');
			var str:String = v;
			python.Lib.println(str);
		#else
			note('default');
			__.sys().println(Std.string(v));
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