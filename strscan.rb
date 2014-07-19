require 'strscan'

ss = StringScanner.new 'aabbbbb' #=> #<StringScanner 0/7 @ "aabbb...">
ss.scan /a/ #=> "a"
ss.scan /a/ #=> "a"
ss.scan /a/ #=> nil
ss #=> #<StringScanner 2/7 "aa" @ "bbbbb">


ss #=> #<StringScanner 2/7 "aa" @ "bbbbb">
ss.getch #=> "b"

ss #=> #<StringScanner 3/7 "aab" @ "bbbb">
