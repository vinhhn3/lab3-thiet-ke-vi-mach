-------------------------------------------------------------------------------
-- Title      : Testbench for design "moore_110_detector"
-- Project    :
-------------------------------------------------------------------------------
-- File       : 110_detector_tb.vhd
-- Author     : Hieu D. Bui  <Hieu D. Bui@>
-- Company    : SISLAB, VNU-UET
-- Created    : 2017-11-30
-- Last update: 2017-11-30
-- Platform   :
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- Copyright (c) 2017 SISLAB, VNU-UET
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2017-11-30  1.0      Hieu D. Bui     Created
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-------------------------------------------------------------------------------

ENTITY fsm_110_detector_tb IS

END ENTITY fsm_110_detector_tb;

-------------------------------------------------------------------------------

ARCHITECTURE test OF fsm_110_detector_tb IS

  -- component ports
  SIGNAL clk                  : STD_LOGIC := '1';
  SIGNAL rst_n                : STD_LOGIC := '0';
  SIGNAL data_in              : STD_LOGIC := '0';
  SIGNAL moore_detect_110_out : STD_LOGIC;
  SIGNAL mealy_detect_110_out : STD_LOGIC;

  CONSTANT PERIOD : TIME := 10 ns;
BEGIN -- ARCHITECTURE test

  -- component instantiation
  MOORE_DUT : ENTITY work.moore_110_detector
    PORT MAP
    (
      clk            => clk,
      rst_n          => rst_n,
      data_in        => data_in,
      detect_110_out => moore_detect_110_out);

  MEALY_DUT : ENTITY work.mealy_110_detector
    PORT
    MAP (
    clk            => clk,
    rst_n          => rst_n,
    data_in        => data_in,
    detect_110_out => mealy_detect_110_out);

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

    -- Set initial data_in value
    data_in <= '1';

    -- Generate waveform pattern
    WAIT FOR PERIOD * 2;
    data_in <= '0';

    -- Assertion for Mealy state detect output after pattern generation
    WAIT FOR 2 ns;
    ASSERT mealy_detect_110_out = '1' REPORT "Mealy: 110 detected failed" SEVERITY ERROR;

    -- Assertion for Moore state detect output after pattern generation
    WAIT UNTIL rising_edge(clk);
    WAIT FOR 2 ns;
    ASSERT moore_detect_110_out = '1' REPORT "Moore: 110 detected failed" SEVERITY ERROR;

    -- Repeat waveform generation and testing for a different pattern

    -- Generate second waveform pattern
    WAIT FOR 3 * PERIOD;
    data_in <= '1';
    WAIT FOR 3 * PERIOD;
    data_in <= '0';

    -- Assertion for Mealy state detect output after second pattern generation
    WAIT FOR 2 ns;
    ASSERT mealy_detect_110_out = '1' REPORT "Mealy: 110 detected failed" SEVERITY ERROR;

    -- Assertion for Moore state detect output after second pattern generation
    WAIT UNTIL rising_edge(clk);
    WAIT FOR 2 ns;
    ASSERT moore_detect_110_out = '1' REPORT "Moore: 110 detected failed" SEVERITY ERROR;

    -- End of testbench report
    REPORT "END fsm_110_detector_tb TESTBENCH";

    -- Wait indefinitely
    WAIT;
  END PROCESS WaveGen_Proc;

END ARCHITECTURE test;

-------------------------------------------------------------------------------

CONFIGURATION fsm_110_detector_tb_test_cfg OF fsm_110_detector_tb IS
  FOR test
  END FOR;
END fsm_110_detector_tb_test_cfg;

-------------------------------------------------------------------------------