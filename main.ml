open! Js_of_ocaml

module Global = struct
  let console_log arg: unit = Js.Unsafe.fun_call (
    Js.Unsafe.js_expr "console.log") [|Js.Unsafe.inject arg|]

  let setInterval fn d = Dom_html.window##setInterval (Js.Unsafe.callback fn) d
  let setTimeout fn d = Dom_html.window##setTimeout (Js.Unsafe.callback fn) d
end

let promise1  = Promise.make (fun res -> fun (_rej: unit -> unit) -> 
  let _ = Global.setTimeout (fun _ -> res "first promise->") 1000.0 in
  ()
)

let promise2 str = Promise.make (fun res -> fun (_rej: unit -> unit) -> 
  let _ = Global.setTimeout (fun _ -> res @@ str ^ "second promise") 2000.0 in
  ()
)

let bad_promise = Promise.make (fun (_res: unit -> unit) -> fun rej -> 
  let _ = Global.setTimeout (fun _ -> rej "bad promise") 0.0 in
  ()
)

let _main = let open Promise.Async in
  let res =
    let+ r1 = promise1 in
    let+ r2 = promise2 r1 in
    (print_endline r2) in
    let+ _ = bad_promise in

  Promise.catch_final (fun _ -> print_endline "catched"; ()) res;
  ()