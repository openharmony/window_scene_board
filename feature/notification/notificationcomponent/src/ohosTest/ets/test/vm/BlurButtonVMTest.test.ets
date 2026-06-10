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
import { NotificationEntry } from '../../../main/ets/model/NotificationEntry';
import { CommonUtils, ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { SettingsConstants } from '@ohos/commonconstants';
import { WindowConstants, SettingsKeyConstants, SCBConstants } from '@ohos/commonconstants';
import {
  EvtBus,
  EventManager,
  PluginSlot,
  WindowEvent,
  HiDfxEventUtil,
  sSettingsUtil,
  SCBWindowSceneConfig,
  ScreenLockEvent,
  viewMgrPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import { windowMgr, SCBSystemBarProperty, SCBSceneSessionManager,
  SCBSpecificSceneSessionList,
  SpecificPanelZOrder,
  SCBSessionRect} from '@ohos/windowscene';
import { NotificationEntryEvent } from '../../../main/ets/common/event/NotificationEvent';
import { hideBannerNtfContentObj } from '../../../main/ets/model/HideBannerNtfContentObj';
import { notificationConfigManager } from '../../../main/ets/manager/NotificationConfigManager';
import {
  NotificationConfigEvent,
  NotificationConfigEventType
} from '@ohos/systemuicommon/src/main/ets/model/NotificationConfigEvent';
import { HideBannerContentType } from '@ohos/systemuicommon/src/main/ets/constants/HideBannerContentType';
import sceneSessionManager from '@ohos.sceneSessionManager';
import Window from '@ohos.window';
import { NotificationSysEventReporter } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import I18n from '@ohos.i18n';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NtfHeadsUpVM } from '../../../main/ets/vm/NtfHeadsUpVM';
import { BlurButtonVM } from '../../../../main/ets/vm/BlurButtonVM';

export default function BlurButtonVMTest() {
  describe('init_testSuite', () => {

    beforeEach(() => {
      // 重置状态
      blurButtonVM.setShouldBlur(false);
      blurButtonVM.isButtonClick = false;
      blurButtonVM.buttonPositionX = 0;
      blurButtonVM.buttonPositionY = 0;
      blurButtonVM.buttonParentArea = undefined;
    });

    // 测试点击按钮后的模糊效果
    it('should apply blur effect when button is clicked', () => {
      const buttonPosition = { x: 100, y: 200 };
      blurButtonVM.blur(buttonPosition);
      expect(blurButtonVM.getShouldBlur()).toBe(true);
      expect(blurButtonVM.getIsButtonClick()).toBe(true);
      expect(blurButtonVM.buttonPositionX).toBe(buttonPosition.x);
      expect(blurButtonVM.buttonPositionY).toBe(buttonPosition.y);
    });

    // 测试取消模糊效果
    it('should remove blur effect when unblur is called', () => {
      blurButtonVM.blur({ x: 100, y: 200 });
      blurButtonVM.unblur(true);
      expect(blurButtonVM.getShouldBlur()).toBe(false);
      expect(blurButtonVM.getIsButtonClick()).toBe(false);
    });

    // 测试按钮位置更新
    it('should update button position correctly', () => {
      const newPosition = { x: 300, y: 400 };
      blurButtonVM.updateButtonPosition(newPosition);
      expect(blurButtonVM.buttonPositionX).toBe(newPosition.x);
      expect(blurButtonVM.buttonPositionY).toBe(newPosition.y);
    });

    // 测试按钮边距计算（非RTL）
    it('should calculate button margin correctly in non-RTL layout', () => {
      blurButtonVM.buttonPositionX = 100;
      blurButtonVM.buttonPositionY = 200;
      const margin = blurButtonVM.getButtonMargin();
      expect(margin.top).toBe(200);
      expect(margin.left).toBe(100);
    });

    // 测试按钮边距计算（RTL）
    it('should calculate button margin correctly in RTL layout', () => {
      RTLUtil.isRTL = () => true;
      blurButtonVM.buttonPositionX = 100;
      blurButtonVM.buttonPositionY = 200;
      const displayInfo = display.getDefaultDisplaySync();
      const screenWidth = displayInfo.width;
      const margin = blurButtonVM.getButtonMargin();
      expect(margin.top).toBe(200);
      expect(margin.right).toBe(screenWidth - 100 - 40);
    });

    // 测试按钮边距计算（有父组件区域）
    it('should calculate button margin with parent area correctly', () => {
      blurButtonVM.buttonParentArea = { globalPosition: { x: 50, y: 100 } };
      blurButtonVM.buttonPositionX = 100;
      blurButtonVM.buttonPositionY = 200;
      const margin = blurButtonVM.getButtonMargin();
      expect(margin.top).toBe(100);
      expect(margin.left).toBe(50);
    });

    // 测试弹窗对齐规则（屏幕底部）
    it('should align dialog to bottom when over screen bottom', () => {
      blurButtonVM.buttonPositionY = 1000; // 模拟超出屏幕底部
      const dialogId = 'testDialog';
      const alignRules = blurButtonVM.getAlignRules(dialogId);
      expect(alignRules.bottom).toBeDefined();
      expect(alignRules.top).toBeUndefined();
    });

    // 测试弹窗对齐规则（非屏幕底部）
    it('should align dialog to top when not over screen bottom', () => {
      blurButtonVM.buttonPositionY = 100; // 模拟未超出屏幕底部
      const dialogId = 'testDialog';
      const alignRules = blurButtonVM.getAlignRules(dialogId);
      expect(alignRules.top).toBeDefined();
      expect(alignRules.bottom).toBeUndefined();
    });

    // 测试弹窗对齐规则（RTL）
    it('should align dialog correctly in RTL layout', () => {
      RTLUtil.isRTL = () => true;
      blurButtonVM.buttonPositionY = 1000; // 模拟超出屏幕底部
      const dialogId = 'testDialog';
      const alignRules = blurButtonVM.getAlignRules(dialogId);
      expect(alignRules.bottom).toBeDefined();
      expect(alignRules.left).toBeDefined();
    });

    // 测试右对齐计算（RTL）
    it('should calculate RTL right value correctly', () => {
      RTLUtil.isRTL = () => true;
      blurButtonVM.buttonPositionX = 100;
      const displayInfo = display.getDefaultDisplaySync();
      const screenWidth = displayInfo.width;
      const rtlRight = blurButtonVM.getIsRTLRight();
      expect(rtlRight).toBe(screenWidth - 100 - 40);
    });

    // 测试右对齐计算（非RTL）
    it('should return 0 for RTL right in non-RTL layout', () => {
      RTLUtil.isRTL = () => false;
      const rtlRight = blurButtonVM.getIsRTLRight();
      expect(rtlRight).toBe(0);
    });

    // 测试检查按钮是否超出屏幕底部
    it('should check if button is over screen bottom correctly', () => {
      blurButtonVM.buttonPositionY = 1000; // 模拟超出屏幕底部
      expect(blurButtonVM.checkOverScreenBottom()).toBe(true);
    });

    // 测试检查按钮未超出屏幕底部
    it('should check if button is not over screen bottom correctly', () => {
      blurButtonVM.buttonPositionY = 100; // 模拟未超出屏幕底部
      expect(blurButtonVM.checkOverScreenBottom()).toBe(false);
    });

    // 测试多次点击按钮
    it('should handle multiple button clicks correctly', () => {
      blurButtonVM.blur({ x: 100, y: 200 });
      expect(blurButtonVM.getShouldBlur()).toBe(true);
      blurButtonVM.blur({ x: 200, y: 300 });
      expect(blurButtonVM.getShouldBlur()).toBe(true);
      expect(blurButtonVM.buttonPositionX).toBe(200);
      expect(blurButtonVM.buttonPositionY).toBe(300);
    });

    // 测试取消模糊后按钮状态
    it('should reset button state after unblurring', () => {
      blurButtonVM.blur({ x: 100, y: 200 });
      blurButtonVM.unblur();
      expect(blurButtonVM.getShouldBlur()).toBe(false);
      expect(blurButtonVM.getIsButtonClick()).toBe(false);
    });

    // 测试按钮位置更新后边距计算
    it('should recalculate margin after position update', () => {
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      const margin = blurButtonVM.getButtonMargin();
      expect(margin.top).toBe(250);
      expect(margin.left).toBe(150);
    });

    // 测试按钮位置更新后对齐规则
    it('should recalculate align rules after position update', () => {
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      const dialogId = 'testDialog';
      const alignRules = blurButtonVM.getAlignRules(dialogId);
      expect(alignRules).toBeDefined();
    });

    // 测试按钮位置更新后右对齐计算
    it('should recalculate RTL right after position update', () => {
      RTLUtil.isRTL = () => true;
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      const rtlRight = blurButtonVM.getIsRTLRight();
      const displayInfo = display.getDefaultDisplaySync();
      const screenWidth = displayInfo.width;
      expect(rtlRight).toBe(screenWidth - 150 - 40);
    });

    // 测试按钮位置更新后检查是否超出屏幕底部
    it('should check screen bottom after position update', () => {
      blurButtonVM.updateButtonPosition({ y: 1000 });
      expect(blurButtonVM.checkOverScreenBottom()).toBe(true);
    });

    // 测试按钮位置更新后取消模糊
    it('should unblur after position update', () => {
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      blurButtonVM.unblur(true);
      expect(blurButtonVM.getShouldBlur()).toBe(false);
      expect(blurButtonVM.getIsButtonClick()).toBe(false);
    });

    // 测试按钮位置更新后重新应用模糊
    it('should reapply blur after position update', () => {
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      blurButtonVM.blur({ x: 150, y: 250 });
      expect(blurButtonVM.getShouldBlur()).toBe(true);
      expect(blurButtonVM.getIsButtonClick()).toBe(true);
    });

    // 测试按钮位置更新后重新计算边距
    it('should recalculate margin after multiple position updates', () => {
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      blurButtonVM.updateButtonPosition({ x: 200, y: 300 });
      const margin = blurButtonVM.getButtonMargin();
      expect(margin.top).toBe(300);
      expect(margin.left).toBe(200);
    });

    // 测试按钮位置更新后重新计算对齐规则
    it('should recalculate align rules after multiple position updates', () => {
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      blurButtonVM.updateButtonPosition({ x: 200, y: 300 });
      const dialogId = 'testDialog';
      const alignRules = blurButtonVM.getAlignRules(dialogId);
      expect(alignRules).toBeDefined();
    });

    // 测试按钮位置更新后重新计算右对齐
    it('should recalculate RTL right after multiple position updates', () => {
      RTLUtil.isRTL = () => true;
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      blurButtonVM.updateButtonPosition({ x: 200, y: 300 });
      const rtlRight = blurButtonVM.getIsRTLRight();
      const displayInfo = display.getDefaultDisplaySync();
      const screenWidth = displayInfo.width;
      expect(rtlRight).toBe(screenWidth - 200 - 40);
    });

    // 测试按钮位置更新后重新检查是否超出屏幕底部
    it('should recheck screen bottom after multiple position updates', () => {
      blurButtonVM.updateButtonPosition({ y: 100 });
      blurButtonVM.updateButtonPosition({ y: 1000 });
      expect(blurButtonVM.checkOverScreenBottom()).toBe(true);
    });

    // 测试按钮位置更新后重新取消模糊
    it('should re-unblur after multiple position updates', () => {
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      blurButtonVM.updateButtonPosition({ x: 200, y: 300 });
      blurButtonVM.unblur(true);
      expect(blurButtonVM.getShouldBlur()).toBe(false);
      expect(blurButtonVM.getIsButtonClick()).toBe(false);
    });

    // 测试按钮位置更新后重新应用模糊
    it('should re-apply blur after multiple position updates', () => {
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      blurButtonVM.updateButtonPosition({ x: 200, y: 300 });
      blurButtonVM.blur({ x: 200, y: 300 });
      expect(blurButtonVM.getShouldBlur()).toBe(true);
      expect(blurButtonVM.getIsButtonClick()).toBe(true);
    });

    // 测试按钮位置更新后重新计算边距（RTL）
    it('should recalculate margin in RTL after position update', () => {
      RTLUtil.isRTL = () => true;
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      const margin = blurButtonVM.getButtonMargin();
      const displayInfo = display.getDefaultDisplaySync();
      const screenWidth = displayInfo.width;
      expect(margin.top).toBe(250);
      expect(margin.right).toBe(screenWidth - 150 - 40);
    });

    // 测试按钮位置更新后重新计算对齐规则（RTL）
    it('should recalculate align rules in RTL after position update', () => {
      RTLUtil.isRTL = () => true;
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      const dialogId = 'testDialog';
      const alignRules = blurButtonVM.getAlignRules(dialogId);
      expect(alignRules).toBeDefined();
    });

    // 测试按钮位置更新后重新计算右对齐（RTL）
    it('should recalculate RTL right after position update in RTL', () => {
      RTLUtil.isRTL = () => true;
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      const rtlRight = blurButtonVM.getIsRTLRight();
      const displayInfo = display.getDefaultDisplaySync();
      const screenWidth = displayInfo.width;
      expect(rtlRight).toBe(screenWidth - 150 - 40);
    });

    // 测试按钮位置更新后重新检查是否超出屏幕底部（RTL）
    it('should recheck screen bottom after position update in RTL', () => {
      RTLUtil.isRTL = () => true;
      blurButtonVM.updateButtonPosition({ y: 1000 });
      expect(blurButtonVM.checkOverScreenBottom()).toBe(true);
    });

    // 测试按钮位置更新后重新取消模糊（RTL）
    it('should re-unblur after position update in RTL', () => {
      RTLUtil.isRTL = () => true;
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      blurButtonVM.unblur(true);
      expect(blurButtonVM.getShouldBlur()).toBe(false);
      expect(blurButtonVM.getIsButtonClick()).toBe(false);
    });

    // 测试按钮位置更新后重新应用模糊（RTL）
    it('should re-apply blur after position update in RTL', () => {
      RTLUtil.isRTL = () => true;
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      blurButtonVM.blur({ x: 150, y: 250 });
      expect(blurButtonVM.getShouldBlur()).toBe(true);
      expect(blurButtonVM.getIsButtonClick()).toBe(true);
    });

    // 测试按钮位置更新后重新计算边距（非RTL）
    it('should recalculate margin in non-RTL after position update', () => {
      RTLUtil.isRTL = () => false;
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      const margin = blurButtonVM.getButtonMargin();
      expect(margin.top).toBe(250);
      expect(margin.left).toBe(150);
    });

    // 测试按钮位置更新后重新计算对齐规则（非RTL）
    it('should recalculate align rules in non-RTL after position update', () => {
      RTLUtil.isRTL = () => false;
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      const dialogId = 'testDialog';
      const alignRules = blurButtonVM.getAlignRules(dialogId);
      expect(alignRules).toBeDefined();
    });

    // 测试按钮位置更新后重新计算右对齐（非RTL）
    it('should recalculate RTL right after position update in non-RTL', () => {
      RTLUtil.isRTL = () => false;
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      const rtlRight = blurButtonVM.getIsRTLRight();
      expect(rtlRight).toBe(0);
    });

    // 测试按钮位置更新后重新检查是否超出屏幕底部（非RTL）
    it('should recheck screen bottom after position update in non-RTL', () => {
      RTLUtil.isRTL = () => false;
      blurButtonVM.updateButtonPosition({ y: 1000 });
      expect(blurButtonVM.checkOverScreenBottom()).toBe(true);
    });

    // 测试按钮位置更新后重新取消模糊（非RTL）
    it('should re-unblur after position update in non-RTL', () => {
      RTLUtil.isRTL = () => false;
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      blurButtonVM.unblur(true);
      expect(blurButtonVM.getShouldBlur()).toBe(false);
      expect(blurButtonVM.getIsButtonClick()).toBe(false);
    });

    // 测试按钮位置更新后重新应用模糊（非RTL）
    it('should re-apply blur after position update in non-RTL', () => {
      RTLUtil.isRTL = () => false;
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      blurButtonVM.blur({ x: 150, y: 250 });
      expect(blurButtonVM.getShouldBlur()).toBe(true);
      expect(blurButtonVM.getIsButtonClick()).toBe(true);
    });

    // 测试按钮位置更新后重新计算边距（有父组件区域）
    it('should recalculate margin with parent area after position update', () => {
      blurButtonVM.buttonParentArea = { globalPosition: { x: 50, y: 100 } };
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      const margin = blurButtonVM.getButtonMargin();
      expect(margin.top).toBe(150);
      expect(margin.left).toBe(50);
    });

    // 测试按钮位置更新后重新计算对齐规则（有父组件区域）
    it('should recalculate align rules with parent area after position update', () => {
      blurButtonVM.buttonParentArea = { globalPosition: { x: 50, y: 100 } };
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      const dialogId = 'testDialog';
      const alignRules = blurButtonVM.getAlignRules(dialogId);
      expect(alignRules).toBeDefined();
    });

    // 测试按钮位置更新后重新计算右对齐（有父组件区域）
    it('should recalculate RTL right with parent area after position update', () => {
      blurButtonVM.buttonParentArea = { globalPosition: { x: 50, y: 100 } };
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      const rtlRight = blurButtonVM.getIsRTLRight();
      expect(rtlRight).toBe(0);
    });

    // 测试按钮位置更新后重新检查是否超出屏幕底部（有父组件区域）
    it('should recheck screen bottom with parent area after position update', () => {
      blurButtonVM.buttonParentArea = { globalPosition: { x: 50, y: 100 } };
      blurButtonVM.updateButtonPosition({ y: 1000 });
      expect(blurButtonVM.checkOverScreenBottom()).toBe(true);
    });

    // 测试按钮位置更新后重新取消模糊（有父组件区域）
    it('should re-unblur with parent area after position update', () => {
      blurButtonVM.buttonParentArea = { globalPosition: { x: 50, y: 100 } };
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      blurButtonVM.unblur(true);
      expect(blurButtonVM.getShouldBlur()).toBe(false);
      expect(blurButtonVM.getIsButtonClick()).toBe(false);
    });

    // 测试按钮位置更新后重新应用模糊（有父组件区域）
    it('should re-apply blur with parent area after position update', () => {
      blurButtonVM.buttonParentArea = { globalPosition: { x: 50, y: 100 } };
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      blurButtonVM.blur({ x: 150, y: 250 });
      expect(blurButtonVM.getShouldBlur()).toBe(true);
      expect(blurButtonVM.getIsButtonClick()).toBe(true);
    });

    // 测试按钮位置更新后重新计算边距（有父组件区域和RTL）
    it('should recalculate margin with parent area and RTL after position update', () => {
      RTLUtil.isRTL = () => true;
      blurButtonVM.buttonParentArea = { globalPosition: { x: 50, y: 100 } };
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      const margin = blurButtonVM.getButtonMargin();
      expect(margin.top).toBe(150);
      expect(margin.left).toBe(50);
    });

    // 测试按钮位置更新后重新计算对齐规则（有父组件区域和RTL）
    it('should recalculate align rules with parent area and RTL after position update', () => {
      RTLUtil.isRTL = () => true;
      blurButtonVM.buttonParentArea = { globalPosition: { x: 50, y: 100 } };
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      const dialogId = 'testDialog';
      const alignRules = blurButtonVM.getAlignRules(dialogId);
      expect(alignRules).toBeDefined();
    });

    // 测试按钮位置更新后重新计算右对齐（有父组件区域和RTL）
    it('should recalculate RTL right with parent area and RTL after position update', () => {
      RTLUtil.isRTL = () => true;
      blurButtonVM.buttonParentArea = { globalPosition: { x: 50, y: 100 } };
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      const rtlRight = blurButtonVM.getIsRTLRight();
      const displayInfo = display.getDefaultDisplaySync();
      const screenWidth = displayInfo.width;
      expect(rtlRight).toBe(screenWidth - 150 - 40);
    });

    // 测试按钮位置更新后重新检查是否超出屏幕底部（有父组件区域和RTL）
    it('should recheck screen bottom with parent area and RTL after position update', () => {
      RTLUtil.isRTL = () => true;
      blurButtonVM.buttonParentArea = { globalPosition: { x: 50, y: 100 } };
      blurButtonVM.updateButtonPosition({ y: 1000 });
      expect(blurButtonVM.checkOverScreenBottom()).toBe(true);
    });

    // 测试按钮位置更新后重新取消模糊（有父组件区域和RTL）
    it('should re-unblur with parent area and RTL after position update', () => {
      RTLUtil.isRTL = () => true;
      blurButtonVM.buttonParentArea = { globalPosition: { x: 50, y: 100 } };
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      blurButtonVM.unblur(true);
      expect(blurButtonVM.getShouldBlur()).toBe(false);
      expect(blurButtonVM.getIsButtonClick()).toBe(false);
    });

    // 测试按钮位置更新后重新应用模糊（有父组件区域和RTL）
    it('should re-apply blur with parent area and RTL after position update', () => {
      RTLUtil.isRTL = () => true;
      blurButtonVM.buttonParentArea = { globalPosition: { x: 50, y: 100 } };
      blurButtonVM.updateButtonPosition({ x: 150, y: 250 });
      blurButtonVM.blur({ x: 150, y: 250 });
      expect(blurButtonVM.getShouldBlur()).toBe(true);
      expect(blurButtonVM.getIsButtonClick()).toBe(true);
    });
  })
}