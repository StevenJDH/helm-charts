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

import { check } from "k6";
import {
  Reader,
  SchemaRegistry,
  SCHEMA_TYPE_JSON,
  TLS_1_2
} from "k6/x/kafka";

// Reference: https://k6.io/docs/using-k6/k6-options/
export const options = {
  thresholds: {
    kafka_reader_message_count: ["count > 0"],
    kafka_reader_error_count: ["count == 0"],
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

const reader = new Reader({
  brokers: [__ENV.BOOTSTRAP_URL],
  groupID: __ENV.CONSUMER_GROUP,
  groupTopics: [__ENV.TOPIC],
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
  // Read 1 message only.
  let messages = reader.consume({ limit: 1, expectTimeout: false });

  check(messages[0], {
    "Message has the expected value": (message) =>
      schemaRegistry.deserialize({
        data: message.value,
        schemaType: SCHEMA_TYPE_JSON,}).message === "Hello World!",
    "Message has the expected id": (message) =>
      schemaRegistry.deserialize({
        data: message.value,
        schemaType: SCHEMA_TYPE_JSON,}).id === 1,
    "Time of message is in past": (message) => new Date(message.time) < new Date(),
    "High watermark is gte zero": (message) => message.highWaterMark >= 0,
  });
}

export function teardown(data) {
  if (reader) reader.close();
}