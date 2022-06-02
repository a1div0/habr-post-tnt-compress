const one_day = 24 * 3600
const one_year = 365 * one_day
const default_date = {
    year: 2019,
    month: 12,
    dayOfMonth: 3,
    hourOfDay: 17,
    minute: 13,
    second: 32
};
const doc_metrics = [
    {type: 'C',    avg_size: 1731,    doc_number: 126140875},
    {type: 'CI',   avg_size: 2439,    doc_number: 126140860},
    {type: 'CSE',  avg_size: 4307,    doc_number: 110253125},
    {type: 'BI',   avg_size: 2351,    doc_number: 125914445},
    {type: 'S',    avg_size: 4202,    doc_number: 99003984},
    {type: 'SI',   avg_size: 2030,    doc_number: 99030024},
    {type: 'SSE',  avg_size: 5481,    doc_number: 96994222},
    {type: 'ACC',  avg_size: 8022,    doc_number: 500011},
    {type: 'CSI',  avg_size: 7166,    doc_number: 500000},
    {type: 'IND',  avg_size: 7623,    doc_number: 500010},
    {type: 'CON',  avg_size: 8101,    doc_number: 500007},
];

let total_num = 0;
for (let doc_info of doc_metrics) {
    total_num += doc_info.doc_number;
}

for (let doc_info of doc_metrics) {
    doc_info.share = doc_info.doc_number / total_num;
}

export function rnd(min, max) {
    const _min = !!min ? min : 0;
    const _max = !!max ? max : 1;
    let result = Math.random() * (_max - _min) + _min;
    if (max > 1) {
        result = Math.floor(result);
    }
    return result;
}

function coin(prob) {
    return rnd() < prob;
}

function choose_doc_type() {
    const roll = rnd();
    let thresh = 0.0;
    for (let doc_info of doc_metrics) {
        if ((roll >= thresh) && (roll < thresh + doc_info.share)) {
            return doc_info;
        }
        thresh += doc_info.share;
    }
}

function choose_random(array) {
    return array[rnd(0, array.length - 1)];
}

function format_08x(int) {
    const hex = int.toString(16);
    return '00000000'.substring(hex.length) + hex;
}

function random_timestamp(duration) {
    const now = new Date();
    return Math.floor(now.getTime()/1000) - rnd(0, duration);
}

function random_composite_date(duration) {
    const dt = new Date(random_timestamp(duration)*1000);
    return {
        year: dt.getFullYear(),
        month: dt.getMonth() + 1,
        dayOfMonth: dt.getDay(),
        hourOfDay: dt.getHours(),
        minute: dt.getMinutes(),
        second: dt.getMilliseconds()
    };
}

function randomize_pe(number) {
    let pe = [];
    for (let i = 1; i <= number; i++) {
        const item = {
            date: random_timestamp(one_year),
            type: choose_random(['SANC_EXEC', 'SOME_PE_TYPE', 'ANOTHER_PE_TYPE']),
            sancExecId: '1DC141916',
            discr: 'SERV_DISABLE',
            context: {
                objectLevel: 'SSE',
                objectId: '24600463'
            }
        };
        pe.push(item);
    }
    return pe;
}

function generate_body(body_len) {
    let body = {
        attributes: {
            actualDateMap: {},
            removeDateMap: {},
            attrsMap: {}
        },
        attributesHistory: {}
    };
    for (let i = 1; i <= body_len; i++) {
        let key_name = 'body_param_' + (i < 10 ? '0' : '') + i;
        body[key_name] = rnd(0, 100500100500).toString();
    }
    return JSON.stringify(body);
}

export function randomizeDoc() {
    const doc_info = choose_doc_type()

    let body_len = Math.max(0, (doc_info.avg_size - 673)) / 34;
    body_len = Math.max(0, body_len - 5) + rnd(0, 10);
    body_len = Math.floor(body_len);

    const doc = {
        attrs: {
            lastActivityDate: coin(0.1) ? random_composite_date(10 * one_year) : default_date,
            lastChangeDate: coin(0.9) ? random_composite_date(10 * one_year) : default_date,
            strMap: {
                BOT: doc_info.type,
                BOID: rnd(1, 100 * 1000 * 1000).toString(),
                CLNT_ID: rnd(1, 100 * 1000 * 1000).toString(),
                PROF_HASH_1: coin(0.4) ? format_08x(rnd(0, 255) * 16777215) : '100001',
                PROF_HASH_2: 'nil',
                //NAME_CLNT_HIST: params.name_clnt_hist,
                MGR_STATUS: coin(0.1) ? 'FINISH_OUT' : ""
            },
            longMap: {
                DATA_SOURCE_ID: choose_random([null, null, null, 1, 1, 1, 3, 3, 11]), // тут box.NULL-ы!!! ???
                MACR_ID: rnd(0, 1000),
                CLIS_ID: 3
            },
            dateMap: {
                //MGR_DATE:
                //MOVE_BAL_DATE:
            }
        },
        ver: "1",
        parts: 0,
        body: body_len ? generate_body(body_len) : "Body {Body} [Body]",
        isZip: false,
        isBase64: false,
        coreVersions: {
            ['8.14.0-SNAPSHOT']: '1580721554072',
            ['8.9.6.1']: '1575887115139',
            ['8.13.0-SNAPSHOT']: '1580583975062'
        },
        removeDateMap: {},
        attrsMap: {}
    }

    if (coin(0.75)) {
        doc.attrs.postponedEvents = randomize_pe(coin(0.75) ? 1 : 2);
    }
    if (coin(0.1)) {
        doc.attrs.dmsPE = {
            date: random_timestamp(3 * one_year)
        }
    }
    if (coin(0.5)) {
        doc.attrs.meta = { ver: '2.0' };
    }

    return doc;
}
