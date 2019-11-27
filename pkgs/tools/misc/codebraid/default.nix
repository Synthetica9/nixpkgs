{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "codebraid";
  version = "0.4.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1654kmf4lj8j56aachjfslld9khgzzldx9v9zknvmcb380agsln9";
  };

  propagatedBuildInputs = with python3Packages; [ bespon ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/gpoore/codebraid";
    description = ''
      Live code in Pandoc Markdown.

      Codebraid is a Python program that enables executable code in Pandoc
      Markdown documents. Using Codebraid can be as simple as adding a class to
      your code blocks' attributes, and then running codebraid rather than
      pandoc to convert your document from Markdown to another format.
      codebraid supports almost all of pandoc's options and passes them to
      pandoc internally.

      Codebraid provides two options for executing code. It includes a built-in
      code execution system that currently supports Python 3.5+, Julia, Rust,
      R, Bash, and JavaScript. Code can also be executed using Jupyter kernels,
      with support for rich output like plots.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ synthetica ];
  };
}
