{ stdenv, fetchFromGitHub, gnome3, glib, libxml2, gtk-engine-murrine, gdk-pixbuf, librsvg, bc }:

stdenv.mkDerivation rec {
  version = "0.20200104";
  pname = "chromeos-gtk-theme";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "ChromeOS-theme";
    rev = "5e7948b6c41873ce23faeb308336fb76d4f8651d";
    sha256 = "1v7m7iv7nq7fayqpyv6v92vnk03ls8ayw46b6r8wr63z8pm27k8p";
  };

  nativeBuildInputs = [ glib libxml2 bc ];

  buildInputs = [ gnome3.gnome-themes-extra gdk-pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontBuild = true;

  installPhase = ''
      head -3 README.md
    patchShebangs install.sh
    sed -i install.sh \
      -e "s|if .*which gnome-shell.*;|if true;|" \
      -e "s|CURRENT_GS_VERSION=.*$|CURRENT_GS_VERSION=${stdenv.lib.versions.majorMinor gnome3.gnome-shell.version}|"
    ./install.sh --dest $out/share/themes
    rm $out/share/themes/*/COPYING
  '';

  meta = with stdenv.lib; {
    description = "Material Design theme for GNOME/GTK based desktop environments";
    homepage = https://github.com/vinceliuice/ChromeOS-theme/;
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [
      # TODO: Add a maintainer
      maintainers.mounium
    ];
  };
}
