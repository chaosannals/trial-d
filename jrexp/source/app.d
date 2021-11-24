import std.stdio;
import std.algorithm;
import std.string;
import std.path;
import std.array;
import std.process;
import std.file;
import onyx.log;
import onyx.bundle;

private const string LOG_CONF_PATH = "./conf/log.conf";
private const string APP_CONF_PATH = "./conf/app.conf";
private string[] LOG_CONF_DEFAULT = [
	"[DebugLogger]", "level = debug", "appender = FileAppender",
	"rolling = SizeBasedRollover", "maxSize = 2M", "maxHistory = 4",
	"fileName = ./run/log/app.log", "[ErrorLogger]", "level = error",
	"appender = ConsoleAppender",
];
private string[] APP_CONF_DEFAULT = [
	"[App]",
	"command = ${jredir}/bin/javaw -cp \".;./*\" -Djava.library.path=./bin exert.d.jrejar.App",
];

private immutable(Bundle) loadBundle(string path, string[] ds)
{
	if (exists(path) && isFile(path))
	{
		return new immutable Bundle(path);
	}
	return new immutable Bundle(ds);
}

private void run(Logger log, string[] command) {
	auto pipes = pipeProcess(command);
	foreach (line; pipes.stdout.byLine)
	{
		log.info("jre: %s", strip(line.idup));
	}
	foreach (line; pipes.stderr.byLine)
	{
		log.error("jre: %s", strip(line.idup));
	}
	wait(pipes.pid);
}

void main(string[] args)
{
	// 路径
	auto jrePath = absolutePath("jre");
	auto jreBinPath = buildPath(jrePath, "bin");

	// 初始化日志
	auto bundle = loadBundle(LOG_CONF_PATH, LOG_CONF_DEFAULT);
	createLoggers(bundle);
	auto log = getLogger("DebugLogger");

	// 应用配置
	auto appBundle = loadBundle(APP_CONF_PATH, APP_CONF_DEFAULT);
	auto command = array(appBundle.values("App", "command").map!(i => i.strip("\"").replace("${jredir}", jrePath)));
	log.debug_("cps: %s", command);

	const envPath = join([jreBinPath, environment["PATH"]], ";");
	environment["PATH"] = envPath;
	log.info("jre: %s", jrePath);
	run(log, command);
}
