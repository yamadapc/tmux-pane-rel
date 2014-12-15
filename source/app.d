import std.conv : to;
import std.getopt : getopt;
import std.process : execute;
import std.stdio : writeln;
import std.string : split;

static immutable string usage = "Usage: tmux-pane-rel [options] <percentage>";

enum axis { x, y }

int main(string[] args) {
  if(args.length == 1) {
    writeln(usage);
  }

  bool help;
  axis ax;

  getopt(
    args,
    "axis|a", &ax,
    "help|h", &help
  );

  if(help || args.length < 2) {
    writeln(usage);
    return 1;
  }

  resizeTmuxPane(ax, args[args.length - 1].to!int);

  return 0;
}

int getTerminalWidth() {
  return execute(["tmux", "list-windows", "-F", "#{session_width}"])
    .output
    .split("\n")[0]
    .to!int;
}

int getTerminalHeight() {
  return execute(["tmux", "list-windows", "-F", "#{session_height}"])
    .output
    .split("\n")[0]
    .to!int;
}

void resizeTmuxPane(axis ax, int percentage) {
  auto wid = ax == axis.x ? getTerminalWidth() : getTerminalHeight();
  auto absValue = ((percentage.to!float / 100) * wid.to!float).to!int;
  execute(["tmux", "resize-pane", "-" ~ ax.to!string, absValue.to!string]);
}
