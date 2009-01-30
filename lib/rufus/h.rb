#
#--
# Copyright (c) 2009, John Mettraux, jmettraux@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#++
#

#
# "assembled in Yokohama"
#


module Rufus

  #
  # Serialization to JSON safe structure
  #
  module H

    PRIMITIVE_TYPES = [
      ::Fixnum, ::TrueClass, ::FalseClass, ::NilClass, ::Numeric, ::Float
    ]

    def self.to_h (o, opts={})

      raise ArgumentError.new('cannot encode classes') if o.is_a?(Class)

      return o if PRIMITIVE_TYPES.include?(o.class)

      if c = cached(opts, o)
        flag(opts, o)
        return "_RH_#{c}"
      end

      if o.respond_to?(:to_h)
        return (o.method(:to_h).arity == 0) ? o.to_h : o.to_h(opts)
      end

      case o
        when ::String then string_to_h(o, opts)
        when ::Symbol then symbol_to_h(o, opts)
        when ::Hash then hash_to_h(o, opts)
        when ::Array then array_to_h(o, opts)
        else object_to_h(o, opts)
      end
    end

    def self.string_to_h (s, opts={})

      return s if s.length < 24

      # cache the string if it's long...

      cache(opts, s, { '_RH_S'=> s })
    end

    def self.symbol_to_h (s, opts={})
      cache(opts, s, { '_RH_:' => s.to_s })
    end

    def self.hash_to_h (h, opts={})
      cache(
        opts,
        h,
        h.inject({}) { |r, (k, v)| r[key_to_s(k, r, opts)] = to_h(v, opts); r })
    end

    def self.array_to_h (a, opts={})
      cache(opts, a, a.collect { |e| to_h(e, opts) })
    end

    def self.object_to_h (o, opts={})

      h = { '_RH_K' => o.class.name }
      o.instance_variables.each do |varname|
        h[varname[1..-1]] = to_h(o.instance_variable_get(varname), opts)
      end
      cache(opts, o, h)
    end

    protected

    def self.key_to_s (key, target_h, opts)

      # TODO : use cache here as well

      return key if key.is_a?(String)

      keys = (target_h['_RH_K'] ||= {})
      k = "_RH_K#{keys.size}"
      keys[k] = to_h(key, opts)
      k
    end

    def self.get_cache (opts)
      (opts[:cache] ||= {})
    end

    def self.get_id (o)
      o.is_a?(String) ? o.hash : o.object_id
    end

    def self.cached (opts, o)
      i, rep = get_cache(opts)[get_id(o)]; i
    end

    def self.cache (opts, o, representation)
      c = get_cache(opts)
      c[get_id(o)] = [ c.size, representation ]
      representation
    end

    def self.flag (opts, o)
      i, rep = get_cache(opts)[get_id(o)]
      rep.is_a?(Array) ?  rep.unshift({ '_RH_I' => i }) : rep['_RH_I'] = i
    end
  end
end

