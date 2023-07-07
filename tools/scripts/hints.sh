diff --git a/configure b/configure
index 169f23e17f..19d8d192f1 100755
--- a/configure
+++ b/configure
@@ -4698,7 +4698,11 @@ probe_cc(){
         else
             _ident=$($_cc --version 2>/dev/null | head -n1 | tr -d '\r')
         fi
-        _DEPCMD='$(DEP$(1)) $(DEP$(1)FLAGS) $($(1)DEP_FLAGS) $< 2>&1 | awk '\''/including/ { sub(/^.*file: */, ""); gsub(/\\/, "/"); if (!match($$0, / /)) print "$@:", $$0 }'\'' > $(@:.o=.d)'
+        if [ -f /bin/wslpath ]; then
+            _DEPCMD='$(DEP$(1)) $(DEP$(1)FLAGS) $($(1)DEP_FLAGS) $< 2>&1 | awk '\''/including/ { sub(/^.*file: */, ""); gsub(/\\/, "/"); if (!match($$0, / /)) b=substr($0,3); $$0=gensub(/(\w):(.*)/,"/mnt/\\1" b,1,tolower($0)); print "$@:", $$0 }'\'' > $(@:.o=.d)'
+        else
+            _DEPCMD='$(DEP$(1)) $(DEP$(1)FLAGS) $($(1)DEP_FLAGS) $< 2>&1 | awk '\''/including/ { sub(/^.*file: */, ""); gsub(/\\/, "/"); if (!match($$0, / /)) print "$@:", $$0 }'\'' > $(@:.o=.d)'
+        fi
         _DEPFLAGS='$(CPPFLAGS) $(CFLAGS) -showIncludes -Zs'
         _cflags_speed="-O2"
         _cflags_size="-O1"
@@ -5570,11 +5574,15 @@ link_name=$(mktemp -u $TMPDIR/name_XXXXXXXX)
 mkdir "$link_dest"
 $ln_s "$link_dest" "$link_name"
 touch "$link_dest/test_file"
-if [ "$source_path" != "." ] && [ "$source_path" != "src" ] && ([ ! -d src ] || [ -L src ]) && [ -e "$link_name/test_file" ]; then
+if [ "$source_path" != "." ] && [ "$source_path" != "src" ] && ([ ! -d src ] || [ -L src ]) && [ -e "$link_name/test_file" ] && [ ! -e /bin/wslpath ]; then
     # create link to source path
     [ -e src ] && rm src
     $ln_s "$source_path" src
     source_link=src
+elif [ -e /bin/wslpath ]; then
+    # cl.exe does not support slash-lead paths (i.e. /mnt/c/source/code.c). Use relative path instead.
+    source_path=$(realpath --relative-to=$(pwd) "$source_path")
+    source_link=$source_path
 else
     # creating directory links doesn't work
     # fall back to using the full source path