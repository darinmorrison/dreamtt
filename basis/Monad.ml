module type S =
sig
  type 'a m
  val ret : 'a -> 'a m
  val bind : 'a m -> ('a -> 'b m) -> 'b m
end

module type Notation =
sig
  type 'a m
  val (let*) : 'a m -> ('a -> 'b m) -> 'b m
  val (and*) : 'a m -> 'b m -> ('a * 'b) m
  val (let+) : 'a m -> ('a -> 'b) -> 'b m
  val (and+) : 'a m -> 'b m -> ('a * 'b) m
  val (<@>) : ('a -> 'b) -> 'a m -> 'b m
  val (|>>) : 'a m -> ('a -> 'b m) -> 'b m
  val (@<<) : ('a -> 'b m) -> 'a m -> 'b m
  val (<&>) : 'a m -> 'b m -> ('a * 'b) m
end

module Notation (M : S) : Notation with type 'a m := 'a M.m =
struct
  let (let*) = M.bind

  let (and*) m n =
    let* x = m in
    let* y = n in
    M.ret (x, y)

  let (let+) m f = M.bind m (fun x -> M.ret (f x))

  let (and+) m n = (and*) m n

  let (<@>) f m = (let+) m f
  let (|>>) = (let*)
  let (@<<) f m = m |>> f
  let (<&>) = (and+)
end
  

