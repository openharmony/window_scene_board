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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import { FrameAnimationParam } from '../../../../../../../Index';
import {
  dropAnimationManager
} from '../../../../../../main/ets/service/animator/drop/manager/DropAnimationManager';
import {
  DropItemViewModel
} from '../../../../../../main/ets/service/animator/drop/viewmodel/DropItemViewModel';
import {
  AnimationViewData,
  DropAnimationConfig,
  DropAnimationDestination,
  DropAnimationParam,
  DropAnimationScene,
  MultiAnimationParam
} from '../../../../../../main/ets/TsIndex';
import curves from '@ohos.curves';

export default function DropAnimationManagerTest() {
  describe('DropAnimationManagerTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    let animationViewData: AnimationViewData = new AnimationViewData('1');
    let dropItemViewModel: DropItemViewModel = new DropItemViewModel(animationViewData);
    let AnimationViewDataList: Array<AnimationViewData> = [];
    let dropItemViewModelMap1: Map<string, DropItemViewModel> = new Map();
    let dropItemViewModelMap2: Map<DropAnimationScene, Map<string, DropItemViewModel>> = new Map();

    it('dropAnimationManager_getDropViewModel_test01', 0, () => {
      let scene: DropAnimationScene = DropAnimationScene.SCENE_DESKTOP;
      dropAnimationManager.getDropViewModel(scene, '1');
      expect(AnimationViewData).not().assertUndefined();
      dropAnimationManager.addDropItemArray(DropAnimationScene.SCENE_DESKTOP, AnimationViewDataList);
      dropAnimationManager.getDropViewModel(scene, '');
      expect(AnimationViewData).not().assertUndefined();
      dropAnimationManager.getDropViewModel(scene, '1');
      expect(AnimationViewData).not().assertUndefined();
      dropAnimationManager.getDropViewModel(scene, '0');
      expect(AnimationViewData).not().assertUndefined();
    })

    it('dropAnimationManager_getDropItemCount_test01', 0, () => {
      let scene: DropAnimationScene = DropAnimationScene.SCENE_DESKTOP;
      dropItemViewModelMap2.set(scene, dropItemViewModelMap1);
      let result: number = dropAnimationManager.getDropItemCount(scene);
      expect(result).not().assertUndefined();
    })

    it('dropAnimationManager_removeDropItem_test01', 0, () => {
      let scene: DropAnimationScene = DropAnimationScene.SCENE_DESKTOP;
      dropItemViewModelMap2.set(scene, dropItemViewModelMap1);
      dropAnimationManager.removeDropItem(scene, '000');
      expect(AnimationViewData).not().assertUndefined();
      dropAnimationManager.addDropItemArray(DropAnimationScene.SCENE_DESKTOP, AnimationViewDataList);
      dropAnimationManager.removeDropItem(scene, '000');
      expect(AnimationViewData).not().assertUndefined();
    })

    it('dropAnimationManager_startDropAnimation_test01', 0, () => {
      let scene: DropAnimationScene = DropAnimationScene.SCENE_DESKTOP;
      dropItemViewModelMap2.set(scene, dropItemViewModelMap1);
      let target: DropAnimationDestination = DropAnimationDestination.DESKTOP;
      let param: DropAnimationParam = new DropAnimationParam('', 0, 0, 0, 0);
      let result: boolean = dropAnimationManager.startDropAnimation(target, param);
      expect(result).not().assertUndefined();
      param.key = '1';
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(DropAnimationConfig, DropAnimationConfig.getDropAnimationScene);
      when(mockFun)().afterReturn(DropAnimationScene.SCENE_DESKTOP);
      let mockFun1: Function = mock.mockFunc(dropItemViewModel, dropItemViewModel.startAnimation);
      when(mockFun1)().afterReturn(true);
      let result1: boolean = dropAnimationManager.startDropAnimation(target, param);
      expect(result1).not().assertUndefined();
      mock.ignoreMock(DropAnimationConfig, DropAnimationConfig.getDropAnimationScene);
      mock.ignoreMock(dropItemViewModel, dropItemViewModel.startAnimation);
    })

    it('dropAnimationManager_startDropAnimation_test02', 0, () => {
      let scene: DropAnimationScene = DropAnimationScene.SCENE_DESKTOP;
      let dropItemViewModel0: DropItemViewModel = new DropItemViewModel(animationViewData);
      dropItemViewModelMap2.set(scene, dropItemViewModelMap1);
      let target: DropAnimationDestination = DropAnimationDestination.DESKTOP;
      let param: DropAnimationParam = new DropAnimationParam('', 0, 0, 0, 0);
      param.key = '1';
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(DropAnimationConfig, DropAnimationConfig.getDropAnimationScene);
      when(mockFun)().afterReturn(DropAnimationScene.SCENE_DESKTOP);
      let mockFun1: Function = mock.mockFunc(dropItemViewModel0, dropItemViewModel0.startAnimation);
      when(mockFun1)().afterReturn(false);
      let result1: boolean = dropAnimationManager.startDropAnimation(target, param);
      expect(result1).assertFalse();
      mock.ignoreMock(DropAnimationConfig, DropAnimationConfig.getDropAnimationScene);
      mock.ignoreMock(dropItemViewModel0, dropItemViewModel0.startAnimation);
    })

    it('dropAnimationManager_startMultiDropAnimation_test01', 0, () => {
      let param: DropAnimationParam = new DropAnimationParam('', 0, 0, 0, 0);
      let params: MultiAnimationParam = {
        target: DropAnimationDestination.DESKTOP,
        paramList: [],
        releaseOnEnd: true
      };
      let result1: boolean = dropAnimationManager.startMultiDropAnimation(params);
      expect(result1).assertFalse();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(DropAnimationConfig, DropAnimationConfig.getDropAnimationScene);
      when(mockFun)().afterReturn(DropAnimationDestination.DESKTOP);
      params.paramList = [param];
      let result: boolean = dropAnimationManager.startMultiDropAnimation(params);
      expect(result).not().assertUndefined();
      mock.ignoreMock(DropAnimationConfig, DropAnimationConfig.getDropAnimationScene);
    })

    it('dropAnimationManager_startMultiDropAnimation_test01', 0, () => {
      let param: DropAnimationParam = new DropAnimationParam('', 0, 0, 0, 0);
      let params: MultiAnimationParam = {
        target: DropAnimationDestination.DESKTOP,
        paramList: [],
        releaseOnEnd: true
      };
      let result1: boolean = dropAnimationManager.startMultiDropAnimation(params);
      expect(result1).assertFalse();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(DropAnimationConfig, DropAnimationConfig.getDropAnimationScene);
      when(mockFun)().afterReturn(DropAnimationDestination.DESKTOP);
      params.paramList = [param];
      let result: boolean = dropAnimationManager.startMultiDropAnimation(params);
      expect(result).not().assertUndefined();
      mock.ignoreMock(DropAnimationConfig, DropAnimationConfig.getDropAnimationScene);
    })

    it('dropAnimationManager_startCustomFrameAnimation_test01', 0, () => {
      let scene1: DropAnimationScene = DropAnimationScene.SCENE_DESKTOP;
      let target: DropAnimationDestination = DropAnimationDestination.DESKTOP;
      let frameAnimationParam: FrameAnimationParam = {
        animationId: '',
        id: '1',
        delay: 0,
        duration: 0,
        endDelay: 0,
        curves: curves.initCurve(undefined),
        begins: [],
        targets: [],
        onRender: (viewData: AnimationViewData, currentVal: number[]): void => {
          throw new Error('Function not implemented.')
        }
      }
      let params: FrameAnimationParam[] = [frameAnimationParam, frameAnimationParam];
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(DropAnimationConfig, DropAnimationConfig.getDropAnimationScene);
      when(mockFun)().afterReturn(DropAnimationDestination.DESKTOP);
      let result: boolean = dropAnimationManager.startCustomFrameAnimation(target, params);
      expect(result).not().assertUndefined();
      dropItemViewModelMap2.set(scene1, dropItemViewModelMap1);
      let result1: boolean = dropAnimationManager.startCustomFrameAnimation(target, params);
      expect(result1).not().assertUndefined();
      mock.ignoreMock(DropAnimationConfig, DropAnimationConfig.getDropAnimationScene);
    })

    it('dropAnimationManager_prepareDropItem_test01', 0, () => {
      let target: DropAnimationDestination = DropAnimationDestination.DESKTOP;
      let scene1: DropAnimationScene = DropAnimationScene.SCENE_DESKTOP;
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(DropAnimationConfig, DropAnimationConfig.getDropAnimationScene);
      when(mockFun)().afterReturn(DropAnimationDestination.DESKTOP);
      dropAnimationManager.prepareDropItem(target);
      expect(animationViewData).not().assertUndefined();
      dropItemViewModelMap2.set(scene1, dropItemViewModelMap1);
      dropAnimationManager.prepareDropItem(target);
      expect(animationViewData).not().assertUndefined();
      dropAnimationManager.prepareDropItem(target, '1');
      expect(animationViewData).not().assertUndefined();
      mock.ignoreMock(DropAnimationConfig, DropAnimationConfig.getDropAnimationScene);
    })

    it('dropAnimationManager_isInDropAnimation_test01', 0, () => {
      let scene1: DropAnimationScene = DropAnimationScene.SCENE_DESKTOP;
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(DropAnimationConfig, DropAnimationConfig.getDropAnimationScene);
      when(mockFun)().afterReturn(DropAnimationDestination.DESKTOP);
      let result1: boolean = dropAnimationManager.isInDropAnimation(scene1);
      expect(result1).assertFalse();
      let mockFun1: Function = mock.mockFunc(dropItemViewModel, dropItemViewModel.isInAnimation);
      when(mockFun1)().afterReturn(true);
      dropItemViewModelMap1.set('1', dropItemViewModel)
      dropItemViewModelMap2.set(scene1, dropItemViewModelMap1);
      let result: boolean = dropAnimationManager.isInDropAnimation(scene1);
      expect(result).not().assertUndefined();
      let result2: boolean = dropAnimationManager.isInDropAnimation(scene1, '1');
      expect(result2).not().assertUndefined();
      mock.ignoreMock(DropAnimationConfig, DropAnimationConfig.getDropAnimationScene);
      mock.ignoreMock(dropItemViewModel, dropItemViewModel.isInAnimation);
    })

    it('dropAnimationManager_isInDropAnimation_test02', 0, () => {
      let scene1: DropAnimationScene = DropAnimationScene.SCENE_DESKTOP;
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(DropAnimationConfig, DropAnimationConfig.getDropAnimationScene);
      when(mockFun)().afterReturn(DropAnimationDestination.DESKTOP);
      let mockFun1: Function = mock.mockFunc(dropItemViewModel, dropItemViewModel.isInAnimation);
      when(mockFun1)().afterReturn(false);
      dropItemViewModelMap1.set('1', dropItemViewModel)
      dropItemViewModelMap2.set(scene1, dropItemViewModelMap1);
      let result: boolean = dropAnimationManager.isInDropAnimation(scene1);
      expect(result).assertFalse();
      mock.ignoreMock(DropAnimationConfig, DropAnimationConfig.getDropAnimationScene);
      mock.ignoreMock(dropItemViewModel, dropItemViewModel.isInAnimation);
    })

    it('dropAnimationManager_hideAnimationItemByScene_test01', 0, () => {
      let scene1: DropAnimationScene = DropAnimationScene.SCENE_DESKTOP;
      dropItemViewModelMap1.set('1', dropItemViewModel)
      dropItemViewModelMap2.set(scene1, dropItemViewModelMap1);
      dropAnimationManager.hideAnimationItemByScene(scene1);
      expect(animationViewData).not().assertUndefined();
      dropAnimationManager.hideAnimationItemByScene(scene1, false);
      expect(animationViewData).not().assertUndefined();
    })

  })
}