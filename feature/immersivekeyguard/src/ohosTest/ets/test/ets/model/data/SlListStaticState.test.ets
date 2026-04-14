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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium';
import { ImmersiveState, ImmersiveType } from '@ohos/systemuicommon';
import {
  immersiveStateMgr,
  IImmersiveState,
} from '../../../../../../main/ets/common/manager/ImmersiveStateManager';
import { CapStyleBuilder } from '../../../../../../main/ets/model/data/ImmersiveCapsuleStyle';
import { SlListStaticState } from '../../../../../../main/ets/model/data/SlListStaticState';
import { BrightnessOptionUtils, ImmersiveTextStyle } from '@ohos/systemuicommon/Index';
/**
 * 沉浸式锁屏通知列表组件静态状态管理测试用例
 *
 */
export function SlListStaticStateTest() {
  let mocker: MockKit;
  describe('SlListStaticStateTest', (): void => {
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
      let manager = new SlListStaticState();
      manager.getSlRootListAnimCtrl();
      expect(res).assertTrue();
    });

    /**
     * 复写 WidgetStaticState get方法测试用例
     *
     */
    it('test_initGetMethods', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlListStaticState();
      manager.getSlRootListAnimCtrl();
      expect(res).assertTrue();
    });

    /**
     * 设置通知列表背景色测试用例
     *
     */
    it('test_setBackgroundColor', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlListStaticState();
      let color ='#000000';
      manager.setBackgroundColor(color);
      expect(res).assertTrue();
    });

    /**
     * 获取通知列表背景色测试用例
     *
     */
    it('test_getBackgroundColor', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlListStaticState();
      manager.getBackgroundColor();
      expect(res).assertTrue();
    });

    /**
     * 设置通知列表提亮参数测试用例
     *
     */
    it('test_setBrightness', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlListStaticState();
      let option =BrightnessOptionUtils.aodTimeLightOptionForFillColor;
      manager.setBrightness(option);
      expect(res).assertTrue();
    });

    /**
     * 获取通知列表提亮参数测试用例
     *
     */
    it('test_getBrightness', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlListStaticState();
      manager.getBrightness();
      expect(res).assertTrue();
    });

    /**
     * 设置通知主文本样式测试用例
     *
     */
    it('test_setListMainTextStyle', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlListStaticState();
      let style = ImmersiveTextStyle.wrapper();
      manager.setListMainTextStyle(style);
      expect(res).assertTrue();
    });

    /**
     * 获取通知主文本样式测试用例
     *
     */
    it('test_getListMainTextStyle', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlListStaticState();
      manager.getListMainTextStyle();
      expect(res).assertTrue();
    });

    /**
     * 设置通知副文本样式测试用例
     *
     */
    it('test_setListSecondaryTextStyle', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlListStaticState();
      let style = ImmersiveTextStyle.wrapper();
      manager.setListSecondaryTextStyle(style);
      expect(res).assertTrue();
    });

    /**
     * 获取通知副文本样式测试用例
     *
     */
    it('test_getListSecondaryTextStyle', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlListStaticState();
      manager.getListSecondaryTextStyle();
      expect(res).assertTrue();
    });

  });
}