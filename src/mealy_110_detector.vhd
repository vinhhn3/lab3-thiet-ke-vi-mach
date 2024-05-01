-------------------------------------------------------------------------------
-- Title      : Mealy '110'-bit-sequence detector
-- Project    : Digital Design Practical Exercies
-------------------------------------------------------------------------------
-- File       : mealy_110_detector.vhd
-- Author     : Duy-Hieu Bui <hieubd@vnu.edu.vn>
-- Company    : 
-- Created    : 2013-05-29
-- Last update: 2017-11-30
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: a description of a mealy FSM to detect 110 sequence.
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2013-05-29  1.0      Duy-Hieu Bui    Created
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mealy_110_detector IS

  PORT (
    clk            : IN  STD_LOGIC;
    rst_n          : IN  STD_LOGIC;
    data_in        : IN  STD_LOGIC;
    detect_110_out : OUT STD_LOGIC);

END mealy_110_detector;

ARCHITECTURE behavioral OF mealy_110_detector IS

  TYPE state IS (IDLE, GOT1, GOT11);
  SIGNAL current_state : state;
  SIGNAL next_state    : state;

BEGIN  -- behavioral

  -- purpose: state register
  -- type   : sequential
  -- inputs : clk, rst_n, next_state
  -- outputs: current_state
  REG : PROCESS (clk, rst_n)
  BEGIN  -- PROCESS REG
    IF rst_n = '0' THEN                 -- asynchronous reset (active low)
      current_state <= IDLE;
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      current_state <= next_state;
    END IF;
  END PROCESS REG;

  -- purpose: calculate the transition of the FSM
  -- type   : combinational
  -- inputs : data_in, current_state
  -- outputs: next_state
  NEXTSTATE : PROCESS (data_in, current_state)
  BEGIN  -- PROCESS FSM

    CASE current_state IS
      WHEN IDLE =>
        IF data_in = '1' THEN
          next_state <= GOT1;
        ELSE
          next_state <= IDLE;
        END IF;
      WHEN GOT1 =>
        IF data_in = '1' THEN
          next_state <= GOT11;
        ELSE
          next_state <= IDLE;
        END IF;
      WHEN GOT11 =>
        IF data_in = '1' THEN
          next_state <= GOT11;
        ELSE
          next_state <= IDLE;
        END IF;
      WHEN OTHERS => NULL;
    END CASE;

  END PROCESS NEXTSTATE;

  detect_110_out <= '1' WHEN (current_state = GOT11 AND data_in = '0') ELSE '0';

END behavioral;
