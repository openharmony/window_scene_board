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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit } from '@ohos/hypium';
import { TraceUtil } from '../../../../../../main/ets/utils/TraceUtil';
import { DomainName } from '../../../../../../main/ets/utils/LogHelper';

export function TraceUtilTest() {
  describe('TraceUtilTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('traceOnce', 0, (): void => {
      expect(TraceUtil.traceOnce(DomainName.SCB, 'traceOnceTest') === undefined).assertTrue();
    })

    it('startTrace', 0, (): void => {
      expect(TraceUtil.startTrace(DomainName.SCB, 'startTrace') === undefined).assertTrue();
      TraceUtil.endTrace(DomainName.SCB, 'startTrace');
    })

    it('startTraceWithTaskNameExisted', 0, (): void => {
      TraceUtil.startTrace(DomainName.SCB, 'startTraceAgain');
      expect(TraceUtil.startTrace(DomainName.SCB, 'startTraceAgain') === undefined).assertTrue();
      TraceUtil.endTrace(DomainName.SCB, 'startTraceAgain');
    })

    it('endTraceWithTaskNameRemoved', 0, (): void => {
      TraceUtil.startTrace(DomainName.SCB, 'startTraceAgainAndAgain');
      TraceUtil.endTrace(DomainName.SCB, 'startTraceAgainAndAgain');
      expect(TraceUtil.endTrace(DomainName.SCB, 'startTraceAgainAndAgain') === undefined).assertTrue();
    })

    it('startTraceWithTaskId', 0, (): void => {
      expect(TraceUtil.startTraceWithTaskId(DomainName.SCB, 'startTraceWithId', 18888) === undefined).assertTrue();
      TraceUtil.endTraceWithTaskId(DomainName.SCB, 'startTraceWithId', 18888);
    })

    it('startAnimTrace', 0, (): void => {
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(TraceUtil, TraceUtil.startAnimTrace);
      TraceUtil.startAnimTrace(DomainName.SCB, 'startAnimTrace');
      mocker.verify('startAnimTrace', [DomainName.SCB, 'startAnimTrace']).once();
      TraceUtil.endAnimTrace(DomainName.SCB, 'startAnimTrace');
      mocker.clear(TraceUtil);
      mocker.clearAll();
    })

    it('endAnimTraceWithTaskNameRemoved', 0, (): void => {
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(TraceUtil, TraceUtil.endAnimTrace);
      TraceUtil.startAnimTrace(DomainName.SCB, 'startAnimTraceAgain');
      TraceUtil.endAnimTrace(DomainName.SCB, 'startAnimTraceAgain');
      TraceUtil.endAnimTrace(DomainName.SCB, 'startAnimTraceAgain');
      mocker.verify('endAnimTrace', [DomainName.SCB, 'startAnimTraceAgain']).atLeast(2);
      mocker.clear(TraceUtil);
      mocker.clearAll();
    })

    it('domain_is_not_enable', 0, (): void => {
      TraceUtil.traceOnce('domain', 'traceOnceTest');
      TraceUtil.startTrace('domain', 'traceOnceTest');
      TraceUtil.endTrace('domain', 'traceOnceTest');
      TraceUtil.startTraceWithTaskId('domain', 'traceOnceTest', 18888);
      TraceUtil.endTraceWithTaskId('domain', 'traceOnceTest', 18888);
      TraceUtil.startAnimTrace('domain', 'traceOnceTest');
    })
  })
}