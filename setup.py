#!/usr/bin/env python

from setuptools import setup
from setuptools_rust import Binding, RustExtension

setup(
    name="hello",
    version="0.13.37",
    description="derp",
    author="It me!",
    author_email="gward@python.net",
    rust_extensions=[
        RustExtension(
            "hello.rhello",
            binding=Binding.PyO3,
        )
    ],
    # packages=["hello"],
    # tell setup that the root python source is inside py folder
    package_dir={"": "py"},
    # entry_points={
    #     "console_scripts": ["greet=hello.cli:run"],
    # },
    zip_safe=False,
)
