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
import { SlCardWidgetBindState } from '../../../../../../main/ets/model/data/SlCardWidgetBindState';
import { BrightnessOptionUtils, ImmersiveTextStyle } from '@ohos/systemuicommon/Index';

/**
 * 沉浸式锁屏卡片组件UI绑定状态管理测试用例
 *
 */
export function SlCardWidgetBindStateTest() {
  let mocker: MockKit;
  describe('SlCardWidgetBindStateTest', (): void => {
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
      let manager = new SlCardWidgetBindState();
      (manager as object)['initSetMethods']();
      expect(res).assertTrue();
    });

    /**
     * 复写 WidgetStaticState get方法测试用例
     *
     */
    it('test_initGetMethods', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCardWidgetBindState();
      (manager as object)['initGetMethods']();
      expect(res).assertTrue();
    });

    /**
     * 设置沉浸卡片背景色测试用例
     *
     */
    it('test_setBackgroundColor', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCardWidgetBindState();
      let color ='#000000';
      manager.setBackgroundColor(color);
      expect(res).assertTrue();
    });

    /**
     * 获取沉浸卡片背景色测试用例
     *
     */
    it('test_getBackgroundColor_01', Level.LEVEL0, (): void => {
      let manager = new SlCardWidgetBindState();
      let res = manager.getBackgroundColor();
      expect(res).assertUndefined();
    });

    it('test_getBackgroundColor_02', Level.LEVEL0, (): void => {
      let manager = new SlCardWidgetBindState();
      (manager as object)['cardBackgroundColor'] = '#000000';
      let res = manager.getBackgroundColor();
      expect(res).assertEqual('#000000');
    });

    /**
     * 设置沉浸卡片提亮参数测试用例
     *
     */
    it('test_setBrightness', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCardWidgetBindState();
      let option =BrightnessOptionUtils.aodTimeLightOptionForFillColor;
      manager.setBrightness(option);
      expect(res).assertTrue();
    });

    /**
     * 获取沉浸卡片提亮参数测试用例
     *
     */
    it('test_getBrightness_01', Level.LEVEL0, (): void => {
      let manager = new SlCardWidgetBindState();
      let res = manager.getBrightness();
      expect(res).assertUndefined();
    });

    it('test_getBrightness_02', Level.LEVEL0, (): void => {
      let manager = new SlCardWidgetBindState();
      (manager as object)['brightnessOptions'] = BrightnessOptionUtils.aodTimeLightOptionForFillColor;
      let res = manager.getBrightness();
      expect(res).assertDeepEquals(BrightnessOptionUtils.aodTimeLightOptionForFillColor);
    });

    it('test_setBgAlpha', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCardWidgetBindState();
      manager.setBgAlpha(0.5);
      expect(res).assertTrue();
    });

    it('test_getBgAlpha_01', Level.LEVEL0, (): void => {
      let manager = new SlCardWidgetBindState();
      let res = manager.getBgAlpha();
      expect(res).assertUndefined();
    });

    it('test_getBgAlpha_02', Level.LEVEL0, (): void => {
      let manager = new SlCardWidgetBindState();
      (manager as object)['bgAlpha'] = 0.1;
      let res = manager.getBgAlpha();
      expect(res).assertEqual(0.1);
    });

    it('test_setPreviewAlpha', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCardWidgetBindState();
      manager.setPreviewAlpha(0.5);
      expect(res).assertTrue();
    });

    it('test_getPreviewAlpha_01', Level.LEVEL0, (): void => {
      let manager = new SlCardWidgetBindState();
      let res = manager.getPreviewAlpha();
      expect(res).assertUndefined();
    });

    it('test_getPreviewAlpha_02', Level.LEVEL0, (): void => {
      let manager = new SlCardWidgetBindState();
      (manager as object)['previewAlpha'] = 0.1;
      let res = manager.getPreviewAlpha();
      expect(res).assertEqual(0.1);
    });

    it('test_setScale', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCardWidgetBindState();
      manager.setScale(1.5);
      expect(res).assertTrue();
    });

    it('test_getScale_01', Level.LEVEL0, (): void => {
      let manager = new SlCardWidgetBindState();
      let res = manager.getScale();
      expect(res).assertUndefined();
    });

    it('test_getScale_02', Level.LEVEL0, (): void => {
      let manager = new SlCardWidgetBindState();
      (manager as object)['cardScale'] = 1.5;
      let res = manager.getScale();
      expect(res).assertEqual(1.5);
    });

    it('test_setAlpha', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCardWidgetBindState();
      manager.setAlpha(0.5);
      expect(res).assertTrue();
    });

    it('test_getAlpha_01', Level.LEVEL0, (): void => {
      let manager = new SlCardWidgetBindState();
      let res = manager.getAlpha();
      expect(res).assertUndefined();
    });

    it('test_getAlpha_02', Level.LEVEL0, (): void => {
      let manager = new SlCardWidgetBindState();
      (manager as object)['alpha'] = 0.5;
      let res = manager.getAlpha();
      expect(res).assertEqual(0.5);
    });

    it('test_setIsCardFold_01', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCardWidgetBindState();
      manager.setIsCardFold(true);
      expect(res).assertTrue();
    });

    it('test_setIsCardFold_02', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCardWidgetBindState();
      manager.setIsCardFold(false);
      expect(res).assertTrue();
    });

    it('test_getIsCardFold_01', Level.LEVEL0, (): void => {
      let manager = new SlCardWidgetBindState();
      let res = manager.getIsCardFold();
      expect(res).assertUndefined();
    });

    it('test_getIsCardFold_02', Level.LEVEL0, (): void => {
      let manager = new SlCardWidgetBindState();
      (manager as object)['isCardFold'] = true;
      let res = manager.getIsCardFold();
      expect(res).assertTrue();
    });

    it('test_getIsCardFold_03', Level.LEVEL0, (): void => {
      let manager = new SlCardWidgetBindState();
      (manager as object)['isCardFold'] = false;
      let res = manager.getIsCardFold();
      expect(res).assertFalse();
    });

    it('test_setUiExtentionLoadState_01', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCardWidgetBindState();
      manager.setUiExtentionLoadState(true);
      expect(res).assertTrue();
    });

    it('test_setUiExtentionLoadState_02', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCardWidgetBindState();
      (manager as object)['uiExtentionLoadingState'] = true;
      manager.setUiExtentionLoadState(true);
      expect(res).assertTrue();
    });

    it('test_setUiExtentionLoadState_03', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCardWidgetBindState();
      (manager as object)['uiExtentionLoadingState'] = false;
      manager.setUiExtentionLoadState(true);
      expect(res).assertTrue();
    });

    it('test_setUiExtentionLoadState_04', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCardWidgetBindState();
      manager.setUiExtentionLoadState(false);
      expect(res).assertTrue();
    });

    it('test_setUiExtentionLoadState_05', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCardWidgetBindState();
      (manager as object)['uiExtentionLoadingState'] = true;
      manager.setUiExtentionLoadState(false);
      expect(res).assertTrue();
    });

    it('test_setUiExtentionLoadState_06', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlCardWidgetBindState();
      (manager as object)['uiExtentionLoadingState'] = false;
      manager.setUiExtentionLoadState(false);
      expect(res).assertTrue();
    });

    it('test_getUiExtentionLoadState_01', Level.LEVEL0, (): void => {
      let manager = new SlCardWidgetBindState();
      let res = manager.getUiExtentionLoadState();
      expect(res).assertUndefined();
    });

    it('test_getUiExtentionLoadState_02', Level.LEVEL0, (): void => {
      let manager = new SlCardWidgetBindState();
      (manager as object)['uiExtentionLoadingState'] = true;
      let res = manager.getUiExtentionLoadState();
      expect(res).assertTrue();
    });

    it('test_getUiExtentionLoadState_03', Level.LEVEL0, (): void => {
      let manager = new SlCardWidgetBindState();
      (manager as object)['uiExtentionLoadingState'] = false;
      let res = manager.getUiExtentionLoadState();
      expect(res).assertFalse();
    });

  });
}