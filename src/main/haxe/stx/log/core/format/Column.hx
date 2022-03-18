package stx.log.core.format;

class Column extends FormatCls{
  override public function print<T>(value:Value<T>):String{
    var p = value.source;
    var s = p.stamp;
    var a : Array<String> = [];
    if(has(INCLUDE_LEVEL)){
      a.push(s.level.toString());
    }
    if(has(INCLUDE_TIMESTAMP)){
      a.push(s.timestamp.toString());
    }
    if(has(INCLUDE_TAGS)){
      a.push('[' + s.tags.join(",") + ']');
    }
    if(has(INCLUDE_LOCATION)){
      //TODO can be earlier than __init__?;
      a.push(p.pos.map(stx.nano.Position.PositionLift.to_vscode_clickable_link).defv('<unknown>'));
    }
    if(has(INCLUDE_NEWLINE_FOR_DETAIL)){
      a.push("\n");
    }
    if(has(INCLUDE_DETAIL)){
      a.push(Std.string(value.detail));
    }
    return a.join("|");
  }
}