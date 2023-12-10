import std.stdio;

import vibe.vibe;

HTTPServerSettings settings = null;
URLRouter router = null;

static this() {
    settings = new HTTPServerSettings;
    settings.port = 12345;
    settings.bindAddresses = ["127.0.0.1"];
    settings.errorPageHandler = toDelegate(&error);
    router = new URLRouter;
}

void main(string[] args) {
    writeln(args);
    // 
    router.get("/", staticTemplate!"index.dt");
    router.get("/about/", staticTemplate!"about.dt");
    // 
    router.get("/favicon.ico", serveStaticFile("static/logo.png"));
    router.get("/doc/", serveStaticFiles("doc/"));
    router.get("*", serveStaticFiles("static/"));
    // 
    auto listener = listenHTTP(settings, router);
    scope (exit)
        listener.stopListening();
    runApplication();
}

void error(HTTPServerRequest req, HTTPServerResponse res,
        HTTPServerErrorInfo err) {
    res.render!("error.dt", req, err);
}
