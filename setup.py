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
            "rhello.rhello",
            binding=Binding.PyO3,
        )
    ],
    packages=["rhello"],
    # package_dir={
    #     "hello": "hello",
    #     # "rhello": "rhello",
    # },
    # entry_points={
    #     "console_scripts": ["greet=hello.cli:run"],
    # },
    zip_safe=False,
)
