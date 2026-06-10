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
import { SlCapStaticState } from '../../../../../../main/ets/model/data/SlCapStaticState';
import { BrightnessOptionUtils, ImmersiveTextStyle } from '@ohos/systemuicommon/Index';

/**
 * 沉浸式锁屏胶囊组件静态状态管理测试用例
 *
 */
export function SlCapStaticStateTest() {
  let mocker: MockKit;
  describe('SlCapStaticStateTest', (): void => {
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
      let manager = new SlCapStaticState();
      manager.getSlContentCapAnimCtrl();
      expect(res).assertTrue();
    });

    /**
     * 复写 WidgetStaticState get方法测试用例
     *
     */
    it('test_initGetMethods', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCapStaticState();
      manager.getSlRootCapAnimCtrl();
      expect(res).assertTrue();
    });

    /**
     * 获取内容胶囊动效管理测试用例
     *
     */
    it('test_getSlContentCapAnimCtrl', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCapStaticState();
      manager.getSlContentCapAnimCtrl();
      expect(res).assertTrue();
    });


    /**
     *  获取阴影胶囊动效管理测试用例
     *
     */
    it('test_getSlShadowCapAnimCtrl', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCapStaticState();
      manager.getSlShadowCapAnimCtrl();
      expect(res).assertTrue();
    });

    /**
     * 获取沉浸胶囊根布局动效管理测试用例
     *
     */
    it('test_getSlRootCapAnimCtrl', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCapStaticState();
      manager.getSlRootCapAnimCtrl();
      expect(res).assertTrue();
    });

    /**
     * 设置沉浸胶囊背景色测试用例
     *
     */
    it('test_setBackgroundColor', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCapStaticState();
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
      let manager = new SlCapStaticState();
      manager.getBackgroundColor();
      expect(res).assertTrue();
    });

    /**
     * 设置沉浸胶囊提亮参数测试用例
     *
     */
    it('test_setBrightness', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCapStaticState();
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
      let manager = new SlCapStaticState();
      manager.getBrightness();
      expect(res).assertTrue();
    });

    /**
     * 设置沉浸胶囊主文本样式测试用例
     *
     */
    it('test_setCapMainTextStyle', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCapStaticState();
      let style = ImmersiveTextStyle.wrapper();
      manager.setCapMainTextStyle(style);
      expect(res).assertTrue();
    });

    /**
     * 获取沉浸胶囊主文本样式测试用例
     *
     */
    it('test_getCapMainTextStyle', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCapStaticState();
      manager.getCapMainTextStyle();
      expect(res).assertTrue();
    });

    /**
     * 设置沉浸胶囊副文本样式测试用例
     *
     */
    it('test_setCapSecondaryTextStyle', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCapStaticState();
      let style = ImmersiveTextStyle.wrapper();
      manager.setCapSecondaryTextStyle(style);
      expect(res).assertTrue();
    });

    /**
     * 获取沉浸胶囊副文本样式测试用例
     *
     */
    it('test_getCapSecondaryTextStyle', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCapStaticState();
      manager.getCapSecondaryTextStyle();
      expect(res).assertTrue();
    });
  });
}