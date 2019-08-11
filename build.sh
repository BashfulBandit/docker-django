#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
fi
versions=( "${versions[@]%/}" )

for version in "${versions[@]}"; do
	dir="${version}"
	image="dtempleton/django:${version}"

	echo "Building ${image}..."
	docker build -t ${image} ${dir}
done
