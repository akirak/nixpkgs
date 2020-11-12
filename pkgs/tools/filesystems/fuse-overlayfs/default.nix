{ stdenv, fetchFromGitHub, autoreconfHook, pkg-config, fuse3, nixosTests }:

stdenv.mkDerivation rec {
  pname = "fuse-overlayfs";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ihibhj48fk1c89yh7vyb44mkywxphxqqgz7xks9caw05qw5ac1y";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ fuse3 ];

  propagateBuildInputs = [ fuse3 ];

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with stdenv.lib; {
    description = "FUSE implementation for overlayfs";
    longDescription = "An implementation of overlay+shiftfs in FUSE for rootless containers.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ma9e ] ++ teams.podman.members;
    platforms = platforms.linux;
    inherit (src.meta) homepage;
  };
}
