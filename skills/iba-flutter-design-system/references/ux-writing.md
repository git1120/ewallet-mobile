# UX writing

Use plain, respectful, calm language and clear action labels such as “Review
transfer” or “Check status,” not vague “OK” where consequence matters.
Localize complete messages; do not concatenate translated fragments or show
backend codes/messages.

Financial wording must distinguish:

- processing: the request is actively being handled;
- pending: accepted but not final;
- failed/declined: authoritatively not completed;
- reversed: a previously posted operation was reversed;
- unknown: the client cannot yet determine the outcome.

Never promise certainty that the server has not established. Explain what the
user can safely do next, include a reference/request ID only when useful and
masked/non-sensitive, and avoid blame or disclosure of internal security rules.
