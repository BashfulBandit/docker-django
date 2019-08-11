#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
fi
versions=( "${versions[@]%/}" )

pythonVersion="3.7.4-buster"
generated_warning() {
	cat <<-EOH
		#
		# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
		#
		# PLEASE DO NOT EDIT IT DIRECTLY.
		#
	EOH
}

for version in "${versions[@]}"; do
	# Declare directory and make sure it is made.
	dir="${version}"
	mkdir -p "${dir}"

	# Declare the entrypoint.
	entrypoint='docker-entrypoint.sh'

	# Prepend warning to Dockerfile.
	{ generated_warning; cat Dockerfile.tmpl; } > "${dir}/Dockerfile"

	# Update Dockerfile with veriables.
	sed -ri \
		-e 's!%%PYTHON_VERSION%%!'"${pythonVersion}"'!g' \
		-e 's!%%DJANGO_VERSION%%!'"${version}"'!g' \
		"${dir}/Dockerfile"

	# Known issue with Python 3.7 and any Django version before 1.11.17.
	if [ "${version}" = '1.11' ]; then
		version='1.11.17'
	fi

	# Use requirements.txt template to generate requirements.txt for build.
	sed -r \
		-e 's!%%PYTHON_VERSION%%!'"${pythonVersion}"'!g' \
		-e 's!%%DJANGO_VERSION%%!'"${version}"'!g' \
		"requirements-txt.tmpl" > "${dir}/requirements.txt"

	# Copy entrypoint for build.
	cp -a "${entrypoint}" "${dir}/docker-entrypoint.sh"
	cp -a "wait-for-it.sh" "${dir}/wait-for-it.sh"
done
