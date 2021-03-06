EAPI=3
inherit git-2 multilib

DESCRIPTION="An audio processing program with an interactive mode."
HOMEPAGE="https://github.com/bmc0/dsp"

EGIT_REPO_URI="git://github.com/bmc0/dsp.git"

LICENSE="( c ) 2013-2015 Michael Barbour <barbour.michael.0@gmail.com>"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="fftw sndfile ffmpeg alsa ao mad pulseaudio dsp ladspa_dsp"
DEPEND="media-libs/ladspa-sdk
fftw? ( >=sci-libs/fftw-3.0.0 )
sndfile? ( media-libs/libsndfile )
ffmpeg? ( media-video/ffmpeg )
alsa? ( media-libs/alsa-lib )
ao? ( media-libs/libao )
mad? ( media-libs/libmad )
pulseaudio? ( media-sound/pulseaudio )"

src_configure() {
	local myconf=""

	if ! use ao; then
                myconf+=" --disable-ao"
	fi
	if ! use dsp; then
                myconf+=" --disable-dsp"
        fi
	if ! use ladspa_dsp; then
                myconf+=" --disable-ladspa_dsp"
        fi
        if ! use fftw; then
                myconf+=" --disable-fftw3"
	fi
        if ! use sndfile; then
                myconf+=" --disable-sndfile"
	fi
        if ! use ffmpeg; then
                myconf+=" --disable-ffmpeg"
	fi
	if ! use alsa; then
                myconf+=" --disable-alsa"
	fi
	if ! use ao; then
                myconf+=" --disable-ao"
	fi
	if ! use mad; then
                myconf+=" --disable-mad"
	fi
	if ! use pulseaudio; then
                myconf+=" --disable-pulse"
        fi

	myconf+=" --prefix="${EPREFIX}"/usr"
	myconf+=" --libdir=/"$(get_libdir)

	echo "myconf:"${myconf}

	${WORKDIR}/${P}/configure ${myconf} || die
}

src_install()
{
	if use dsp; then
		emake DESTDIR="${D}" install_dsp || die
	fi
	if use ladspa_dsp; then
                emake DESTDIR="${D}" install_ladspa_dsp || die
        fi

	if ! use dsp && ! use ladspa_dsp; then
		die "no install target chosen"
	fi

	exeinto "/usr/bin"
	doexe scripts/rew_to_dsp.sh

	dodoc README.md
}
