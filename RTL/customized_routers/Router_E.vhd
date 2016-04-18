--Copyright (C) 2016 Siavoosh Payandeh Azad

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity router is
	generic (
        DATA_WIDTH: integer := 32;
        current_address : integer := 0;
        Rxy_rst : integer := 60;
        Cx_rst : integer := 10
    );
    port (
    reset, clk: in std_logic;
    DCTS_N, DCTS_w, DCTS_S, DCTS_L: in std_logic;
    DRTS_N, DRTS_W, DRTS_S, DRTS_L: in std_logic;
    RX_N, RX_E, RX_W, RX_S, RX_L : in std_logic_vector (DATA_WIDTH-1 downto 0); 
    RTS_N, RTS_E, RTS_W, RTS_S, RTS_L: out std_logic;
    CTS_N, CTS_E, CTS_w, CTS_S, CTS_L: out std_logic;
    TX_N, TX_E, TX_W, TX_S, TX_L: out std_logic_vector (DATA_WIDTH-1 downto 0)
    ); 
end router; 

architecture behavior of router is

  COMPONENT FIFO   
 	generic (
        DATA_WIDTH: integer := 32
    );
    port (  reset: in  std_logic;
            clk: in  std_logic;
            RX: in std_logic_vector (DATA_WIDTH-1 downto 0); 
            DRTS: in std_logic;
            read_en_N : in std_logic;   
            read_en_E : in std_logic; 
            read_en_W : in std_logic; 
            read_en_S : in std_logic; 
            read_en_L : in std_logic;
            CTS: out std_logic;
            Data_out: out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
	end COMPONENT;

    COMPONENT Arbiter   
 	 
    port (  reset: in  std_logic;
            clk: in  std_logic;
            Req_N, Req_E, Req_W, Req_S, Req_L:in std_logic;
            DCTS: in std_logic;
            Grant_N, Grant_E, Grant_W, Grant_S, Grant_L:out std_logic;
            Xbar_sel : out std_logic_vector(4 downto 0);
            RTS: out std_logic
            );
	end COMPONENT;

	COMPONENT LBDR is
    generic (
        cur_addr_rst: integer := 0;
        Rxy_rst: integer := 60;
        Cx_rst: integer := 8
    );
    port (  reset: in  std_logic;
            clk: in  std_logic;
            flit_type: in std_logic_vector(2 downto 0);
            dst_addr: in std_logic_vector(3 downto 0);
            Req_N, Req_E, Req_W, Req_S, Req_L:out std_logic
            );
	end COMPONENT;

 	COMPONENT XBAR is
    generic (
        DATA_WIDTH: integer := 32
    );
    port (
        North_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        East_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        West_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        South_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        Local_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        sel: in std_logic_vector (4 downto 0);
        Data_out: out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
	end COMPONENT;

  	signal FIFO_D_out_N, FIFO_D_out_W, FIFO_D_out_S, FIFO_D_out_L: std_logic_vector(DATA_WIDTH-1 downto 0);

    -- Grant_XY : Grant signal generated from Arbiter for output X connected to FIFO of input Y

 	signal Grant_NN, Grant_NE, Grant_NW, Grant_NS, Grant_NL: std_logic;
 	signal Grant_WN, Grant_WE, Grant_WW, Grant_WS, Grant_WL: std_logic;
 	signal Grant_SN, Grant_SE, Grant_SW, Grant_SS, Grant_SL: std_logic;
 	signal Grant_LN, Grant_LE, Grant_LW, Grant_LS, Grant_LL: std_logic;

 	signal Req_NN, Req_WN, Req_SN, Req_LN: std_logic;
 	signal Req_NE, Req_WE, Req_SE, Req_LE: std_logic;
 	signal Req_NW, Req_WW, Req_SW, Req_LW: std_logic;
 	signal Req_NS, Req_WS, Req_SS, Req_LS: std_logic;
 	signal Req_NL, Req_WL, Req_SL, Req_LL: std_logic;

 	signal Xbar_sel_N, Xbar_sel_W, Xbar_sel_S, Xbar_sel_L: std_logic_vector(4 downto 0);
begin
	
------------------------------------------------------------------------------------------------------------------------------
--                                      block diagram of one channel
--
--                                     .____________grant_________     
--                                     |                          ▲
--                                     |     _______            __|_______        
--                                     |    |       |          |          |      
--                                     |    | LBDR  |---req--->|  Arbiter | <--handshake-->                       
--                                     |    |_______|          |__________|     signals         
--                                     |       ▲                  |
--                                   __▼___    | flit          ___▼__  
--                         RX ----->|      |   | type         |      |        
--                     <-handshake->| FIFO |---o------------->|      |-----> TX
--                        signals   |______|           ------>|      |
--                                                     ------>| XBAR |        
--                                                     ------>|      |        
--                                                     ------>|      |        
--                                                            |______|        
--                    
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

-- all the FIFOs
 FIFO_N: FIFO generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (reset => reset, clk => clk, RX => RX_N, DRTS => DRTS_N, 
   			read_en_N => '0', read_en_E =>'0', read_en_W =>Grant_WN, read_en_S =>Grant_SN, read_en_L =>Grant_LN, 
   			CTS => CTS_N, Data_out => FIFO_D_out_N);      

 FIFO_W: FIFO generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (reset => reset, clk => clk, RX => RX_W, DRTS => DRTS_W, 
   			read_en_N => Grant_NW, read_en_E =>'0', read_en_W =>'0', read_en_S =>Grant_SW, read_en_L =>Grant_LW, 
   			CTS => CTS_W, Data_out => FIFO_D_out_W);

 FIFO_S: FIFO generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (reset => reset, clk => clk, RX => RX_S, DRTS => DRTS_S, 
   			read_en_N => Grant_NS, read_en_E =>'0', read_en_W =>Grant_WS, read_en_S =>'0', read_en_L =>Grant_LS, 
   			CTS => CTS_S, Data_out => FIFO_D_out_S); 

 FIFO_L: FIFO generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (reset => reset, clk => clk, RX => RX_L, DRTS => DRTS_L, 
   			read_en_N => Grant_NL, read_en_E =>'0', read_en_W =>Grant_WL, read_en_S => Grant_SL, read_en_L =>'0',
   			CTS => CTS_L, Data_out => FIFO_D_out_L); 
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

-- all the LBDRs
LBDR_N: LBDR generic map (cur_addr_rst => current_address, Rxy_rst => Rxy_rst, Cx_rst => Cx_rst)
	   PORT MAP (reset => reset, clk => clk, flit_type => FIFO_D_out_N(DATA_WIDTH-1 downto DATA_WIDTH-3), dst_addr=> FIFO_D_out_N(DATA_WIDTH-16 downto DATA_WIDTH-19) ,
   		 	 Req_N=> Req_NN, Req_E=>Req_NE, Req_W=>Req_NW, Req_S=>Req_NS, Req_L=>Req_NL);

LBDR_W: LBDR generic map (cur_addr_rst => current_address, Rxy_rst => Rxy_rst, Cx_rst => Cx_rst)
   PORT MAP (reset =>  reset, clk => clk, flit_type => FIFO_D_out_W(DATA_WIDTH-1 downto DATA_WIDTH-3), dst_addr=> FIFO_D_out_W(DATA_WIDTH-16 downto DATA_WIDTH-19) ,
   		 	 Req_N=> Req_WN, Req_E=>Req_WE, Req_W=>Req_WW, Req_S=>Req_WS, Req_L=>Req_WL);

LBDR_S: LBDR generic map (cur_addr_rst => current_address, Rxy_rst => Rxy_rst, Cx_rst => Cx_rst)
   PORT MAP (reset =>  reset, clk => clk, flit_type => FIFO_D_out_S(DATA_WIDTH-1 downto DATA_WIDTH-3), dst_addr=> FIFO_D_out_S(DATA_WIDTH-16 downto DATA_WIDTH-19) ,
   		 	 Req_N=> Req_SN, Req_E=>Req_SE, Req_W=>Req_SW, Req_S=>Req_SS, Req_L=>Req_SL);

LBDR_L: LBDR generic map (cur_addr_rst => current_address, Rxy_rst => Rxy_rst, Cx_rst => Cx_rst)
   PORT MAP (reset =>  reset, clk => clk, flit_type => FIFO_D_out_L(DATA_WIDTH-1 downto DATA_WIDTH-3), dst_addr=> FIFO_D_out_L(DATA_WIDTH-16 downto DATA_WIDTH-19) ,
   		 	 Req_N=> Req_LN, Req_E=>Req_LE, Req_W=>Req_LW, Req_S=>Req_LS, Req_L=>Req_LL);

------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

-- all the Arbiters
Arbiter_N: Arbiter 
   PORT MAP (reset => reset, clk => clk,
          Req_N => '0' , Req_E => '0', Req_W => Req_WN, Req_S => Req_SN, Req_L => Req_LN,
          DCTS => DCTS_N, Grant_N => Grant_NN, Grant_E => Grant_NE, Grant_W => Grant_NW, Grant_S => Grant_NS, Grant_L => Grant_NL,
          Xbar_sel => Xbar_sel_N, 
          RTS =>  RTS_N
        );     

  Arbiter_W: Arbiter 
   PORT MAP (reset => reset, clk => clk,
          Req_N => Req_NW , Req_E => '0', Req_W => '0', Req_S => Req_SW, Req_L => Req_LW,
          DCTS => DCTS_W, Grant_N => Grant_WN, Grant_E => Grant_WE, Grant_W => Grant_WW, Grant_S => Grant_WS, Grant_L => Grant_WL,
          Xbar_sel => Xbar_sel_W, 
          RTS =>  RTS_W
        );      

  Arbiter_S: Arbiter 
   PORT MAP (reset => reset, clk => clk,
          Req_N => Req_NS , Req_E => '0', Req_W => Req_WS, Req_S => '0', Req_L => Req_LS,
          DCTS => DCTS_S, Grant_N => Grant_SN, Grant_E => Grant_SE, Grant_W => Grant_SW, Grant_S => Grant_SS, Grant_L => Grant_SL,
          Xbar_sel => Xbar_sel_S, 
          RTS =>  RTS_S
        );   

  Arbiter_L: Arbiter 
   PORT MAP (reset => reset, clk => clk,
          Req_N => Req_NL , Req_E => '0', Req_W => Req_WL, Req_S => Req_SL, Req_L => '0',
          DCTS => DCTS_L, Grant_N => Grant_LN, Grant_E => Grant_LE, Grant_W => Grant_LW, Grant_S => Grant_LS, Grant_L => Grant_LL,
          Xbar_sel => Xbar_sel_L, 
          RTS =>  RTS_L
        );          
        
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

-- all the Xbars
XBAR_N: XBAR generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (North_in => FIFO_D_out_N, East_in => (others=>'0'), West_in => FIFO_D_out_W, South_in => FIFO_D_out_S, Local_in => FIFO_D_out_L,
        sel => Xbar_sel_N,  Data_out=> TX_N);
XBAR_W: XBAR generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (North_in => FIFO_D_out_N, East_in => (others=>'0'), West_in => FIFO_D_out_W, South_in => FIFO_D_out_S, Local_in => FIFO_D_out_L,
        sel => Xbar_sel_W,  Data_out=> TX_W);
XBAR_S: XBAR generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (North_in => FIFO_D_out_N, East_in => (others=>'0'), West_in => FIFO_D_out_W, South_in => FIFO_D_out_S, Local_in => FIFO_D_out_L,
        sel => Xbar_sel_S,  Data_out=> TX_S);
XBAR_L: XBAR generic map (DATA_WIDTH  => DATA_WIDTH)
   PORT MAP (North_in => FIFO_D_out_N, East_in => (others=>'0'), West_in => FIFO_D_out_W, South_in => FIFO_D_out_S, Local_in => FIFO_D_out_L,
        sel => Xbar_sel_L,  Data_out=> TX_L);
end;