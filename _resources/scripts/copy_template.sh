#!/usr/bin/bash
####################################################################################
# Copy a template from _templates and rename it.
# v0.1, 2020-05-19
#
# Intended to be used from the Makefile to create new files.
#
# Expects the template type ($1) to correspond to a singularly named file of
# the same name in _templates/. The name will be prompted if not supplied on
# the command line.
#
# The following substitutions will be made in the copied file:
#
#     @@NAME@@     - The name as entered or supplied on the command line.
#     @@CLEANAME@@ - The name as converted to filename format (towercase, no spaces)
#     @@TYPE@@     - The (lowercase) template type.
#     @@CAPTYPE@@  - Same as @@TYPE@@ but with the first letter capitalized
#     @@NOW@@      - The current timestamp.
####################################################################################

if [[ "$#" -eq 0 ]]; then
    echo "Usage: $0 <template-type> [name]"
    exit 254
fi

basedir=$(pwd)
template_type="$1"
shift

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && cd .. && pwd)"
template_file="${script_dir}/_templates/${template_type}.md"

if [[ ! -f "${template_file}" ]]; then
    echo "Could not find ${template_type} template in ${script_dir}/_templates"
    exit 201
fi

cmdline_name="$@"

if [[ "${cmdline_name}" == "" ]]; then
    echo -n "Enter ${template_type} name: "
    read template_name
else
    template_name="${cmdline_name}"
fi

if [[ "${template_name}" == "" ]]; then
    echo "No input provided - exiting!"
    exit 202
fi

template_filename=$(echo ${template_name} | sed 's/ /_/g' | tr [A-Z] [a-z])
output_file="${basedir}/${template_type}s/${template_filename}.md"

echo "_templates/${template_type} -> ${template_type}s/${template_filename}.md"
cp "${script_dir}/_templates/${template_type}.md" "${output_file}"

sed -i "s/@@NAME@@/${template_name}/ig" "${output_file}"
sed -i "s/@@CLEANNAME@@/${template_filename}/ig" "${output_file}"
sed -i "s/@@TYPE@@/${template_type}/ig" "${output_file}"
sed -i "s/@@CAPTYPE@@/$(echo ${template_type} | sed -e 's/\b\(.\)/\u\1/g')/ig" "${output_file}"
sed -i "s/@@NOW@@/$(date)/ig" "${output_file}"

exit 0
