/*
 * This file is part of Strimzi Cluster <https://github.com/StevenJDH/helm-charts>.
 * Copyright (C) 2025 Steven Jenkins De Haro.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  Writer,
  SchemaRegistry,
  SCHEMA_TYPE_STRING,
  SCHEMA_TYPE_JSON,
  TLS_1_2
} from "k6/x/kafka";

// Reference: https://k6.io/docs/using-k6/k6-options/
export const options = {
  thresholds: {
    kafka_writer_message_count: ["count > 0"],
    kafka_writer_error_count: ["count == 0"],
  },
  scenarios: {
    load_test: {
      exec: "load_test",
      executor: "constant-vus",
      vus: __ENV.VUS,
      duration: __ENV.DURATION,
      gracefulStop: __ENV.GRACEFUL_STOP,
    },
  },
};

const writer = new Writer({
  brokers: [__ENV.BOOTSTRAP_URL],
  topic: __ENV.TOPIC,
  tls: {
    enableTls: true,
    insecureSkipTLSVerify: false,
    minVersion: TLS_1_2,
    clientCertPem: __ENV.CERT_PATH,
    clientKeyPem: __ENV.KEY_PATH,
    serverCaPem: __ENV.CA_PATH,
  },
});

const schemaRegistry = new SchemaRegistry();

export function load_test() {
  writer.produce({
    messages: [
      {
        key: schemaRegistry.serialize({
          data: "a-key",
          schemaType: SCHEMA_TYPE_STRING,
        }),
        value: schemaRegistry.serialize({
          data: {
            id: 1,
            source: __ENV.POD_NAME,
            namespace: __ENV.NAMESPACE,
            cluster: __ENV.CLUSTER,
            message: "Hello World!"
          },
          schemaType: SCHEMA_TYPE_JSON,
        }),
        headers: {
          foo: "bar",
        },
        time: new Date(), // Converts to timestamp automatically.
      },
    ],
  });
}

export function teardown(data) {
  if (writer) writer.close();
}