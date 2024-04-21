{
  description = "DeepMind's `penzai`, built with Nix.";
  inputs = {
    penzai-src = {
      flake = false;
      url = "github:google-deepmind/penzai";
    };
  };
  outputs =
    { penzai-src, self }:
    {
      lib.with-pypkgs =
        pypkgs:
        pypkgs.buildPythonPackage {
          pname = "penzai";
          version = "main";
          src = penzai-src;
          pyproject = true;
          build-system = with pypkgs; [ flit-core ];
          dependencies =
            let
              jax = (
                pypkgs.jax.overridePythonAttrs (
                  old:
                  old
                  // {
                    doCheck = false;
                    propagatedBuildInputs = old.propagatedBuildInputs ++ [ pypkgs.jaxlib-bin ];
                  }
                )
              );
            in
            [
              jax
              pypkgs.absl-py
              (pypkgs.equinox.overridePythonAttrs (
                old:
                old
                // {
                  nativeCheckInputs = [ ];
                  propagatedBuildInputs = [
                    jax
                    pypkgs.jaxtyping
                  ];
                }
              ))
              pypkgs.ordered-set
            ];
        };
    };
}
