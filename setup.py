import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="xclingo", # Replace with your own username
    version="0.0.1",
    author="Brais Muñiz",
    author_email="mc.brais@gmail.com",
    description="Tool for explaining Answer Set Programming programs",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/bramucas/xclingo",
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.7.0',
)
