import std.stdio;
import std.algorithm;
import std.string;
import std.path;
import std.array;
import std.process;
import onyx.log;
import onyx.bundle;

void main(string[] args)
{
	// 初始化日志
	auto bundle = new immutable Bundle("./conf/log.conf");
	createLoggers(bundle);
	auto log = getLogger("DebugLogger");

	// 应用配置
	auto appBundle = new immutable Bundle("./conf/app.conf");
	auto command = array(appBundle.values("App", "command").map!(i => i.strip("\"")));
	log.debug_("cps: %s", command);

	auto jrePath = absolutePath("jre");
	auto jreBinPath = buildPath(jrePath, "bin");
	auto envPath = join([jreBinPath, environment["PATH"]], ";");
	environment["PATH"] = envPath;
	log.info("jre: %s",  jrePath);
	auto pipes = pipeProcess(command);
	foreach (line; pipes.stdout.byLine) {
		log.info("jre: %s", strip(line.idup));
	}
	foreach (line; pipes.stderr.byLine) {
		log.error("jre: %s", strip(line.idup));
	}
}
