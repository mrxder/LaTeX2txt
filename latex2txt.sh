command -v sd >/dev/null 2>&1 || { echo >&2 "I require sd but it's not installed. https://github.com/chmln/sd  Aborting."; exit 1; }

if [ "$#" -ne 1 ]; then
    echo "Specify .tex file as argument"
    exit -1
fi

cat $1 | \
sd '%.*' '' | \
sd '\\.*title[\{\[](.*?)[\}\]].*' '$1' | \
sd '\\author\[(.*)\].*' '$1' | \
sd '\\footertext\{(.*)\}.*' '$1' | \
sd '\\.*section\{(.*)\}.*' '$1' | \
sd '\\begin\{frame\}.*' '//' | \
sd '\\.*title\{(.*)\}.*' '$1' | \
sd '\\item(.*)' '$1' | \
sd '\\footnote\{(.*)\}' '$1' | \
sd '\\caption\{(.*)\}.*' '$1' | \
sd '\\text..+?\{(.*)\}' '$1' | \
sd '\\.*' '' | \
sd -f m '^\s*$' '' > \
"$1.clean"
