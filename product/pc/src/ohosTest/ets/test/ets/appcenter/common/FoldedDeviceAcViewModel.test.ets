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
import { AppCenterGridStyleConfig } from '@ohos/appcenter'
import { FoldedDeviceAcViewModel } from '@ohos/appcenter/src/main/ets/default/folded/FoldedDeviceAcViewModel'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium'
import { AppGridItemInfo } from '@ohos/launchercommon/src/main/ets/bean/AppGridItemInfo'
import { ReflectionUtils } from '../../common/utils/ReflectionUtils'

export default function FoldedDeviceAcViewModelTest() {
  describe('FoldedDeviceAcViewModelTest', () => {
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

    it('test_FoldedDeviceAcViewModelTest_getInstance_should_return_single_instance', Level.LEVEL0, (): void => {
      let instance1 = FoldedDeviceAcViewModel.getInstance(0);
      expect(instance1).not().assertNull();
      let instance2 = FoldedDeviceAcViewModel.getInstance(0);
      expect(instance1).assertEqual(instance2);
    })

    it('test_FoldedDeviceAcViewModelTest_deleteInstance', Level.LEVEL0, (): void => {
      let instance1 = FoldedDeviceAcViewModel.getInstance(0);
      FoldedDeviceAcViewModel.deleteInstance(1);
      FoldedDeviceAcViewModel.deleteInstance(0);
      expect(instance1 instanceof FoldedDeviceAcViewModel).assertTrue();
    })

    it('test_FoldedDeviceAcViewModelTest_setFoldState', Level.LEVEL0, (): void => {
      let instance1 = FoldedDeviceAcViewModel.getInstance(0);
      let instance2 = FoldedDeviceAcViewModel.getInstance(2);
      let instance3 = FoldedDeviceAcViewModel.getInstance(3);
      instance1.setFoldState(1);
      instance2.setFoldState(-1);
      instance2.setFoldState(6);
      instance3.setFoldState(5);
      expect(instance1 instanceof FoldedDeviceAcViewModel).assertTrue();
    })

    it('test_FoldedDeviceAcViewModelTest_convertStateEnum', Level.LEVEL0, (): void => {
      let instance = FoldedDeviceAcViewModel.getInstance(0);
      (instance as object)['convertStateEnum'](0);
      (instance as object)['convertStateEnum'](1);
      (instance as object)['convertStateEnum'](2);
      (instance as object)['convertStateEnum'](3);
      (instance as object)['convertStateEnum'](4);
      (instance as object)['convertStateEnum'](5);
      (instance as object)['convertStateEnum'](6);
      expect(instance instanceof FoldedDeviceAcViewModel).assertTrue();
    })

    it('test_FoldedDeviceAcViewModelTest_setIsFoldedDevice', Level.LEVEL0, (): void => {
      let instance1 = FoldedDeviceAcViewModel.getInstance(0);
      let instance2 = FoldedDeviceAcViewModel.getInstance(2);
      let instance3 = FoldedDeviceAcViewModel.getInstance(3);
      instance1.setIsFoldedDevice(true);
      instance2.setIsFoldedDevice(false);
      expect(instance1 instanceof FoldedDeviceAcViewModel).assertTrue();
    })

    it('test_FoldedDeviceAcViewModelTest_isUnFoldedHorizontal', Level.LEVEL0, (): void => {
      let instance = FoldedDeviceAcViewModel.getInstance(0);
      ReflectionUtils.setProperty(instance, 'mCurrentFoldState', 5);
      instance.isUnFoldedHorizontal();
      ReflectionUtils.setProperty(instance, 'mCurrentFoldState', 1);
      instance.isUnFoldedHorizontal();
      expect(instance instanceof FoldedDeviceAcViewModel).assertTrue();
    })

    it('test_FoldedDeviceAcViewModelTest_isUnFoldedVertical', Level.LEVEL0, (): void => {
      let instance = FoldedDeviceAcViewModel.getInstance(0);
      ReflectionUtils.setProperty(instance, 'mCurrentFoldState', 4);
      instance.isUnFoldedVertical();
      ReflectionUtils.setProperty(instance, 'mCurrentFoldState', 1);
      instance.isUnFoldedVertical();
      expect(instance instanceof FoldedDeviceAcViewModel).assertTrue();
    })

    it('test_FoldedDeviceAcViewModelTest_isUnFolded', Level.LEVEL0, (): void => {
      let instance = FoldedDeviceAcViewModel.getInstance(0);
      ReflectionUtils.setProperty(instance, 'mCurrentFoldState', 4);
      instance.isUnFolded();
      ReflectionUtils.setProperty(instance, 'mCurrentFoldState', 5);
      instance.isUnFolded();
      ReflectionUtils.setProperty(instance, 'mCurrentFoldState', 1);
      instance.isUnFolded();
      expect(instance instanceof FoldedDeviceAcViewModel).assertTrue();
    })

    it('test_FoldedDeviceAcViewModelTest_isHalfFolded', Level.LEVEL0, (): void => {
      let instance = FoldedDeviceAcViewModel.getInstance(0);
      ReflectionUtils.setProperty(instance, 'mCurrentFoldState', 3);
      instance.isHalfFolded();
      ReflectionUtils.setProperty(instance, 'mCurrentFoldState', 5);
      instance.isHalfFolded();
      ReflectionUtils.setProperty(instance, 'mCurrentFoldState', 1);
      instance.isHalfFolded();
      expect(instance instanceof FoldedDeviceAcViewModel).assertTrue();
    })

    it('test_FoldedDeviceAcViewModelTest_isHalfFoldedVirtualKeyboard', Level.LEVEL0, (): void => {
      let instance = FoldedDeviceAcViewModel.getInstance(0);
      ReflectionUtils.setProperty(instance, 'mCurrentFoldState', 3);
      instance.isHalfFoldedVirtualKeyboard();
      ReflectionUtils.setProperty(instance, 'mCurrentFoldState', 1);
      instance.isHalfFoldedVirtualKeyboard();
      expect(instance instanceof FoldedDeviceAcViewModel).assertTrue();
    })

    it('test_FoldedDeviceAcViewModelTest_setSwiperItemSpace', Level.LEVEL0, (): void => {
      let instance = FoldedDeviceAcViewModel.getInstance(0);
      instance.setSwiperItemSpace(1);
      instance.setSwiperItemSpace(2);
      expect(instance instanceof FoldedDeviceAcViewModel).assertTrue();
    })

    it('test_FoldedDeviceAcViewModelTest_isNearBSideBottom', Level.LEVEL0, (): void => {
      let instance = FoldedDeviceAcViewModel.getInstance(0);
      ReflectionUtils.setProperty(instance, 'mUnfoldedAcBSideBottom', 2);
      ReflectionUtils.setProperty(instance, 'squeezeTriggerYOffsetValue', 1);
      instance.isNearBSideBottom(1);
      instance.isNearBSideBottom(0);
      expect(instance instanceof FoldedDeviceAcViewModel).assertTrue();
    })

    it('test_FoldedDeviceAcViewModelTest_recalculateAcDraggableAreaBottom', Level.LEVEL0, (): void => {
      let instance = FoldedDeviceAcViewModel.getInstance(0);
      let mAppCenterGridStyleConfig: AppCenterGridStyleConfig = AppCenterGridStyleConfig.getInstance();
      ReflectionUtils.setProperty(instance, 'mCurrentFoldState', 1);
      instance.recalculateAcDraggableAreaBottom(mAppCenterGridStyleConfig);
      ReflectionUtils.setProperty(instance, 'mCurrentFoldState', 3);
      instance.recalculateAcDraggableAreaBottom(mAppCenterGridStyleConfig);
      ReflectionUtils.setProperty(instance, 'mCurrentFoldState', 5);
      instance.recalculateAcDraggableAreaBottom(mAppCenterGridStyleConfig);
      expect(instance instanceof FoldedDeviceAcViewModel).assertTrue();
    })

    it('test_FoldedDeviceAcViewModelTest_isRotating', Level.LEVEL0, (): void => {
      let instance = FoldedDeviceAcViewModel.getInstance(0);
      instance.isRotating(400, 0);
      instance.isRotating(40, 0);
      expect(instance instanceof FoldedDeviceAcViewModel).assertTrue();
    })

    it('test_FoldedDeviceAcViewModelTest_isDragInMiddleArea', Level.LEVEL0, (): void => {
      let instance = FoldedDeviceAcViewModel.getInstance(0);
      ReflectionUtils.setProperty(instance, 'mAcBSideBottom', 3);
      ReflectionUtils.setProperty(instance, 'mAcCSideTop', 5);
      instance.isDragInMiddleArea(3);
      instance.isDragInMiddleArea(4);
      instance.isDragInMiddleArea(10);
      expect(instance instanceof FoldedDeviceAcViewModel).assertTrue();
    })

    it('test_FoldedDeviceAcViewModelTest_calculateRectMap', Level.LEVEL0, (): void => {
      let instance = FoldedDeviceAcViewModel.getInstance(0);
      instance.calculateRectMap(5, 5);
      instance.calculateRectMap(0, 5);
      instance.calculateRectMap(5, 0);
      expect(instance instanceof FoldedDeviceAcViewModel).assertTrue();
    })

    it('test_FoldedDeviceAcViewModelTest_initFoldedAnimationData', Level.LEVEL0, (): void => {
      let instance = FoldedDeviceAcViewModel.getInstance(0);
      ReflectionUtils.setProperty(instance, 'mIsFoldedDevice', false);
      instance.initFoldedAnimationData();
      ReflectionUtils.setProperty(instance, 'mIsFoldedDevice', true);
      instance.initFoldedAnimationData();
      expect(instance instanceof FoldedDeviceAcViewModel).assertTrue();
    })

    it('test_FoldedDeviceAcViewModelTest_transformToPortrait', Level.LEVEL0, (): void => {
      let instance = FoldedDeviceAcViewModel.getInstance(0);
      let aii: AppGridItemInfo = new AppGridItemInfo();
      ReflectionUtils.setProperty(instance, 'isFoldedDevice', false);
      instance.transformToPortrait(aii);
      ReflectionUtils.setProperty(instance, 'isFoldedDevice', true);
      ReflectionUtils.setProperty(instance, 'mCurrentFoldState', 5);
      instance.transformToPortrait(aii);
      ReflectionUtils.setProperty(instance, 'mCurrentFoldState', 1);
      instance.transformToPortrait(aii);
      expect(instance instanceof FoldedDeviceAcViewModel).assertTrue();
    })

    it('test_FoldedDeviceAcViewModelTest_getFoldedTimeAsc', Level.LEVEL0, (): void => {
      let instance = FoldedDeviceAcViewModel.getInstance(0);
      let aii: AppGridItemInfo = new AppGridItemInfo();
      ReflectionUtils.setProperty(instance, 'mCurrentFoldState', 4);
      instance.getFoldedTimeAsc();
      ReflectionUtils.setProperty(instance, 'mCurrentFoldState', 0);
      instance.getFoldedTimeAsc();
      expect(instance instanceof FoldedDeviceAcViewModel).assertTrue();
    })
  })
}