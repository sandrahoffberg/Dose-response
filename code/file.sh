#!/usr/bin/bash
set -ex

source ./config.sh

if [ "${run_capsule}" == "yes" ]; then

    python ./run_dose_response.py --metadata_file ${metadata} --all_rpm_file ${all_rpm} --target_list ${target_list}

else
    echo "Dose Response capsule was not run" > ../results/not_run.txt
fi