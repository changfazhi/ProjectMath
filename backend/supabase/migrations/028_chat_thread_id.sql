-- Scopes each AI hint conversation to a "thread" that starts fresh every time the
-- question is opened (page refresh / reopen / new tab / new device), while all rows
-- stay in the table forever so the daily quota (usageService) and the per-question
-- 40-message cap (chatService) keep counting every message the user has ever sent.
ALTER TABLE chat_messages
  ADD COLUMN thread_id UUID NOT NULL DEFAULT uuid_generate_v4();

CREATE INDEX idx_chat_messages_thread
  ON chat_messages (session_id, question_id, thread_id, created_at);
