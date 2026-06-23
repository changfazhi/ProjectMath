import { io, type Socket } from 'socket.io-client'

// Single shared connection. No URL → same origin, so it tunnels through the Vite proxy in dev
// and connects natively in production.
let socket: Socket | null = null

export function getSocket(): Socket {
  if (!socket) {
    socket = io({ autoConnect: true })
  }
  return socket
}
