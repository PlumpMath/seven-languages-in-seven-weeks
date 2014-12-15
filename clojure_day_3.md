# Find

1. A queue implementation that blocks when the queue is empty and waits for a
   new item in the queue

# Do

1. Use refs to create a vector of accounts in memory. Create debit and credit
   functions to change the balance of an account.

    ```Clojure
    (defn find-account-by-id
      "Finds account with the given ID."
      [accounts account-id]
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
      "Credits money to the account with given ID. Does nothing if the account
      doesn't exist."
      [accounts-ref account-id amount]
      (maybe-mutate-account-balance accounts-ref account-id + amount))

    (defn debit
      "Debits money from the account with given ID. Does nothing if the account
      doesn't exist."
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
    (ns barber-shop.core
      (:require [clojure.data   :as data]
                [clojure.string :as string]
                [clojure.set    :as set]
                [clj-time.core  :as time]))

    (def configuration {:waiting-room-chairs-count 3
                        :barbers-count 1
                        :barber-chairs-count 1
                        :customer-delay-range [10 30]
                        :haircut-time 20
                        :barber-shop-runtime 10000})

    (def log (atom []))

    (defn- append-to-log [string] (swap! log conj (str (time/now) " " string)))

    (defn- make-uuid [] (java.util.UUID/randomUUID))

    (defn- random-customer-arrival-delay []
      (rand-nth (apply range (:customer-delay-range configuration))))

    (defn- n-seconds-customer-arrival-delay-window [n]
      (reduce (fn [[window-time window] arrival-delay]
                (if (<= (+ window-time arrival-delay) n)
                  [(+ window-time arrival-delay) (conj window arrival-delay)]
                  (reduced window)))
              [0 []]
              (repeatedly random-customer-arrival-delay)))

    (defn- make-customer [] {:id (make-uuid)})
    (defn- customer-sitting [chair] (:seated chair))
    (defn- customers-sitting [chairs] (filter identity (map customer-sitting chairs)))

    (defn- make-chair
      ([] {:seated nil})
      ([seated] {:seated seated}))

    (defn- chair-empty? [chair] (nil? (customer-sitting chair)))
    (def chair-not-empty? (complement chair-empty?))

    (defn- sit [chair customer]
      {:pre [(chair-empty? chair)]}
      (make-chair customer))

    (defn- stand [chair customer]
      {:pre [(= (customer-sitting chair) customer)]}
      (make-chair))

    (defn- room-full? [chairs] (not-any? chair-empty? chairs))

    (defn- is-sitting-in-any? [chairs customer]
      (contains? (into #{} chairs) (make-chair customer)))

    (defn- sit-in-room [chairs customer]
      (if (some chair-empty? chairs)
        ;; TODO: do it without converting to a vector?
        (let [chairs (vec chairs)]
          (seq (assoc chairs (.indexOf chairs (make-chair)) (make-chair customer))))
        chairs))

    (defn- stand-from-room [chairs customer]
      (if (is-sitting-in-any? chairs customer)
        ;; TODO: do it without converting to a vector?
        (let [chairs (vec chairs)]
          (seq (assoc chairs (.indexOf chairs (make-chair customer)) (make-chair))))
        chairs))

    (defn- make-barber
      ([] {:cutting-hair nil})
      ([customer] {:cutting-hair customer}))

    (defn- perform-haircut [barber customer]
      (Thread/sleep (:haircut-time configuration)))

    (defn- move-to-barber-room [barber-shop customer]
      {:pre [(is-sitting-in-any? (:waiting-room-chairs barber-shop) customer)
             (not (is-sitting-in-any? (:barber-chairs barber-shop) customer))]}
      (-> barber-shop
          (update-in [:waiting-room-chairs] #(stand-from-room % customer))
          (update-in [:barber-chairs] #(sit-in-room % customer))))

    (defn- arrive [barber-shop customer]
      (if (room-full? (:waiting-room-chairs barber-shop))
        (do
          (append-to-log (format "%-27s %s" "turned away " customer))
          barber-shop)
        (update-in barber-shop [:waiting-room-chairs] #(sit-in-room % customer))))

    (defn- leave [barber-shop customer]
      {:pre [(or (is-sitting-in-any? (:waiting-room-chairs barber-shop) customer)
                 (is-sitting-in-any? (:barber-chairs barber-shop) customer))]}
      (-> barber-shop
          (update-in [:waiting-room-chairs] #(stand-from-room % customer))
          (update-in [:barber-chairs] #(stand-from-room % customer))))

    (defn simulate-customer-arrivals! [barber-shop arrival-delays]
      (doseq [arrival-delay arrival-delays]
        (Thread/sleep arrival-delay)
        (swap! barber-shop arrive (make-customer))))

    (defn- watch-room [reference room-key room-name]
      (add-watch reference
                 room-key
                 (fn [_ _ {old-room-chairs room-key} {new-room-chairs room-key}]
                   (let [[only-in-old-room-chairs
                          only-in-new-room-chairs
                          _] (data/diff old-room-chairs new-room-chairs)]
                     (when-let [removed-room-chairs
                                (seq (customers-sitting
                                       (filter identity only-in-old-room-chairs)))]
                       (doseq [removed-room-chair removed-room-chairs]
                         (append-to-log (format "%-27s %s" (str "left " room-name)
                                                removed-room-chair))))
                     (when-let [added-room-chairs
                                (seq (customers-sitting
                                       (filter identity only-in-new-room-chairs)))]
                       (doseq [added-room-chair added-room-chairs]
                         (append-to-log (format "%-27s %s" (str "entered " room-name)
                                                added-room-chair))))))))


    (defn- make-receptionist []
      (watch-room barber-shop :waiting-room-chairs "waiting room")
      (watch-room barber-shop :barber-chairs "barber room")
      (add-watch barber-shop
                 :haircuts
                 (fn [_ reference _ {new-waiting-room-chairs :waiting-room-chairs
                                     new-barber-chairs :barber-chairs}]
                   (when (and (every? chair-empty? new-barber-chairs)
                              (not-every? chair-empty? new-waiting-room-chairs))
                     (let [customer (first (customers-sitting new-waiting-room-chairs))]
                       (swap! reference move-to-barber-room customer)
                       (future
                         (append-to-log (format "%-27s %s" "started haircut" customer))
                         (perform-haircut nil customer)
                         (append-to-log (format "%-27s %s" "ended haircut" customer))
                         (swap! reference leave customer)))))))

    (defn- make-report [log]
      (merge
        configuration
        {:haircuts-performed (count (filter #(.contains % "ended haircut") log))
         :customers-turned-away-count (count (filter #(.contains % "turned away") log))
         :barber-shop-runtime [(/ (:barber-shop-runtime configuration) 1000) :seconds]}))

    (def barber-shop
      (atom
        {:waiting-room-chairs (repeatedly (:waiting-room-chairs-count configuration) make-chair)
         :barbers (repeatedly (:barbers-count configuration) make-barber)
         :barber-chairs (repeatedly (:barber-chairs-count configuration) make-chair)}
        :validator (fn [{:keys [waiting-room-chairs barber-chairs]}]
                     (empty? (set/intersection
                               (into #{} (customers-sitting waiting-room-chairs))
                               (into #{} (customers-sitting barber-chairs)))))))

    (defn- main []
      (make-receptionist)
      (simulate-customer-arrivals!
        barber-shop
        (n-seconds-customer-arrival-delay-window (:barber-shop-runtime configuration)))
      (make-report @log))
    ```
