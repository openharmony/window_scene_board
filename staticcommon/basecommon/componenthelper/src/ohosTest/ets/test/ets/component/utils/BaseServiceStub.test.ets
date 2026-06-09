/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import rpc from '@ohos.rpc';
import { BaseServiceStub, IService } from '../../../../../../main/ets/utils/BaseServiceStub';

/**
 * BaseServiceStub DT测试套
 */
export function BaseServiceStubTest() {
  describe('BaseServiceStubTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('BaseServiceStub_simple_mode', Level.LEVEL0, async (done: Function) => {
        let provider: TestProviderServiceStub = new TestProviderServiceStub('TestProviderServiceStub');
        expect(provider).not().assertNull();
        let simpleReply = new rpc.MessageSequence();
        let result = await provider.onRemoteMessageRequest(1, provider.buildSimpleData(), simpleReply, null);
        expect(result).assertTrue();
        done();
    })

    it('BaseServiceStub_segment_mode', Level.LEVEL0, async (done: Function) => {
      let provider: TestProviderServiceStub = new TestProviderServiceStub('TestProviderServiceStub');
      expect(provider).not().assertNull();
      let segmentReply = new rpc.MessageSequence();
      let result = await provider.onRemoteMessageRequest(2, provider.buildSegmentData(), segmentReply, null);
      expect(result).assertTrue();
      done();
    })

    it('BaseServiceStub_cannot_find_service', Level.LEVEL0, async (done: Function) => {
      let provider: TestProviderServiceStub = new TestProviderServiceStub('TestProviderServiceStub');
      expect(provider).not().assertNull();
      let segmentReply = new rpc.MessageSequence();
      let result = await provider.onRemoteMessageRequest(3, provider.buildSegmentData(), segmentReply, null);
      expect(result).assertFalse();
      done();
    })

    it('BaseServiceStub_simple_mode', Level.LEVEL0, async (done: Function) => {
      let provider: TestProviderServiceStub = new TestProviderServiceStub('TestProviderServiceStub');
      expect(provider).not().assertNull();
      let simpleReply = new rpc.MessageSequence();
      let result1 = await provider.onRemoteMessageRequest(1,null, simpleReply, null);
      expect(result1).assertFalse();
      let result2 = await provider.onRemoteMessageRequest(1, provider.buildSimpleData(), null, null);
      expect(result2).assertFalse();
      let result3 = await provider.onRemoteMessageRequest(1, provider.buildSimpleData(), undefined, null);
      expect(result3).assertFalse();
      let result = await provider.onRemoteMessageRequest(8, provider.buildSegmentData(), simpleReply, null);
      expect(provider).not().assertUndefined();
      done();
    })
  })
}

/**
 * RPC的ProviderService
 */
class TestProviderServiceStub extends BaseServiceStub {
  protected getTag(): string {
    return 'TestProviderServiceStub';
  }

  protected initServiceMap(): Map<number, () => IService> {
    return new Map<number, () => IService>([
      [1, (): IService => new TestSimpleService()],
      [2, (): IService => new TestSegmentService()],
    ]);
  }

  public buildSimpleData(): rpc.MessageSequence {
    let data = new rpc.MessageSequence();
    data.writeString('TestProviderServiceStub send simple data ...');
    return data;
  }

  public checkSimpleReply(reply: rpc.MessageSequence): boolean {
    let data = reply.readString();
    if (data === 'TestProviderServiceStub send simple data ...') {
      return true;
    }
    return false;
  }

  public buildSegmentData(): rpc.MessageSequence {
    let data = new rpc.MessageSequence();
    data.writeInt(2);
    data.writeString('TestProviderServiceStub send segment data 1...');
    data.writeString('TestProviderServiceStub send segment data 2...');
    return data;
  }

  public checkSegmentReply(reply: rpc.MessageSequence): boolean {
    let count = reply.readInt();
    if (count !== 2) {
      return false;
    }

    let data = reply.readString();
    if (data !== 'TestProviderServiceStub send segment data 1...') {
      return false;
    }
    data = reply.readString();
    if (data !== 'TestProviderServiceStub send segment data 2...') {
      return false;
    }

    return true;
  }
}

/**
 * 简单服务
 */
class TestSimpleService implements IService {
  onCall(json: string): Promise<string> {
    return new Promise((resolve, reject) => {
      resolve('TestSimpleService reply ...');
    });
  }

  isSupportSegments(): boolean {
    return false;
  }
}

/**
 * 支持分片的服务
 */
class TestSegmentService implements IService {
  onCall(json: string): Promise<string> {
    return new Promise((resolve, reject) => {
      resolve('TestSegmentService reply ...');
    });
  }

  isSupportSegments(): boolean {
    return true;
  }
}