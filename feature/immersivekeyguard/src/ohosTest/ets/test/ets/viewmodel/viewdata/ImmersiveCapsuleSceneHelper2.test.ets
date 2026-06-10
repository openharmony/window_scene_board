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
  });
}