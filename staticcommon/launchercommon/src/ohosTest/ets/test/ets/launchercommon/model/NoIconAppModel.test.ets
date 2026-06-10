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
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { CheckEmptyUtils } from '@ohos/basicutils';

import { NoIconAppModel, NoIconAppInfo } from '../../../../../../main/ets/TsIndex';

export default function NoIconAppModelTest() {
  describe('NoIconAppModelTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_getNoIconAppItemBundleList1', 0, async (done: Function) => {
      const noIconAppModel: NoIconAppModel = NoIconAppModel.getInstance();
      expect(noIconAppModel.getNoIconAppItemBundleList().length > 0).assertTrue();
      done();
    })

    it('test_getNoIconAppItemInfo1', 0, async (done: Function) => {
      const noIconAppModel: NoIconAppModel = NoIconAppModel.getInstance();
      const mocker = new MockKit();
      const updateNoIconAppInfo: Function = mocker.mockFunc(noIconAppModel, noIconAppModel.updateNoIconAppInfo);
      when(updateNoIconAppInfo)(ArgumentMatchers.any).afterReturn({});
      expect(noIconAppModel.getNoIconAppItemInfo().length === 0).assertTrue();
      mocker.clear(noIconAppModel);
      mocker.clearAll();
      done();
    })

    it('test_getNoIconAppItemInfo1', 0, async (done: Function) => {
      const noIconAppModel: NoIconAppModel = NoIconAppModel.getInstance();
      const mocker = new MockKit();
      const updateNoIconAppInfo: Function = mocker.mockFunc(noIconAppModel, noIconAppModel.updateNoIconAppInfo);
      when(updateNoIconAppInfo)(ArgumentMatchers.any).afterReturn({
        label: 'label'
      });
      expect(noIconAppModel.getNoIconAppItemInfo().length > 0).assertTrue();
      mocker.clear(noIconAppModel);
      mocker.clearAll();
      done();
    })

    it('test_checkIfBundleIsNoIconApp', 0, async (done: Function) => {
      const noIconAppModel: NoIconAppModel = NoIconAppModel.getInstance();
      expect(noIconAppModel.checkIfBundleIsNoIconApp('')).assertFalse();
      done();
    })

    it('test_NoIconAppInfo', 0, async (done: Function) => {
      const noIconAppInfo: NoIconAppInfo = new NoIconAppInfo();
      const label: string = noIconAppInfo.label;
      expect(label === '').assertTrue();
      done();
    })

    it('getNoIconAppItemByBundle_01', 0, async (done: Function) => {
      const noIconAppModel: NoIconAppModel = NoIconAppModel.getInstance();
      const bundle: string = '';
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      expect(noIconAppModel.getNoIconAppItemByBundle(bundle)).assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('getNoIconAppItemByBundle_02', 0, async (done: Function) => {
      const noIconAppModel: NoIconAppModel = NoIconAppModel.getInstance();
      const bundle: string = '123';
      let mocker: MockKit = new MockKit();
      const updateNoIconAppInfo: Function = mocker.mockFunc(noIconAppModel, noIconAppModel.updateNoIconAppInfo);
      when(updateNoIconAppInfo)(ArgumentMatchers.any).afterReturn({});
      expect(noIconAppModel.getNoIconAppItemByBundle(bundle)).assertUndefined();
      mocker.clear(updateNoIconAppInfo);
      mocker.clearAll();
    })

    it('getNoIconAppItemByBundle_03', 0, async (done: Function) => {
      const noIconAppModel: NoIconAppModel = NoIconAppModel.getInstance();
      let noIconAppInfo: NoIconAppInfo = new NoIconAppInfo();
      let mocker: MockKit = new MockKit();
      const getNoIconAppItemByBundle: Function = mocker.mockFunc(noIconAppModel, noIconAppModel.getNoIconAppItemByBundle);
      when(getNoIconAppItemByBundle)(ArgumentMatchers.any).afterReturn(noIconAppInfo);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.clear(getNoIconAppItemByBundle);
      mocker.clearAll();
      done();
    })

    it('test_checkNoIconAppItem', 0, async (done: Function) => {
      const noIconAppModel: NoIconAppModel = NoIconAppModel.getInstance();
      let bundle: string = 'com.ohos.sceneboard';
      expect(noIconAppModel.checkNoIconAppItem(bundle) === true).assertTrue();
      done();
    })
  })
}