#!/usr/bin/bash
set -ex

source ./config.sh

echo python ./run_dose_response.py --metadata_file ${metadata} --all_rpm_file ${all_rpm} --target_list ${target_list}

exit 1