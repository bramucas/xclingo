import setuptools
from xclingo import __version__

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="xclingo",
    version=__version__,
    author="Brais Muñiz",
    author_email="mc.brais@gmail.com",
    description="Tool for explaining Answer Set Programming programs",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/bramucas/xclingo",    
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    keywords=[
        'artificial intelligence',
        'logic programming',
        'answer set programming',
    ],
    python_requires='>=3.7.0',
    packages=[
        'xclingo',
        'xclingo.explain',
        'xclingo.translation',
        'xclingo.utils',
    ],
    entry_points={
        'console_scripts': ['xclingo=xclingo.__main__:main']
    }
)
