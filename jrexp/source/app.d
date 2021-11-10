import std.stdio;
import std.string;
import std.path;
import std.array;
import std.process;
import onyx.log;
import onyx.bundle;

void main(string[] args)
{
	auto bundle = new immutable Bundle("./conf/log.conf");
	createLoggers(bundle);

	auto log = getLogger("DebugLogger");

	auto jrePath = absolutePath("jre");
	auto jreBinPath = buildPath(jrePath, "bin");
	auto envPath = join([jreBinPath, environment["PATH"]], ";");
	environment["PATH"] = envPath;
	log.info("jre: %s",  jrePath);
	auto pipes = pipeProcess(["javaw", "-version"]);
	foreach (line; pipes.stdout.byLine) {
		log.info("jre: %s", strip(line.idup));
	}
	foreach (line; pipes.stderr.byLine) {
		log.error("jre: %s", strip(line.idup));
	}
}
