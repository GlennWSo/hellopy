#!/usr/bin/env python

from distutils.core import setup

setup(
    name="hello",
    version="0.13.37",
    description="derp",
    author="It me!",
    author_email="gward@python.net",
    package_dir={"hello": "hello"},
    entry_points={
        "console_scripts": ["greet=hello.cli:run"],
    },
)
