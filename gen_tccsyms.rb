#!/usr/bin/env ruby

nacl_sdk_root = ARGV[0]
nacl_toolchain_root="#{nacl_sdk_root}/toolchain/linux_x86"
#nacl_lib_dir = "#{nacl_toolchain_root}/x86_64-nacl/lib"
nacl_lib_dir = "#{nacl_toolchain_root}/x86_64-nacl/lib32"
#$nacl_gcc="#{nacl_toolchain_root}/bin/x86_64-nacl-gcc"
$nacl_gcc="#{nacl_toolchain_root}/bin/i686-nacl-gcc"
#$nacl_nm="#{nacl_toolchain_root}/bin/x86_64-nacl-nm"
$nacl_nm="#{nacl_toolchain_root}/bin/i686-nacl-nm"

syms = []
IO.popen([$nacl_nm,
          "#{nacl_lib_dir}/libcrt_common.a",
          "#{nacl_lib_dir}/libcrt_platform.a",
          "#{nacl_lib_dir}/libnacl.a",
          "#{nacl_lib_dir}/libm.a",
          "#{nacl_lib_dir}/link_segment_gap.o",
          "#{nacl_lib_dir}/libppapi_stub.a",
          "#{nacl_lib_dir}/libpthread.a",
          "#{nacl_lib_dir}/libnacl_dyncode.a",
         ] * ' ') do |pipe|
  pipe.each do |line|
    a = line.split
    if a.size != 3
      next
    end

    sym = a[2]
    if /^[a-zA-Z_]+$/ !~ sym || /^NACL/ =~ sym || '_impure_ptr' == sym
      next
    end

    syms << sym
  end
end

syms = syms.sort.uniq

File.open('conftset.c', 'w') do |of|
  of.puts('int main() {}')
end

def gen_tccsyms(syms)
  File.open('tccsyms.tab', 'w') do |of|
    syms.each do |sym|
      of.puts('TCCSYM(' + sym + ')')
    end
  end
  #`#{$nacl_gcc} tccsyms.c conftest.c -m64 -lm -lppapi -lnacl_dyncode 2>&1`
  `#{$nacl_gcc} tccsyms.c conftest.c -m32 -lm -lppapi -lnacl_dyncode 2>&1`
end

prev_undefines = 0
while true
  errmsg = gen_tccsyms(syms)

  if $? == 0
    break
  end

  undefined = []
  errmsg.scan(/`(.*?)'/) do
    undefined << $1
  end
  syms -= undefined

  if prev_undefines == undefined.size
    break
  end

  prev_undefines = undefined.size
end

ok_syms = []
syms.each_with_index do |sym, i|
  print "#{i+1}/#{syms.size} Checking #{sym}... "
  errmsg = gen_tccsyms([sym])

  if $? == 0
    ok_syms << sym
    puts 'OK'
  else
    puts 'FAIL'
  end
end

errmsg = gen_tccsyms(ok_syms)
if $? != 0
  puts errmsg
  exit 1
end

puts 'DONE!'
