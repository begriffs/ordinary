## Ordinal Arithmetic in Ruby

Finite numbers are small. You're bigger than that. Use this gem to count
above the *ordinary*.

```ruby
require 'ordinary'
include Ordinary

infinity = Ord.Omega

2 < infinity                    # => true
infinity < infinity + 1         # => true
infinity < infinity + infinity  # => true

!!"You'll love this library"    # => true
```
