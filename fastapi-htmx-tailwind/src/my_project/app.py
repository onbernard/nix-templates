from pathlib import Path
import subprocess
import os

from fastapi import (
    FastAPI,
    Request,
)
from fastapi.responses import (
    HTMLResponse,
)
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.gzip import GZipMiddleware
import arel

_DEBUG = os.getenv("DEBUG")

app = FastAPI()
app.mount("/static", StaticFiles(directory="static"), name="static")
app.add_middleware(GZipMiddleware)
templates = Jinja2Templates("templates")


async def _run_tailwind():
    global _DEBUG
    assert _DEBUG is not None
    p = subprocess.run([
        "tailwindcss",
        "-i", os.path.join(_DEBUG, "tailwindcss/styles/app.css"),
        "-o", os.path.join(_DEBUG, "static/css/app.css")
    ], capture_output=True)
    print(p.stdout)


if _DEBUG:
    assert Path(_DEBUG).exists(), "DEBUG_DIR must be an existing path"
    hot_reload = arel.HotReload(paths=[
        arel.Path(_DEBUG, on_reload=[_run_tailwind,]),
    ])
    app.add_websocket_route("/hot-reload", route=hot_reload, name="hot-reload") # type: ignore
    app.add_event_handler("startup", hot_reload.startup)
    app.add_event_handler("shutdown", hot_reload.shutdown)
    templates.env.globals["hot_reload"] = hot_reload
    templates.env.globals["DEBUG"] = True
else:
    templates.env.globals["DEBUG"] = False


@app.get("/")
async def index(request: Request) -> HTMLResponse:
    return templates.TemplateResponse("index.jinja", context={"request": request, "name": "John"})


