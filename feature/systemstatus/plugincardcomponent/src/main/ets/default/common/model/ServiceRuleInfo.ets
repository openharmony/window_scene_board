/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import rpc from '@ohos.rpc';
import { ContinuityState } from './ContinuityState';

export class ServiceRuleInfo extends rpc.MessageSequence {
  public serviceName: string;
  public state: ContinuityState;
  public priority: number;

  constructor(serviceName: string, state: ContinuityState, priority: number) {
    super();
    this.serviceName = serviceName;
    this.state = state;
    this.priority = priority;
  }

  public marshalling(dataOut: rpc.MessageSequence): boolean {
    dataOut.writeString(this.serviceName);
    dataOut.writeInt(this.state);
    dataOut.writeInt(this.priority);
    return true;
  }

  public unmarshalling(dataIn: rpc.MessageSequence): boolean {
    this.serviceName = dataIn.readString();
    this.state = dataIn.readInt();
    this.priority = dataIn.readInt();
    return true;
  }

  public toString(): string {
    return 'serviceName:' + this.serviceName + ', state:' + this.state.toString() + ', priority:' +
    this.priority.toString();
  }
}