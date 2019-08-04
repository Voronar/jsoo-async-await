open Js_of_ocaml

module Global = struct
  let console_log arg: unit = Js.Unsafe.fun_call (
    Js.Unsafe.js_expr "console.log") [|Js.Unsafe.inject arg|]

  let setInterval fn d = Dom_html.window##setInterval (Js.Unsafe.callback fn) d
  let setTimeout fn d = Dom_html.window##setTimeout (Js.Unsafe.callback fn) d
end
