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
  __.log().trace("traced");

  //logic constructor
  final lx = __.log().logic();

  //configure global/default logger;
  __.logger().global().configure(
    log -> log.with_logic(
      l -> l.or(lx.Tag("**/*"))//includes with glob format
    )
  );
 }
}
```

The global logger is swappable like so:
```haxe
  __.logger().global().configure((x:LoggerApi<Dynamic>) -> @:note("whatever thing that implements LoggerApi<Dynamic> can be returned here") x);
```


```haxe
  var logger = new MyEmptyLogger();//A logger which does nothing.
  __.log()("test")//printed to screen
  __.logger().attach(logger);//automatically disuse default

  __.log()("test")//nothing, default unused.
  __.logger().global().reinstate();
  __.log()("test")//we're back using `stx.log.logger.Default`
```
The Global **only shows values which are not tagged** unless you tag your Log and add to the array `includes` or set `verbose` to true.

```haxe
  final lc = __.log().logic();
  __.log()("test")//ok
  __.log().tag("tagged")("test")//not shown 
      __.logger().global().configure(
        log -> log.with_logic(l -> l.or(lc.Tag("tagged")))
      )
  __.log().tag("tagged")("test")//ok
```

There is a default `stx.log.Level` filter.
```haxe
  __.log().global.level = INFO;
  __.log()("test")//Level CRAZY, nope
  __.log().info("test")// Ok
```
here is an example override to tag your Log values.

```haxe
package my.pack;

using stx.Nano;
using my.pack.Logging;//needs to go after `using stx.Nano` for this local `log` function to be used.

using stx.Nano;
using stx.Log;
using stx.Pkg;

class Logging{
  static public function log(wildcard:Wildcard){
    return stx.Log.pkg(__.pkg());//Log tagged `my/pack`
  }
}

class Main{
 static public function main(){
  final lX = __.log().logic();
  __.logger().global().configure(
    l -> l.or(lX.Tag("my/pack"))
  )
  __.log().debug("test")//value.source.stamp.tags == ['my.pack']
 }
}
```
You can use this to make your logs unobtrusive to other projects and development whilst still having full data available at `stx.log.Signal`


There is `stx.log.Logic` available to do complex including and excluding
The value of Logic is a `stx.log.Filter` which keeps a record of it's decision. override `applyI` for your own use.

`stx.log.Logic` supports the `&&` and `||` operators.

The log value type is at `stx.log.Value`, it's immutable, so keep that in mind, and contains a typed value `T` and `source` which is a wrapper over `haxe.PosInfos` called `stx.log.LogPosition`


## Logger Type

The Logger `apply` function takes a `Value` and produces a `stx.fp.Continuation<Upshot<String,LogFailure>>`. `apply` hardwires the effect and `do_apply` does the filter logic in the typical case, although you can go from scratch with `LoggerApi` should you need it.

```haxe
class TestLogger<T> implement Logger<T>{
 override public function do_apply(value:Value<T>):Continuation<Upshot<String,LogFailure>,Value<T>>{
  super.do_apply(value).mod(// allows you to edit the result
    (res:Upshot<String,LogFailure>) -> {
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

`LogPosition` Does not contain a pos in [Initialisation Macros](https://haxe.org/manual/macro-initialization.html)

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

To edit the format on the Facade, use `stx.log.logger.Global.unit().format =  [];`

The order is currently fixed `[level, timestamp, tags, path, newline, detail]`.

### TODO
1 FileSystem Logger. 