//
//  MonoHtmlSource.swift
//  
//
//  Created by Umar Abdullahi on 28/09/2020.
//

import Foundation

struct MonoHtmlSource {
    let publicKey: String
    
    func GetString() -> String {
        let str = """
            <!DOCTYPE html>
            <html lang="en">
                <head>
                  <meta charset="UTF-8">
                  <meta http-equiv="X-UA-Compatible" content="ie=edge">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <title>Mono Connect</title>
                </head>
                <body onload="setupMonoConnect()" style="background-color:#fff;height:100vh;overflow: scroll;">
                  <script src="https://connect.withmono.com/connect.js"></script>
                  <script type="text/javascript">
                    window.onload = setupMonoConnect;
                    function setupMonoConnect() {
                      const options = {
                        onSuccess: function(data) {
                          const response = {event: 'done', data: {...data}}
                          window.webkit.messageHandlers.done.postMessage(response);
                        },
                        onClose: function() {
                          const response = {event: 'closed', data: null}
                          window.webkit.messageHandlers.closed.postMessage(response);
                        }
                      };
                      const MonoConnect = new Connect("\(publicKey)", options);
                      MonoConnect.setup();
                      MonoConnect.open()
                    }
                  </script>
                </body>
            </html>
        """
        
        return str
    }
}
