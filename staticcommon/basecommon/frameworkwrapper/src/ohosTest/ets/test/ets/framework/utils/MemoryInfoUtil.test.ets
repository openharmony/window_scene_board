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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import MemoryInfoUtil from '../../../../../../main/ets/utils/MemoryInfoUtil';
import fs from '@ohos.file.fs';
import { ArrayUtils } from '@ohos/basicutils';

export function MemoryInfoUtilTest() {
  const UNIT_BYTE = 'B';
  const UNIT_KB = 'kB';
  const UNIT_KB_UPPER = 'KB';
  const UNIT_MB = 'MB';
  const UNIT_GB = 'GB';

  describe('MemoryInfoUtilTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('MemoryInfoUtilTest_getBytes', 0, (): void => {
      expect(MemoryInfoUtil['getBytes'](0, null)).assertEqual(0);
      expect(MemoryInfoUtil['getBytes'](1, UNIT_BYTE)).assertEqual(1);
      expect(MemoryInfoUtil['getBytes'](1, UNIT_KB)).assertEqual(1024);
      expect(MemoryInfoUtil['getBytes'](1, UNIT_KB_UPPER)).assertEqual(1024);
      expect(MemoryInfoUtil['getBytes'](1, UNIT_MB)).assertEqual(1024 * 1024);
      expect(MemoryInfoUtil['getBytes'](1, UNIT_GB)).assertEqual(1024 * 1024 * 1024);
    })

    it('MemoryInfoUtilTest_getMemoryTotalSize_01', 0, (): void => {
      let size = MemoryInfoUtil.getMemoryTotalSize();
      expect(size).not().assertUndefined();
    })

    it('MemoryInfoUtilTest_getMemoryTotalSize_02', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockerFun: Function = mocker.mockFunc(ArrayUtils, ArrayUtils.isEmpty);
      when(mockerFun)(ArgumentMatchers.any).afterThrow('mocker error');
      let size = MemoryInfoUtil.getMemoryTotalSize();
      expect(size).not().assertUndefined();
      mocker.clear(mockerFun);
      mocker.ignoreMock(ArrayUtils, mockerFun);
      mocker.clearAll();
    })
  })
}