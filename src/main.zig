const std = @import("std");
const libc = std.os.linux;
const generic = libc.errno.generic.E;
const errno = std.c.linux._errno;
const Allocator = std.mem.Allocator;

const SocketError = error {
    /// Permission to create a socket of the specified type and/or protocol is denied.
    Access,
    /// The implementation does not support the specified address family.
    FNoSupport,
    /// Unknown protocol, or protocol family not available. Invalid flags in type.
    Inval,
    /// The per-process limit on the number of open file descriptors has been reached.
    MFile,
    /// The system-wide limit on the total number of open files has been reached.
    NFile,
    /// Insufficient memory is available.  The socket cannot be created until sufficient resources are freed.
    NoBufs,
    /// Insufficient memory is available.  The socket cannot be created until sufficient resources are freed.
    NoMem,
    /// The protocol type or the specified protocol is not supported within this domain.
    ProtoNoSupport,
};
pub fn socket_error(x: anytype) SocketError {
    switch (@intCast(x,u16)) {
        generic.ACCES => SocketError.Acces
        generic.AFNOSUPPORT => SocketError.FNoSupport,
        generic.INVAL => SocketError.Inval,
        generic.NFILE => SocketError.NFIle,
        generic.MFILE => SocketError.MFile,
        generic.NOBUFS => SocketError.NoBufs,
        generic.NOMEM => SocketError.NoMem,
        generic.PROTONOSUPPORT => SocketError.ProtoNoSupport,
        else unreachable
    }
}
const SetsockoptError = error {
    /// The socket argument is not a valid file descriptor.
    BadF,
    /// The send and receive timeout values are too big to fit into the timeout fields in the socket structure.
    Dom,
    /// The specified option is invalid at the specified socket level or the socket has been shut down.
    Inval,
    /// The socket is already connected, and a specified option cannot be set while the socket is connected.
    IsConn,
    /// The option is not supported by the protocol.
    NoProtoOpt,
    /// The socket argument does not refer to a socket.
    NotSock,
    /// There was insufficient memory available for the operation to complete.
    NoMem,
    /// Insufficient resources are available in the system to complete the call.
    NoBufs,
};
pub fn setsocketopt_error(x: anytype) SetsockoptError {
    switch (@intCast(x,u16)) {
        generic.BADF => SetsockoptError.BadF
        generic.DOM => SetsockoptError.Dom,
        generic.INVAL => SetsockoptError.Inval,
        generic.ISCONN => SetsockoptError.IsConn,
        generic.NOPROTOOPT => SetsockoptError.NoProtoOpt,
        generic.NOTSOCK => SetsockoptError.NotSock,
        generic.NOMEM => SetsockoptError.NoMem,
        generic.NOBUFS => SetsockoptError.NoBufs,
        else unreachable
    }
}
const BindError = error {
    /// The address is protected, and the user is not the superuser.
    ///
    /// Search permission is denied on a component of the path prefix. (See also path_resolution(7).)
    Access,
    /// The given address is already in use.
    ///
    /// (Internet domain sockets) The port number was specified as zero in the socket address
    /// structure, but, upon attempting to bind to an ephemeral port, it was determined that all
    /// port numbers in the ephemeral port range are currently in use.  See the discussion of
    /// /proc/sys/net/ipv4/ip_local_port_range ip(7).
    AddrInUse,
    /// sockfd is not a valid file descriptor.
    BadF,
    /// sockfd is not a valid file descriptor.
    ///
    /// addrlen is wrong, or addr is not a valid address for this socket's domain.
    Inval,
    /// The file descriptor sockfd does not refer to a socket.
    NotSock,
    /// A nonexistent interface was requested or the requested address was not local.
    AddrNotAvail,
    /// addr points outside the user's accessible address space.
    Fault,
    /// Too many symbolic links were encountered in resolving addr.
    Loop,
    /// addr is too long.
    NameTooLong,
    /// A component in the directory prefix of the socket pathname does not exist.
    NoEnt,
    /// Insufficient kernel memory was available.
    NoMem,
    /// A component of the path prefix is not a directory.
    NotDir,
    /// The socket inode would reside on a read-only filesystem.
    ROFS
};
pub fn bind_error(x: anytype) BindError {
    switch (@intCast(x,u16)) {
        generic.ACCES => SetsockoptError.Access
        generic.ADDRINUSE => SetsockoptError.AddrInUse,
        generic.BADF => SetsockoptError.BadF,
        generic.INVAL => SetsockoptError.Inval,
        generic.NOTSOCK => SetsockoptError.NotSock,
        generic.ADDRNOTAVAIL => SetsockoptError.AddrNotAvail,
        generic.FAULT => SetsockoptError.Fault,
        generic.LOOP => SetsockoptError.Loop,
        generic.NAMETOOLONG => SetsockoptError.NameTooLong,
        generic.NOENT => SetsockoptError.NoEnt,
        generic.NOMEM => SetsockoptError.NoMem,
        generic.NOTDIR => SetsockoptError.NotDir,
        generic.ROFS => SetsockoptError.ROFS,
        else unreachable
    }
}
const ListenError = error {
    /// Another socket is already listening on the same port.
    ///
    /// (Internet domain sockets) The socket referred to by sockfd had not previously been bound to
    /// an address and, upon attempting to bind it to an ephemeral port, it was determined that all
    /// port numbers in the ephemeral port range are currently in use.  See the discussion of
    /// /proc/sys/net/ipv4/ip_local_port_range in ip(7).
    AddrInUse,
    /// The argument sockfd is not a valid file descriptor.
    BadF,
    /// The file descriptor sockfd does not refer to a socket.
    NotSock,
    /// The socket is not of a type that supports the listen() operation.
    OpNotSupp
};
pub fn listen_error(x: anytype) ListenError {
    switch (@intCast(x,u16)) {
        generic.ADDRINUSE => SetsockoptError.AddrInUse,
        generic.BADF => SetsockoptError.BadF,
        generic.NOTSOCK => SetsockoptError.NotSock,
        generic.OPNOTSUPP => SetsockoptError.OpNotSupp,
        else unreachable
    }
}

const PthreadSigmaskError = error {
    /// The set or oldset argument points outside the process's allocated address space.
    Fault,
    /// Either the value specified in how was invalid or the kernel does not support the size passed
    /// in sigsetsize.
    Inval
};
/// Blocks interrupt signal on this thread
pub const pthread_sigmask(sigset: SignalSet) PthreadSigmaskError!void {
    const result = libc.pthread_sigmask(
        libc.SIG.SETMASK,
        sigset.set,
        null
    );
    switch (result) {
        0 => {
            return;
        },
        generic.FAULT => {
            return PthreadSigmaskError.Fault;
        },
        generic.INVAL => {
            return PthreadSigmaskError.Inval;
        },
        else => unreachable,
    }
}
const SigAddSetError = error {
    /// The value of the signo argument is an invalid or unsupported signal number.
    Inval,
}

enum Signal(u6) {
    Interrupt = libc.SIG.INT,
}

pub const SignalSet = struct {
    const Self = @This();

    .set = sigset_t,

    pub fn empty() Self {
        return Self { .set = libc.empty_sigset };
    }
    pub fn add(self: Self,sig: Signal) SigAddSetError!void {
        return sigaddset(self,sig);
    }
    pub fn sigaddset(set: *sigset_t, sig: Signal) SigAddSetError!void {
        const result = libc.sigaddset(set,@enumToInt(sig));
        if result == -1 {
            return SigAddSetError.Inval;
        }
    }
    /// Returns signal set only containing interrupt.
    pub fn interrupt() SigAddSetError!Self {
        var sigset = SignalSet.empty();
        try sigset.add(Signal.Interrupt);
        return sigset;
    }
}

enum Domain {
    Unix = libc.AF.UNIX,
    IPv6 = libc.AF.INET6,
}
enum Level {
    Socket = libc.SOL.SOCKET,
}
pub const IPv6Socket = Socket(Domain::IPv6);
pub fn Socket(comptime domain: Domain) type {
    return struct {
        const Self = @This();

        file_descriptor = i32,

        pub const ADDR: type = switch(domain) {
            Domain.Unix => libc.sockaddr.unm
            Domain.IPv6 => libc.sockaddr.in6
        };

        pub const IPv6 = struct {
            pub fn localhost(port: u16) libc.sockaddr.in6 {
                return libc.sockaddr.in6 {
                    .port = port,
                    .flowinfo = 0,
                    .addr = [16]u8{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
                    .scope_id = 0,
                }
            }
        };

        pub const LOCAL_HOST: anytype = switch(domain) {
            Domain.Unix => void,
            Domain.IPv6 => [16]u8{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1}
        };

        pub const OPTION = switch(domain) {
            Domain.Unix => enum {

            },
            Domain.IPv6 => enum {
                /// Permits multiple AF_INET or AF_INET6 sockets to be bound
                /// to an identical socket address.  This option must be set
                /// on each socket (including the first socket) prior to
                /// calling bind(2) on the socket.
                Reuseport = libc.SO.REUSEPORT,
            }
        };

        pub fn socket() SocketError!Self {
            const socket = libc.socket(
                @enumToInt(domain),
                switch (domain) {
                    Domain.Unix => libc.SOCK.DGRAM,
                    Domain.IPv6 => libc.SOCK.STREAM
                },
                0
            );
            switch (socket) {
                0 => {
                    return Self { .file_descriptor = socket };
                },
                -1 => {
                    return socket_error(errno.*);
                },
                else => unreachable
            }
        }
        // port: in_port_t, addr: [16]u8
        pub fn bind(self: Self, addr: Self.ADDR) BindError!void {
            const bind_result = libc.bind(
                self.file_descriptor,
                @ptrCast(*const libc.sockaddr,&addr),
                @sizeOf(ADDR)
            );
            switch (bind_result) {
                0 => {
                    return;
                },
                -1 => {
                    return bind_error(errno.*);
                },
                else => unreachable
            }
        }
        pub fn setsockopt(self: Self, comptime level: Level, comptime name: Self.OPTION, value: bool) {
            const opt: i32 = if (value) { 1 } else { 0 };
            const setsocketopt_result = libc.setsockopt(
                self.file_descriptor,
                @enumToInt(level),
                @enumToInt(name),
                &opt,
                @sizeOf(opt)
            );
            switch (setsockopt_result) {
                0 => {
                    return;
                },
                -1 => {
                    return setsocketopt_error(errno.*); 
                },
                else => unreachable
            }
        }
    }
}

/// A UNIX socket.
pub const UnixSocket = struct {

};

/// A TCP socket.
pub const TcpSocket = struct {
    const Self = @This();

    file_descriptor: i32,

    pub const LOCAL_HOST: [16]u8 = [_]u8{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1};

    /// Creates a local TCP socket, binding and listening.
    pub fn local(port: u16) !Self {
        // Create socket
        const socket = try Self.socket();
        // Enable cross-process socket re-use
        try socket.reuseport();
        // Bind socket
        try socket.bind(port,Self.LOCAL_HOST);
        // Listen on socket
        // TODO: What should be used instead of `64` as the backlog parameter?
        try socket.listen(64);

        return socket;
    }

    pub fn socket() SocketError!Self {
        const socket = libc.socket(libc.AF.INET6, libc.SOCK.STREAM,0);
        switch (socket) {
            0 => {
                return Self { .file_descriptor = socket };
            },
            -1 => {
                return socket_error(errno.*);
            },
            else => unreachable
        }
    }
    pub fn reuseport(self: Self) SetsockoptError!void {
        const opt: i32 = 1;
        const setsockopt_result = libc.setsockopt(
            self.file_descriptor,
            libc.SOL.SOCKET,
            libc.SO.REUSEPORT,
            @ptrCast([*]const u8,&opt),
            @sizeOf(i32)
        );
        switch (setsockopt_result) {
            0 => {
                return;
            },
            -1 => {
               return setsocketopt_error(errno.*); 
            },.
            else => unreachable
        }
    }
    pub fn bind(self: Self, port: in_port_t, addr: [16]u8) BindError!void {
        const addr = libc.sockaddr.in6 {
            .port = port,
            .flowinfo = 0,
            .addr = addr,
            .scope_id = 0,
        };
        const bind_result = libc.bind(
            self.file_descriptor,
            @ptrCast(*const libc.sockaddr,&addr),
            @sizeOf(libc.sockaddr.in6)
        );
        switch (bind_result) {
            0 => {
                return;
            },
            -1 => {
                return bind_error(errno.*);
            },
            else => unreachable
        }
    }
    pub fn listen(self: Self, backlog: u32) ListenError!void {
        const listen_result = libc.listen(self.file_descriptor,backlog);
        if listen_result == -1 {
            return listen_error(errno.*);
        }
    }

    pub fn deinit(self:Self) void {
        _ = libc.close(self.file_descriptor);
        // TODO: Assert this returns 0.
    }
};

/// Name of application.
const NAME = "neutron";
/// Server process key.
const KEY = "1";
/// Directory to store process transfer sockets.
const SOCKET_DIR = "/tmp";
/// Fix for the socket the current server process is bound to.
const CUR = "cur";
/// Fix for the socket the new server process is bound to.
const NEW = "new";
/// Prefix for the process transfer socket.
const SOCKET_PREFIX = SOCKET_DIR ++ "/" ++ NAME ++ KEY;
/// The current server process socket path.
const CURRENT_PROCESS_SOCKET = SOCKET_PREFIX ++ "-" ++ CUR;
/// The new server process socket path.
const NEW_PROCESS_SOCKET = SOCKET_PREFIX ++ "-" ++ NEW;;

pub fn main() anyerror!void {
    std.log.info("Started", .{});
    
    // var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // defer _ = gpa.deinit();
    // std.log.info("Created allocator", .{});

    var socket = try IPv6Socket.socket();
    defer socket.deinit();
    try socket.setsockopt(
        IPv6Socket.Level.Socket,
        IPv6Socket.Option.Reuseport,
        true
    );
    // TODO: Can we avoid needing to specify the domain twice here?
    try socket.bind(IPv6Socket.IPv6.localhost(8080));
    try socket.listen(64);

    // -------------------

    var socket = try TcpSocket.local(8080);
    defer socket.deinit();
    std.log.info("Created socket", .{});

    const sigset = try SignalSet.interrupt();
    try pthread_sigmask(sigset);
    std.log.info("Blocked interrupt", .{});

    // Check if server currently running by checking if current server process socket file exists.
    const file = std.fs.accessAbsolute(CURRENT_PROCESS_SOCKET) catch ;
    const new = if (file) |_void|{ true } else |_err| { false };
    if (!new) {

    }



    return;

    // const socketfd = libc.socket(libc.AF.INET6, libc.SOCK.STREAM | libc.SOCK.NONBLOCK,0);
    // try std.testing.expect(socketfd != -1);
    // co nst socketfdi32 = @intCast(i32, socketfd);

    // std.debug.print("Created socket: {}\n", .{socketfd});

    // var optval: i32 = 1;
    // const sso_res = libc.setsockopt(socketfdi32,libc.SOL.SOCKET,libc.SO.REUSEPORT,@ptrCast([*]const u8,&optval),4);
    // try std.testing.expect(sso_res != -1);

    // std.debug.print("Set socket option: {}\n", .{ optval });

    // const sockaddr = libc.sockaddr {
    //     .family = libc.AF.INET6,
    //     .data = [_]u8{ '1', '2', '7', '.', '0', '.', '0', '.', '1', ':', '8', '0', '8', '0' }
    // };

    // const bind_res = libc.bind(socketfdi32,&sockaddr,16);
    // try std.testing.expect(bind_res != -1);

    // std.debug.print("Bound socket\n", .{});

    // const listen_res = libc.listen(socketfdi32,64);
    // try std.testing.expect(listen_res != -1);

    // std.debug.print("Listening on socket\n", .{});

    // const close_res = libc.close(socketfdi32);
    // try std.testing.expect(close_res != -1);

    // std.debug.print("Closed socket\n", .{});
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
