import std.stdio;
import gtk.MainWindow;
import gtk.Label;
import gtk.Main;

void main(string[] args)
{
	writeln("first application.");
	Main.init(args);
	MainWindow win = new MainWindow("gtkd window");
	win.setDefaultSize(800, 600);
	win.add(new Label("gtkd"));
	win.showAll();
	Main.run();
}
