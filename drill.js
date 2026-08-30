/**
 * Neovim JavaScript practice file.
 *
 * HOW TO USE
 * 1. Open this file with `nvim drill.js`.
 * 2. Work from top to bottom without copying and pasting.
 * 3. For postfix snippets, type the trigger immediately after an expression,
 *    select it from completion, then press Enter.
 * 4. For template snippets, type the trigger on an empty line.
 * 5. Use Tab and Shift-Tab to move through snippet placeholders.
 * 6. Undo each exercise with `u` so it can be repeated.
 * 7. Reset the entire file with Git when you want a clean practice session.
 *
 * USEFUL KEYS
 * K                 Hover documentation
 * gd / gr / gi      Definition / references / implementations
 * grn / gra         Rename / code action
 * [d / ]d           Previous / next diagnostic
 * <C-p>             Find files
 * <leader>fw        Search project text
 * s                 Flash jump
 * ;;                Open Oil file browser
 * gn / gp           Next / previous Git hunk
 * <leader>gp        Preview Git hunk
 * ;b / ;B / ;L      Breakpoint / conditional breakpoint / logpoint
 * ;e                Exception break behavior
 * <leader>dw / de   Watch / evaluate an expression
 * ;o / ;i / ;u      Step over / into / out
 * ;t                Terminate debugger
 * <leader>nn / nd   Run / debug the nearest Jest or Vitest test
 * <leader>nf        Run the current test file
 * <leader>nw / nW   Watch nearest test / current test file
 * <leader>nr        Rerun failures in test watch mode
 * <leader>rs        Pick and run a package.json script
 * <leader>cl / ct   Load LCOV coverage / toggle gutter signs
 * <leader>hr / hR   Run / replay a request in a .http file
 * <leader>hi        Inspect a .http request
 * <leader>db        Toggle the database UI (SQL completion uses Dadbod)
 * <leader>rr        Save and run this file with Node
 * <leader>se        Edit snippets
 *
 * RUNNING THIS FILE
 * Press `<leader>rr`. The file is saved and its output opens in a horizontal
 * terminal. Use Jest or Vitest for tests; this shortcut is for running a
 * standalone JavaScript file.
 *
 * MASTERCLASS PATH
 * Level 1: motions and editing
 * Level 2: search and navigation
 * Level 3: snippets and completion
 * Level 4: LSP refactoring
 * Level 5: diagnostics and Git
 * Level 6: running and debugging
 * Level 7: macros and automation
 */

const user = {
  id: 42,
  name: "Ada Lovelace",
  active: true,
  roles: ["admin", "developer"],
  profile: {
    location: "London",
    language: "JavaScript",
  },
};

// ---------------------------------------------------------------------------
// LEVEL 1: Motions and editing
// ---------------------------------------------------------------------------
// Practice without arrow keys:
//
// w / b            next / previous word
// f" / t"          jump to / before the next quote
// ci"              replace text inside quotes
// ciw              replace the current word
// yap              copy this paragraph
// cs"'             change double quotes to single quotes
// .                repeat the last edit
// u / <C-r>        undo / redo
//
// Drill: change "Ada Lovelace" to another name with `ci"`, move to "London",
// and press `.` to repeat the same kind of edit.

const users = [
  user,
  {
    id: 84,
    name: "Grace Hopper",
    active: true,
    roles: ["developer"],
    profile: {
      location: "New York",
      language: "COBOL",
    },
  },
];

function getUser() {
  return user;
}

// ---------------------------------------------------------------------------
// LEVEL 2: Search and navigation
// ---------------------------------------------------------------------------
// s                 Flash jump to visible text
// <C-p>             find a file
// <leader>fw        search project text
// <leader>rf        recent files
// ;;                open Oil in this directory
// <BS>              alternate between two buffers
//
// Drill: use `s` to jump between `user`, `users`, and `getUser`. Search for
// `calculateTotal` with `<leader>fw`, then return here with `<C-o>`.

// ---------------------------------------------------------------------------
// LEVEL 3: Snippets and completion
// ---------------------------------------------------------------------------
// Append one postfix trigger to each expression below. Press `u` afterward to
// restore the original expression and try the next trigger.
user;
user.profile;
users;
users[0];
getUser();

// Try each workflow:
//
// user.Log       -> logs with the label "Log user"
// user.Logs      -> pretty JSON with the label "Log user"
// users.Table    -> tabular output
// user.Dir       -> deep Node.js inspection
// user.id.Assert -> select the condition, then type `user.id === 42`
// getUser().Await -> assign an awaited result
// getUser().Catch -> log and rethrow a rejected promise
//
// Return logging:
// Append `.LogR` after the semicolon on a return statement. It extracts the
// expression into a selected temporary variable, logs it, and returns it.

// Snippet templates
// On an empty line below, expand each trigger and move through fields with Tab:
//
// guard
// trya
// fetchj
// dbg
// trace
// timer
// bench
//
// Use `dbg` for a statement breakpoint, `trace` for a call stack, and `timer`
// or `bench` when you need to find a slow block.
//
// WebSocket: wsclient, wswatch, wssend, wsserver
// Event loop: eventlag, asynctrace
// JSX identification: type `uxmark` inside an opening tag:
// <div uxmark>
// It adds a colored outline and searchable `data-debug` label.

// ---------------------------------------------------------------------------
// LEVEL 4: LSP navigation and refactoring
// ---------------------------------------------------------------------------

/**
 * @param {{ price: number, quantity: number }} item
 * @returns {number}
 */
function itemTotal(item) {
  return item.price * item.quantity;
}

/**
 * @param {{ price: number, quantity: number }[]} items
 * @param {number} discountRate
 * @returns {number}
 */
function calculateTotal(items, discountRate = 0) {
  const subtotal = items.reduce((sum, item) => sum + itemTotal(item), 0);
  console.log("Log", subtotal);
  // Append `.LogR` after this return statement's semicolon to log its result.
  return subtotal * (1 - discountRate);
}

const cart = [
  { price: 12.5, quantity: 2 },
  { price: 8, quantity: 3 },
];

const discountRate = 0.1;
const total = calculateTotal(cart, discountRate);

// Drills:
// 1. Put the cursor on `calculateTotal` and press `gd`.
// 2. Press `gr` to find all references.
// 3. Put the cursor on `discountRate` and press `grn`.
// 4. Put the cursor on `itemTotal` and press `K`.

// ---------------------------------------------------------------------------
// LEVEL 5: Diagnostics and Git
// ---------------------------------------------------------------------------
// Uncomment one line at a time. Navigate with [d and ]d, inspect diagnostics,
// then use `gra` where a code action is available.

// const unusedValue = 123;
// console.log(missingValue);
// calculateTotal("not an array");
//
// After changing this file:
// gn / gp           next / previous Git hunk
// <leader>gp        preview the hunk
// gs / gu           stage / unstage the hunk
// gb                blame the current line
// ;c                open LazyGit

// ---------------------------------------------------------------------------
// LEVEL 6: Running, async code, and debugging
// ---------------------------------------------------------------------------

async function loadUser() {
  return Promise.resolve({
    id: 126,
    name: "Margaret Hamilton",
    active: true,
  });
}

async function runAsyncDrills() {
  const request = loadUser();

  // Append `.Await` to `request`, accept the snippet, and rename `result`.
  request;

  // Undo, then append `.Catch` to practice visible promise failure handling.
  request;
}

function applyTax(amount, rate) {
  const tax = amount * rate;
  const result = amount + tax;
  return result;
}

function checkout() {
  const subtotal = calculateTotal(cart, discountRate);
  const finalTotal = applyTax(subtotal, 0.2);
  return {
    subtotal: 50,
    finalTotal,
  };
}

// Debug drill:
// 1. Put the cursor on `const tax` and press `;b`.
// 2. Press `;d` and choose "Launch current file".
// 3. Confirm `●` marks the breakpoint and `▶` marks the stopped line.
// 4. Inspect `amount`, `rate`, and `tax` in the DAP UI.
// 5. Step with `;o`, `;i`, and `;u`.
// 6. Finish with `;t`.
// 7. Press `<leader>rr` to run the complete file without the debugger.
//
// Conditional drill: press `;B` on `const tax`, enter `amount > 40`, then run.
// The debugger stops only when that expression is true.

// ---------------------------------------------------------------------------
// LEVEL 7: Macros and automation
// ---------------------------------------------------------------------------
// Add `const ` before each assignment and `;` at the end.
// Record the first edit with `qa`, move down, stop with `q`, then replay `@a`.

// firstName = "Ada"
// lastName = "Lovelace"
// language = "JavaScript"
// editor = "Neovim"

// Change the first double-quoted string to single quotes with `cs"'`, then use
// `.` to repeat that change on the remaining lines.

const tools = ["Neovim", "Node.js", "TypeScript", "Git"];

// ---------------------------------------------------------------------------
// BONUS: TODO and quickfix workflow
// ---------------------------------------------------------------------------

// TODO: Add validation for an empty cart.
// TODO: Add support for fixed-value discounts.
// FIX: Make the tax rate configurable.

// Use ]t and [t to move between comments.
// Use <leader>tt to list TODOs.
// Search for `const` with <leader>fw, press <C-q>, then use ;n and ;p.

// DAILY FIVE-MINUTE ROUTINE
// 1. Jump to a function with `s`.
// 2. Expand `.Log`, `.Logs`, and `.Table`, undoing after each one.
// 3. Rename one symbol with `grn`.
// 4. Uncomment one diagnostic and fix it with `gra`.
// 5. Preview a changed Git hunk with `gn` and `<leader>gp`.
// 6. Stop on `const tax` using `;b` and `;d`.
// 7. Repeat one edit with `.` or record a short macro with `qa ... q`.
// 8. Run the file with `<leader>rr`.

function main() {
  const result = checkout();
  console.log("Checkout", result);
  console.log("Tools", tools.join(", "));
}

main();

void runAsyncDrills;
