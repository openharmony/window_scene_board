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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import settings from '@ohos.settings';
import { GlobalContext, SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import {
  SingleHandMode,
  SCBSingleHandController,
  SingleHandExitReason,
  SingleHandConditionFunc,
  SingleHandAnimationFinishCallBack
} from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/onehandmode/SCBSingleHandController';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'SCBSingleHandControllerTest';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const SINGLE_HAND_MODE: string = 'single_hand_mode';
const SINGLE_HAND_SWITCH: string = 'single_hand_switch';
const SINGLE_HAND_SWITCH_ON: string = 'on';
const SINGLE_HAND_SWITCH_OFF: string = 'off';

class TestSingleHandConditionFunc implements SingleHandConditionFunc {
  private testCondition: boolean = false;
  isSingleHandAvailableNow(): boolean {
    return this.testCondition;
  }
  setCurCondition(val: boolean): void {
    this.testCondition = val;
  }
}

class TestSingleHandAnimationFinishCallback implements SingleHandAnimationFinishCallBack {
  public animationFinish: boolean = false;
  onEnterSingleHandAnimationFinish(): void {
    this.animationFinish = true;
  }
  onExitSingleHandAnimationFinish(): void {
    this.animationFinish = false;
  }
}

export function SCBSingleHandControllerTest() {
  describe('SCBSingleHandControllerTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
      setSettingsData(SINGLE_HAND_SWITCH, SINGLE_HAND_SWITCH_ON);
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
    /*
    * @tc.number:SCBSingleHandControllerTest_001
    * @tc.name: 单手模式开启成功，单手模式关闭成功
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 单手模式左侧开启成功，单手模式关闭成功测试
    */
    it('SCBSingleHandControllerTest_001', 0, () => {
      let controller: SCBSingleHandController = SCBSingleHandController.getInstance();
      controller.enterSingleHand(SingleHandMode.LEFT);
      expect(getSettingsData(SINGLE_HAND_MODE)).assertEqual(SingleHandMode.LEFT);
      controller.exitSingleHand(SingleHandExitReason.CLICK_EMPTY);
      expect(getSettingsData(SINGLE_HAND_MODE)).assertEqual(SingleHandMode.MIDDLE);
    })
    /*
    * @tc.number:SCBSingleHandControllerTest_002
    * @tc.name: 单手模式开启成功
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 单手模式右侧开启成功测试
    */
    it('SCBSingleHandControllerTest_002', 0, () => {
      let controller: SCBSingleHandController = SCBSingleHandController.getInstance();
      controller.enterSingleHand(SingleHandMode.RIGHT);
      expect(getSettingsData(SINGLE_HAND_MODE)).assertEqual(SingleHandMode.RIGHT);
      controller.exitSingleHand(SingleHandExitReason.CLICK_EMPTY);
      expect(getSettingsData(SINGLE_HAND_MODE)).assertEqual(SingleHandMode.MIDDLE);
    })
    /*
    * @tc.number:SCBSingleHandControllerTest_003
    * @tc.name: 单手模式开启成功
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 单手模式重复开启，多次开启后按照第一次调用接口开启
    */
    it('SCBSingleHandControllerTest_003', 0, () => {
      let controller: SCBSingleHandController = SCBSingleHandController.getInstance();
      controller.enterSingleHand(SingleHandMode.RIGHT);
      controller.enterSingleHand(SingleHandMode.LEFT);
      expect(getSettingsData(SINGLE_HAND_MODE)).assertEqual(SingleHandMode.RIGHT);
      controller.exitSingleHand(SingleHandExitReason.CLICK_EMPTY);
      expect(getSettingsData(SINGLE_HAND_MODE)).assertEqual(SingleHandMode.MIDDLE);
    })
    /*
    * @tc.number:SCBSingleHandControllerTest_004
    * @tc.name: 单手模式开启失败
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 单手模式开关关闭，单手模式开启失败
    */
    it('SCBSingleHandControllerTest_004', 0, () => {
      let controller: SCBSingleHandController = SCBSingleHandController.getInstance();
      let curSwitch: string = getSettingsData(SINGLE_HAND_SWITCH);
      setSettingsData(SINGLE_HAND_SWITCH, SINGLE_HAND_SWITCH_OFF);
      controller.enterSingleHand(SingleHandMode.LEFT);
      expect(getSettingsData(SINGLE_HAND_MODE)).assertEqual(SingleHandMode.LEFT);
      setSettingsData(SINGLE_HAND_SWITCH, curSwitch);
    })
    /*
    * @tc.number:SCBSingleHandControllerTest_005
    * @tc.name: 单手模式开启失败(注册函数拦截)
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 注册单手模式关闭函数，单手模式开启失败
    */
    it('SCBSingleHandControllerTest_005', 0, () => {
      let controller: SCBSingleHandController = SCBSingleHandController.getInstance();
      let testSingleHandCondition: TestSingleHandConditionFunc = new TestSingleHandConditionFunc();
      controller.registerSingleHandConditionFunc("testSingleHandCondition", testSingleHandCondition);
      controller.enterSingleHand(SingleHandMode.LEFT);
      expect(getSettingsData(SINGLE_HAND_MODE)).assertEqual(SingleHandMode.LEFT);
      testSingleHandCondition.setCurCondition(true);
      controller.enterSingleHand(SingleHandMode.LEFT);
      expect(getSettingsData(SINGLE_HAND_MODE)).assertEqual(SingleHandMode.LEFT);
      controller.exitSingleHand(SingleHandExitReason.CLICK_EMPTY);
      expect(getSettingsData(SINGLE_HAND_MODE)).assertEqual(SingleHandMode.MIDDLE);
      controller.unregisterSingleHandConditionFunc("testSingleHandCondition");
    })
    /*
    * @tc.number:SCBSingleHandControllerTest_006
    * @tc.name: 单手模式重复退出
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 重复退出，退出成功
    */
    it('SCBSingleHandControllerTest_006', 0, () => {
      let controller: SCBSingleHandController = SCBSingleHandController.getInstance();
      controller.enterSingleHand(SingleHandMode.LEFT);
      expect(getSettingsData(SINGLE_HAND_MODE)).assertEqual(SingleHandMode.LEFT);
      controller.exitSingleHand(SingleHandExitReason.CLICK_EMPTY);
      expect(getSettingsData(SINGLE_HAND_MODE)).assertEqual(SingleHandMode.MIDDLE);
      controller.exitSingleHand(SingleHandExitReason.SCREEN_LOCK);
      expect(getSettingsData(SINGLE_HAND_MODE)).assertEqual(SingleHandMode.MIDDLE);
    })
    /*
    * @tc.number:SCBSingleHandControllerTest_006
    * @tc.name: 单手模式注册函数监听退出
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 单手模式注册函数监听到single_hand_mode变化，退出成功
    */
    it('SCBSingleHandControllerTest_007', 0, () => {
      let controller: SCBSingleHandController = SCBSingleHandController.getInstance();
      controller.enterSingleHand(SingleHandMode.LEFT);
      expect(getSettingsData(SINGLE_HAND_MODE)).assertEqual(SingleHandMode.LEFT);
      setSettingsData(SINGLE_HAND_MODE, SingleHandMode.MIDDLE);
      expect(getSettingsData(SINGLE_HAND_MODE)).assertEqual(SingleHandMode.MIDDLE);
    })
    /*
    * @tc.number:SCBSingleHandControllerTest_008
    * @tc.name: 单手模式注册动效完成函数监听
    * @tc.type: 0 || TestType.FUNCTION  || Level.LEVEL0
    * @tc.desc: 单手模式注册动效完成函数监听成功
    */
    it('SCBSingleHandControllerTest_008', 0, () => {
      let controller: SCBSingleHandController = SCBSingleHandController.getInstance();
      let testSingleHandAnimaFinishCallback: TestSingleHandAnimationFinishCallback =
        new TestSingleHandAnimationFinishCallback();
      controller.registerSingleHandAnimationFinishCallBack("singleHandTest", testSingleHandAnimaFinishCallback);
      controller.notifySingleHandModeAnimationFinish(true);
      expect(testSingleHandAnimaFinishCallback.animationFinish).assertEqual(true);
      controller.notifySingleHandModeAnimationFinish(false);
      expect(testSingleHandAnimaFinishCallback.animationFinish).assertEqual(false);
      controller.unregisterSingleHandAnimationFinishCallBack("singleHandTest");
    })
  })
}

/* 获取SettingsData的值 */
function getSettingsData(key: string): string {
  let domainName: string = settings.domainName.USER_PROPERTY;
  let context = GlobalContext.getContext();
  let data: string  = settings.getValueSync(context, key, SINGLE_HAND_SWITCH_ON, domainName);
  return data;
}

/* 设置SettingsData的值 */
function setSettingsData(key: string, val: string): void {
  let domainName: string = settings.domainName.USER_PROPERTY;
  let context = GlobalContext.getContext();
  settings.setValueSync(context, key, val, domainName);
}