TAG_NAME_MAP = {
"#"  => "sharp",
"/"  => "slash",
"\\" => "backslash",
"."  => "dot",
"+"  => "plus",
" "  => "-"
}

# Map a tag to its directory name. Certain characters are escaped,
# using the TAG_NAME_MAP constant, above. - from brizzled.clapper.org
def name_to_dir(name)
  s = ""
  name.each_char do |c|
    if (c =~ /[-A-Za-z0-9_]/) != nil
      s += c
    else
      c2 = TAG_NAME_MAP[c]
      if not c2
        msg = "Bad character '#{c}' in tag '#{name}'"
        puts("*** #{msg}")
        raise FatalException.new(msg)
      end
      s += c2
    end
  end
  s
end