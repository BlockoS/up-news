#!/usr/bin/env bash

progname=$(basename $0)

usage()
{
    cat << EOT
Usage: ${progname} [-o OUTDIR] [-i FILE] VAR0 VAR1 ...
    -o OUTDIR     Output directory (./ by default).
    -i FILE       PC Engine ROM.
    VAR0 VAR1 ... RAM code variables.
EOT
}

out_dir='./'
pce_file=''

# parse command line arguments
OPTIND=1
while getopts "i:o:h" opt
do
    case ${opt} in
        h)
            usage
            exit 0
            ;;
        o)
            out_dir=${OPTARG}
            ;;
        i)
            pce_file=${OPTARG}
            ;;
        *)
            usage >& 2
            exit 1
            ;;
    esac
done

shift $((OPTIND-1))

if ! [ -f ${pce_file} -a -r ${pce_file} ]; then
    echo "${pce_file} is not a valid file." >&2
    exit 4
fi

if ! [ -d ${out_dir} -a -r ${out_dir} -a -w ${out_dir} ]; then
    echo "${out_dir} is not a valid directory." >&2
    exit 4
fi

if [ $# -lt 1 ]; then
    echo "${progname}: missing arguments" 1>&2
    exit 1
fi

path=${pce_file%.pce}
prefix=$(basename $path)
echo "grep -rin ${prefix}_begin ${path}.sym | cut -f 4"
# parse sym file to extract ROM offsets
ramcode_begin=$(grep -rin ${prefix}_begin ${path}.sym \
    | tr -s [:space:] ' ' | cut -d ' '  -f 2)
ramcode_end=$(grep -rin ${prefix}_end ${path}.sym \
    | tr -s [:space:] ' ' | cut -d ' '  -f 2)

# extract ramcode
begin=$((0x${ramcode_begin} & 0x1fff))
end=$((0x${ramcode_end} & 0x1fff))
size=$(expr $end - $begin)
dd if=${pce_file} ibs=1 skip=$begin count=$size of=${out_dir}/${prefix}.bin

# extract variables
if [ $# -ge 1 ]; then
    >| ${out_dir}/${prefix}.inc
    for arg; do
        address=$(grep -rin ${arg} ${path}.sym | tr -s [:space:] ' ' | cut -d ' ' -f 2)
        cat >> ${out_dir}/${prefix}.inc << EOT
${arg} = \$${address}
EOT
    done
fi
