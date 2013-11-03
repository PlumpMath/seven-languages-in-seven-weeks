# Find

1. A queue implementation that blocks when the queue is empty and waits for a
   new item in the queue

# Do

1. Use refs to create a vector of accounts in memory. Create debit and credit
   functions to change the balance of an account.

    ```Clojure
    (defn find-account-by-id "Finds account by ID." [accounts account-id]
      (first
        (filter (fn [account] (if (= (account :id) account-id) account)) accounts)))

    (defn maybe-mutate-account-balance
      [accounts-ref account-id operation amount]
      {:pre [(contains? #{+ -} operation)]}
      (dosync
        (alter
          accounts-ref
          (fn [accounts account-id operation amount]
            (when-let
              [account (find-account-by-id accounts account-id)]
              (replace
                {account (assoc account :balance (operation (account :balance) amount))}
                accounts)))
          account-id operation amount)))

    (defn credit
      "Credits money to the account with the given ID. Does nothing if an account
      with the given ID doesn't exist."
      [accounts-ref account-id amount]
      (maybe-mutate-account-balance accounts-ref account-id + amount))

    (defn debit
      "Debits money from the account with the given ID. Does nothing if an account
      with the given ID doesn't exist."
      [accounts-ref account-id amount]
      (maybe-mutate-account-balance accounts-ref account-id - amount))

    (defn transfer
      "Transfers money from an account to another. Does nothing if either of the
      accounts don't exist."
      [accounts-ref source-id destination-id amount]
      (dosync
        (alter
          accounts-ref
          (fn [accounts source-id destination-id amount]
            (when-let
              [source (find-account-by-id accounts source-id)]
              (when-let
                [destination (find-account-by-id accounts destination-id)]
                (debit accounts-ref (source :id) amount)
                (credit accounts-ref (destination :id) amount))))
          source-id destination-id amount)))

    (def accounts-ref (ref [{:id 1 :balance 22.00}
                            {:id 2 :balance 2034.54}
                            {:id 3 :balance 513.70}]))

    (credit accounts-ref 1 99)
    (debit accounts-ref 3 100.50)
    (transfer accounts-ref 2 1 300)
    ```

2. In this section, I'm going to outline a single problem called *sleeping
   barber*. It was created by Edsger Dijkstra in 1965. It has these
   characteristics.

  - A barber shop takes customers.
  - Customers arrive at random intervals, from ten to thirty milliseconds.
  - The barber shop has three chairs in the waiting room.
  - The barber shop has one barber and one barber chair.
  - When the barber's chair is empty, a customer sits in the chair, wakes up the
    barber, and gets a haircut.
  - If the chairs are occupied, all new customers will turn away.
  - Haircuts take twenty milliseconds.
  - After a customer receives a haircut, he gets up and leaves.

  Write a multithreaded program to determine how many haircuts a barber can give
  in ten seconds.

    ```Clojure
    ```
