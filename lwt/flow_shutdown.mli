(*
 * Copyright (C) 2015 Docker Inc
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

(** Adds a layer of signalling over Hyper-V sockets to simulate unidirectional
    shutdown. This implements the same protocol as:

    https://github.com/rneugeba/virtsock/tree/master/go/hvsock
*)

module Make(Time: Mirage_time.S)(Fn: S.FN)(Socket_family: Hvsock.Af_common.S): sig

  (** A Mirage FLOW over a hypervisor socket with an additional protocol layer to
      workaround bugs where in-flight data is lost after a shutdown_write or a close.
  *)

  type error = [ `Unix of Unix.error ]

  include Mirage_flow.S with type error := error

  module Socket: S.SOCKET with type sockaddr = Socket_family.sockaddr

  val read_into: flow -> Cstruct.t -> (unit Mirage_flow.or_eof, error) result Lwt.t

  val connect: Socket.t -> flow
end
