FROM gitpod/workspace-full

USER gitpod

# Install Julia
RUN sudo apt-get update \
    && sudo apt-get install -y \
        build-essential \
        libatomic1 \
        python \
        gfortran \
        perl \
        wget \
        m4 \
        cmake \
        pkg-config \
        ca-certificates \
        curl \
    && sudo rm -rf /var/lib/apt/lists/*

USER root

# Install current version of julia (see https://github.com/docker-library/julia)
ENV JULIA_PATH /usr/local/julia
ENV PATH $JULIA_PATH/bin:$PATH

# https://julialang.org/juliareleases.asc
# Julia (Binary signing key) <buildbot@julialang.org>
ENV JULIA_GPG 3673DF529D9049477F76B37566E3C7DC03D6E495

# https://julialang.org/downloads/
ENV JULIA_VERSION 1.7.1

RUN set -eux; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	if ! command -v gpg > /dev/null; then \
		apt-get update; \
		apt-get install -y --no-install-recommends \
			gnupg \
			dirmngr \
		; \
		rm -rf /var/lib/apt/lists/*; \
	fi; \
	\
# https://julialang.org/downloads/#julia-command-line-version
# https://julialang-s3.julialang.org/bin/checksums/julia-1.7.1.sha256
	arch="$(dpkg --print-architecture)"; \
	case "$arch" in \
		'amd64') \
			url='https://julialang-s3.julialang.org/bin/linux/x64/1.7/julia-1.7.1-linux-x86_64.tar.gz'; \
			sha256='44658e9c7b45e2b9b5b59239d190cca42de05c175ea86bc346c294a8fe8d9f11'; \
			;; \
		'arm64') \
			url='https://julialang-s3.julialang.org/bin/linux/aarch64/1.7/julia-1.7.1-linux-aarch64.tar.gz'; \
			sha256='5d9f23916d331f54a2bb68936c2c7fbf3fdb4a6f7bfbb99750276cc23a292a4d'; \
			;; \
		'i386') \
			url='https://julialang-s3.julialang.org/bin/linux/x86/1.7/julia-1.7.1-linux-i686.tar.gz'; \
			sha256='6b5f7a235dc51b586d6ab914042b6d91c8634eeeb011636460ab6dcbf5671fac'; \
			;; \
		*) \
			echo >&2 "error: current architecture ($arch) does not have a corresponding Julia binary release"; \
			exit 1; \
			;; \
	esac; \
	\
	curl -fL -o julia.tar.gz.asc "$url.asc"; \
	curl -fL -o julia.tar.gz "$url"; \
	\
	echo "$sha256 *julia.tar.gz" | sha256sum --strict --check -; \
	\
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$JULIA_GPG"; \
	gpg --batch --verify julia.tar.gz.asc julia.tar.gz; \
	command -v gpgconf > /dev/null && gpgconf --kill all; \
	rm -rf "$GNUPGHOME" julia.tar.gz.asc; \
	\
	mkdir "$JULIA_PATH"; \
	tar -xzf julia.tar.gz -C "$JULIA_PATH" --strip-components 1; \
	rm julia.tar.gz; \
	\
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false;
    
USER gitpod
    # smoke test
RUN	julia --version

# Install packages
ENV TEMP="/home/gitpod/tmp"
RUN mkdir $TEMP
WORKDIR ${TEMP}
COPY *.toml $TEMP
RUN mkdir ${TEMP}/src
COPY ./ $TEMP/
RUN julia --project=$TEMP -e 'import Pkg; Pkg.instantiate()'
WORKDIR ${TEMP}/test
RUN julia --project=$TEMP/test -e 'import Pkg; Pkg.instantiate();'
WORKDIR ${TEMP}/dev/
RUN julia --project=$TEMP/dev -e 'import Pkg; Pkg.instantiate();'
WORKDIR ${TEMP}/docs/
RUN julia --project=$TEMP/docs -e 'import Pkg; Pkg.instantiate();'

# Give control back to Gitpod Layer
USER root