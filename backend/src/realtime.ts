import type { Server as HttpServer } from 'node:http';
import { Server } from 'socket.io';

// Single Socket.IO instance, created at boot. Routes/services emit through emitToPair()
// rather than importing the server directly, keeping the dependency one-directional.
let io: Server | null = null;

export function initRealtime(httpServer: HttpServer): Server {
  io = new Server(httpServer, {
    // Same-origin in dev (via the Vite proxy) and prod; '*' keeps direct connections working too.
    cors: { origin: '*' },
  });

  io.on('connection', (socket) => {
    // A desktop joins the room for its pairing token so it receives that pairing's events only.
    socket.on('pair:subscribe', (data: { token?: string }) => {
      if (data?.token) socket.join(data.token);
    });
    socket.on('pair:unsubscribe', (data: { token?: string }) => {
      if (data?.token) socket.leave(data.token);
    });
  });

  return io;
}

// Emit an event to every desktop subscribed to a pairing token.
export function emitToPair(token: string, event: string, payload?: unknown): void {
  io?.to(token).emit(event, payload);
}
