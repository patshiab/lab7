(*
                              CS51 Lab 7
                   Modules and Abstract Data Types
 *)

(* Objective: This lab practices concepts of modules, including files
as modules, signatures, and polymorphic abstract data types.

There are 4 total parts to this lab. Please refer to the following
files to complete all exercises:

   lab7_part1.ml -- Part 1: Implementing modules
   lab7_part2.ml -- Part 2: Files as modules
-> lab7_part3.ml -- Part 3: Interfaces as abstraction barriers (this file)
   lab7_part4.ml -- Part 4: Polymorphic abstract types
 *)

(*======================================================================
Part 3: Interfaces as abstraction barriers

It may feel at first that it's redundant to have both signatures and
implementations for modules. However, as we saw at the end of Part 2,
the use of signatures allows to define a set of functionality that
might be shared between two related (but still different) modules. It
is also used as a way to hide, within a single module, various helper
functions or implementation details that we (as the developer of a
module) would rather not expose. In other words, it provides a rigid
*abstraction barrier* that when deployed properly makes it impossible
for a programmer using your module to violate desired invariants.

Let's say we want to build a stack data structure. A stack is similar
to a queue (as described in Section 12.2) except that the last
element to be added to it is the first one to be removed. That is, it
operates as a LIFO (Last-In First-Out) structure.

To get started, we can implement stacks using lists. "Push" and "pop"
are commonly the names of the functions associated with adding an
element to the top or removing the topmost element, respectively. (The
terminology is reminiscent of a stack of plates in a cafeteria: you
begin with an empty pile, "push" one or more plates onto the top of
the stack, and at any point might "pop" a plate off the top of the
pile.)

In imperative programming languages, a "pop" function typically
*modifies* the stack by removing the topmost element from the stack as
a side effect and then returns the value of that element. However, in
the functional paradigm, side effects are eschewed. As a result, we'll
separate "pop" into two functions: "top", which returns the topmost
element from the stack (without removing it), and "pop", which returns
a new stack that has the topmost element removed.

........................................................................
Exercise 3A: Complete this implementation of an integer stack module.
......................................................................*)

module IntListStack =
struct
  exception EmptyStack
  type stack = int list

  (* empty -- An empty stack *)
  let empty : stack = []

  (* push i s -- Adds an integer element i to the top of stack s *)
  let push (i : int) (s : stack) : stack =
    i :: s

  (* top s -- Returns the value of the topmost element on stack s,
     raising the EmptyStack exception if there is no element to be
     returned. *)
  let top (s : stack) : int =
    match s with
    | [] -> raise EmptyStack
    | h :: _ -> h

  (* pop s -- Returns a stack with the topmost element from s
     removed, raising the EmptyStack exception if there is no
     element to be removed. *)
  let pop (s : stack) : stack =
    match s with
    | [] -> raise EmptyStack
    | _ :: t -> t
end ;;


(* Now let's use this implementation and consider some implications.

........................................................................
Exercise 3B: Write a function `small_stack` that takes an argument of
type unit and uses the IntListStack implementation to create and
return a new stack with the values `5` and then `1` pushed in that
order.
......................................................................*)

let small_stack () : IntListStack.stack =
  let open IntListStack in
  empty
  |> push 5
  |> push 1 ;;


(*......................................................................
Exercise 3C: Now, use `IntListStack` functions to write an expression that
defines `last_el` as the value of the topmost element from `small_stack`.
......................................................................*)

let last_el = IntListStack.top (small_stack ()) ;;

(* Based on our requirements above, what should the value `last_el` be?

Look more closely at the type of `small_stack`: it's of type `int
list`. This is expected, since that's how we defined it, but this also
means that we have the ability to operate on the data structure
without using the provided *abstraction* specified by the module.

In other words, the `IntListStack` module is intended to enforce the
invariant that the elements will always be pushed and popped in a LIFO
manner. But, we could altogether circumvent that merely by changing
the list.

........................................................................
Exercise 3D: Write a function that, given a stack, returns a stack
with the elements inverted, *without using any of the `IntListStack`
methods*.
......................................................................*)

let invert_stack (s : IntListStack.stack) : IntListStack.stack =
  List.rev ;;

(* Now what would be the result of the top operation on a stack
inverted with `invert_stack`? Let's try it.

........................................................................
Exercise 3E: Write an expression using `IntListStack` methods to get the
top value from `small_stack` inverted with `invert_stack` and name the
result `bad_el`.
......................................................................*)

let bad_el = IntListStack.top (invert_stack (small_stack ())) ;;

(* This is bad. We have broken through the *abstraction barrier*
defined by the `IntListStack` module. You may wonder: "if I know that
the module is defined by a list, why not have the power to update it
manually?"

Several reasons:

First, as we've just done, it was entirely possible for a user of the
module to completely modify a value in its internal representation.
Imagine what would happen for a more complex module that allowed us to
break an invariant! From Problem Set 3, what would break if a person
could change a zero bignum to set the negative flag? Or construct a
list of coefficients some of which are larger than the base?

Second, what if the developer of the module wants to change the module
implementation for a more sophisticated version? Stacks are fairly
simple, yet there are multiple reasonable ways of implementing stack
regimen. And more complex data structures could certainly need several
iterations of implementation before settling on a final version.

Let's preserve the abstraction barrier by writing an interface for
this module. The signature will manifest an *abstract* data type for
stacks, without revealing the concrete implementation type. Because of
that abstraction barrier, users of modules satisfying the signature
will have *no access* to the values of the type except through the
abstraction provided by the functions and values in the signature.

........................................................................
Exercise 3F: Define an interface for an integer stack, called
`INT_STACK`, which should be structured as much as possible like the
implementation of `IntStack` above. But be careful in deciding what type
of data your function types in the signature should use; it's not `int
list`, even though that's the type you used in your implementation.
......................................................................*)

module type INT_STACK =
  sig
    exception EmptyStack
    type stack
    val empty : stack
    val push : int -> stack -> stack
    val top : stack -> int
    val pop : stack -> stack
  end ;;
(* Now, we'll apply the `INT_STACK` interface to the `IntListStack` to
form a module `SafeIntListStack` that is protected by the `INT_STACK`
signature. *)

module SafeIntListStack = (IntListStack : INT_STACK) ;;

(*......................................................................
Exercise 3G: Write a function `safe_stack` that takes a unit and uses
`SafeIntListStack` methods to return a stack of type
`SafeIntListStack.stack`, with the integers 5 and then 1 pushed onto
it.

Notice: What type is `safe_stack`? You should no longer be able to
perform list operations directly on it, which means the stack
preserves its abstraction barrier.
......................................................................*)

let safe_stack () : SafeIntListStack.stack =
  let open SafeIntListStack in
  empty
  |> push 5
  |> push 1 ;;
