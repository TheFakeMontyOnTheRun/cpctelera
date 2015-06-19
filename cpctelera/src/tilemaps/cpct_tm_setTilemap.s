;;-----------------------------LICENSE NOTICE------------------------------------
;;  This file is part of CPCtelera: An Amstrad CPC Game Engine 
;;  Copyright (C) 2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
;;
;;  This program is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.
;;
;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU General Public License for more details.
;;
;;  You should have received a copy of the GNU General Public License
;;  along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;-------------------------------------------------------------------------------
.module cpct_tilemaps

.include /tilemaps.s.inc/

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Function: cpct_tm_setTilemap
;;
;;    Estabilishes the 2D array that contains the tilemap that should be  
;; currently displayed on the screen.
;;
;; C Definition:
;;    void <cpct_tm_setTilemap> (void* ptilemap);
;;
;; Input Parameters (2 bytes):
;;  (2B HL) ptilemap - Pointer to the tilemap
;;
;; Assembly call (Input parameters on registers):
;;    > call cpct_tm_setTilemap_asm
;;
;; Parameter Restrictions:
;;    * *ptilemap* could be any 16-bits value, representing the memory 
;; address where the tilemap is stored (first byte).
;;
;; Known limitations:
;;     * This function does not do any kind of checking over the tilemap, its
;; contents or size. If you give a wrong pointer, your tilemap has different
;; dimensions than required or has less/more tiles than will be used later,
;; rubbish can appear on the screen.
;;     * It is *very important* to call this function previously to the use of 
;; tilemap managing functions; otherwise, functions will access random tile definitions 
;; from memory, which will lead to drawing problems.
;;
;; Details:
;;    Estabilishes a internal pointer that is used by tiledrawing functions
;; to read map of tiles to be displayed on the screen. This pointer should point 
;; to the first byte in memory where the tilemap is stored. 
;;
;;    A tilemap is a 2D array of indexes to tile definitions (indexes referred
;; to elements of the tileset). Each element of the 2D array is a N-bits integer
;; that is the index to access the tile definition on the tileset array. There
;; is no predefined value for N-bits (could be anyone). The function pointed
;; by <cpct_pgetTileIndexFunc> will be used to access the elements of the tilemap.
;;
;; Destroyed Register values: 
;;    C Call   - AF, HL
;;    ASM Call - none
;;
;; Required memory:
;;     8 bytes
;;
;; Time Measures:
;; (start code)
;;    Case    | Cycles | microSecs (us)
;; ---------------------------------
;;    Any     |    68  |   17.00
;; ---------------------------------
;; Asm saving |   -42  |  -10.50
;; ---------------------------------
;; (end code)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_cpct_tm_setTilemap::
   ;; GET Parameters from the stack (42 cycles)
   pop  af                 ;; [10] AF = Return Address
   pop  hl                 ;; [10] HL = Pointer to the tileset
   push hl                 ;; [11] Left Stack as it was previously
   push af                 ;; [11]

_cpct_tm_setTilemap_asm::    ;; Assembly entry point
   ld  (#_cpct_ptilemap), hl ;; [16] Store pointer to the tilemap in our internal variable
   ret                       ;; [10] Return