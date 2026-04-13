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
import { SlCardStaticState } from '../../../../../../main/ets/model/data/SlCardStaticState';
import { BrightnessOptionUtils, ImmersiveTextStyle } from '@ohos/systemuicommon/Index';

/**
 * 沉浸式锁屏卡片组件静态状态管理测试用例
 *
 */
export function SlCardStaticStateTest() {
  let mocker: MockKit;
  describe('SlCardStaticStateTest', (): void => {
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
      let manager = new SlCardStaticState();
      (manager as object)['initSetMethods']();
      manager.getSlToggleCardAnimCtrl();
      expect(manager).not().assertNull();
    });

    /**
     * 复写 WidgetStaticState get方法测试用例
     *
     */
    it('test_initGetMethods', Level.LEVEL0, (): void => {
      let manager = new SlCardStaticState();
      (manager as object)['initGetMethods']();
      manager.getSlRootCardAnimCtrl();
      expect(manager).not().assertNull();
    });

    /**
     * 获取更新场景卡片动效管理测试用例
     *
     */
    it('test_getSlUpdateCardAnimCtrl', Level.LEVEL0, (): void => {
      let manager = new SlCardStaticState();
      manager.getSlUpdateCardAnimCtrl();
      expect(manager).not().assertNull();
    });

    /**
     *  获取切换场景卡片动效管理测试用例
     *
     */
    it('test_getSlToggleCardAnimCtrl', Level.LEVEL0, (): void => {
      let manager = new SlCardStaticState();
      manager.getSlToggleCardAnimCtrl();
      expect(manager).not().assertNull();
    });

    /**
     * 获取沉浸卡片根布局动效管理测试用例
     *
     */
    it('test_getSlRootCardAnimCtrl', Level.LEVEL0, (): void => {
      let manager = new SlCardStaticState();
      manager.getSlRootCardAnimCtrl();
      expect(manager).not().assertNull();
    });

    /**
     * 设置沉浸卡片背景色测试用例
     *
     */
    it('test_setBackgroundColor', Level.LEVEL0, (): void => {
      let manager = new SlCardStaticState();
      let color ='#000000';
      manager.setBackgroundColor(color);
      expect(manager).not().assertNull();
    });

    /**
     * 获取沉浸卡片背景色测试用例
     *
     */
    it('test_getBackgroundColor', Level.LEVEL0, (): void => {
      let manager = new SlCardStaticState();
      manager.getBackgroundColor();
      expect(manager).not().assertNull();
    });

    /**
     * 设置沉浸卡片提亮参数测试用例
     *
     */
    it('test_setBrightness', Level.LEVEL0, (): void => {
      let manager = new SlCardStaticState();
      let option =BrightnessOptionUtils.aodTimeLightOptionForFillColor;
      manager.setBrightness(option);
      expect(manager).not().assertNull();
    });

    /**
     * 获取沉浸卡片提亮参数测试用例
     *
     */
    it('test_getBrightness', Level.LEVEL0, (): void => {
      let manager = new SlCardStaticState();
      manager.getBrightness();
      expect(manager).not().assertNull();
    });

    /**
     * 设置三方卡片标题文本样式测试用例
     *
     */
    it('test_setOtherCardTitleTextStyle', Level.LEVEL0, (): void => {
      let manager = new SlCardStaticState();
      let style = ImmersiveTextStyle.wrapper();
      manager.setOtherCardTitleTextStyle(style);
      expect(manager).not().assertNull();
    });

    /**
     * 获取三方卡片标题文本样式测试用例
     *
     */
    it('test_getOtherCardTitleTextStyle', Level.LEVEL0, (): void => {
      let manager = new SlCardStaticState();
      manager.getOtherCardTitleTextStyle();
      expect(manager).not().assertNull();
    });

    /**
     * 设置三方卡片副文本样式测试用例
     *
     */
    it('test_setOtherCardRichTextStyle', Level.LEVEL0, (): void => {
      let manager = new SlCardStaticState();
      let style = ImmersiveTextStyle.wrapper();
      manager.setOtherCardRichTextStyle(style);
      expect(manager).not().assertNull();
    });

    /**
     * 获取三方卡片副文本样式测试用例
     *
     */
    it('test_getOtherCardRichTextStyle', Level.LEVEL0, (): void => {
      let manager = new SlCardStaticState();
      manager.getOtherCardRichTextStyle();
      expect(manager).not().assertNull();
    });

    /**
     * 设置导航卡片主要导航文本样式测试用例
     *
     */
    it('test_setCardMainNavInfoStyle', Level.LEVEL0, (): void => {
      let manager = new SlCardStaticState();
      let style = ImmersiveTextStyle.wrapper();
      manager.setCardMainNavInfoStyle(style);
      expect(manager).not().assertNull();
    });

    /**
     * 获取导航卡片副文本样式测试用例
     *
     */
    it('test_getCardMainNavInfoStyle', Level.LEVEL0, (): void => {
      let manager = new SlCardStaticState();
      let style = ImmersiveTextStyle.wrapper();
      manager.setCardMainNavInfoStyle(style);
      manager.getCardMainNavInfoStyle();
      expect(manager).not().assertNull();
    });

    it('test_CardViceNavInfoStyle', Level.LEVEL0, (): void => {
      let manager = new SlCardStaticState();
      let style1 = ImmersiveTextStyle.wrapper();
      let style2 = ImmersiveTextStyle.wrapper();
      style1.setTextWeight(100);
      style2.setTextWeight(100);
      manager.setCardViceNavInfoStyle(style1);
      manager.setCardViceNavInfoStyle(style2);
      manager.getCardViceNavInfoStyle();
      expect(manager).not().assertNull();
    });
  });
}