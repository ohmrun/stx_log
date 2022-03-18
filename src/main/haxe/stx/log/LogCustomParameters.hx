package stx.log;

@:forward abstract LogCustomParameters(Array<Dynamic>) from Array<Dynamic> to Array<Dynamic>{
  public function new(?self:Array<Dynamic>) this = __.option(self).defv([]);

  public var stamp(get,never) : Stamp;

  private function get_stamp():Stamp{
    var obj : Stamp = null;
    for(x in this){
      var clazz = StdType.getClass(x);
      if(clazz == Stamp){
        obj = x;
        break;
      }
    }
    if(obj == null){
      obj = new Stamp();
      this.push(obj);
    }
    return obj;
  }
  public function restamp(fn:Stamp->Stamp):LogCustomParameters{
    var indexed = this.imap(__.couple).search(

      (tp:Couple<Int,Dynamic>)-> is_stamp(tp.snd())
    ).def(
      () -> {
        var stamp = new Stamp();
        var index = this.length;
        this[index] = stamp;
        return __.couple(index,stamp);
      }
    );
    var next_stamp  = fn(indexed.snd());
    var copy        = this.copy();
        copy[indexed.fst()] = next_stamp;
    return copy;
  }
  static function is_stamp(v:Dynamic){
    var clazz = StdType.getClass(v);
    return (clazz == Stamp);
  }
}