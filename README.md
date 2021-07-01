# stx_log
## 01/07/2021

Leave your log calls in your source code without effecting downstream source. Uses glob matching for filters


## Install

``` bash
haxelib git stx_log https://github.com/ohmrun/stx_log.git
```
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

`stx.log.Facade` is a singleton used for easy setup and points to `stx.log.logger.Unit`

The Logger `stx.log.logger.Default` is attached by default, but is removed automatically when you add your own via: `stx.log.Signal.attach(logger:LoggerApi<Dynamic>)`

```haxe
  var logger = new MyEmptyLogger();//A logger which does nothing.
  __.log()("test")//printed to screen
  stx.log.Signal.attach(
    logger
  );//automatically disuse default

  __.log()("test")//nothing, default unused.
  stx.log.Facade.reinstate = true;
  __.log()("test")//we're back using `stx.log.logger.Default`
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

@:forward @:callable abstract Log(stx.Log){
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
The value of Logic is a `stx.log.Filter` which keeps a record of it's decision. override `applyI` for your own use.

`stx.log.Logic` supports the `&&` and `||` operators.

The log value type is at `stx.log.Value`, it's immutable, so keep that in mind, and contains a typed value `T` and `source` which is a wrapper over `haxe.PosInfos` called `stx.log.LogPosition`


## Logger Type

The Logger `apply` function takes a `Value` and produces a `stx.fp.Continuation<Res<String,LogFailure>>`. `apply` hardwires the effect and `do_apply` does the filter logic in the typical case, although you can go from scratch with `LoggerApi` should you need it.

```haxe
class TestLogger<T> implement Logger<T>{
 override public function do_apply(value:Value<T>):Continuation<Res<String,LogFailure>,Value<T>>{
  super.do_apply(value).mod(// allows you to edit the result
    (res:Res<String,LogFailure>) -> {
      return res;
    }
  ).map(
    (value:Value<T>) -> {//allows to edit the input
      return stamp.tag("test");
    }
  )
 }
}
```

`LogPosition` is backward compatible with `haxe.PosInfos` but keeps track of a value in `customParams` called `stamp:stx.log.Stamp`

```haxe
//Stamp variables
public var id(default,null)         : String;//uuid
public var level                    : Level;//usually passed by the statics on `stx.Log`, defaults to CRAZY
public var timestamp                : Date;//Date.now()
public var tags(default,null)       : Array<String>;//[]
public var hidden                   : Bool;//false, not used just yet, but could be a clearer control flow for 1.0.
```

You can write whatever filters you like to make use of that data.

`stx.log.PosPredicate` contains logic which allows you to write filters using the `stx.Assert` library for your predicate grammar.
See `stx.log.Logic` for examples of this.

### Formatting

```haxe
  INCLUDE_LEVEL;
  INCLUDE_TIMESTAMP;
  INCLUDE_TAGS;
  INCLUDE_LOCATION;
  INCLUDE_NEWLINE_FOR_DETAIL;
  INCLUDE_DETAIL;
```

To edit the format on the Facade, use `stx.log.Facade.unit().format =  [];`

The order is currently fixed `[level, timestamp, tags, path, newline, detail]`.

### TODO
1 FileSystem Logger.  
2 Sane detail printing