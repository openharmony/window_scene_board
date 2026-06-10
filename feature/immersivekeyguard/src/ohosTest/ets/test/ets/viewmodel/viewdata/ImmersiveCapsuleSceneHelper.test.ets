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
import { CommonUtils } from '@ohos/basicutils';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  Level,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { ImmersiveNtfScene } from '../../../../../../main/ets/common/anim/ImmersiveAnimConstants';
import { CapsulePositionType } from '../../../../../../main/ets/common/ImmersiveConstants';
import { ImmersiveCapsuleData } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveCapsuleData';
import { ImmersiveCapsuleList } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveCapsuleList';
import { ImmersiveCapsuleSceneHelper } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveCapsuleSceneHelper';
import { ImmersiveDataGroupPacker } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveDataGroupProcessor';
import { ImmersiveNtfData } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveNtfData';
import { immersiveNtfSceneHelper } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveNtfSceneHelper';

export function ImmersiveCapsuleSceneHelperTest() {
  let mocker: MockKit;
  describe('ImmersiveCapsuleSceneHelperTest', (): void => {
    beforeAll((): void => {
      mocker = new MockKit();
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('test_constructor', Level.LEVEL1, (): void => {
      let oldList = new ImmersiveCapsuleList();
      let newList = new ImmersiveCapsuleList();
      let group = new ImmersiveDataGroupPacker();
      new ImmersiveCapsuleSceneHelper(oldList, newList, group);
      expect(ImmersiveCapsuleSceneHelper).not().assertNull();
    });

    it('test_checkAnimScene1', Level.LEVEL1, (): void => {
      let oldList = new ImmersiveCapsuleList();
      let newList = new ImmersiveCapsuleList();
      let group = new ImmersiveDataGroupPacker();
      let capsceneHelper = new ImmersiveCapsuleSceneHelper(oldList, newList, group);
      capsceneHelper.checkAnimScene();
      let mockfunc_1 = mocker.mockFunc(group, group.getOldGroupSize);
      let mockfunc_2 = mocker.mockFunc(group, group.getGroupSize);
      when(mockfunc_1)().afterReturn(0);
      when(mockfunc_2)().afterReturn(10);
      capsceneHelper.checkAnimScene();
      mocker.clear(group);
      expect(capsceneHelper).not().assertNull();
    });

    it('test_checkAnimScene2', Level.LEVEL1, (): void => {
      let oldList = new ImmersiveCapsuleList();
      let newList = new ImmersiveCapsuleList();
      let group = new ImmersiveDataGroupPacker();
      let capsceneHelper = new ImmersiveCapsuleSceneHelper(oldList, newList, group);
      capsceneHelper.checkAnimScene();
      let mockfunc_1 = mocker.mockFunc(group, group.getOldGroupSize);
      let mockfunc_2 = mocker.mockFunc(group, group.getGroupSize);
      when(mockfunc_1)().afterReturn(10);
      when(mockfunc_2)().afterReturn(0);
      capsceneHelper.checkAnimScene();
      mocker.clear(group);
      expect(capsceneHelper).not().assertNull();
    });

    it('test_checkAnimScene3', Level.LEVEL1, (): void => {
      let oldList = new ImmersiveCapsuleList();
      let newList = new ImmersiveCapsuleList();
      let group = new ImmersiveDataGroupPacker();
      let capsceneHelper = new ImmersiveCapsuleSceneHelper(oldList, newList, group);
      capsceneHelper.checkAnimScene();
      let mockfunc_1 = mocker.mockFunc(group, group.getOldGroupSize);
      let mockfunc_2 = mocker.mockFunc(group, group.getGroupSize);
      when(mockfunc_1)().afterReturn(10);
      when(mockfunc_2)().afterReturn(20);
      capsceneHelper.checkAnimScene();
      mocker.clear(group);
      expect(capsceneHelper).not().assertNull();
    });

    it('test_checkAnimScene3', Level.LEVEL1, (): void => {
      let oldList = new ImmersiveCapsuleList();
      let newList = new ImmersiveCapsuleList();
      let group = new ImmersiveDataGroupPacker();
      let capsceneHelper = new ImmersiveCapsuleSceneHelper(oldList, newList, group);
      capsceneHelper.checkAnimScene();
      let mockfunc_1 = mocker.mockFunc(group, group.getOldGroupSize);
      let mockfunc_2 = mocker.mockFunc(group, group.getGroupSize);
      when(mockfunc_1)().afterReturn(20);
      when(mockfunc_2)().afterReturn(10);
      capsceneHelper.checkAnimScene();
      mocker.clear(group);
      expect(capsceneHelper).not().assertNull();
    });

    it('test_isSingleTopUpdate', Level.LEVEL1, (): void => {
      let oldList = new ImmersiveCapsuleList();
      let newList = new ImmersiveCapsuleList();
      let group = new ImmersiveDataGroupPacker();
      let helper: ImmersiveCapsuleSceneHelper = new ImmersiveCapsuleSceneHelper(oldList, newList, group);
      (helper as object)['isSingleTopUpdate']();

      let oldData: ImmersiveNtfData = new ImmersiveNtfData();
      oldData.groupKey = 'test';
      let newData: ImmersiveNtfData = new ImmersiveNtfData();
      oldList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, oldData);
      newList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, newData);
      (helper as object)['isSingleTopUpdate']();

      let newData2: ImmersiveNtfData = new ImmersiveNtfData();
      newData2.groupKey = 'test';
      (helper as object)['isSingleTopUpdate']();
      expect(helper).not().assertNull();
    });

    it('test_isSingleNotTopRemindUpdate', Level.LEVEL1, (): void => {
      let oldList = new ImmersiveCapsuleList();
      let newList = new ImmersiveCapsuleList();
      let group = new ImmersiveDataGroupPacker();
      let helper: ImmersiveCapsuleSceneHelper = new ImmersiveCapsuleSceneHelper(oldList, newList, group);
      (helper as object)['isSingleNotTopRemindUpdate']();


      let newData: ImmersiveNtfData = new ImmersiveNtfData();
      newData.groupKey = 'test';
      newList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, newData);
      (helper as object)['isSingleNotTopRemindUpdate']();
      expect(helper).not().assertNull();
    });

    it('test_isSingleTopRemindUpdate', Level.LEVEL1, (): void => {
      let oldList = new ImmersiveCapsuleList();
      let newList = new ImmersiveCapsuleList();
      let group = new ImmersiveDataGroupPacker();
      let helper: ImmersiveCapsuleSceneHelper = new ImmersiveCapsuleSceneHelper(oldList, newList, group);
      (helper as object)['isSingleTopRemindUpdate']();


      let newData: ImmersiveNtfData = new ImmersiveNtfData();
      newData.groupKey = 'test';
      newList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, newData);
      (helper as object)['isSingleTopRemindUpdate']();
      expect(helper).not().assertNull();
    });

    let oldList = new ImmersiveCapsuleList();
    let newList = new ImmersiveCapsuleList();
    let group = new ImmersiveDataGroupPacker();
    let helper: ImmersiveCapsuleSceneHelper = new ImmersiveCapsuleSceneHelper(oldList, newList, group);

    it('checkAnimScene_test01', Level.LEVEL1, (): void => {
      let oldList = new ImmersiveCapsuleList();
      let newList = new ImmersiveCapsuleList();
      let group = new ImmersiveDataGroupPacker();
      let immersiveCapsuleSceneHelper = new ImmersiveCapsuleSceneHelper(oldList, newList, group);
      immersiveCapsuleSceneHelper.checkAnimScene();
      let mockFunc_1 = mocker.mockFunc(group, group.getOldGroupSize);
      let mockFunc_2 = mocker.mockFunc(group, group.getGroupSize);
      when(mockFunc_1)().afterReturn(null);
      when(mockFunc_2)().afterReturn(null);
      immersiveCapsuleSceneHelper.checkAnimScene();
      mocker.clear(group);
      expect(immersiveCapsuleSceneHelper).not().assertUndefined();
    });

    it('checkAnimScene_test02', Level.LEVEL1, (): void => {
      let oldList = new ImmersiveCapsuleList();
      let newList = new ImmersiveCapsuleList();
      let group = new ImmersiveDataGroupPacker();
      let immersiveCapsuleSceneHelper = new ImmersiveCapsuleSceneHelper(oldList, newList, group);
      immersiveCapsuleSceneHelper.checkAnimScene();
      let mockFunc_1 = mocker.mockFunc(group, group.getOldGroupSize);
      let mockFunc_2 = mocker.mockFunc(group, group.getGroupSize);
      let mockFunc_3 = mocker.mockFunc((immersiveCapsuleSceneHelper as object),
        (immersiveCapsuleSceneHelper as object)['isSingleTopRemindUpdate']);
      let mockFunc_4 = mocker.mockFunc((immersiveCapsuleSceneHelper as object),
        (immersiveCapsuleSceneHelper as object)['isSingleNotTopRemindUpdate']);
      when(mockFunc_1)().afterReturn(20);
      when(mockFunc_2)().afterReturn(20);
      when(mockFunc_3)().afterReturn(true);
      immersiveCapsuleSceneHelper.checkAnimScene();
      expect(immersiveCapsuleSceneHelper).not().assertUndefined();
      when(mockFunc_3)().afterReturn(false);
      when(mockFunc_4)().afterReturn(true);
      immersiveCapsuleSceneHelper.checkAnimScene();
      expect(immersiveCapsuleSceneHelper).not().assertUndefined();
      mocker.clear(group);
      mocker.clear((immersiveCapsuleSceneHelper as object));
    });

    it('checkAddOrRemoveScene_test01', Level.LEVEL1, (): void => {
      let oldList = new ImmersiveCapsuleList();
      let newList = new ImmersiveCapsuleList();
      let group = new ImmersiveDataGroupPacker();
      let immersiveCapsuleSceneHelper = new ImmersiveCapsuleSceneHelper(oldList, newList, group);
      let mockFunc_3 = mocker.mockFunc((immersiveCapsuleSceneHelper as object),
        (immersiveCapsuleSceneHelper as object)['isTopCapsuleChange']);
      let mockFunc_4 = mocker.mockFunc((immersiveCapsuleSceneHelper as object),
        (immersiveCapsuleSceneHelper as object)['isSameTopCapsule']);
      when(mockFunc_3)().afterReturn(true);
      (immersiveCapsuleSceneHelper as object)['checkAddOrRemoveScene'](1, 5);
      expect(immersiveCapsuleSceneHelper).not().assertUndefined();
      when(mockFunc_3)().afterReturn(false);
      when(mockFunc_4)().afterReturn(true);
      (immersiveCapsuleSceneHelper as object)['checkAddOrRemoveScene'](1, 5);
      expect(immersiveCapsuleSceneHelper).not().assertUndefined();
      when(mockFunc_4)().afterReturn(false);
      (immersiveCapsuleSceneHelper as object)['checkAddOrRemoveScene'](1, 5);
      expect(immersiveCapsuleSceneHelper).not().assertUndefined();
      mocker.clear((immersiveCapsuleSceneHelper as object));
    });

    it('checkAddOrRemoveScene_test02', Level.LEVEL1, (): void => {
      let oldList = new ImmersiveCapsuleList();
      let newList = new ImmersiveCapsuleList();
      let group = new ImmersiveDataGroupPacker();
      let immersiveCapsuleSceneHelper = new ImmersiveCapsuleSceneHelper(oldList, newList, group);
      let mockFunc_3 = mocker.mockFunc((immersiveCapsuleSceneHelper as object),
        (immersiveCapsuleSceneHelper as object)['isTopCapsuleChange']);
      let mockFunc_4 = mocker.mockFunc((immersiveCapsuleSceneHelper as object),
        (immersiveCapsuleSceneHelper as object)['isSameTopCapsule']);
      when(mockFunc_3)().afterReturn(true);
      (immersiveCapsuleSceneHelper as object)['checkAddOrRemoveScene'](5, 1);
      expect(immersiveCapsuleSceneHelper).not().assertUndefined();
      when(mockFunc_3)().afterReturn(false);
      when(mockFunc_4)().afterReturn(true);
      (immersiveCapsuleSceneHelper as object)['checkAddOrRemoveScene'](5, 1);
      expect(immersiveCapsuleSceneHelper).not().assertUndefined();
      when(mockFunc_4)().afterReturn(false);
      (immersiveCapsuleSceneHelper as object)['checkAddOrRemoveScene'](5, 1);
      expect(immersiveCapsuleSceneHelper).not().assertUndefined();
      (immersiveCapsuleSceneHelper as object)['checkAddOrRemoveScene'](1, 1);
      expect(immersiveCapsuleSceneHelper).not().assertUndefined();
      mocker.clear((immersiveCapsuleSceneHelper as object));
    });

    it('isSingleNotTopRemindUpdate_test01', Level.LEVEL1, (): void => {
      let curList: ImmersiveCapsuleList = new ImmersiveCapsuleList();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.groupKey = 'a';
      (helper as object)['curList'] = curList;
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun1: Function = mock.mockFunc(immersiveNtfSceneHelper, immersiveNtfSceneHelper.checkImmersiveDataScene);
      let mockFun3: Function = mock.mockFunc(immersiveNtfSceneHelper, immersiveNtfSceneHelper.getImmersiveSceneKey);
      let mockFun2: Function = mock.mockFunc(curList, curList.getNtfData);
      when(mockFun2)(ArgumentMatchers.any).afterReturn(immersiveNtfData);
      when(mockFun)(ArgumentMatchers.any).afterReturn(true);
      (helper as object)['isSingleNotTopRemindUpdate']();
      expect(helper).not().assertUndefined();
      when(mockFun2)(ArgumentMatchers.any).afterReturn(immersiveNtfData);
      when(mockFun)(ArgumentMatchers.any).afterReturn(false);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      (helper as object)['isSingleNotTopRemindUpdate']();
      expect(helper).not().assertUndefined();
      when(mockFun2)(ArgumentMatchers.any).afterReturn(immersiveNtfData);
      when(mockFun)(ArgumentMatchers.any).afterReturn(false);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(false);
      when(mockFun3)(ArgumentMatchers.any).afterReturnNothing;
      (helper as object)['isSingleNotTopRemindUpdate']();
      expect(helper).not().assertUndefined();
      when(mockFun2)(ArgumentMatchers.any).afterReturn(immersiveNtfData);
      when(mockFun)(ArgumentMatchers.any).afterReturn(false);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(false);
      when(mockFun3)(ArgumentMatchers.any).afterReturn('a');
      (helper as object)['isSingleNotTopRemindUpdate']();
      expect(helper).not().assertUndefined();
      mock.clear(CommonUtils);
      mock.clear(immersiveNtfSceneHelper);
      mock.clear(curList);
    });
  });
}