LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-------------------------------------------------------------------------------

ENTITY fsm_101_detector_tb IS

END ENTITY fsm_101_detector_tb;

-------------------------------------------------------------------------------

ARCHITECTURE test OF fsm_101_detector_tb IS

  -- component ports
  SIGNAL clk                  : STD_LOGIC := '1';
  SIGNAL rst_n                : STD_LOGIC := '0';
  SIGNAL data_in              : STD_LOGIC := '0';
  SIGNAL moore_detect_101_out : STD_LOGIC;
  SIGNAL mealy_detect_101_out : STD_LOGIC;
  CONSTANT PERIOD             : TIME := 10 ns;
BEGIN -- ARCHITECTURE test

  -- component instantiation
  MOORE_DUT : ENTITY work.moore_101_detector
    PORT MAP
    (
      clk            => clk,
      rst_n          => rst_n,
      data_in        => data_in,
      detect_101_out => moore_detect_101_out);

  MEALY_DUT : ENTITY work.mealy_101_detector
    PORT MAP
    (
      clk            => clk,
      rst_n          => rst_n,
      data_in        => data_in,
      detect_101_out => mealy_detect_101_out
    );
  -- clock & reset generation
  clk_process : PROCESS
  BEGIN
    WHILE now < 200 ns LOOP
      clk <= '0';
      WAIT FOR PERIOD / 2;
      clk <= '1';
      WAIT FOR PERIOD / 2;
    END LOOP;
    WAIT;
  END PROCESS clk_process;
  -- Waveform generation and initialization block
  WaveGen_Proc : PROCESS
  BEGIN
    -- Wait for initial setup time
    WAIT FOR 2 * PERIOD + PERIOD / 4;

    -- Reset signal asserted
    rst_n <= '1';

    -- Wait for clock rising edge
    WAIT UNTIL rising_edge(clk);

    -- Wait for quarter period
    WAIT FOR PERIOD / 4;

    -- Generate waveform pattern
    data_in <= '1';
    WAIT FOR PERIOD * 1;
    data_in <= '0';
    WAIT FOR PERIOD * 1;
    data_in <= '1';

    -- Assertion for Moore state detect output after pattern generation
    WAIT UNTIL rising_edge(clk);
    WAIT FOR 2 ns;
    ASSERT moore_detect_101_out = '1' REPORT "Moore: 101 detected failed" SEVERITY ERROR;

    -- reset data_in
    data_in <= '0';
    WAIT FOR 5 * PERIOD;

    -- Repeat waveform generation and testing for a pattern 10101
    data_in <= '1';
    WAIT FOR PERIOD * 1;
    data_in <= '0';
    WAIT FOR PERIOD * 1;
    data_in <= '1';
    WAIT FOR PERIOD * 2;
    -- WAIT UNTIL rising_edge(clk);
    -- WAIT FOR 2 ns;
    -- ASSERT moore_detect_101_out = '1' REPORT "Moore: 101 detected" SEVERITY ERROR;
    data_in <= '0';
    WAIT FOR PERIOD * 1;
    data_in <= '1';
    WAIT UNTIL rising_edge(clk);
    WAIT FOR 2 ns;
    ASSERT moore_detect_101_out = '0' REPORT "Moore: 101 NOT detected" SEVERITY ERROR;

    -- End of testbench report
    REPORT "END fsm_101_detector_tb TESTBENCH";

    -- Wait indefinitely
    WAIT;
  END PROCESS WaveGen_Proc;

END ARCHITECTURE test;

-------------------------------------------------------------------------------

CONFIGURATION fsm_101_detector_tb_test_cfg OF fsm_101_detector_tb IS
  FOR test
  END FOR;
END fsm_101_detector_tb_test_cfg;

-------------------------------------------------------------------------------