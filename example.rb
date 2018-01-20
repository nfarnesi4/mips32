require_relative "./tb"

# Example of declarative test_bench
TB.generate :andd do |tb|
    # Declare DUT
    tb.dut.generic n: TB::Types::Natural.new
    tb.dut.port x: TB::Types::Input.new(  TB::Types::GenericSTDLogicVector.new(:n) ),
                y: TB::Types::Input.new(  TB::Types::GenericSTDLogicVector.new(:n) ),
                z: TB::Types::Output.new( TB::Types::GenericSTDLogicVector.new(:n) )

    # Run test
    tb.generic_set n:2
    tb.test_with TB::TruthTable.new(
              tb.head(:x, :y, :z),
                    [[ 0,  0,  0],
                     [ 1,  0,  0],
                     [ 0,  1,  0],
                     [ 1,  1,  1]])
                .bit_agnostic(2)
end
