(ns app.main)

(def value-a 6)
(defonce value-b 2)

(defn main! []
  (println "App loaded!"))

(defn reload! []
  (println "Code has been changed.")
  (js/console.log (.getElementById js/document "playground"))
  )
