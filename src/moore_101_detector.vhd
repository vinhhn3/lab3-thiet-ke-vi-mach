
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY moore_101_detector IS

  PORT
  (
    clk            : IN STD_LOGIC;
    rst_n          : IN STD_LOGIC;
    data_in        : IN STD_LOGIC;
    detect_101_out : OUT STD_LOGIC);

END moore_101_detector;

ARCHITECTURE behavioral OF moore_101_detector IS

  TYPE state_t IS (IDLE, GOT1, GOT10, GOT101);
  SIGNAL current_state : state_t;
  SIGNAL next_state    : state_t;

BEGIN -- behavioral

  -- purpose: state register
  -- type   : sequential
  -- inputs : clk, rst_n, next_state
  -- outputs: current_state
  REG : PROCESS (clk, rst_n)
  BEGIN -- PROCESS REG
    IF rst_n = '0' THEN -- asynchronous reset (active low)
      current_state <= IDLE;
    ELSIF clk'EVENT AND clk = '1' THEN -- rising clock edge
      current_state <= next_state;
    END IF;
  END PROCESS REG;

  -- purpose: calculate the transition of the FSM
  -- type   : combinational
  -- inputs : data_in, current_state
  -- outputs: next_state
  NEXTSTATE : PROCESS (data_in, current_state)
  BEGIN -- PROCESS FSM

    CASE current_state IS
      WHEN IDLE =>
        IF data_in = '1' THEN
          next_state <= GOT1;
        ELSE
          next_state <= IDLE;
        END IF;
      WHEN GOT1 =>
        IF data_in = '0' THEN
          next_state <= GOT10;
        ELSE
          next_state <= IDLE;
        END IF;
      WHEN GOT10 =>
        IF data_in = '1' THEN
          next_state <= GOT101;
        ELSE
          next_state <= GOT10;
        END IF;
      WHEN GOT101 =>
        IF data_in = '1' THEN
          next_state <= GOT101;
        ELSE
          next_state <= IDLE;
        END IF;
      WHEN OTHERS => NULL;
    END CASE;

  END PROCESS NEXTSTATE;

  detect_101_out <= '1' WHEN current_state = GOT101 ELSE
    '0';

END behavioral;