param (
    $in,
    $out
)
# Read the contents of the fin file
$fin = Get-Content -Path $in -Raw


$fin = $fin.Replace(@"
        _DEPCMD='`$(DEP`$(1)) `$(DEP`$(1)FLAGS) `$(`$(1)DEP_FLAGS) $< 2>&1 | awk '\''/including/ { sub(/^.*file: */, ""); gsub(/\\/, "/"); if (!match(`$`$0, / /)) print "$@:", `$`$0 }'\'' > `$(@:.o=.d)'
"@, @"
if [ -f /bin/wslpath ]; then
    _DEPCMD='`$(DEP`$(1)) `$(DEP`$(1)FLAGS) `$(`$(1)DEP_FLAGS) `$< 2>&1 | awk '\''/including/ { sub(/^.*file: */, ""); gsub(/\\/, "/"); if (!match(`$`$0, / /)) b=substr(`$0,3); `$`$0=gensub(/(\w):(.*)/,"/mnt/\\1" b,1,tolower(`$0)); print "`$@:", `$`$0 }'\'' > `$(@:.o=.d)'
else
    _DEPCMD='`$(DEP`$(1)) `$(DEP`$(1)FLAGS) `$(`$(1)DEP_FLAGS) `$< 2>&1 | awk '\''/including/ { sub(/^.*file: */, ""); gsub(/\\/, "/"); if (!match(`$`$0, / /)) print "`$@:", `$`$0 }'\'' > `$(@:.o=.d)'
fi
"@)


$fin = $fin.Replace(@"
if [ "`$source_path" != "." ] && [ "`$source_path" != "src" ] && ([ ! -d src ] || [ -L src ]) && [ -e "`$link_name/test_file" ]; then
"@, @"
if [ "$source_path" != "." ] && [ "$source_path" != "src" ] && ([ ! -d src ] || [ -L src ]) && [ -e "$link_name/test_file" ] && [ -e /bin/wslpath ]; then
    # cl.exe does not support slash-lead paths (i.e. /mnt/c/source/code.c). Use relative path instead.
    source_path=`$(realpath --relative-to=`$(pwd) "`$source_path")
    source_link=`$source_path
elif [ "$source_path" != "." ] && [ "$source_path" != "src" ] && ([ ! -d src ] || [ -L src ]) && [ -e "$link_name/test_file" ] && [ ! -e /bin/wslpath ]; then
"@)

Set-Content -Path $out -Value ($fin -replace "`r`n","`n" ) -NoNewLine
# "$fin" | Out-File -FilePath -NoNewline
