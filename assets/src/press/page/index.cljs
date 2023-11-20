(ns press.page.index
  (:require
   [hoplon.core  :as h]
   [javelin.core :as j :refer [cell cell=]]
   ;[hoplon.svg :as svg]
   ))

(defonce clicks (cell 0))
(def home
  (h/div
    :id "playground"
    (h/main
      (h/header
        (h/h1 "SOME TITLE")
        (h/h3 "A sub heading"))
      (h/button :click #(swap! clicks inc) "click me")
      (h/p (h/text "You've clicked ~{clicks} times, so far."))
      )))

(defn init! []
  (let [
    app    (.getElementById js/document "playground")
    parent (.-parentElement app)]
    (.replaceChild parent (home) app)))

(defn ^{:export true} main [] (init!))
