module TB
    module Types
        class Type
            def signal; self; end
            def generic_set(gs); self; end
        end
        class Directioned < Type
            def initialize(value); @value=value; end
            def signal; @value; end
            def generic_set(gs); self.class.new(@value.generic_set(gs)); end
        end
        class Input < Directioned
            def to_vhd; "in #{@value.to_vhd}"; end
        end
        class Output < Directioned
            def to_vhd; "out #{@value.to_vhd}"; end
        end
        class STDLogic < Type; def to_vhd; "std_logic"; end; end
        class Natural < Type; def to_vhd; "natural"; end; end
        class STDLogicVector < Type
            def self.vsize(gval); STDLogicVector.new(gval-1, 0); end
            def self.generic_vsize(gvar); STDLogicVector.new("#{gvar}-1", 0); end
            def initialize(msb,lsb); @msb=msb; @lsb=lsb; end
            def to_vhd; "std_logic_vector(#{@msb} downto #{@lsb})"; end
            def is_generic?; @msb.is_a?(String); end
        end
        class GenericSTDLogicVector < Type
            def initialize name; @name = name; end
            def to_vhd; "std_logic_vector(#{@name}-1 downto 0)"; end
            def generic_set(gs); STDLogicVector.new(gs[@name]-1, 0); end
        end
    end

    # ------------------------------------------------------------------------------

    class NamedMapping
        attr :name
        def initialize(name, mps={}); @name = name; @mps = mps; end
        def set(mps); @mps = mps; end
        def empty?; @mps.empty?; end
        def to_vhd; "#{name} ( #{vhd_for_each_map.join(";\n")} );\n" end
        def signals; @mps.each.collect{|k,v| [k,v.signal]}.to_h; end
        def generic_set(gs); NamedMapping.new(@name, @mps.each.collect { |k,v| [k,v.generic_set(gs) ]}.to_h); end
        def keys; @mps.keys.to_a; end
        def input_names; @mps.each.select{|k,v| v.is_a? TB::Types::Input}.collect{|k,v| k}; end
        def output_names; @mps.each.select{|k,v| v.is_a? TB::Types::Output}.collect{|k,v| k}; end
        def [](index); @mps[index]; end

        private

        def vhd_for_each_map; @mps.each.collect{|k,v| "#{k} : #{v.to_vhd}"}; end
    end

    class Component
        attr :name

        def initialize name
            @name = name
            @generic = NamedMapping.new "generic"
            @port = NamedMapping.new "port"
        end

        def generic(mps={}); @generic.set(mps); end
        def port(mps={}); @port.set(mps); end

        def input_names; @port.input_names; end
        def output_names; @port.output_names; end

        def to_vhd
            "component #{@name} is\n" \
            + @generic.to_vhd \
            + @port.to_vhd \
            + "end component;"
        end

        def assignment gmap
            Assignment.new @name, gmap, @port.keys
        end

        def signals gmap
            Signals.new @port.generic_set(gmap).signals
        end
    end

    class Assignment
        attr :name

        def initialize name, gmaps, pmaps
            @name = name
            @gmaps = gmaps
            @pmaps = pmaps
        end

        def to_vhd
            "dut: #{name} #{generic_map} #{port_map};"
        end

        private

        def generic_map
            @gmaps.empty? ? "" : "generic map(#{ generic_map_sa.join(", ") })"
        end

        def port_map
            @pmaps.empty? ? "" : "port map(#{ port_map_sa.join(", ") })"
        end

        def generic_map_sa
            @gmaps.each.collect { |k,v| "#{k} => #{v}" }
        end

        def port_map_sa
            @pmaps.each.collect { |k| "#{k} => #{k}" }
        end
    end

    class Signals
        attr :maps

        def initialize maps
            @maps = maps
        end

        def [] index
            @maps[index]
        end

        def to_vhd
            @maps.each.collect{ |k,v| "signal #{k} : #{v.to_vhd};" }.join("\n")
        end
    end

    # ------------------------------------------------------------------------------

    class TruthTable
        attr :head, :data

        def initialize head, data
            @head = head
            @data = data
        end

        def bit_agnostic bits
            newdata = []
            bits.times do |n|
                newdata += @data.collect { |row| row.collect { |cell| cell << n } }
            end
            return TruthTable.new @head, newdata
        end

        def to_vhd
            record_type_vhd + "\n" \
            + array_type_vhd + "\n" \
            + data_array_vhd
        end

        private

        def record_type_vhd
            "type pattern_type is record\n" \
            + @head.collect{|col| "#{col[0]} : #{col[1].to_vhd};"}.join("\n") \
            + "\nend record;"
        end

        def array_type_vhd
            "type pattern_array is array (natural range <>) of pattern_type;"
        end

        def data_array_vhd
            "constant patterns : pattern_array := (\n"\
            + @data.collect { |row| "(" + row.collect{|v| "X\"#{v.to_s(16)}\""}.join(", ") + ")" }.join(",\n") \
            + ");"
        end
    end

    # ------------------------------------------------------------------------------

    class TestBench
        attr :dut

        def initialize name
            @dut = Component.new name
            @generics = {}
            @table = nil
        end

        def head *names
            names.collect { |name|
                [ name, @dut.signals(@generics)[name] ] }
        end

        def generic_set opts
            @generics = opts
        end

        def test_with table
            @table = table
        end

        def to_vhd
            "-- Entity declaration\n" \
            + "entity #{@dut.name}_tb is end entity;\n\n" \
            + "-- Behavioral declaration\n" \
            + "architecture behav of #{@dut.name}_tb is\n\n" \
            + arch_head_vhd + "\n\n" \
            + "begin\n\n" \
            + arch_assignment_vhd + "\n\n" \
            + "process\n\n" \
            + arch_table_vhd + "\n\n"\
            + "begin\n\n" \
            + arch_test_logic + "\n\n" \
            + "end process;\n" \
            + "end architecture;"
        end

        private

        def arch_head_vhd
            "-- Component declaration\n" \
            + @dut.to_vhd + "\n\n" \
            + "-- Signal declaration\n" \
            + @dut.signals(@generics).to_vhd
        end

        def arch_assignment_vhd
            "-- Assign DUT\n" \
            + @dut.assignment(@generics).to_vhd
        end

        def arch_table_vhd
            "-- Table Declaration\n" \
            + @table.to_vhd
        end

        def arch_test_logic
            "-- Test Logic\n"\
            + "for i in patterns'range loop\n\n" \
            + input_sets + "\n\n" \
            + "wait for 1 ns;\n\n" \
            + output_assertions + "\n\n" \
            + "end loop;\n" \
            + "assert false report \"end of test\" severity note;\n" \
            + "wait;" \
        end

        def input_sets
            "-- Set variables\n"\
            + @dut.input_names.collect{|name|
                "#{name} <= patterns(i).#{name}"}
            .join("\n")
        end

        def output_assertions
            "-- Run assertions\n"\
            + @dut.output_names.collect{|name|
                "assert #{name} = patterns(i).#{name} report \"bad #{@dut.name} value for #{name}\" severity error;"}
            .join("\n")
        end
    end

    def self.generate name
        tb = TestBench.new name
        yield tb
        File.open("#{name}_tb.vhd", "w+") { |f| f.write tb.to_vhd }
    end
end

# ------------------------------------------------------------------------------
