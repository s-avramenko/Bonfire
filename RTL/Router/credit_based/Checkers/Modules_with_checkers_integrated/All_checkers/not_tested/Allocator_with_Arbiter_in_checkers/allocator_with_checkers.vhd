--Copyright (C) 2016 Siavoosh Payandeh Azad Behrad Niazmand

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity allocator is      
    port (  reset: in  std_logic;
            clk: in  std_logic;
            -- flow control
            credit_in_N, credit_in_E, credit_in_W, credit_in_S, credit_in_L: in std_logic;

           	req_N_N, req_N_E, req_N_W, req_N_S, req_N_L: in std_logic;
           	req_E_N, req_E_E, req_E_W, req_E_S, req_E_L: in std_logic;
           	req_W_N, req_W_E, req_W_W, req_W_S, req_W_L: in std_logic;
           	req_S_N, req_S_E, req_S_W, req_S_S, req_S_L: in std_logic;
           	req_L_N, req_L_E, req_L_W, req_L_S, req_L_L: in std_logic;

            empty_N, empty_E, empty_W, empty_S, empty_L: in std_logic;
           	-- grant_X_Y means the grant for X output port towards Y input port
           	-- this means for any X in [N, E, W, S, L] then set grant_X_Y is one hot!
            valid_N, valid_E, valid_W, valid_S, valid_L : out std_logic;

           	grant_N_N, grant_N_E, grant_N_W, grant_N_S, grant_N_L: out std_logic;
           	grant_E_N, grant_E_E, grant_E_W, grant_E_S, grant_E_L: out std_logic;
           	grant_W_N, grant_W_E, grant_W_W, grant_W_S, grant_W_L: out std_logic;
           	grant_S_N, grant_S_E, grant_S_W, grant_S_S, grant_S_L: out std_logic;
           	grant_L_N, grant_L_E, grant_L_W, grant_L_S, grant_L_L: out std_logic;

            -- Arbiter_in checker outputs

            -- North Arbiter_in checker outputs
            N_err_Requests_state_in_state_not_equal, 

            N_err_IDLE_Req_N, 
            N_err_IDLE_grant_N,
            N_err_North_Req_N, 
            N_err_North_grant_N, 
            N_err_East_Req_E, 
            N_err_East_grant_E, 
            N_err_West_Req_W, 
            N_err_West_grant_W, 
            N_err_South_Req_S,
            N_err_South_grant_S,
            N_err_Local_Req_L, 
            N_err_Local_grant_L,

            N_err_IDLE_Req_E,
            N_err_IDLE_grant_E,
            N_err_North_Req_E,
            N_err_North_grant_E,
            N_err_East_Req_W,
            N_err_East_grant_W,
            N_err_West_Req_S,
            N_err_West_grant_S,
            N_err_South_Req_L,
            N_err_South_grant_L,
            N_err_Local_Req_N,
            N_err_Local_grant_N,

            N_err_IDLE_Req_W,
            N_err_IDLE_grant_W,
            N_err_North_Req_W,
            N_err_North_grant_W,
            N_err_East_Req_S,
            N_err_East_grant_S,
            N_err_West_Req_L,
            N_err_West_grant_L,
            N_err_South_Req_N, 
            N_err_South_grant_N,
            N_err_Local_Req_E,
            N_err_Local_grant_E, 

            N_err_IDLE_Req_S, 
            N_err_IDLE_grant_S, 
            N_err_North_Req_S, 
            N_err_North_grant_S, 
            N_err_East_Req_L, 
            N_err_East_grant_L, 
            N_err_West_Req_N, 
            N_err_West_grant_N, 
            N_err_South_Req_E, 
            N_err_South_grant_E, 
            N_err_Local_Req_W, 
            N_err_Local_grant_W, 

            N_err_IDLE_Req_L, 
            N_err_IDLE_grant_L, 
            N_err_North_Req_L, 
            N_err_North_grant_L, 
            N_err_East_Req_N, 
            N_err_East_grant_N, 
            N_err_West_Req_E, 
            N_err_West_grant_E, 
            N_err_South_Req_W, 
            N_err_South_grant_W, 
            N_err_Local_Req_S, 
            N_err_Local_grant_S, 

            N_err_state_in_onehot, 
            N_err_no_request_grants, 
            N_err_request_no_grants, 

            N_err_no_Req_N_grant_N,
            N_err_no_Req_E_grant_E, 
            N_err_no_Req_W_grant_W, 
            N_err_no_Req_S_grant_S, 
            N_err_no_Req_L_grant_L, 

            -- East Arbiter_in checker outputs
            E_err_Requests_state_in_state_not_equal, 

            E_err_IDLE_Req_N, 
            E_err_IDLE_grant_N,
            E_err_North_Req_N, 
            E_err_North_grant_N, 
            E_err_East_Req_E, 
            E_err_East_grant_E, 
            E_err_West_Req_W, 
            E_err_West_grant_W, 
            E_err_South_Req_S,
            E_err_South_grant_S,
            E_err_Local_Req_L, 
            E_err_Local_grant_L,

            E_err_IDLE_Req_E,
            E_err_IDLE_grant_E,
            E_err_North_Req_E,
            E_err_North_grant_E,
            E_err_East_Req_W,
            E_err_East_grant_W,
            E_err_West_Req_S,
            E_err_West_grant_S,
            E_err_South_Req_L,
            E_err_South_grant_L,
            E_err_Local_Req_N,
            E_err_Local_grant_N,

            E_err_IDLE_Req_W,
            E_err_IDLE_grant_W,
            E_err_North_Req_W,
            E_err_North_grant_W,
            E_err_East_Req_S,
            E_err_East_grant_S,
            E_err_West_Req_L,
            E_err_West_grant_L,
            E_err_South_Req_N, 
            E_err_South_grant_N,
            E_err_Local_Req_E,
            E_err_Local_grant_E, 

            E_err_IDLE_Req_S, 
            E_err_IDLE_grant_S, 
            E_err_North_Req_S, 
            E_err_North_grant_S, 
            E_err_East_Req_L, 
            E_err_East_grant_L, 
            E_err_West_Req_N, 
            E_err_West_grant_N, 
            E_err_South_Req_E, 
            E_err_South_grant_E, 
            E_err_Local_Req_W, 
            E_err_Local_grant_W, 

            E_err_IDLE_Req_L, 
            E_err_IDLE_grant_L, 
            E_err_North_Req_L, 
            E_err_North_grant_L, 
            E_err_East_Req_N, 
            E_err_East_grant_N, 
            E_err_West_Req_E, 
            E_err_West_grant_E, 
            E_err_South_Req_W, 
            E_err_South_grant_W, 
            E_err_Local_Req_S, 
            E_err_Local_grant_S, 

            E_err_state_in_onehot, 
            E_err_no_request_grants, 
            E_err_request_no_grants, 

            E_err_no_Req_N_grant_N,
            E_err_no_Req_E_grant_E, 
            E_err_no_Req_W_grant_W, 
            E_err_no_Req_S_grant_S, 
            E_err_no_Req_L_grant_L, 

            -- West Arbiter_in checker outputs
            W_err_Requests_state_in_state_not_equal, 

            W_err_IDLE_Req_N, 
            W_err_IDLE_grant_N,
            W_err_North_Req_N, 
            W_err_North_grant_N, 
            W_err_East_Req_E, 
            W_err_East_grant_E, 
            W_err_West_Req_W, 
            W_err_West_grant_W, 
            W_err_South_Req_S,
            W_err_South_grant_S,
            W_err_Local_Req_L, 
            W_err_Local_grant_L,

            W_err_IDLE_Req_E,
            W_err_IDLE_grant_E,
            W_err_North_Req_E,
            W_err_North_grant_E,
            W_err_East_Req_W,
            W_err_East_grant_W,
            W_err_West_Req_S,
            W_err_West_grant_S,
            W_err_South_Req_L,
            W_err_South_grant_L,
            W_err_Local_Req_N,
            W_err_Local_grant_N,

            W_err_IDLE_Req_W,
            W_err_IDLE_grant_W,
            W_err_North_Req_W,
            W_err_North_grant_W,
            W_err_East_Req_S,
            W_err_East_grant_S,
            W_err_West_Req_L,
            W_err_West_grant_L,
            W_err_South_Req_N, 
            W_err_South_grant_N,
            W_err_Local_Req_E,
            W_err_Local_grant_E, 

            W_err_IDLE_Req_S, 
            W_err_IDLE_grant_S, 
            W_err_North_Req_S, 
            W_err_North_grant_S, 
            W_err_East_Req_L, 
            W_err_East_grant_L, 
            W_err_West_Req_N, 
            W_err_West_grant_N, 
            W_err_South_Req_E, 
            W_err_South_grant_E, 
            W_err_Local_Req_W, 
            W_err_Local_grant_W, 

            W_err_IDLE_Req_L, 
            W_err_IDLE_grant_L, 
            W_err_North_Req_L, 
            W_err_North_grant_L, 
            W_err_East_Req_N, 
            W_err_East_grant_N, 
            W_err_West_Req_E, 
            W_err_West_grant_E, 
            W_err_South_Req_W, 
            W_err_South_grant_W, 
            W_err_Local_Req_S, 
            W_err_Local_grant_S, 

            W_err_state_in_onehot, 
            W_err_no_request_grants, 
            W_err_request_no_grants, 

            W_err_no_Req_N_grant_N,
            W_err_no_Req_E_grant_E, 
            W_err_no_Req_W_grant_W, 
            W_err_no_Req_S_grant_S, 
            W_err_no_Req_L_grant_L, 

            -- South Arbiter_in checker outputs
            S_err_Requests_state_in_state_not_equal, 

            S_err_IDLE_Req_N, 
            S_err_IDLE_grant_N,
            S_err_North_Req_N, 
            S_err_North_grant_N, 
            S_err_East_Req_E, 
            S_err_East_grant_E, 
            S_err_West_Req_W, 
            S_err_West_grant_W, 
            S_err_South_Req_S,
            S_err_South_grant_S,
            S_err_Local_Req_L, 
            S_err_Local_grant_L,

            S_err_IDLE_Req_E,
            S_err_IDLE_grant_E,
            S_err_North_Req_E,
            S_err_North_grant_E,
            S_err_East_Req_W,
            S_err_East_grant_W,
            S_err_West_Req_S,
            S_err_West_grant_S,
            S_err_South_Req_L,
            S_err_South_grant_L,
            S_err_Local_Req_N,
            S_err_Local_grant_N,

            S_err_IDLE_Req_W,
            S_err_IDLE_grant_W,
            S_err_North_Req_W,
            S_err_North_grant_W,
            S_err_East_Req_S,
            S_err_East_grant_S,
            S_err_West_Req_L,
            S_err_West_grant_L,
            S_err_South_Req_N, 
            S_err_South_grant_N,
            S_err_Local_Req_E,
            S_err_Local_grant_E, 

            S_err_IDLE_Req_S, 
            S_err_IDLE_grant_S, 
            S_err_North_Req_S, 
            S_err_North_grant_S, 
            S_err_East_Req_L, 
            S_err_East_grant_L, 
            S_err_West_Req_N, 
            S_err_West_grant_N, 
            S_err_South_Req_E, 
            S_err_South_grant_E, 
            S_err_Local_Req_W, 
            S_err_Local_grant_W, 

            S_err_IDLE_Req_L, 
            S_err_IDLE_grant_L, 
            S_err_North_Req_L, 
            S_err_North_grant_L, 
            S_err_East_Req_N, 
            S_err_East_grant_N, 
            S_err_West_Req_E, 
            S_err_West_grant_E, 
            S_err_South_Req_W, 
            S_err_South_grant_W, 
            S_err_Local_Req_S, 
            S_err_Local_grant_S, 

            S_err_state_in_onehot, 
            S_err_no_request_grants, 
            S_err_request_no_grants, 

            S_err_no_Req_N_grant_N,
            S_err_no_Req_E_grant_E, 
            S_err_no_Req_W_grant_W, 
            S_err_no_Req_S_grant_S, 
            S_err_no_Req_L_grant_L, 

            -- Local Arbiter_in checker outputs
            L_err_Requests_state_in_state_not_equal, 

            L_err_IDLE_Req_N, 
            L_err_IDLE_grant_N,
            L_err_North_Req_N, 
            L_err_North_grant_N, 
            L_err_East_Req_E, 
            L_err_East_grant_E, 
            L_err_West_Req_W, 
            L_err_West_grant_W, 
            L_err_South_Req_S,
            L_err_South_grant_S,
            L_err_Local_Req_L, 
            L_err_Local_grant_L,

            L_err_IDLE_Req_E,
            L_err_IDLE_grant_E,
            L_err_North_Req_E,
            L_err_North_grant_E,
            L_err_East_Req_W,
            L_err_East_grant_W,
            L_err_West_Req_S,
            L_err_West_grant_S,
            L_err_South_Req_L,
            L_err_South_grant_L,
            L_err_Local_Req_N,
            L_err_Local_grant_N,

            L_err_IDLE_Req_W,
            L_err_IDLE_grant_W,
            L_err_North_Req_W,
            L_err_North_grant_W,
            L_err_East_Req_S,
            L_err_East_grant_S,
            L_err_West_Req_L,
            L_err_West_grant_L,
            L_err_South_Req_N, 
            L_err_South_grant_N,
            L_err_Local_Req_E,
            L_err_Local_grant_E, 

            L_err_IDLE_Req_S, 
            L_err_IDLE_grant_S, 
            L_err_North_Req_S, 
            L_err_North_grant_S, 
            L_err_East_Req_L, 
            L_err_East_grant_L, 
            L_err_West_Req_N, 
            L_err_West_grant_N, 
            L_err_South_Req_E, 
            L_err_South_grant_E, 
            L_err_Local_Req_W, 
            L_err_Local_grant_W, 

            L_err_IDLE_Req_L, 
            L_err_IDLE_grant_L, 
            L_err_North_Req_L, 
            L_err_North_grant_L, 
            L_err_East_Req_N, 
            L_err_East_grant_N, 
            L_err_West_Req_E, 
            L_err_West_grant_E, 
            L_err_South_Req_W, 
            L_err_South_grant_W, 
            L_err_Local_Req_S, 
            L_err_Local_grant_S, 

            L_err_state_in_onehot, 
            L_err_no_request_grants, 
            L_err_request_no_grants, 

            L_err_no_Req_N_grant_N,
            L_err_no_Req_E_grant_E, 
            L_err_no_Req_W_grant_W, 
            L_err_no_Req_S_grant_S, 
            L_err_no_Req_L_grant_L : out std_logic   
            );
end allocator;

architecture behavior of allocator is

-- so the idea is that we should have counters that keep track of credit!
signal credit_counter_N_in, credit_counter_N_out: std_logic_vector(1 downto 0);
signal credit_counter_E_in, credit_counter_E_out: std_logic_vector(1 downto 0);
signal credit_counter_W_in, credit_counter_W_out: std_logic_vector(1 downto 0);
signal credit_counter_S_in, credit_counter_S_out: std_logic_vector(1 downto 0);
signal credit_counter_L_in, credit_counter_L_out: std_logic_vector(1 downto 0);

signal grant_N, grant_E, grant_W, grant_S, grant_L: std_logic;

signal X_N_N, X_N_E, X_N_W, X_N_S, X_N_L: std_logic;
signal X_E_N, X_E_E, X_E_W, X_E_S, X_E_L: std_logic;
signal X_W_N, X_W_E, X_W_W, X_W_S, X_W_L: std_logic;
signal X_S_N, X_S_E, X_S_W, X_S_S, X_S_L: std_logic;
signal X_L_N, X_L_E, X_L_W, X_L_S, X_L_L: std_logic;

signal grant_N_N_sig, grant_N_E_sig, grant_N_W_sig, grant_N_S_sig, grant_N_L_sig: std_logic;
signal grant_E_N_sig, grant_E_E_sig, grant_E_W_sig, grant_E_S_sig, grant_E_L_sig: std_logic;
signal grant_W_N_sig, grant_W_E_sig, grant_W_W_sig, grant_W_S_sig, grant_W_L_sig: std_logic;
signal grant_S_N_sig, grant_S_E_sig, grant_S_W_sig, grant_S_S_sig, grant_S_L_sig: std_logic;
signal grant_L_N_sig, grant_L_E_sig, grant_L_W_sig, grant_L_S_sig, grant_L_L_sig: std_logic;

component Arbiter_in is
    port (  reset: in std_logic;
            clk: in std_logic;
            Req_X_N, Req_X_E, Req_X_W, Req_X_S, Req_X_L: in std_logic; -- From LBDR modules

            X_N, X_E, X_W, X_S, X_L: out std_logic; -- Grants given to LBDR requests (encoded as one-hot)

            -- Checker outputs
            err_Requests_state_in_state_not_equal, 

            err_IDLE_Req_N, 
            err_IDLE_grant_N,
            err_North_Req_N, 
            err_North_grant_N, 
            err_East_Req_E, 
            err_East_grant_E, 
            err_West_Req_W, 
            err_West_grant_W, 
            err_South_Req_S,
            err_South_grant_S,
            err_Local_Req_L, 
            err_Local_grant_L,

            err_IDLE_Req_E,
            err_IDLE_grant_E,
            err_North_Req_E,
            err_North_grant_E,
            err_East_Req_W,
            err_East_grant_W,
            err_West_Req_S,
            err_West_grant_S,
            err_South_Req_L,
            err_South_grant_L,
            err_Local_Req_N,
            err_Local_grant_N,

            err_IDLE_Req_W,
            err_IDLE_grant_W,
            err_North_Req_W,
            err_North_grant_W,
            err_East_Req_S,
            err_East_grant_S,
            err_West_Req_L,
            err_West_grant_L,
            err_South_Req_N, 
            err_South_grant_N,
            err_Local_Req_E,
            err_Local_grant_E, 

            err_IDLE_Req_S, 
            err_IDLE_grant_S, 
            err_North_Req_S, 
            err_North_grant_S, 
            err_East_Req_L, 
            err_East_grant_L, 
            err_West_Req_N, 
            err_West_grant_N, 
            err_South_Req_E, 
            err_South_grant_E, 
            err_Local_Req_W, 
            err_Local_grant_W, 

            err_IDLE_Req_L, 
            err_IDLE_grant_L, 
            err_North_Req_L, 
            err_North_grant_L, 
            err_East_Req_N, 
            err_East_grant_N, 
            err_West_Req_E, 
            err_West_grant_E, 
            err_South_Req_W, 
            err_South_grant_W, 
            err_Local_Req_S, 
            err_Local_grant_S, 

            err_state_in_onehot, 
            err_no_request_grants, 
            err_request_no_grants, 

            err_no_Req_N_grant_N,
            err_no_Req_E_grant_E, 
            err_no_Req_W_grant_W, 
            err_no_Req_S_grant_S, 
            err_no_Req_L_grant_L : out std_logic
          );
end component;

component arbiter_out is
    port (  reset: in  std_logic;
            clk: in  std_logic;
            X_N_Y, X_E_Y, X_W_Y, X_S_Y, X_L_Y:in std_logic; -- From LBDR modules
            credit: in std_logic_vector(1 downto 0);
            grant_Y_N, grant_Y_E, grant_Y_W, grant_Y_S, grant_Y_L :out std_logic -- Grants given to LBDR requests (encoded as one-hot)
            );
end component;

begin 
  
-- sequential part

process(clk, reset)
begin
	if reset = '0' then 
		-- we start with all full cradit
	 	credit_counter_N_out <= (others=>'1');
		credit_counter_E_out <= (others=>'1');
		credit_counter_W_out <= (others=>'1');
		credit_counter_S_out <= (others=>'1');
		credit_counter_L_out <= (others=>'1');
	elsif clk'event and clk = '1' then 
		credit_counter_N_out <= credit_counter_N_in;
		credit_counter_E_out <= credit_counter_E_in;
		credit_counter_W_out <= credit_counter_W_in;
		credit_counter_S_out <= credit_counter_S_in;
		credit_counter_L_out <= credit_counter_L_in;

	end if;
end process;
 
-- The combionational part

-- Taking Arbiter_in checker outputs to outputs of Allocator



    grant_N_N <= grant_N_N_sig and not empty_N;
    grant_N_E <= grant_N_E_sig and not empty_E;
    grant_N_W <= grant_N_W_sig and not empty_W;
    grant_N_S <= grant_N_S_sig and not empty_S;
    grant_N_L <= grant_N_L_sig and not empty_L;

    grant_E_N <= grant_E_N_sig and not empty_N;
    grant_E_E <= grant_E_E_sig and not empty_E;
    grant_E_W <= grant_E_W_sig and not empty_W;
    grant_E_S <= grant_E_S_sig and not empty_S;
    grant_E_L <= grant_E_L_sig and not empty_L;

    grant_W_N <= grant_W_N_sig and not empty_N;
    grant_W_E <= grant_W_E_sig and not empty_E;
    grant_W_W <= grant_W_W_sig and not empty_W;
    grant_W_S <= grant_W_S_sig and not empty_S;
    grant_W_L <= grant_W_L_sig and not empty_L;

    grant_S_N <= grant_S_N_sig and not empty_N;
    grant_S_E <= grant_S_E_sig and not empty_E;
    grant_S_W <= grant_S_W_sig and not empty_W;
    grant_S_S <= grant_S_S_sig and not empty_S;
    grant_S_L <= grant_S_L_sig and not empty_L;

    grant_L_N <= grant_L_N_sig and not empty_N;
    grant_L_E <= grant_L_E_sig and not empty_E;
    grant_L_W <= grant_L_W_sig and not empty_W;
    grant_L_S <= grant_L_S_sig and not empty_S;
    grant_L_L <= grant_L_L_sig and not empty_L;
    
grant_N <=  (grant_N_N_sig and not empty_N )or (grant_N_E_sig and not empty_E) or (grant_N_W_sig and not empty_W) or (grant_N_S_sig and not empty_S) or (grant_N_L_sig and not empty_L);
grant_E <=  (grant_E_N_sig and not empty_N )or (grant_E_E_sig and not empty_E) or (grant_E_W_sig and not empty_W) or (grant_E_S_sig and not empty_S) or (grant_E_L_sig and not empty_L);
grant_W <=  (grant_W_N_sig and not empty_N )or (grant_W_E_sig and not empty_E) or (grant_W_W_sig and not empty_W) or (grant_W_S_sig and not empty_S) or (grant_W_L_sig and not empty_L);
grant_S <=  (grant_S_N_sig and not empty_N )or (grant_S_E_sig and not empty_E) or (grant_S_W_sig and not empty_W) or (grant_S_S_sig and not empty_S) or (grant_S_L_sig and not empty_L);
grant_L <=  (grant_L_N_sig and not empty_N )or (grant_L_E_sig and not empty_E) or (grant_L_W_sig and not empty_W) or (grant_L_S_sig and not empty_S) or (grant_L_L_sig and not empty_L);

-- this process handels the credit counters!
process(credit_in_N, credit_in_E, credit_in_W, credit_in_S, credit_in_L, grant_N, grant_E, grant_W, grant_S, grant_L,
		credit_counter_N_out, credit_counter_E_out, credit_counter_W_out, credit_counter_S_out, credit_counter_L_out
		)
 begin
 	credit_counter_N_in <= credit_counter_N_out;
 	credit_counter_E_in <= credit_counter_E_out;
 	credit_counter_W_in <= credit_counter_W_out;
 	credit_counter_S_in <= credit_counter_S_out;
 	credit_counter_L_in <= credit_counter_L_out;

 	if credit_in_N = '1' and grant_N = '1' then 
       credit_counter_N_in <= credit_counter_N_out; 
  elsif credit_in_N = '1'  and credit_counter_N_out < 3 then 
 		   credit_counter_N_in <= credit_counter_N_out + 1;
 	elsif grant_N = '1' and credit_counter_N_out > 0 then
 		   credit_counter_N_in <= credit_counter_N_out - 1;
 	end if;
 	

  if credit_in_E = '1' and grant_E = '1' then 
       credit_counter_E_in <= credit_counter_E_out; 
 	elsif credit_in_E = '1' and credit_counter_E_out < 3 then 
 		credit_counter_E_in <= credit_counter_E_out + 1;
 	elsif grant_E = '1' and credit_counter_E_out > 0 then
 		credit_counter_E_in <= credit_counter_E_out - 1;
 	end if;

 	if credit_in_W = '1' and grant_W = '1' then 
       credit_counter_W_in <= credit_counter_W_out; 
  elsif credit_in_W = '1' and credit_counter_W_out < 3 then 
    credit_counter_W_in <= credit_counter_W_out + 1;
  elsif grant_W = '1' and credit_counter_W_out > 0 then
    credit_counter_W_in <= credit_counter_W_out - 1;
  end if;

 	if credit_in_S = '1' and grant_S = '1' then 
       credit_counter_S_in <= credit_counter_S_out; 
  elsif credit_in_S = '1' and credit_counter_S_out < 3 then 
    credit_counter_S_in <= credit_counter_S_out + 1;
  elsif grant_S = '1' and credit_counter_S_out > 0 then
    credit_counter_S_in <= credit_counter_S_out - 1;
  end if;

 	
 	if credit_in_L = '1' and grant_L = '1' then 
       credit_counter_L_in <= credit_counter_L_out; 
  elsif credit_in_L = '1' and credit_counter_L_out < 3 then 
    credit_counter_L_in <= credit_counter_L_out + 1;
  elsif grant_L = '1' and credit_counter_L_out > 0 then
    credit_counter_L_in <= credit_counter_L_out - 1;
  end if;

 end process;

-- North Arbiter_in with checkers integrated
arb_N_X: Arbiter_in  PORT MAP (reset => reset, clk => clk,
				                       Req_X_N=>req_N_N, Req_X_E=> req_N_E, Req_X_W=>req_N_W, Req_X_S=>req_N_S, Req_X_L=>req_N_L,
                               X_N=>X_N_N, X_E=>X_N_E, X_W=>X_N_W, X_S=>X_N_S, X_L=>X_N_L, 
                                      
                               -- North Arbiter_in Checker outputs
                              err_Requests_state_in_state_not_equal => N_err_Requests_state_in_state_not_equal,
            
                              err_IDLE_Req_N =>    N_err_IDLE_Req_N,
                              err_IDLE_grant_N =>  N_err_IDLE_grant_N,
                              err_North_Req_N =>   N_err_North_Req_N,
                              err_North_grant_N => N_err_North_grant_N,
                              err_East_Req_E =>    N_err_East_Req_E,
                              err_East_grant_E =>  N_err_East_grant_E,
                              err_West_Req_W =>    N_err_West_Req_W,
                              err_West_grant_W =>  N_err_West_grant_W,
                              err_South_Req_S =>   N_err_South_Req_S,
                              err_South_grant_S => N_err_South_grant_S,
                              err_Local_Req_L =>   N_err_Local_Req_L,
                              err_Local_grant_L => N_err_Local_grant_L,
            
                              err_IDLE_Req_E => N_err_IDLE_Req_E,
                              err_IDLE_grant_E => N_err_IDLE_grant_E,
                              err_North_Req_E => N_err_North_Req_E,
                              err_North_grant_E => N_err_North_grant_E,
                              err_East_Req_W => N_err_East_Req_W,
                              err_East_grant_W => N_err_East_grant_W,
                              err_West_Req_S => N_err_West_Req_S,
                              err_West_grant_S => N_err_West_grant_S,
                              err_South_Req_L => N_err_South_Req_L,
                              err_South_grant_L => N_err_South_grant_L,
                              err_Local_Req_N => N_err_Local_Req_N,
                              err_Local_grant_N => N_err_Local_grant_N,
            
                              err_IDLE_Req_W => N_err_IDLE_Req_W,
                              err_IDLE_grant_W => N_err_IDLE_grant_W,
                              err_North_Req_W => N_err_North_Req_W,
                              err_North_grant_W => N_err_North_grant_W,
                              err_East_Req_S => N_err_East_Req_S,
                              err_East_grant_S => N_err_East_grant_S,
                              err_West_Req_L => N_err_West_Req_L,
                              err_West_grant_L => N_err_West_grant_L,
                              err_South_Req_N => N_err_South_Req_N,
                              err_South_grant_N => N_err_South_grant_N,
                              err_Local_Req_E => N_err_Local_Req_E,
                              err_Local_grant_E => N_err_Local_grant_E,
            
                              err_IDLE_Req_S => N_err_IDLE_Req_S,
                              err_IDLE_grant_S => N_err_IDLE_grant_S,
                              err_North_Req_S => N_err_North_Req_S,
                              err_North_grant_S => N_err_North_grant_S,
                              err_East_Req_L => N_err_East_Req_L,
                              err_East_grant_L => N_err_East_grant_L,
                              err_West_Req_N => N_err_West_Req_N,
                              err_West_grant_N => N_err_West_grant_N,
                              err_South_Req_E => N_err_South_Req_E,
                              err_South_grant_E => N_err_South_grant_E,
                              err_Local_Req_W => N_err_Local_Req_W,
                              err_Local_grant_W => N_err_Local_grant_W,
            
                              err_IDLE_Req_L => N_err_IDLE_Req_L,
                              err_IDLE_grant_L => N_err_IDLE_grant_L,
                              err_North_Req_L => N_err_North_Req_L,
                              err_North_grant_L => N_err_North_grant_L,
                              err_East_Req_N => N_err_East_Req_N,
                              err_East_grant_N => N_err_East_grant_N,
                              err_West_Req_E => N_err_West_Req_E,
                              err_West_grant_E => N_err_West_grant_E,
                              err_South_Req_W => N_err_South_Req_W,
                              err_South_grant_W => N_err_South_grant_W,
                              err_Local_Req_S => N_err_Local_Req_S,
                              err_Local_grant_S => N_err_Local_grant_S,
            
                              err_state_in_onehot   => N_err_state_in_onehot, 
                              err_no_request_grants => N_err_no_request_grants,
                              err_request_no_grants => N_err_request_no_grants, 

                              err_no_Req_N_grant_N => N_err_no_Req_N_grant_N,
                              err_no_Req_E_grant_E => N_err_no_Req_E_grant_E,
                              err_no_Req_W_grant_W => N_err_no_Req_W_grant_W,
                              err_no_Req_S_grant_S => N_err_no_Req_S_grant_S,
                              err_no_Req_L_grant_L => N_err_no_Req_L_grant_L                  
                               );

arb_E_X: Arbiter_in  PORT MAP (reset => reset, clk => clk,
				                       Req_X_N=>req_E_N, Req_X_E=> req_E_E, Req_X_W=>req_E_W, Req_X_S=>req_E_S, Req_X_L=>req_E_L,
                               X_N=>X_E_N, X_E=>X_E_E, X_W=>X_E_W, X_S=>X_E_S, X_L=>X_E_L, 
                                      
                               -- East Arbiter_in Checker outputs
                              err_Requests_state_in_state_not_equal => E_err_Requests_state_in_state_not_equal,
            
                              err_IDLE_Req_N =>    E_err_IDLE_Req_N,
                              err_IDLE_grant_N =>  E_err_IDLE_grant_N,
                              err_North_Req_N =>   E_err_North_Req_N,
                              err_North_grant_N => E_err_North_grant_N,
                              err_East_Req_E =>    E_err_East_Req_E,
                              err_East_grant_E =>  E_err_East_grant_E,
                              err_West_Req_W =>    E_err_West_Req_W,
                              err_West_grant_W =>  E_err_West_grant_W,
                              err_South_Req_S =>   E_err_South_Req_S,
                              err_South_grant_S => E_err_South_grant_S,
                              err_Local_Req_L =>   E_err_Local_Req_L,
                              err_Local_grant_L => E_err_Local_grant_L,
            
                              err_IDLE_Req_E => E_err_IDLE_Req_E,
                              err_IDLE_grant_E => E_err_IDLE_grant_E,
                              err_North_Req_E => E_err_North_Req_E,
                              err_North_grant_E => E_err_North_grant_E,
                              err_East_Req_W => E_err_East_Req_W,
                              err_East_grant_W => E_err_East_grant_W,
                              err_West_Req_S => E_err_West_Req_S,
                              err_West_grant_S => E_err_West_grant_S,
                              err_South_Req_L => E_err_South_Req_L,
                              err_South_grant_L => E_err_South_grant_L,
                              err_Local_Req_N => E_err_Local_Req_N,
                              err_Local_grant_N => E_err_Local_grant_N,
            
                              err_IDLE_Req_W => E_err_IDLE_Req_W,
                              err_IDLE_grant_W => E_err_IDLE_grant_W,
                              err_North_Req_W => E_err_North_Req_W,
                              err_North_grant_W => E_err_North_grant_W,
                              err_East_Req_S => E_err_East_Req_S,
                              err_East_grant_S => E_err_East_grant_S,
                              err_West_Req_L => E_err_West_Req_L,
                              err_West_grant_L => E_err_West_grant_L,
                              err_South_Req_N => E_err_South_Req_N,
                              err_South_grant_N => E_err_South_grant_N,
                              err_Local_Req_E => E_err_Local_Req_E,
                              err_Local_grant_E => E_err_Local_grant_E,
            
                              err_IDLE_Req_S => E_err_IDLE_Req_S,
                              err_IDLE_grant_S => E_err_IDLE_grant_S,
                              err_North_Req_S => E_err_North_Req_S,
                              err_North_grant_S => E_err_North_grant_S,
                              err_East_Req_L => E_err_East_Req_L,
                              err_East_grant_L => E_err_East_grant_L,
                              err_West_Req_N => E_err_West_Req_N,
                              err_West_grant_N => E_err_West_grant_N,
                              err_South_Req_E => E_err_South_Req_E,
                              err_South_grant_E => E_err_South_grant_E,
                              err_Local_Req_W => E_err_Local_Req_W,
                              err_Local_grant_W => E_err_Local_grant_W,
            
                              err_IDLE_Req_L => E_err_IDLE_Req_L,
                              err_IDLE_grant_L => E_err_IDLE_grant_L,
                              err_North_Req_L => E_err_North_Req_L,
                              err_North_grant_L => E_err_North_grant_L,
                              err_East_Req_N => E_err_East_Req_N,
                              err_East_grant_N => E_err_East_grant_N,
                              err_West_Req_E => E_err_West_Req_E,
                              err_West_grant_E => E_err_West_grant_E,
                              err_South_Req_W => E_err_South_Req_W,
                              err_South_grant_W => E_err_South_grant_W,
                              err_Local_Req_S => E_err_Local_Req_S,
                              err_Local_grant_S => E_err_Local_grant_S,
            
                              err_state_in_onehot   => E_err_state_in_onehot, 
                              err_no_request_grants => E_err_no_request_grants,
                              err_request_no_grants => E_err_request_no_grants, 

                              err_no_Req_N_grant_N => E_err_no_Req_N_grant_N,
                              err_no_Req_E_grant_E => E_err_no_Req_E_grant_E,
                              err_no_Req_W_grant_W => E_err_no_Req_W_grant_W,
                              err_no_Req_S_grant_S => E_err_no_Req_S_grant_S,
                              err_no_Req_L_grant_L => E_err_no_Req_L_grant_L 
                               );

arb_W_X: Arbiter_in  PORT MAP (reset => reset, clk => clk,
                               Req_X_N=>req_W_N, Req_X_E=> req_W_E, Req_X_W=>req_W_W, Req_X_S=>req_W_S, Req_X_L=>req_W_L,
                               X_N=>X_W_N, X_E=>X_W_E, X_W=>X_W_W, X_S=>X_W_S, X_L=>X_W_L, 
                                      
                               -- West Arbiter_in Checker outputs
                              err_Requests_state_in_state_not_equal => W_err_Requests_state_in_state_not_equal,
            
                              err_IDLE_Req_N =>    W_err_IDLE_Req_N,
                              err_IDLE_grant_N =>  W_err_IDLE_grant_N,
                              err_North_Req_N =>   W_err_North_Req_N,
                              err_North_grant_N => W_err_North_grant_N,
                              err_East_Req_E =>    W_err_East_Req_E,
                              err_East_grant_E =>  W_err_East_grant_E,
                              err_West_Req_W =>    W_err_West_Req_W,
                              err_West_grant_W =>  W_err_West_grant_W,
                              err_South_Req_S =>   W_err_South_Req_S,
                              err_South_grant_S => W_err_South_grant_S,
                              err_Local_Req_L =>   W_err_Local_Req_L,
                              err_Local_grant_L => W_err_Local_grant_L,
            
                              err_IDLE_Req_E => W_err_IDLE_Req_E,
                              err_IDLE_grant_E => W_err_IDLE_grant_E,
                              err_North_Req_E => W_err_North_Req_E,
                              err_North_grant_E => W_err_North_grant_E,
                              err_East_Req_W => W_err_East_Req_W,
                              err_East_grant_W => W_err_East_grant_W,
                              err_West_Req_S => W_err_West_Req_S,
                              err_West_grant_S => W_err_West_grant_S,
                              err_South_Req_L => W_err_South_Req_L,
                              err_South_grant_L => W_err_South_grant_L,
                              err_Local_Req_N => W_err_Local_Req_N,
                              err_Local_grant_N => W_err_Local_grant_N,
            
                              err_IDLE_Req_W => W_err_IDLE_Req_W,
                              err_IDLE_grant_W => W_err_IDLE_grant_W,
                              err_North_Req_W => W_err_North_Req_W,
                              err_North_grant_W => W_err_North_grant_W,
                              err_East_Req_S => W_err_East_Req_S,
                              err_East_grant_S => W_err_East_grant_S,
                              err_West_Req_L => W_err_West_Req_L,
                              err_West_grant_L => W_err_West_grant_L,
                              err_South_Req_N => W_err_South_Req_N,
                              err_South_grant_N => W_err_South_grant_N,
                              err_Local_Req_E => W_err_Local_Req_E,
                              err_Local_grant_E => W_err_Local_grant_E,
            
                              err_IDLE_Req_S => W_err_IDLE_Req_S,
                              err_IDLE_grant_S => W_err_IDLE_grant_S,
                              err_North_Req_S => W_err_North_Req_S,
                              err_North_grant_S => W_err_North_grant_S,
                              err_East_Req_L => W_err_East_Req_L,
                              err_East_grant_L => W_err_East_grant_L,
                              err_West_Req_N => W_err_West_Req_N,
                              err_West_grant_N => W_err_West_grant_N,
                              err_South_Req_E => W_err_South_Req_E,
                              err_South_grant_E => W_err_South_grant_E,
                              err_Local_Req_W => W_err_Local_Req_W,
                              err_Local_grant_W => W_err_Local_grant_W,
            
                              err_IDLE_Req_L => W_err_IDLE_Req_L,
                              err_IDLE_grant_L => W_err_IDLE_grant_L,
                              err_North_Req_L => W_err_North_Req_L,
                              err_North_grant_L => W_err_North_grant_L,
                              err_East_Req_N => W_err_East_Req_N,
                              err_East_grant_N => W_err_East_grant_N,
                              err_West_Req_E => W_err_West_Req_E,
                              err_West_grant_E => W_err_West_grant_E,
                              err_South_Req_W => W_err_South_Req_W,
                              err_South_grant_W => W_err_South_grant_W,
                              err_Local_Req_S => W_err_Local_Req_S,
                              err_Local_grant_S => W_err_Local_grant_S,
            
                              err_state_in_onehot   => W_err_state_in_onehot, 
                              err_no_request_grants => W_err_no_request_grants,
                              err_request_no_grants => W_err_request_no_grants, 

                              err_no_Req_N_grant_N => W_err_no_Req_N_grant_N,
                              err_no_Req_E_grant_E => W_err_no_Req_E_grant_E,
                              err_no_Req_W_grant_W => W_err_no_Req_W_grant_W,
                              err_no_Req_S_grant_S => W_err_no_Req_S_grant_S,
                              err_no_Req_L_grant_L => W_err_no_Req_L_grant_L 
                               );

arb_S_X: Arbiter_in  PORT MAP (reset => reset, clk => clk,
                               Req_X_N=>req_S_N, Req_X_E=> req_S_E, Req_X_W=>req_S_W, Req_X_S=>req_S_S, Req_X_L=>req_S_L,
                               X_N=>X_S_N, X_E=>X_S_E, X_W=>X_S_W, X_S=>X_S_S, X_L=>X_S_L, 

                               -- South Arbiter_in Checker outputs
                              err_Requests_state_in_state_not_equal => S_err_Requests_state_in_state_not_equal,
            
                              err_IDLE_Req_N =>    S_err_IDLE_Req_N,
                              err_IDLE_grant_N =>  S_err_IDLE_grant_N,
                              err_North_Req_N =>   S_err_North_Req_N,
                              err_North_grant_N => S_err_North_grant_N,
                              err_East_Req_E =>    S_err_East_Req_E,
                              err_East_grant_E =>  S_err_East_grant_E,
                              err_West_Req_W =>    S_err_West_Req_W,
                              err_West_grant_W =>  S_err_West_grant_W,
                              err_South_Req_S =>   S_err_South_Req_S,
                              err_South_grant_S => S_err_South_grant_S,
                              err_Local_Req_L =>   S_err_Local_Req_L,
                              err_Local_grant_L => S_err_Local_grant_L,
            
                              err_IDLE_Req_E => S_err_IDLE_Req_E,
                              err_IDLE_grant_E => S_err_IDLE_grant_E,
                              err_North_Req_E => S_err_North_Req_E,
                              err_North_grant_E => S_err_North_grant_E,
                              err_East_Req_W => S_err_East_Req_W,
                              err_East_grant_W => S_err_East_grant_W,
                              err_West_Req_S => S_err_West_Req_S,
                              err_West_grant_S => S_err_West_grant_S,
                              err_South_Req_L => S_err_South_Req_L,
                              err_South_grant_L => S_err_South_grant_L,
                              err_Local_Req_N => S_err_Local_Req_N,
                              err_Local_grant_N => S_err_Local_grant_N,
            
                              err_IDLE_Req_W => S_err_IDLE_Req_W,
                              err_IDLE_grant_W => S_err_IDLE_grant_W,
                              err_North_Req_W => S_err_North_Req_W,
                              err_North_grant_W => S_err_North_grant_W,
                              err_East_Req_S => S_err_East_Req_S,
                              err_East_grant_S => S_err_East_grant_S,
                              err_West_Req_L => S_err_West_Req_L,
                              err_West_grant_L => S_err_West_grant_L,
                              err_South_Req_N => S_err_South_Req_N,
                              err_South_grant_N => S_err_South_grant_N,
                              err_Local_Req_E => S_err_Local_Req_E,
                              err_Local_grant_E => S_err_Local_grant_E,
            
                              err_IDLE_Req_S => S_err_IDLE_Req_S,
                              err_IDLE_grant_S => S_err_IDLE_grant_S,
                              err_North_Req_S => S_err_North_Req_S,
                              err_North_grant_S => S_err_North_grant_S,
                              err_East_Req_L => S_err_East_Req_L,
                              err_East_grant_L => S_err_East_grant_L,
                              err_West_Req_N => S_err_West_Req_N,
                              err_West_grant_N => S_err_West_grant_N,
                              err_South_Req_E => S_err_South_Req_E,
                              err_South_grant_E => S_err_South_grant_E,
                              err_Local_Req_W => S_err_Local_Req_W,
                              err_Local_grant_W => S_err_Local_grant_W,
            
                              err_IDLE_Req_L => S_err_IDLE_Req_L,
                              err_IDLE_grant_L => S_err_IDLE_grant_L,
                              err_North_Req_L => S_err_North_Req_L,
                              err_North_grant_L => S_err_North_grant_L,
                              err_East_Req_N => S_err_East_Req_N,
                              err_East_grant_N => S_err_East_grant_N,
                              err_West_Req_E => S_err_West_Req_E,
                              err_West_grant_E => S_err_West_grant_E,
                              err_South_Req_W => S_err_South_Req_W,
                              err_South_grant_W => S_err_South_grant_W,
                              err_Local_Req_S => S_err_Local_Req_S,
                              err_Local_grant_S => S_err_Local_grant_S,
            
                              err_state_in_onehot   => S_err_state_in_onehot, 
                              err_no_request_grants => S_err_no_request_grants,
                              err_request_no_grants => S_err_request_no_grants, 

                              err_no_Req_N_grant_N => S_err_no_Req_N_grant_N,
                              err_no_Req_E_grant_E => S_err_no_Req_E_grant_E,
                              err_no_Req_W_grant_W => S_err_no_Req_W_grant_W,
                              err_no_Req_S_grant_S => S_err_no_Req_S_grant_S,
                              err_no_Req_L_grant_L => S_err_no_Req_L_grant_L 
                               );

arb_L_X: Arbiter_in  PORT MAP (reset => reset, clk => clk,
                               Req_X_N=>req_L_N, Req_X_E=> req_L_E, Req_X_W=>req_L_W, Req_X_S=>req_L_S, Req_X_L=>req_L_L,
                               X_N=>X_L_N, X_E=>X_L_E, X_W=>X_L_W, X_S=>X_L_S, X_L=>X_L_L, 

                               -- Local Arbiter_in Checker outputs
                              err_Requests_state_in_state_not_equal => L_err_Requests_state_in_state_not_equal,
            
                              err_IDLE_Req_N =>    L_err_IDLE_Req_N,
                              err_IDLE_grant_N =>  L_err_IDLE_grant_N,
                              err_North_Req_N =>   L_err_North_Req_N,
                              err_North_grant_N => L_err_North_grant_N,
                              err_East_Req_E =>    L_err_East_Req_E,
                              err_East_grant_E =>  L_err_East_grant_E,
                              err_West_Req_W =>    L_err_West_Req_W,
                              err_West_grant_W =>  L_err_West_grant_W,
                              err_South_Req_S =>   L_err_South_Req_S,
                              err_South_grant_S => L_err_South_grant_S,
                              err_Local_Req_L =>   L_err_Local_Req_L,
                              err_Local_grant_L => L_err_Local_grant_L,
            
                              err_IDLE_Req_E => L_err_IDLE_Req_E,
                              err_IDLE_grant_E => L_err_IDLE_grant_E,
                              err_North_Req_E => L_err_North_Req_E,
                              err_North_grant_E => L_err_North_grant_E,
                              err_East_Req_W => L_err_East_Req_W,
                              err_East_grant_W => L_err_East_grant_W,
                              err_West_Req_S => L_err_West_Req_S,
                              err_West_grant_S => L_err_West_grant_S,
                              err_South_Req_L => L_err_South_Req_L,
                              err_South_grant_L => L_err_South_grant_L,
                              err_Local_Req_N => L_err_Local_Req_N,
                              err_Local_grant_N => L_err_Local_grant_N,
            
                              err_IDLE_Req_W => L_err_IDLE_Req_W,
                              err_IDLE_grant_W => L_err_IDLE_grant_W,
                              err_North_Req_W => L_err_North_Req_W,
                              err_North_grant_W => L_err_North_grant_W,
                              err_East_Req_S => L_err_East_Req_S,
                              err_East_grant_S => L_err_East_grant_S,
                              err_West_Req_L => L_err_West_Req_L,
                              err_West_grant_L => L_err_West_grant_L,
                              err_South_Req_N => L_err_South_Req_N,
                              err_South_grant_N => L_err_South_grant_N,
                              err_Local_Req_E => L_err_Local_Req_E,
                              err_Local_grant_E => L_err_Local_grant_E,
            
                              err_IDLE_Req_S => L_err_IDLE_Req_S,
                              err_IDLE_grant_S => L_err_IDLE_grant_S,
                              err_North_Req_S => L_err_North_Req_S,
                              err_North_grant_S => L_err_North_grant_S,
                              err_East_Req_L => L_err_East_Req_L,
                              err_East_grant_L => L_err_East_grant_L,
                              err_West_Req_N => L_err_West_Req_N,
                              err_West_grant_N => L_err_West_grant_N,
                              err_South_Req_E => L_err_South_Req_E,
                              err_South_grant_E => L_err_South_grant_E,
                              err_Local_Req_W => L_err_Local_Req_W,
                              err_Local_grant_W => L_err_Local_grant_W,
            
                              err_IDLE_Req_L => L_err_IDLE_Req_L,
                              err_IDLE_grant_L => L_err_IDLE_grant_L,
                              err_North_Req_L => L_err_North_Req_L,
                              err_North_grant_L => L_err_North_grant_L,
                              err_East_Req_N => L_err_East_Req_N,
                              err_East_grant_N => L_err_East_grant_N,
                              err_West_Req_E => L_err_West_Req_E,
                              err_West_grant_E => L_err_West_grant_E,
                              err_South_Req_W => L_err_South_Req_W,
                              err_South_grant_W => L_err_South_grant_W,
                              err_Local_Req_S => L_err_Local_Req_S,
                              err_Local_grant_S => L_err_Local_grant_S,
            
                              err_state_in_onehot   => L_err_state_in_onehot, 
                              err_no_request_grants => L_err_no_request_grants,
                              err_request_no_grants => L_err_request_no_grants, 

                              err_no_Req_N_grant_N => L_err_no_Req_N_grant_N,
                              err_no_Req_E_grant_E => L_err_no_Req_E_grant_E,
                              err_no_Req_W_grant_W => L_err_no_Req_W_grant_W,
                              err_no_Req_S_grant_S => L_err_no_Req_S_grant_S,
                              err_no_Req_L_grant_L => L_err_no_Req_L_grant_L 
                               );

-- Y is N now
arb_X_N: arbiter_out port map (reset => reset, clk => clk,
                               X_N_Y => X_N_N, X_E_Y => X_E_N,  X_W_Y => X_W_N,  X_S_Y => X_S_N,  X_L_Y => X_L_N, 
                               credit => credit_counter_N_out,
                               grant_Y_N => grant_N_N_sig, 
                               grant_Y_E => grant_N_E_sig, 
                               grant_Y_W => grant_N_W_sig, 
                               grant_Y_S => grant_N_S_sig, 
                               grant_Y_L => grant_N_L_sig);

-- Y is E now
arb_X_E: arbiter_out port map (reset => reset, clk => clk,
                               X_N_Y => X_N_E, X_E_Y => X_E_E, X_W_Y => X_W_E, X_S_Y => X_S_E, X_L_Y => X_L_E, 
                               credit => credit_counter_E_out,
                               grant_Y_N => grant_E_N_sig, 
                               grant_Y_E => grant_E_E_sig, 
                               grant_Y_W => grant_E_W_sig, 
                               grant_Y_S => grant_E_S_sig, 
                               grant_Y_L => grant_E_L_sig);

-- Y is W now
arb_X_W: arbiter_out port map (reset => reset, clk => clk,
                               X_N_Y => X_N_W, X_E_Y => X_E_W, X_W_Y => X_W_W, X_S_Y => X_S_W, X_L_Y => X_L_W, 
                               credit => credit_counter_W_out,
                               grant_Y_N => grant_W_N_sig, 
                               grant_Y_E => grant_W_E_sig, 
                               grant_Y_W => grant_W_W_sig, 
                               grant_Y_S => grant_W_S_sig, 
                               grant_Y_L => grant_W_L_sig);

-- Y is S now
arb_X_S: arbiter_out port map (reset => reset, clk => clk, 
                               X_N_Y => X_N_S, X_E_Y => X_E_S, X_W_Y => X_W_S, X_S_Y => X_S_S, X_L_Y => X_L_S, 
                               credit => credit_counter_S_out,
                               grant_Y_N => grant_S_N_sig, 
                               grant_Y_E => grant_S_E_sig, 
                               grant_Y_W => grant_S_W_sig, 
                               grant_Y_S => grant_S_S_sig, 
                               grant_Y_L => grant_S_L_sig);

-- Y is L now
arb_X_L: arbiter_out port map (reset => reset, clk => clk, 
                               X_N_Y => X_N_L, X_E_Y => X_E_L, X_W_Y => X_W_L, X_S_Y => X_S_L, X_L_Y => X_L_L, 
                               credit => credit_counter_L_out,
                               grant_Y_N => grant_L_N_sig, 
                               grant_Y_E => grant_L_E_sig, 
                               grant_Y_W => grant_L_W_sig, 
                               grant_Y_S => grant_L_S_sig, 
                               grant_Y_L => grant_L_L_sig);

valid_N <= grant_N;
valid_E <= grant_E;
valid_W <= grant_W;
valid_S <= grant_S;
valid_L <= grant_L;
 

END;





