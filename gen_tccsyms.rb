#!/usr/bin/env ruby
#
# A generator to create the list of symbols tcc has
#
#  Copyright (c) 2011 Shinichiro Hamaji
#
# This script is intended to be invoked from nacl-configure

def get_env(key)
  e = ENV[key]
  if !e
    puts "Environment variable #{key} is not set!"
    exit 1
  end
  e
end

nacl_toolchain_root = get_env('NACL_TOOLCHAIN_ROOT')
nacl_lib_dir = get_env('NACL_LIB_DIR')
nacl_prefix = get_env('NACL_PREFIX')
$nacl_gcc = "#{nacl_toolchain_root}/bin/#{nacl_prefix}gcc"
$nacl_nm = "#{nacl_toolchain_root}/bin/#{nacl_prefix}nm"
nacl_extra_ldflags = get_env('NACL_EXTRA_LDFLAGS')
nacl_extra_cflags = get_env('NACL_EXTRA_CFLAGS')
$nacl_flags = "#{nacl_extra_cflags} #{nacl_extra_ldflags}"

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

File.open('conftest.c', 'w') do |of|
  of.puts('int main() {}')
end

def gen_tccsyms(syms)
  File.open('tccsyms.tab', 'w') do |of|
    syms.each do |sym|
      of.puts('TCCSYM(' + sym + ')')
    end
  end
  `#{$nacl_gcc} tccsyms.c conftest.c #{$nacl_flags} 2>&1`
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
