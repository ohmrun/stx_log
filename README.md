# stx_log

Logging framework


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