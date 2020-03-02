(*
                              CS51 Lab 7
                          Modules & Functors

                 A module for colors and color names

The representation for colors in this implementation is really obscure
and arguably unnecessarily so. By the way, it also has some bugs so it
doesn't pass all the unit tests. No need to debug it though. You'll be
replacing it wholesale with a simpler implementation. *)

(* 8-bit RGB channel colors *)
type color = int ;;

(* Some standard color names *)
type color_name =
  | Red
  | Green
  | Blue
  | Orange
  | Yellow
  | Indigo
  | Violet ;;

(* to_color r g b -- Returns the color corresponding to the RGB
   values given by r, g, and b *)
   let to_color (r : int) (g : int) (b : int) : color =
     r lsl 0b10000 + g lsl 0b1000 + b ;;

(* red c -- Returns the red channel value for the color c *)
let red (c : color) : int =
  match c with
  | (r, _g, _b) -> r ;;

(* green c -- Returns the green channel value for the color c *)
let green (c : color) : int =
  match c with
  | (_r, g, _b) -> g ;;

(* blue c -- Returns the blue channel value for the color c *)
let blue (c : color) : int =
  match c with
  | (_r, _g, b) -> b ;;

(* color_named name -- Returns the color (as RGB representation)
   corresponding to the color name *)
let color_named (name : color_name) : color =
  match name with
  | Red ->    to_color 255    0    0
  | Green ->  to_color   0  255    0
  | Blue ->   to_color   0    0  255
  | Orange -> to_color 255  165    0
  | Yellow -> to_color 255  255    0
  | Indigo -> to_color  75    0  130
  | Violet -> to_color 240  130  240
