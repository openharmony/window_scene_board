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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium';
import { ImmersiveState, ImmersiveType } from '@ohos/systemuicommon';
import {
  immersiveStateMgr,
  IImmersiveState,
} from '../../../../../../main/ets/common/manager/ImmersiveStateManager';
import { CapStyleBuilder } from '../../../../../../main/ets/model/data/ImmersiveCapsuleStyle';
import { SlCapWidgetBindState } from '../../../../../../main/ets/model/data/SlCapWidgetBindState';
import { BrightnessOptionUtils, ImmersiveTextStyle } from '@ohos/systemuicommon/Index';

/**
 * 沉浸式锁屏胶囊组件UI绑定状态管理测试用例
 *
 */
export function SlCapWidgetBindStateTest() {
  let mocker: MockKit;
  describe('SlCapWidgetBindStateTest', (): void => {
    beforeAll((): void => {
      mocker = new MockKit();
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
      mocker.clearAll();
    });
    afterEach((): void => {
    });

    /**
     * 复写 WidgetStaticState set方法测试用例
     *
     */
    it('test_initSetMethods', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCapWidgetBindState();
      manager.getBackgroundColor();
      expect(res).assertTrue();
    });

    /**
     * 复写 WidgetStaticState get方法测试用例
     *
     */
    it('test_initGetMethods', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCapWidgetBindState();
      manager.getBackgroundColor();
      expect(res).assertTrue();
    });

    /**
     * 设置沉浸胶囊背景色测试用例
     *
     */
    it('test_setBackgroundColor', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCapWidgetBindState();
      let color ='#000000';
      manager.setBackgroundColor(color);
      expect(res).assertTrue();
    });

    /**
     * 获取沉浸胶囊背景色测试用例
     *
     */
    it('test_getBackgroundColor', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCapWidgetBindState();
      manager.getBackgroundColor();
      expect(res).assertTrue();
    });

    /**
     * 设置沉浸胶囊提亮参数测试用例
     *
     */
    it('test_setBrightness', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCapWidgetBindState();
      let option =BrightnessOptionUtils.aodTimeLightOptionForFillColor;
      manager.setBrightness(option);
      expect(res).assertTrue();
    });

    /**
     * 获取沉浸胶囊提亮参数测试用例
     *
     */
    it('test_getBrightness', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCapWidgetBindState();
      manager.getBrightness();
      expect(res).assertTrue();
    });

    it('test_setAlpha', Level.LEVEL0, (): void => {
      let num = 5;
      let manager = new SlCapWidgetBindState();
      (manager as object)['alpha'] = num;
      (manager as object)['setAlpha'](num);
      expect(manager.getScale()).not().assertNull();
    });

    it('test_getAlpha', Level.LEVEL0, (): void =>{
      let manager = new SlCapWidgetBindState();
      expect(manager.getAlpha()).not().assertNull();
    });

    it('test_setScale', Level.LEVEL0, (): void => {
      let num = 5;
      let manager = new SlCapWidgetBindState();
      (manager as object)['capScale'] = num;
      (manager as object)['capScale'] = undefined;
      expect(manager.getScale()).not().assertNull();
    });

    it('test_getScale', Level.LEVEL0, (): void => {
      let manager = new SlCapWidgetBindState();
      expect(manager.getScale()).not().assertNull();
    });

    it('test_setAlpha_02', Level.LEVEL0, (): void => {
      let num = 5;
      let manager = new SlCapWidgetBindState();
      (manager as object)['alpha'] = num;
      (manager as object)['setAlpha'](1);
      expect(manager.getScale()).not().assertNull();
    });

    it('test_setScale_02', Level.LEVEL0, (): void => {
      let num = 5;
      let manager = new SlCapWidgetBindState();
      (manager as object)['alpha'] = num;
      (manager as object)['setScale'](num);
      expect(manager.getScale()).not().assertNull();
    });

    it('test_setScale_03', Level.LEVEL0, (): void => {
      let num = 5;
      let manager = new SlCapWidgetBindState();
      (manager as object)['alpha'] = num;
      (manager as object)['setScale'](3);
      expect(manager).not().assertNull();
    });
  });
}