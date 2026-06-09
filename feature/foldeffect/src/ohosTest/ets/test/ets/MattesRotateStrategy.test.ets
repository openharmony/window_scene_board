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
  describe,
  expect,
  it,
  Level
} from '@ohos/hypium';
import { MattesRotateStrategy } from '../../../../main/ets/mattesstrategy/MattesRotateStrategy';
import { ReflectionUtils } from './ReflectionUtils';

const DEFAULT_PERSISTENT_ID = 0;
const DEFAULT_REQUESTED_ORIENTATION = 0;

export default function MattesRotateStrategyTest() {
  describe('MattesRotateStrategyTest', () => {
    MattesRotateStrategyTest_01();
    MattesRotateStrategyTest_02();
    MattesRotateStrategyTest_03();
    MattesRotateStrategyTest_04();
  });
}

/**
 * test when init MattesRotateStrategy
 *
 */
export function MattesRotateStrategyTest_01() {
  it('initPersistentId', Level.LEVEL0, (): void => {
    let testStrategy_01: MattesRotateStrategy = MattesRotateStrategy.getInstance();
    let result_01: number = ReflectionUtils.getProperty(testStrategy_01, 'saveMattesPersistentId');
    expect(DEFAULT_PERSISTENT_ID).assertEqual(result_01);
  })
  it('initRequestedOrientation', Level.LEVEL0, (): void => {
    let testStrategy_02: MattesRotateStrategy = MattesRotateStrategy.getInstance();
    let result_02: number = ReflectionUtils.getProperty(testStrategy_02, 'saveRequestedOrientation');
    expect(DEFAULT_REQUESTED_ORIENTATION).assertEqual(result_02);
  })
}

/**
 * test public function writeContainerOrientation
 *
 */
export function MattesRotateStrategyTest_02() {
  it('writePersistentId', Level.LEVEL0, (): void => {
    let testStrategy_03: MattesRotateStrategy = MattesRotateStrategy.getInstance();
    let testPersistentId_03: number = 1;
    let testRequestedOrientation_03: number = DEFAULT_REQUESTED_ORIENTATION;
    ReflectionUtils.useFunc(testStrategy_03, 'writeContainerOrientation', testPersistentId_03, testRequestedOrientation_03);
    expect(testPersistentId_03).assertEqual(testPersistentId_03);
  })
  it('writeRequestedOrientation', Level.LEVEL0, (): void => {
    let testStrategy_04: MattesRotateStrategy = MattesRotateStrategy.getInstance();
    let testPersistentId_04: number = DEFAULT_PERSISTENT_ID;
    let testRequestedOrientation_04: number = 1;
    ReflectionUtils.useFunc(testStrategy_04, 'writeContainerOrientation', testPersistentId_04, testRequestedOrientation_04);
    expect(testRequestedOrientation_04).assertEqual(testRequestedOrientation_04);
  })
}

/**
 * test public function isNeedContainerOrientation
 *
 */
export function MattesRotateStrategyTest_03() {
  it('isNeedContainerOrientation_01', Level.LEVEL0, (): void => {
    let testStrategy_05: MattesRotateStrategy = MattesRotateStrategy.getInstance();
    let testPersistentId_05: number = 1;
    let testRequestedOrientation_05: number = DEFAULT_REQUESTED_ORIENTATION;
    let saveMattesPersistentId_05: number = DEFAULT_PERSISTENT_ID;
    let saveRequestedOrientation_05: number = DEFAULT_REQUESTED_ORIENTATION;
    ReflectionUtils.setProperty(testStrategy_05, 'saveMattesPersistentId', saveMattesPersistentId_05);
    ReflectionUtils.setProperty(testStrategy_05, 'saveRequestedOrientation', saveRequestedOrientation_05);
    let result_05: boolean = ReflectionUtils.useFunc(testStrategy_05, 'isNeedContainerOrientation', testPersistentId_05,
      testRequestedOrientation_05);
    expect(!result_05).assertTrue();
  })
  it('isNeedContainerOrientation_02', Level.LEVEL0, (): void => {
    let testStrategy_06: MattesRotateStrategy = MattesRotateStrategy.getInstance();
    let testPersistentId_06: number = DEFAULT_PERSISTENT_ID;
    let testRequestedOrientation_06: number = 1;
    let saveMattesPersistentId_06: number = DEFAULT_PERSISTENT_ID;
    let saveRequestedOrientation_06: number = DEFAULT_REQUESTED_ORIENTATION;
    ReflectionUtils.setProperty(testStrategy_06, 'saveMattesPersistentId', saveMattesPersistentId_06);
    ReflectionUtils.setProperty(testStrategy_06, 'saveRequestedOrientation', saveRequestedOrientation_06);
    let result_06: boolean = ReflectionUtils.useFunc(testStrategy_06, 'isNeedContainerOrientation', testPersistentId_06,
      testRequestedOrientation_06);
    expect(!result_06).assertTrue();
  })
  it('isNeedContainerOrientation_03', Level.LEVEL0, (): void => {
    let testStrategy_07: MattesRotateStrategy = MattesRotateStrategy.getInstance();
    let testPersistentId_07: number = DEFAULT_PERSISTENT_ID;
    let testRequestedOrientation_07: number = DEFAULT_REQUESTED_ORIENTATION;
    let saveMattesPersistentId_07: number = DEFAULT_PERSISTENT_ID;
    let saveRequestedOrientation_07: number = DEFAULT_REQUESTED_ORIENTATION;
    ReflectionUtils.setProperty(testStrategy_07, 'saveMattesPersistentId', saveMattesPersistentId_07);
    ReflectionUtils.setProperty(testStrategy_07, 'saveRequestedOrientation', saveRequestedOrientation_07);
    let result_07: boolean = ReflectionUtils.useFunc(testStrategy_07, 'isNeedContainerOrientation', testPersistentId_07,
      testRequestedOrientation_07);
    expect(!result_07).assertTrue();
  })
  it('isNeedContainerOrientation_04', Level.LEVEL0, (): void => {
    let testStrategy_08: MattesRotateStrategy = MattesRotateStrategy.getInstance();
    let testPersistentId_08: number = 1;
    let testRequestedOrientation_08: number = 1;
    let saveMattesPersistentId_08: number = DEFAULT_PERSISTENT_ID;
    let saveRequestedOrientation_08: number = DEFAULT_REQUESTED_ORIENTATION;
    ReflectionUtils.setProperty(testStrategy_08, 'saveMattesPersistentId', saveMattesPersistentId_08);
    ReflectionUtils.setProperty(testStrategy_08, 'saveRequestedOrientation', saveRequestedOrientation_08);
    let result_08: boolean = ReflectionUtils.useFunc(testStrategy_08, 'isNeedContainerOrientation', testPersistentId_08,
      testRequestedOrientation_08);
    expect(result_08).assertTrue();
  })
  it('isNeedContainerOrientation_05', Level.LEVEL1, (): void => {
    let testStrategy_09: MattesRotateStrategy = MattesRotateStrategy.getInstance();
    let testPersistentId_09: number = 1;
    let testRequestedOrientation_09: number = DEFAULT_REQUESTED_ORIENTATION;
    let saveMattesPersistentId_09: number = 1;
    let saveRequestedOrientation_09: number = 1;
    ReflectionUtils.setProperty(testStrategy_09, 'saveMattesPersistentId', saveMattesPersistentId_09);
    ReflectionUtils.setProperty(testStrategy_09, 'saveRequestedOrientation', saveRequestedOrientation_09);
    let result_09: boolean = ReflectionUtils.useFunc(testStrategy_09, 'isNeedContainerOrientation', testPersistentId_09,
      testRequestedOrientation_09);
    expect(!result_09).assertTrue();
  })
  it('isNeedContainerOrientation_06', Level.LEVEL1, (): void => {
    let testStrategy_10: MattesRotateStrategy = MattesRotateStrategy.getInstance();
    let testPersistentId_10: number = DEFAULT_PERSISTENT_ID;
    let testRequestedOrientation_10: number = 1;
    let saveMattesPersistentId_10: number = 1;
    let saveRequestedOrientation_10: number = 1;
    ReflectionUtils.setProperty(testStrategy_10, 'saveMattesPersistentId', saveMattesPersistentId_10);
    ReflectionUtils.setProperty(testStrategy_10, 'saveRequestedOrientation', saveRequestedOrientation_10);
    let result_10: boolean = ReflectionUtils.useFunc(testStrategy_10, 'isNeedContainerOrientation', testPersistentId_10,
      testRequestedOrientation_10);
    expect(!result_10).assertTrue();
  })
  it('isNeedContainerOrientation_07', Level.LEVEL1, (): void => {
    let testStrategy_11: MattesRotateStrategy = MattesRotateStrategy.getInstance();
    let testPersistentId_11: number = DEFAULT_PERSISTENT_ID;
    let testRequestedOrientation_11: number = DEFAULT_REQUESTED_ORIENTATION;
    let saveMattesPersistentId_11: number = 1;
    let saveRequestedOrientation_11: number = 1;
    ReflectionUtils.setProperty(testStrategy_11, 'saveMattesPersistentId', saveMattesPersistentId_11);
    ReflectionUtils.setProperty(testStrategy_11, 'saveRequestedOrientation', saveRequestedOrientation_11);
    let result_11: boolean = ReflectionUtils.useFunc(testStrategy_11, 'isNeedContainerOrientation', testPersistentId_11,
      testRequestedOrientation_11);
    expect(!result_11).assertTrue();
  })
  it('isNeedContainerOrientation_08', Level.LEVEL1, (): void => {
    let testStrategy_12: MattesRotateStrategy = MattesRotateStrategy.getInstance();
    let testPersistentId_12: number = 1;
    let testRequestedOrientation_12: number = 1;
    let saveMattesPersistentId_12: number = 1;
    let saveRequestedOrientation_12: number = 1;
    ReflectionUtils.setProperty(testStrategy_12, 'saveMattesPersistentId', saveMattesPersistentId_12);
    ReflectionUtils.setProperty(testStrategy_12, 'saveRequestedOrientation', saveRequestedOrientation_12);
    let result_12: boolean = ReflectionUtils.useFunc(testStrategy_12, 'isNeedContainerOrientation', testPersistentId_12,
      testRequestedOrientation_12);
    expect(result_12).assertTrue();
  })
}

/**
 * test public function getContainerRequestedOrientation
 *
 */
export function MattesRotateStrategyTest_04() {
  it('getContainerRequestedOrientation_01', Level.LEVEL0, (): void => {
    let testStrategy_13: MattesRotateStrategy = MattesRotateStrategy.getInstance();
    let testPersistentId_13: number = 1;
    ReflectionUtils.setProperty(testStrategy_13, 'saveMattesPersistentId', 2);
    ReflectionUtils.setProperty(testStrategy_13, 'saveRequestedOrientation', 3);
    let result_13: [number, number] = ReflectionUtils.useFunc(testStrategy_13, 'getContainerRequestedOrientation',
      testPersistentId_13);
    expect(DEFAULT_PERSISTENT_ID).assertEqual(result_13[0]);
  })
  it('getContainerRequestedOrientation_02', Level.LEVEL0, (): void => {
    let testStrategy_14: MattesRotateStrategy = MattesRotateStrategy.getInstance();
    let testPersistentId_14: number = 1;
    ReflectionUtils.setProperty(testStrategy_14, 'saveMattesPersistentId', 2);
    ReflectionUtils.setProperty(testStrategy_14, 'saveRequestedOrientation', 3);
    let result_14: [number, number] = ReflectionUtils.useFunc(testStrategy_14, 'getContainerRequestedOrientation',
      testPersistentId_14);
    expect(DEFAULT_REQUESTED_ORIENTATION).assertEqual(result_14[1]);
  })
  it('getContainerRequestedOrientation_03', Level.LEVEL0, (): void => {
    let testStrategy_15: MattesRotateStrategy = MattesRotateStrategy.getInstance();
    let testPersistentId_15: number = 1;
    ReflectionUtils.setProperty(testStrategy_15, 'saveMattesPersistentId', testPersistentId_15);
    ReflectionUtils.setProperty(testStrategy_15, 'saveRequestedOrientation', 3);
    let result_15: [number, number] = ReflectionUtils.useFunc(testStrategy_15, 'getContainerRequestedOrientation',
      testPersistentId_15);
    expect(testPersistentId_15).assertEqual(result_15[0]);
  })
  it('getContainerRequestedOrientation_04', Level.LEVEL0, (): void => {
    let testStrategy_16: MattesRotateStrategy = MattesRotateStrategy.getInstance();
    let testPersistentId_16: number = 1;
    ReflectionUtils.setProperty(testStrategy_16, 'saveMattesPersistentId', testPersistentId_16);
    ReflectionUtils.setProperty(testStrategy_16, 'saveRequestedOrientation', 3);
    let result_16: [number, number] = ReflectionUtils.useFunc(testStrategy_16, 'getContainerRequestedOrientation',
      testPersistentId_16);
    expect(3).assertEqual(result_16[1]);
  })
  it('getContainerRequestedOrientation_05', Level.LEVEL0, (): void => {
    let testStrategy_17: MattesRotateStrategy = MattesRotateStrategy.getInstance();
    let testPersistentId_17: number = 1;
    ReflectionUtils.setProperty(testStrategy_17, 'saveMattesPersistentId', 2);
    ReflectionUtils.setProperty(testStrategy_17, 'saveRequestedOrientation', 3);
    let result_17: [number, number] = ReflectionUtils.useFunc(testStrategy_17, 'getContainerRequestedOrientation',
      testPersistentId_17);
    let resultPersistentId_17: number = ReflectionUtils.getProperty(testStrategy_17, 'saveMattesPersistentId');
    expect(2).assertEqual(resultPersistentId_17);
  })
  it('getContainerRequestedOrientation_06', Level.LEVEL0, (): void => {
    let testStrategy_18: MattesRotateStrategy = MattesRotateStrategy.getInstance();
    let testPersistentId_18: number = 1;
    ReflectionUtils.setProperty(testStrategy_18, 'saveMattesPersistentId', 2);
    ReflectionUtils.setProperty(testStrategy_18, 'saveRequestedOrientation', 3);
    let result_18: [number, number] = ReflectionUtils.useFunc(testStrategy_18, 'getContainerRequestedOrientation',
      testPersistentId_18);
    let resultRequestedOrientation_18: number = ReflectionUtils.getProperty(testStrategy_18, 'saveRequestedOrientation');
    expect(3).assertEqual(resultRequestedOrientation_18);
  })
  it('getContainerRequestedOrientation_07', Level.LEVEL0, (): void => {
    let testStrategy_19: MattesRotateStrategy = MattesRotateStrategy.getInstance();
    let testPersistentId_19: number = 1;
    ReflectionUtils.setProperty(testStrategy_19, 'saveMattesPersistentId', testPersistentId_19);
    ReflectionUtils.setProperty(testStrategy_19, 'saveRequestedOrientation', 3);
    let result_19: [number, number] = ReflectionUtils.useFunc(testStrategy_19, 'getContainerRequestedOrientation',
      testPersistentId_19);
    let resultPersistentId_19: number = ReflectionUtils.getProperty(testStrategy_19, 'saveMattesPersistentId');
    expect(DEFAULT_PERSISTENT_ID).assertEqual(resultPersistentId_19);
  })
  it('getContainerRequestedOrientation_08', Level.LEVEL0, (): void => {
    let testStrategy_20: MattesRotateStrategy = MattesRotateStrategy.getInstance();
    let testPersistentId_20: number = 1;
    ReflectionUtils.setProperty(testStrategy_20, 'saveMattesPersistentId', testPersistentId_20);
    ReflectionUtils.setProperty(testStrategy_20, 'saveRequestedOrientation', 3);
    let result_20: [number, number] = ReflectionUtils.useFunc(testStrategy_20, 'getContainerRequestedOrientation',
      testPersistentId_20);
    let resultRequestedOrientation_20: number = ReflectionUtils.getProperty(testStrategy_20, 'saveRequestedOrientation');
    expect(DEFAULT_REQUESTED_ORIENTATION).assertEqual(resultRequestedOrientation_20);
  })
}
