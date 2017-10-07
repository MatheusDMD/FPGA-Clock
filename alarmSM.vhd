-- Copyright (C) 2017  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel MegaCore Function License Agreement, or other 
-- applicable license agreement, including, without limitation, 
-- that your use is for the sole purpose of programming logic 
-- devices manufactured by Intel and sold by Intel or its 
-- authorized distributors.  Please refer to the applicable 
-- agreement for further details.

-- Generated by Quartus Prime Version 17.0.0 Build 595 04/25/2017 SJ Lite Edition
-- Created on Fri Oct  6 15:06:33 2017

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY alarmSM IS
    PORT (
        reset : IN STD_LOGIC := '0';
        clock : IN STD_LOGIC;
        alarm_mode : IN STD_LOGIC := '0';
        h_m : IN STD_LOGIC := '0';
        saida : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END alarmSM;

ARCHITECTURE BEHAVIOR OF alarmSM IS
    TYPE type_fstate IS (set_min,set_hora,init,wait_alarm);
    SIGNAL fstate : type_fstate;
    SIGNAL reg_fstate : type_fstate;
BEGIN
    PROCESS (clock,reg_fstate)
    BEGIN
        IF (clock='1' AND clock'event) THEN
            fstate <= reg_fstate;
        END IF;
    END PROCESS;

    PROCESS (fstate,reset,alarm_mode,h_m)
    BEGIN
        IF (reset='1') THEN
            reg_fstate <= init;
            saida <= "0000";
        ELSE
            saida <= "0000";
            CASE fstate IS
                WHEN set_min =>
                    IF (((alarm_mode = '1') AND (h_m = '1'))) THEN
                        reg_fstate <= set_hora;
                    ELSIF ((NOT((alarm_mode = '1')) AND NOT((h_m = '1')))) THEN
                        reg_fstate <= wait_alarm;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= set_min;
                    END IF;

                    saida <= "0011";
                WHEN set_hora =>
                    IF (((alarm_mode = '1') AND NOT((h_m = '1')))) THEN
                        reg_fstate <= set_min;
                    ELSIF ((NOT((alarm_mode = '1')) AND (h_m = '1'))) THEN
                        reg_fstate <= wait_alarm;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= set_hora;
                    END IF;

                    saida <= "0101";
                WHEN init =>
                    IF ((NOT((h_m = '1')) AND (alarm_mode = '1'))) THEN
                        reg_fstate <= set_min;
                    ELSIF (((alarm_mode = '1') AND (h_m = '1'))) THEN
                        reg_fstate <= set_hora;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= init;
                    END IF;

                    saida <= "1000";
                WHEN wait_alarm =>
                    IF (((alarm_mode = '1') AND (h_m = '1'))) THEN
                        reg_fstate <= set_hora;
                    ELSIF (((alarm_mode = '1') AND NOT((h_m = '1')))) THEN
                        reg_fstate <= set_min;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= wait_alarm;
                    END IF;

                    saida <= "0000";
                WHEN OTHERS => 
                    saida <= "XXXX";
                    report "Reach undefined state";
            END CASE;
        END IF;
    END PROCESS;
END BEHAVIOR;