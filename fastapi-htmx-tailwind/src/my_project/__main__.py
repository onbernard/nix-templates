from pathlib import Path
import os

import uvicorn
import typer

typer_app = typer.Typer()

@typer_app.command()
def dev(host: str="0.0.0.0", port: int=8080, debug_wd: str|None=None):
    if debug_wd is None:
        debug_wd = str(Path(__file__).parent.parent.parent)
    os.environ["DEBUG_WD"] = debug_wd
    uvicorn.run("my_project.app:app", host=host, port=port, reload=True, reload_includes=["*.py", "*.jinja"])

@typer_app.command()
def prod(host: str="0.0.0.0", port: int=80):
    uvicorn.run("my_project.app:app", host=host, port=port)
