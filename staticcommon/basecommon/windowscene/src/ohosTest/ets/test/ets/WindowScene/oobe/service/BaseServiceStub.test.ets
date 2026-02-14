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
import { describe, it, expect, beforeEach} from '@ohos/hypium';
import {
  BaseServiceStub,
  IService,
} from '../../../../../../../main/ets/oobe/service/BaseServiceStub';

export function BaseServiceStubTest() {
  describe('BaseServiceStubTest', () => {
    let stub: TestServiceStub;
    beforeEach(() => {
      stub = new TestServiceStub('TestServiceStub');
    });

    it('onRemoteMessageRequest_InvalidRequestCodeTest', 0, async (): Promise<void> => {
      const reply = new rpc.MessageSequence();
      const result = await stub.onRemoteMessageRequest(0, stub.buildSimpleData(), reply, null);
      expect(result).assertFalse();
    });

    it('onRemoteMessageRequest_OnCallTest', 0, async (): Promise<void> => {
      const reply = new rpc.MessageSequence();
      const result = await stub.onRemoteMessageRequest(1, stub.buildSimpleData(), reply, null);
      expect(result).assertTrue();
    });
  });
}

/**
 * 测试stub, 继承虚基类用于测试
 */
class TestServiceStub extends BaseServiceStub {
  protected getTag(): string {
    return 'TestServiceStub';
  }

  protected initServiceMap(): Map<number, () => IService> {
    return new Map<number, () => IService>([
      [1, (): IService => new TestService()],
    ]);
  }

  public buildSimpleData(): rpc.MessageSequence {
    let data = new rpc.MessageSequence();
    data.writeString('TestServiceStub send simple data ...');
    return data;
  }
}

/**
 * 测试Service, 用于测试BaseService中对接口的调用
 */
class TestService implements IService {
  public onCall(json: string): Promise<string> {
    return new Promise((resolve) => {
      resolve('TestService');
    })
  }
}
