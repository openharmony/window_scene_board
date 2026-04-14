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

import { it, describe, expect, MockKit, when } from '@ohos/hypium';
import SymbolIconUtil from '../../../../../main/ets/utils/SymbolIconUtil';


const DEFAULT = 0;
const DEFAULT_MAC = '11:22:33:AA:BB:FF';
const INVALID_MAC = '';
const MOCK_PRODUCT_ID: string[] = ['000149', '01', '4103'];
const MOCK_INVALID_PRODUCT_ID: string[] = ['FFFFFF', 'FF', 'FFFF'];

export function SymbolIconUtilTest() {
  describe('SymbolIconUtilTest', (): void => {
    it("activeGetProductId", DEFAULT, activeGetProductId);
    it("invalidGetProductId", DEFAULT, invalidGetProductId);
    it("activeIsEarphone", DEFAULT, activeIsEarphone);
    it("invalidIsEarphone", DEFAULT, invalidIsEarphone);
    it("activeIdGetEarphoneFillIcon", DEFAULT, activeIdGetEarphoneFillIcon);
    it("invalidIdGetEarphoneFillIcon", DEFAULT, invalidIdGetEarphoneFillIcon);
    it("activeIdGetEarphoneCaseIcon", DEFAULT, activeIdGetEarphoneCaseIcon);
    it("invalidIdGetEarphoneCaseIcon", DEFAULT, invalidIdGetEarphoneCaseIcon);
  })
}

function activeGetProductId(): void {
  // 有效mac调用
  const active: string[] = SymbolIconUtil.getProductId(DEFAULT_MAC);
  expect(active.length).not().assertEqual(0);
}

function invalidGetProductId(): void {
  const invalid: string[] = SymbolIconUtil.getProductId(INVALID_MAC);
  expect(invalid.length).assertEqual(0);
}

function activeIsEarphone(): void {
  // 有效mac调用
  const active: boolean = SymbolIconUtil.isEarphone(DEFAULT_MAC);
  expect(active).not().assertNull();
}

function invalidIsEarphone(): void {
  const invalid: boolean = SymbolIconUtil.isEarphone(INVALID_MAC);
  expect(invalid).assertFalse();
}

function activeIdGetEarphoneFillIcon(): void {
  const mocker: MockKit = new MockKit();
  const mockFunc: Function = mocker.mockFunc(SymbolIconUtil, SymbolIconUtil.getProductId);
  when(mockFunc)(DEFAULT_MAC).afterReturn(MOCK_PRODUCT_ID);
  const activeId: string = SymbolIconUtil.getEarphoneFillIcon(DEFAULT_MAC);
  expect(activeId).assertContain('earphone');
}

function invalidIdGetEarphoneFillIcon(): void {
  const mocker: MockKit = new MockKit();
  const mockFunc: Function = mocker.mockFunc(SymbolIconUtil, SymbolIconUtil.getProductId);
  when(mockFunc)(INVALID_MAC).afterReturn(MOCK_INVALID_PRODUCT_ID);
  const invalidId: string = SymbolIconUtil.getEarphoneFillIcon(INVALID_MAC);
  expect(invalidId).assertContain('bluetooth');
}

function activeIdGetEarphoneCaseIcon(): void {
  const mocker: MockKit = new MockKit();
  const mockFunc: Function = mocker.mockFunc(SymbolIconUtil, SymbolIconUtil.getProductId);
  when(mockFunc)(DEFAULT_MAC).afterReturn(MOCK_PRODUCT_ID);
  const activeId: string = SymbolIconUtil.getEarphoneCaseIcon(DEFAULT_MAC);
  expect(activeId).assertContain('earphone_case');
}

function invalidIdGetEarphoneCaseIcon(): void {
  const mocker: MockKit = new MockKit();
  const mockFunc: Function = mocker.mockFunc(SymbolIconUtil, SymbolIconUtil.getProductId);
  when(mockFunc)(INVALID_MAC).afterReturn(MOCK_INVALID_PRODUCT_ID);
  const invalidId: string = SymbolIconUtil.getEarphoneCaseIcon(INVALID_MAC);
  expect(invalidId).assertContain('bluetooth');
}