function to_abs_path() {
    echo $(readlink -m $1)
}

function combine_doxygen_configs() {
    cat $1
    cat $2
    echo "HTML_EXTRA_STYLESHEET = $this_dir/doxygen-awesome-css/doxygen-awesome.css"
}

source_dir=$1

if [ ! $source_dir ]; then
    source_dir=$(pwd)
else
    source_dir=$(to_abs_path $source_dir)
fi

build_dir=$2

if [ ! $build_dir ]; then
    build_dir="$source_dir/build/docs"
else
    build_dir=$(to_abs_path $build_dir)
fi

this_file=$(realpath "$0")
this_dir=$(dirname "$this_file")
atom_doxyfile_path='Doxyfile'
user_doxyfile_path="$source_dir/Doxyfile"

if [ ! -f "$user_doxyfile_path" ]; then
    echo "error: $user_doxyfile_path doesn't exist."
    exit 1
fi

echo "source_dir: $source_dir"
echo "build_dir: $build_dir"

# --------------------------------------------------------------------------------------------------
# doxygen

doxygen_config=$(combine_doxygen_configs $atom_doxyfile_path $user_doxyfile_path)

rm -r "$build_dir"
mkdir -p "$build_dir"

echo "running doxygen..."
cd $source_dir
(echo "$doxygen_config") | doxygen -
