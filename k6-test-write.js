import http from 'k6/http';
import { check } from 'k6';
import { Counter } from 'k6/metrics';
import {rnd, randomizeDoc} from './data-gen.js';

const sendedBytes = new Counter('send_bytes');
const baseUrl = 'http://localhost:8888/api';
const doc_qty = 100 * 1000;

export const options = {
    scenarios: {
        scenarioWrite: {
            exec: 'scenarioWrite',
            executor: 'shared-iterations',
            vus: 10,
            iterations: doc_qty,
            maxDuration: '30s',
        }
    }
}

export const scenarioWrite = () => {
    const uid = rnd(0, doc_qty);
    const doc = randomizeDoc();
    const body = JSON.stringify(doc);
    const result = http.post(baseUrl + `/doc_post?uid=` + uid, body);
    check(result, {'doc_post - status was 200': (r) => r.status === 200 });
    sendedBytes.add(body.length);
}
