**DO TDD** There is a TDD skill, and we always want to test drive any code that we write. The only exception is strictly explorator code when you are trying to understand how something worse. Any code intended to be part of the system should follow TDD and having a failing test **FIRST**

**TESTS MUST ALWAYS PASS: You MUST always make sure the tests all pass when you complete your work. NEVER assume they were already failing. ALWAYS assume it is your job to get ALL tests passing. If you are unable, and you are ABSOLUTELY CONVINCED it is not the result of your work that a test fails, ask the user**

**FACTORY USAGE REQUIREMENT: ALWAYS use ExMachina factories (`insert/2`, `build/2`) when creating test data instead of manual struct creation and Repo operations. This ensures consistent, maintainable test data creation and leverages the existing factory patterns.**

**TEST CONCISENESS: Keep tests clear and concise, just like the rest of the codebase. Avoid overly verbose test cases - a single well-written test that covers the essential functionality is better than multiple redundant tests. Focus on clarity and readability while ensuring comprehensive coverage.**

**IMPORTANT: When fixing bugs or issues, ALWAYS create a test that reproduces the bug first (to verify it exists), then fix the issue, then verify the test passes. This ensures the bug is properly fixed and won't regress in the future.**

**Note: When running tests with `mix test`, you don't need to add `MIX_ENV=test` as it's the default environment for the test command.**

**When running shell commands, do NOT append `2>&1`, `| tail`, or other output-modifying pipes. Run commands plainly and let the full output come through.**

**IMPORTANT:** At the end of every session, be sure to run `mix test` to run the elixir tests, and `npm run test --prefix assets` to run the client side javascript (typescript) tests.

In elixir, any time you feel compelled to use a nested case statement, you should probably use a with statement instead

When writing a function, if there are more than three parameters consider if you could define a map or other structure to consolidate params in a way that makes the code easier to understand and work with

Never do imports or aliases in a function body or describe block, they *always* belong at the top of the module
