const { spawn } = require('child_process')
const path = require('path')

const RESET = '\x1b[0m'
const BLUE  = '\x1b[34m'
const GREEN = '\x1b[32m'

function prefix(color, label, line) {
  const trimmed = line.toString().replace(/\n$/, '')
  if (!trimmed) return
  for (const part of trimmed.split('\n')) {
    process.stdout.write(`${color}[${label}]${RESET} ${part}\n`)
  }
}

function run(label, color, cwd) {
  const proc = spawn('npm', ['run', 'dev'], {
    cwd: path.join(__dirname, cwd),
    shell: true,
  })
  proc.stdout.on('data', (d) => prefix(color, label, d))
  proc.stderr.on('data', (d) => prefix(color, label, d))
  proc.on('exit', (code) => console.log(`${color}[${label}]${RESET} exited with code ${code}`))
  return proc
}

run('backend',  BLUE,  'backend')
run('frontend', GREEN, 'frontend')
