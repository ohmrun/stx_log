package stx.log.core.format;

class Console extends FormatCls{
  override public function print<T>(value:Value<T>):String{
    var p = value.source;
    var s = value.stamp;
    var a : Array<String> = [];
    if(has(INCLUDE_LEVEL)){
      var l = s.level;
      final level_str = switch(s.level){
        case TRACE  : '<grey>${l}</grey>';//TRACE
        case DEBUG  : '<light_white>${l}</light_white>';//DEBUG
        case INFO   : '<green>${l}</green>';//INFO
        case WARN   : '<yellow>${l}</yellow>';//WARN
        case ERROR  : '<red>${l}</red>';//ERROR
        case FATAL  : '<invert><red>${l}</red></invert>';//FATAL

        default: '${l}';//BLANK
      }
      a.push('$level_str');
    }
    if(has(INCLUDE_TIMESTAMP)){
      //https://www.w3.org/TR/NOTE-datetime
      var fmt = '%Y-%m-%dT%H:%M:%S'; 
      a.push('${DateTools.format(s.timestamp,fmt)}');
    }
    if(has(INCLUDE_TAGS)){
      var tag_string = ['${s.tags.join(",")}']; 
      a.push('<magenta>$tag_string</magenta>');
    }
    if(has(INCLUDE_LOCATION)){
      //TODO can be earlier than __init__?;
      var lnk = p.pos.map(stx.nano.Position.PositionLift.to_vscode_clickable_link).defv("<unknown>");
      a.push(lnk);
    }
    if(has(INCLUDE_NEWLINE_FOR_DETAIL)){
      a.push("\n");
    }
    if(has(INCLUDE_DETAIL)){
      var detail_string = Std.string(value.detail); 
      a.push('<invert>$detail_string</invert>');
    }
    return a.join(" ");
  }
}