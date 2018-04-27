-- setup gpio
gpio.mode(3, gpio.OUTPUT)
gpio.mode(4, gpio.OUTPUT)

gpio.write(4, gpio.LOW)
gpio.write(3, gpio.LOW)

topic = "table3"
m = mqtt.Client(topic, 120, "rgvtpvvg", "p1CTGZHxybZf")



m:lwt("/lwt", "offline", 0, 0)

m:on("connect", function(client) print ("connected") end)
m:on("offline", function(client) print ("offline") end)

m:on("message", function(client, topic, data)
       print(topic .. ":" )
       if data ~= nil then
         print("got a message!: " .. data)
         if data == "up" then
           print("going UP!")
           gpio.write(3, gpio.LOW)
           gpio.write(4, gpio.HIGH)
         end
         if data == "down" then
           print("going down!")
           gpio.write(4, gpio.LOW)
           gpio.write(3, gpio.HIGH)
         end
         if data == "stop" then
           gpio.write(3, gpio.LOW)
           gpio.write(4, gpio.LOW)
           print("stopping")
         end

       end
end)

m:connect("m23.cloudmqtt.com", 29916, 1, function(client)
            print("connected")
            -- Calling subscribe/publish only makes sense once the connection
            -- was successfully established. You can do that either here in the
            -- 'connect' callback or you need to otherwise make sure the
            -- connection was established (e.g. tracking connection status or in
            -- m:on("connect", function)).

            -- subscribe topic with qos = 0
            client:subscribe(topic, 0, function(client) print("subscribe success") end)
            -- publish a message with data = hello, QoS = 0, retain = 0
            client:publish(topic, "hello from " .. topic, 0, 0, function(client) print("sent") end)
                                     end,
          function(client, reason)
            print("failed reason: " .. reason)
end)
