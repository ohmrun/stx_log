package stx;

using Lambda;
import Type;


using stx.log.Position;

import haxe.PosInfos;
import stx.data.Log in TLog;
import stx.log.Level;
import stx.log.data.Stamp;

@:callable abstract Log(TLog) to TLog from TLog{
  public function new(?v){
    if(v==null){
      v = FullHaxeLog.trace;
    }
    this = v;
  }
  /**
    For using in each functions.
  */
  public function printer(?pos:PosInfos):Dynamic->Void{
    return function(x:Dynamic){
      this(x,pos);
    }
  }
  function logWithLevelAndPosition(v:Dynamic,level:Level,pos:Position){
    pos.meta.setStamp(new Stamp(level));
    this(v,pos);
  }
  /**
    Logs with Level.TRACE
  **/
  public function trace(v:Dynamic,?pos:PosInfos){
    logWithLevelAndPosition(v,TRACE,pos);
  }
  /**
    Logs with Level.DEBUG
  **/
  public function debug(v:Dynamic,?pos:PosInfos){
    logWithLevelAndPosition(v,DEBUG,pos);
  }
  /**
    Logs with LogLevel.INFO
  **/
  public function info(v:Dynamic,?pos:PosInfos){
    logWithLevelAndPosition(v,INFO,pos);
  }

  /**
    Logs with LogLevel.WARN
  **/
  public function warn(v:Dynamic,?pos:PosInfos){
    logWithLevelAndPosition(v,WARN,pos);
  }

  /**
    Logs with LogLevel.ERROR
  **/
  public function error(v:Dynamic,?pos:PosInfos){
    logWithLevelAndPosition(v,ERROR,pos);
  }

  /**
    Logs with LogLevel.FATAL
  **/
  public function fatal(v:Dynamic,?pos:PosInfos){
    logWithLevelAndPosition(v,FATAL,pos);
  }

  public function method(?pos:PosInfos){
    this(pos.methodName,pos);
  }
  /**
    Logs with LogLevel[LEVEL]
  **/
  public function levelled(level){
    return Logs.levelled(this,level);
  }
  /**
    Adds customParam [obj] to the resulting log call.
  
  public function with(obj:Dynamic):Log{
    return function(x:Dynamic,?pos:PosInfos){
      var position : Position = pos;
      return this(x,position.withCustomParam(obj));
    }
  }
  **/
  /**
    Adds a tag to the customParams[tags] of the resulting log call.
  **/
  public function tag(string:String):Log{
    return function(x:Dynamic,?pos:haxe.PosInfos){
      Position.pure(pos).meta.tags.push(string);

      return this(x,pos);
    }
  }
  /**
    See tag
  */
  public function tags(arr:Array<String>):Log{
    return arr.fold(
      function(next,memo){
        var memo0 : Log   = memo;
        var memo1 : Log   = memo0.tag(next);
        var memo1 : TLog  = memo1;
        return memo1;
      },this
    );
  }
  /**
    mutate the object before logging
  */
  public function use(fn:Dynamic->Dynamic):Log{
    return function(x:Dynamic,?pos:PosInfos){
      this(fn(x),pos);
    }
  }
  /**
    Filter based on the value of the printable object.
  */
  public function containing(p:Predicate<Dynamic>):Log{
    return Logs.containing(this,p);
  }
  /**
    @param selector
    @returns Log which filters on predicate.
  **/
  public function positioned(p:Predicate<PosInfos>):Log{
    return Logs.positioned(this,p);
  }

  /**

  */
  public function close():Log{
    return Logs.positioned(this,stx.Compare.never());
  }
}

/*
  Modifications *not* to show the customParams in the printout.
*/

/*
 * Copyright (C)2005-2012 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

private class FullHaxeLog{
  public static dynamic function trace( v : Dynamic, ?infos : PosInfos ) : Void {
    var meta =
      (switch(
        Transducer.Reducers.search(
          function(x){
            return switch(Type.typeof(x)){
              case TClass(Stamp) : true;
              default           : false;
            }
          }
        ).into(infos.customParams == null ? [] : infos.customParams,null)
      ).unbox(){
        case Some(v) : v;
        case None: new Stamp(TRACE);
      });


    var data = (switch Type.typeof(v) {
      case TClass(String) : cast v;
      default             : '$v';
    });

    HaxeLog.trace('${meta.toLogString(infos)} $data');
  }
}
/**
	Log primarily provides the trace() method, which is invoked upon a call to
	trace() in haxe code.
**/
private class HaxeLog {

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
	public static dynamic function trace( v : Dynamic, ?infos : PosInfos ) : Void {
		#if flash
			#if (fdb || native_trace)
				//var pstr = infos == null ? "(null)" : infos.fileName + ":" + infos.lineNumber;
				var str = FlashLog.__string_rec(v, "");
				//if( infos != null && infos.customParams != null ) for( v in infos.customParams ) str += "," + flash.Boot.__string_rec(v, "");
				untyped __global__["trace"](pstr+": "+str);
			#else
				untyped FlashLog.__trace(v,infos);
			#end
		#elseif neko
			untyped {
				$print(v);
				$print("\n");
			}
		#elseif js
			untyped JsLog.__trace(v,infos);
		#elseif php
				untyped __call__('_hx_trace', v, null);
		#elseif cpp
				untyped __trace(v,infos);
		#elseif (cs || java)
			var str:String  = v;
			#if cs
			cs.system.Console.WriteLine(str);
			#elseif java
			untyped __java__("java.lang.System.out.println(str)");
			#end
		#elseif (python)
			var str:String = v;
			python.Lib.println(str);
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
#if flash
class FlashLog{
  public static function __trace( v : Dynamic, pos : haxe.PosInfos ) {
		var tf = flash.Boot.getTrace();
		var pstr = if( pos == null ) "(null)" else pos.fileName+":"+pos.lineNumber;
		if( lines == null ) lines = [];
		var str = pstr +": "+ flash.Boot.__string_rec(v, "");
		lines = lines.concat(str.split("\n"));
		tf.text = lines.join("\n");
		var stage = flash.Lib.current.stage;
		if( stage == null )
			return;
		while( lines.length > 1 && tf.height > stage.stageHeight ) {
			lines.shift();
			tf.text = lines.join("\n");
		}
	}
}
#elseif js
class JsLog{
  private static function __trace(v,i : haxe.PosInfos) {
		untyped {
			var msg = if( i != null ) i.fileName+":"+i.lineNumber+": " else "";
			#if jsfl
			msg += js.Boot.__string_rec(v,"");
			fl.trace(msg);
			#else
			msg += js.Boot.__string_rec(v, "");
			var d;
			if( __js__("typeof")(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null )
				d.innerHTML += __unhtml(msg)+"<br/>";
			else if( __js__("typeof console") != "undefined" && __js__("console").log != null )
				__js__("console").log(msg);
			#end
		}
	}
}
#end
