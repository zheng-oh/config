# Defined in - @ line 1
function pip
 if test "$argv[1]" = "install"
  command pip $argv -i https://pypi.tuna.tsinghua.edu.cn/simple
 else
  command pip $argv
 end
end
