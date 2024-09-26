from contextlib import asynccontextmanager
import importlib.resources
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
from jinja2 import PackageLoader
import arel


@asynccontextmanager
async def lifespan(app: FastAPI):
    if (cwd := os.getenv("DEBUG_WD")) is not None:
        _run_tailwind(cwd)
        hot_reload = arel.HotReload(paths=[
            arel.Path(os.path.join(cwd, "src"), on_reload=[]),
        ])
        app.add_websocket_route("/hot-reload", route=hot_reload, name="hot-reload")
        app.add_event_handler("startup", hot_reload.startup)
        app.add_event_handler("shutdown", hot_reload.shutdown)
        templates.env.globals["hot_reload"] = hot_reload
        templates.env.globals["DEBUG"] = True
    else:
        templates.env.globals["DEBUG"] = False
    yield


def _run_tailwind(cwd: str):
    p = subprocess.run([
        "tailwindcss",
        "-i", os.path.join(cwd, "tailwindcss/styles/app.css"),
        "-o", os.path.join(cwd, "src/my_project/static/css/app.css")
    ], cwd=cwd, stderr=subprocess.STDOUT, stdout=subprocess.PIPE)
    print(p.stdout.decode())
        

app = FastAPI(lifespan=lifespan)
static_folder = importlib.resources.files("my_project").joinpath("static")
app.mount("/static", StaticFiles(directory=str(static_folder)), name="static")
templates = Jinja2Templates("templates")
templates.env.loader = PackageLoader("my_project", "templates")


@app.get("/")
async def index(request: Request) -> HTMLResponse:
    return templates.TemplateResponse("index.jinja", context={"request": request, "name": "John"})

