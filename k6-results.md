# WRITE AND PACK
Стенд такой:
```shell
K6 --> Router --> Storage
```

## Only write
```shell

          /\      |‾‾| /‾‾/   /‾‾/   
     /\  /  \     |  |/  /   /  /    
    /  \/    \    |     (   /   ‾‾\  
   /          \   |  |\  \ |  (‾)  | 
  / __________ \  |__| \__\ \_____/ .io

  execution: local
     script: test-write.js
     output: -

  scenarios: (100.00%) 1 scenario, 10 max VUs, 1m0s max duration (incl. graceful stop):
           * scenarioWrite: 100000 iterations shared among 10 VUs (maxDuration: 30s, exec: scenarioWrite, gracefulStop: 30s)


running (0m14.1s), 00/10 VUs, 100000 complete and 0 interrupted iterations
scenarioWrite ✓ [======================================] 10 VUs  14.1s/30s  100000/100000 shared iters

     ✓ doc_post - status was 200

     checks.........................: 100.00%   ✓ 100000          ✗ 0     
     data_received..................: 23 MB     1.6 MB/s
     data_sent......................: 341 MB    24 MB/s
     http_req_blocked...............: avg=2.46µs   min=867ns    med=1.75µs   max=8.02ms   p(90)=2.55µs  p(95)=2.9µs  
     http_req_connecting............: avg=13ns     min=0s       med=0s       max=486.55µs p(90)=0s      p(95)=0s     
     http_req_duration..............: avg=716.21µs min=181.54µs med=563.39µs max=12.44ms  p(90)=1.22ms  p(95)=1.55ms 
       { expected_response:true }...: avg=716.21µs min=181.54µs med=563.39µs max=12.44ms  p(90)=1.22ms  p(95)=1.55ms 
     http_req_failed................: 0.00%     ✓ 0               ✗ 100000
     http_req_receiving.............: avg=31.1µs   min=8.01µs   med=17.47µs  max=11.49ms  p(90)=27.92µs p(95)=49.88µs
     http_req_sending...............: avg=20.08µs  min=5.46µs   med=12.75µs  max=6.51ms   p(90)=25.54µs p(95)=31.25µs
     http_req_tls_handshaking.......: avg=0s       min=0s       med=0s       max=0s       p(90)=0s      p(95)=0s     
     http_req_waiting...............: avg=665.02µs min=161.39µs med=519.74µs max=9.87ms   p(90)=1.16ms  p(95)=1.46ms 
     http_reqs......................: 100000    7075.63449/s
     iteration_duration.............: avg=1.4ms    min=376.96µs med=1.18ms   max=14.96ms  p(90)=2.21ms  p(95)=2.85ms 
     iterations.....................: 100000    7075.63449/s
     send_bytes.....................: 328307117 23229811.603925/s
     vus............................: 10        min=10            max=10  
     vus_max........................: 10        min=10            max=10
```

Параметры спейса:
{"table_size":264833774,"count":94971}

## ZLIB

```shell

          /\      |‾‾| /‾‾/   /‾‾/   
     /\  /  \     |  |/  /   /  /    
    /  \/    \    |     (   /   ‾‾\  
   /          \   |  |\  \ |  (‾)  | 
  / __________ \  |__| \__\ \_____/ .io

  execution: local
     script: test-write.js
     output: -

  scenarios: (100.00%) 1 scenario, 10 max VUs, 1m0s max duration (incl. graceful stop):
           * scenarioWrite: 100000 iterations shared among 10 VUs (maxDuration: 30s, exec: scenarioWrite, gracefulStop: 30s)


running (0m27.8s), 00/10 VUs, 100000 complete and 0 interrupted iterations
scenarioWrite ✓ [======================================] 10 VUs  27.8s/30s  100000/100000 shared iters

     ✓ doc_post - status was 200

     checks.........................: 100.00%   ✓ 100000         ✗ 0     
     data_received..................: 23 MB     816 kB/s
     data_sent......................: 342 MB    12 MB/s
     http_req_blocked...............: avg=1.81µs  min=909ns    med=1.58µs  max=1.24ms   p(90)=2.29µs  p(95)=2.62µs 
     http_req_connecting............: avg=7ns     min=0s       med=0s      max=249.39µs p(90)=0s      p(95)=0s     
     http_req_duration..............: avg=2.27ms  min=369.73µs med=2.22ms  max=11.64ms  p(90)=2.87ms  p(95)=3.15ms 
       { expected_response:true }...: avg=2.27ms  min=369.73µs med=2.22ms  max=11.64ms  p(90)=2.87ms  p(95)=3.15ms 
     http_req_failed................: 0.00%     ✓ 0              ✗ 100000
     http_req_receiving.............: avg=25.59µs min=8.35µs   med=19.25µs max=9.29ms   p(90)=27.01µs p(95)=31.82µs
     http_req_sending...............: avg=16.78µs min=5.4µs    med=12.94µs max=7.89ms   p(90)=23.11µs p(95)=25.17µs
     http_req_tls_handshaking.......: avg=0s      min=0s       med=0s      max=0s       p(90)=0s      p(95)=0s     
     http_req_waiting...............: avg=2.22ms  min=285.68µs med=2.18ms  max=10.65ms  p(90)=2.82ms  p(95)=3.11ms 
     http_reqs......................: 100000    3594.498096/s
     iteration_duration.............: avg=2.77ms  min=599.64µs med=2.67ms  max=13.4ms   p(90)=3.48ms  p(95)=3.85ms 
     iterations.....................: 100000    3594.498096/s
     send_bytes.....................: 329056909 11827944.32757/s
     vus............................: 10        min=10           max=10  
     vus_max........................: 10        min=10           max=10 
```

Параметры спейса:
{"table_size":155357102,"count":86391}

## TNT_ZSTD
```shell
          /\      |‾‾| /‾‾/   /‾‾/   
     /\  /  \     |  |/  /   /  /    
    /  \/    \    |     (   /   ‾‾\  
   /          \   |  |\  \ |  (‾)  | 
  / __________ \  |__| \__\ \_____/ .io

  execution: local
     script: test-write.js
     output: -

  scenarios: (100.00%) 1 scenario, 10 max VUs, 1m0s max duration (incl. graceful stop):
           * scenarioWrite: 100000 iterations shared among 10 VUs (maxDuration: 30s, exec: scenarioWrite, gracefulStop: 30s)


running (0m30.0s), 00/10 VUs, 46964 complete and 0 interrupted iterations
scenarioWrite ✗ [================>---------------------] 10 VUs  30.0s/30s  046964/100000 shared iters

     ✓ doc_post - status was 200

     checks.........................: 100.00%   ✓ 46964          ✗ 0    
     data_received..................: 11 MB     355 kB/s
     data_sent......................: 160 MB    5.3 MB/s
     dropped_iterations.............: 53036     1767.521454/s
     http_req_blocked...............: avg=2.12µs  min=949ns    med=1.72µs  max=1.86ms   p(90)=2.35µs  p(95)=2.62µs 
     http_req_connecting............: avg=20ns    min=0s       med=0s      max=185.44µs p(90)=0s      p(95)=0s     
     http_req_duration..............: avg=5.78ms  min=668.09µs med=5.69ms  max=13.06ms  p(90)=7.34ms  p(95)=7.95ms 
       { expected_response:true }...: avg=5.78ms  min=668.09µs med=5.69ms  max=13.06ms  p(90)=7.34ms  p(95)=7.95ms 
     http_req_failed................: 0.00%     ✓ 0              ✗ 46964
     http_req_receiving.............: avg=25.8µs  min=9.38µs   med=19.97µs max=4.39ms   p(90)=32.55µs p(95)=42.12µs
     http_req_sending...............: avg=19.42µs min=4.78µs   med=13.29µs max=3.34ms   p(90)=26.11µs p(95)=29.46µs
     http_req_tls_handshaking.......: avg=0s      min=0s       med=0s      max=0s       p(90)=0s      p(95)=0s     
     http_req_waiting...............: avg=5.74ms  min=633.65µs med=5.64ms  max=12.96ms  p(90)=7.29ms  p(95)=7.89ms 
     http_reqs......................: 46964     1565.160977/s
     iteration_duration.............: avg=6.38ms  min=992.14µs med=6.26ms  max=14.47ms  p(90)=8.04ms  p(95)=8.75ms 
     iterations.....................: 46964     1565.160977/s
     send_bytes.....................: 153916101 5129534.856361/s
     vus............................: 10        min=10           max=10 
     vus_max........................: 10        min=10           max=10
```

Параметры спейса:
{"table_size":42329250,"count":37377}

## LZ4
```shell

          /\      |‾‾| /‾‾/   /‾‾/   
     /\  /  \     |  |/  /   /  /    
    /  \/    \    |     (   /   ‾‾\  
   /          \   |  |\  \ |  (‾)  | 
  / __________ \  |__| \__\ \_____/ .io

  execution: local
     script: test-write.js
     output: -

  scenarios: (100.00%) 1 scenario, 10 max VUs, 1m0s max duration (incl. graceful stop):
           * scenarioWrite: 100000 iterations shared among 10 VUs (maxDuration: 30s, exec: scenarioWrite, gracefulStop: 30s)


running (0m15.7s), 00/10 VUs, 100000 complete and 0 interrupted iterations
scenarioWrite ✓ [======================================] 10 VUs  15.7s/30s  100000/100000 shared iters

     ✓ doc_post - status was 200

     checks.........................: 100.00%   ✓ 100000         ✗ 0     
     data_received..................: 23 MB     1.4 MB/s
     data_sent......................: 341 MB    22 MB/s
     http_req_blocked...............: avg=2.17µs   min=881ns    med=1.72µs   max=4.23ms   p(90)=2.5µs   p(95)=2.82µs 
     http_req_connecting............: avg=16ns     min=0s       med=0s       max=582.16µs p(90)=0s      p(95)=0s     
     http_req_duration..............: avg=934.78µs min=215.64µs med=807.08µs max=13.13ms  p(90)=1.45ms  p(95)=1.79ms 
       { expected_response:true }...: avg=934.78µs min=215.64µs med=807.08µs max=13.13ms  p(90)=1.45ms  p(95)=1.79ms 
     http_req_failed................: 0.00%     ✓ 0              ✗ 100000
     http_req_receiving.............: avg=28.71µs  min=7.96µs   med=18.12µs  max=12.35ms  p(90)=26.99µs p(95)=36.07µs
     http_req_sending...............: avg=19.22µs  min=5.18µs   med=12.6µs   max=7.6ms    p(90)=25.26µs p(95)=29.56µs
     http_req_tls_handshaking.......: avg=0s       min=0s       med=0s       max=0s       p(90)=0s      p(95)=0s     
     http_req_waiting...............: avg=886.83µs min=187.26µs med=764.93µs max=9.51ms   p(90)=1.4ms   p(95)=1.71ms 
     http_reqs......................: 100000    6351.669009/s
     iteration_duration.............: avg=1.56ms   min=464.36µs med=1.38ms   max=14.5ms   p(90)=2.31ms  p(95)=2.94ms 
     iterations.....................: 100000    6351.669009/s
     send_bytes.....................: 328277936 20851127.92575/s
     vus............................: 10        min=10           max=10  
     vus_max........................: 10        min=10           max=10  

```

Параметры спейса:
{"table_size":120224181,"count":63171}

