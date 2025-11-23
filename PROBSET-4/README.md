## Academic Document LaTeX Template

A LaTeX template for creating academic purposes documents or more.

## Title Page Formatting

Only modify the `details.tex` file to modify the document title and its contents. It will automatically create the title page for you. This is done to avoid sloppy errors.

## Dependencies

> We use LuaLaTeX as the main latex compiler to address the color rendering issue persistent in multiple pdf viewers in Windows/Linux. 

### Install Minted/Python-pygments

> We will use minted to address tcolorbox issues with codeblocks rendering.

Linux Debian/Ubuntu Install:

```bash
sudo apt update
sudo apt install python3-pygments
```

Verify if working.

```bash
pygmentize -V
```

### LuaLaTeX Installation

Installation & Compiling LuaLaTeX compiler:

Linux Debian/Ubuntu Install:

```bash
sudo apt update
sudo apt install -y texlive-luatex latexmk
```

Make sure to navigate to current working directory.

```bash
cd /your_path/your_project_folder/
```

## Generating Pdf Output

### Linux 

Generate pdf output.

```bash
make
```

Clean the generated files.

```bash
make clean
```

Start fresh (Delete generated files including pdf)

```bash
make purge
```

### Windows

Generate pdf output.

```shell
.\build.bat
```

Clean the generated files.

```shell
.\build.bat clean
```

Start fresh (Delete generated files including pdf)

```shell
.\build.bat purge
```
