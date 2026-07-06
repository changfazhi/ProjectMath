import { io, type Socket } from 'socket.io-client'

// Single shared connection. No URL → same origin, so it tunnels through the Vite proxy in dev
// and connects natively in production. websocket-only skips the HTTP long-polling handshake,
// which is the part of Socket.IO that would need sticky sessions behind Cloud Run.
let socket: Socket | null = null

export function getSocket(): Socket {
  if (!socket) {
    socket = io({ autoConnect: true, transports: ['websocket'] })
  }
  return socket
}
