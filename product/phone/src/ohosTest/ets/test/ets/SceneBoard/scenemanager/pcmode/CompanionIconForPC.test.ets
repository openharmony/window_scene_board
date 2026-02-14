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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import { CompanionIconForPC, CompanionIconViewModel }
  from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/pcmode/CompanionIconForPC';

let companionIconViewModel: CompanionIconViewModel;

export function CompanionIconForPCTest() {
  describe('CompanionIconViewModelTest', (): void => {
    beforeAll((): void => {
      companionIconViewModel = new CompanionIconViewModel();
      companionIconViewModel.iconWidth = 0;
      companionIconViewModel.iconHeight = 0;
      companionIconViewModel.iconPosX = 0;
      companionIconViewModel.iconPosY = 0;
      companionIconViewModel.iconTranX = 0;
      companionIconViewModel.iconTranY = 0;
      companionIconViewModel.iconScaleX = 1.0;
      companionIconViewModel.iconScaleY = 1.0;
      companionIconViewModel.iconAlpha = 1.0;
      companionIconViewModel.iconRadius = 0;
      companionIconViewModel.iconVisible = false;
      companionIconViewModel.iconFixSize = 0;
      companionIconViewModel.animCount = 0;
    })
    beforeEach((): void => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach((): void => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll((): void => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    setInitStateTest();
    setEndStateTest();
    setTranTest();
    getRadiusTest();
  });
}

function setInitStateTest() {
  it('setInitStateTest_01', Level.LEVEL0, (): void => {
    companionIconViewModel.setInitState();
    expect(companionIconViewModel.iconTranX).assertEqual(0);
  });
  it('setInitStateTest_02', Level.LEVEL0, (): void => {
    companionIconViewModel.setInitState();
    expect(companionIconViewModel.iconTranY).assertEqual(0);
  });
  it('setInitStateTest_03', Level.LEVEL0, (): void => {
    companionIconViewModel.setInitState();
    expect(companionIconViewModel.iconScaleX).assertEqual(1.0);
  });
  it('setInitStateTest_04', Level.LEVEL0, (): void => {
    companionIconViewModel.setInitState();
    expect(companionIconViewModel.iconScaleY).assertEqual(1.0);
  });
  it('setInitStateTest_05', Level.LEVEL0, (): void => {
    companionIconViewModel.setInitState();
    expect(companionIconViewModel.iconAlpha).assertEqual(1.0);
  });
  it('setInitStateTest_06', Level.LEVEL0, (): void => {
    companionIconViewModel.setInitState();
    expect(companionIconViewModel.iconRadius).assertEqual(0);
  });
  it('setInitStateTest_07', Level.LEVEL0, (): void => {
    companionIconViewModel.setInitState();
    expect(companionIconViewModel.iconVisible).assertEqual(false);
  });
  it('setInitStateTest_08', Level.LEVEL0, (): void => {
    companionIconViewModel.setInitState();
    expect(companionIconViewModel.iconFixSize).assertEqual(0);
  });
}

function setEndStateTest() {
  it('setEndStateTest_01', Level.LEVEL0, (): void => {
    companionIconViewModel.setEndState(0, 0);
    expect(companionIconViewModel.iconTranX).assertEqual(0);
    expect(companionIconViewModel.iconTranY).assertEqual(0);
  });
  it('setEndStateTest_02', Level.LEVEL0, (): void => {
    companionIconViewModel.setEndState(100, 100);
    expect(companionIconViewModel.iconTranX).assertEqual(100);
    expect(companionIconViewModel.iconTranY).assertEqual(100);
  });
  it('setEndStateTest_03', Level.LEVEL0, (): void => {
    companionIconViewModel.setEndState(0, 0);
    expect(companionIconViewModel.iconAlpha).assertEqual(1.0);
  });
  it('setEndStateTest_04', Level.LEVEL0, (): void => {
    companionIconViewModel.setEndState(100, 100);
    expect(companionIconViewModel.iconAlpha).assertEqual(1.0);
  });
  it('setEndStateTest_05', Level.LEVEL0, (): void => {
    companionIconViewModel.setEndState(0, 0);
    expect(companionIconViewModel.iconVisible).assertTrue();
  });
  it('setEndStateTest_06', Level.LEVEL0, (): void => {
    companionIconViewModel.setEndState(100, 100);
    expect(companionIconViewModel.iconVisible).assertTrue();
  });
}

function setTranTest() {
  it('setTranTest_01', Level.LEVEL0, (): void => {
    companionIconViewModel.setTran(0, 0);
    expect(companionIconViewModel.iconTranX).assertEqual(0);
    expect(companionIconViewModel.iconTranY).assertEqual(0);
  });
  it('setTranTest_02', Level.LEVEL0, (): void => {
    companionIconViewModel.setTran(100, 100);
    expect(companionIconViewModel.iconTranX).assertEqual(100);
    expect(companionIconViewModel.iconTranY).assertEqual(100);
  });
}

function getRadiusTest() {
  it('getRadiusTest', Level.LEVEL0, (): void => {
    let result = companionIconViewModel.getRadius();
    expect(result).assertInstanceOf('Number');
  });
}