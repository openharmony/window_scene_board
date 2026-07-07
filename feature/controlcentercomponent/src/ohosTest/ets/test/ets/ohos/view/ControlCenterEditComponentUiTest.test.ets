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

import {
  afterAll, beforeAll, it,
  describe, expect} from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import { QuickToggleController } from '../../../../../../main/ets/com/ohos/controller/QuickToggleController';

export async function ControlCenterEditComponentUiTest() {

  describe('ControlCenterEditComponentUiTest', (): void => {
    // 定义Driver类
    let driver = Driver.create();
    beforeAll(async () => {
      QuickToggleController.getInstance().saveQuickToggleData([
        'flashlight', 'ring_mode', 'auto_rotate', 'mobile_data', 'share', 'location', 'air_plane', 'hotspot',
        'toggle_screenshot', 'toggle_screen_recorder', 'nfc', 'CastToggle', 'dark_mode', 'camera', 'mic', 'sound'
      ]);
      try {
        // 亮屏解锁
        await driver.wakeUpDisplay();
        await driver.delayMs(2000);
        await driver.fling({
          x: 500, y: 2000
        }, {
          x: 500, y: 900
        }, 1000, 2000);
        await driver.delayMs(2000);
      } catch (exception) {
        await driver.pressHome();
      }
      await driver.delayMs(2000);
    });

    afterAll(async () => {
    });

    it('ControlCenterEditComponentUiTest_showControlCenter', 0, async () => {
      try {
        // 下拉控制中心
        await driver.swipe(850, 10, 850, 400, 2000);
        await driver.delayMs(1500);

        // 面板快速下滑
        await driver.swipe(500, 1000, 500, 3000, 30000);
        await driver.delayMs(1000);

        // 面板慢速下滑
        await driver.swipe(500, 1000, 500, 3000, 600);
        await driver.delayMs(1000);

        // 从状态栏短距离下滑
        await driver.swipe(800, 1, 800, 500, 5000);
        await driver.delayMs(1000);

        // 从状态栏长距离下滑
        await driver.swipe(800, 1, 800, 1500, 5000);
        await driver.delayMs(1000);

        // 上滑收起控制中心
        await driver.swipe(500, 2000, 500, 1000, 1000);
        await driver.delayMs(1500);
        expect(driver !== undefined).assertTrue();
      } finally {
        await driver.pressHome();
      }
    });

    it('ControlCenterEditComponentUiTest_edit_back', 0, async () => {
      try {
        // 下拉控制中心
        await driver.swipe(850, 10, 850, 400, 2000);
        await driver.delayMs(1500);

        // 进入编辑
        let editBtn = await driver.findComponent(ON.id('Ctrl.HeaderLayout_Image_edit'));
        await editBtn.click();
        await driver.delayMs(3000);

        // 点击返回
        let backBtn = await driver.findComponent(ON.id('Ctrl.ToggleEditView_header_btn_left_FOCUS'));
        await backBtn.click();
        await driver.delayMs(3000);

        // 上滑收起控制中心
        await driver.swipe(500, 2000, 500, 1000, 1000);
        await driver.delayMs(1500);
        expect(driver !== undefined).assertTrue();
      } finally {
        await driver.pressHome();
      }
    });

    it('ControlCenterEditComponentUiTest_edit_remove', 0, async () => {
      try {
        // 下拉控制中心
        await driver.swipe(850, 10, 850, 400, 2000);
        await driver.delayMs(1500);

        // 进入编辑
        let editBtn = await driver.findComponent(ON.id('Ctrl.HeaderLayout_Image_edit'));
        await editBtn.click();
        await driver.delayMs(3000);

        // 点击移除
        let removeBtn = await driver.findComponent(ON.id('Ctrl.ToggleEditView_Remove_Btn'));
        await removeBtn.click();
        await driver.delayMs(3000);

        // 点击确认
        let rightBtn = await driver.findComponent(ON.id('Ctrl.ToggleEditView_header_btn_right_FOCUS'));
        await rightBtn.click();
        await driver.delayMs(3000);

        // 上滑收起控制中心
        await driver.swipe(500, 2000, 500, 1000, 1000);
        await driver.delayMs(1500);
        expect(driver !== undefined).assertTrue();
      } finally {
        await driver.pressHome();
      }
    });
  })
}