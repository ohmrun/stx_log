# stx_log

Logging framework (beta-ish)


## Usage

```haxe
using stx.Nano;//Wildcard
using stx.Log;

class Main{
 static function main(){
  __.log()("test");
  __.log().trace("traced");
 }
}
```

The `Log` is a function that sends a signal, and a `Logger` is an interface that exposes a handler for `stx.log.Signal`.

The default situation works as follows.

`stx.log.Facade` is a singleton used for easy setup and points to `stx.log.logger.Default`

The Logger `stx.log.logger.Default` is attached by default, but is removed automatically when you add your own via: `stx.log.Signal.attach(logger:LoggerApi<Dynamic>)`

```haxe
  __.log()("test")//printed to screen
  stx.log.Signal.handle(
    (x)  -> {}
  );//automatically disuse default

  __.log()("test")//nothing, default unused.
  stx.log.Facade.reinstate = true;
  __.log()("test")//we're back.
```
The Facade **only shows values which are not tagged** unless you add to the array `Facade.includes` or set `Facade.verbose` to true.

```haxe
  var facade = stx.log.Facade;
  __.log()("test")//ok
  __.log().tag("tagged")("test")//not shown 
      facade.includes.push("tagged");
  __.log().tag("tagged")("test")//ok
```

There is a default `stx.log.Level` filter.
```haxe
  stx.log.Facade.level = INFO;
  __.log()("test")//Level CRAZY, nope
  __.log().info("test")// Ok
```
here is an example override to tag your Log values.

```haxe
package my.pack;

using stx.Nano;
using my.pack.Log;//needs to go after `using stx.Nano` for this local `log` function to be used.

abstract Log(stx.Log){
 static public function log(wildcard:Wildcard){
  return new my.pack.Log();
 }
 public function new(){
  this = __log().tag('my.pack');
 }
}

class Main{
 static public function main(){
  var facade = stx.log.Facade.unit();
      facade.includes.push("my.pack")//tagged log values are hidden by default
  __.log()("test")//value.source.stamp.tags == ['my.pack']
 }
}
```
You can use this to make your logs unobtrusive to other projects and development whilst still having full data available at `stx.log.Signal`


There is `stx.log.Logic` available to do complex white and blacklisting
The value of Logic is a `stx.log.Filter` which keeps a record of it's decision. override `opine` for your own use.

`stx.log.Logic` supports the `&&` and `||` operators.

The log value type is at `stx.log.Value`, it's immutable, so keep that in mind, and contains a typed value `T` and `source` which is a wrapper over `haxe.PosInfos` called `stx.log.LogPosition`

```haxe
class TestLogger<T> extends Logger<T>{
 override public function react(value:Value<T>){
  super.react(
   value.restamp(
    stamp -> stamp.tag("test")
   )
  );
 }
}
```

`LogPosition` is backward compatible with `haxe.PosInfos` but keeps track of a value in `customParams` called `stamp:stx.log.Stamp`

```haxe
\\Stamp vars
public var id(default,null)         : String;//random asigned
public var level                    : Level;//usually passed by the statics on `stx.Log`
public var timestamp                : Date;//Date.now()
public var tags(default,null)       : Array<String>;//[]
public var hidden                   : Bool;//false, not used just yet, but could be a clearer control flow for 1.0.
```

You can write whatever filters you like to make use of that data.

`stx.log.PosPredicate` contains logic which allows you to write filters using the `stx.Assert` library for your predicate grammar.
See `stx.log.Logic` for examples of this.


To implement your own Logger
```haxe
class MyLogger extends Logger{
 public function new(){
   super(stx.Log.Logic().always());
 }
 override private function opine(value:Value<T>):Bool{
  var my_logic = true;
   return my_logic && super.opine(value);
 }
 override private function render(value:Dynamic,?pos:Pos):Void{
   super.render(value,pos);//or to wherever
 }
}
class Main{
 static public function main(){
  stx.log.Signal.attach(new MyLogger());//removes Default loggerr, uses this one.
 }
}
```

### TODO
1 FileSystem Logger.  
2 Grammar for Formatting. 