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
  describe} from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import { QuickToggleController } from '../../../../../../main/ets/com/ohos/controller/QuickToggleController';

export async function ControlCenterEditComponentUiTest() {

  describe('ControlCenterEditComponentUiTest', (): void => {
    // 定义Driver类
    let driver = Driver.create();
    beforeAll(async () => {
      QuickToggleController.getInstance().saveQuickToggleData([
        'flashlight', 'ring_mode', 'auto_rotate', 'mobile_data', 'share', 'location', 'air_plane', 'hotspot',
        'toggle_screenshot', 'toggle_screen_recorder', 'nfc', 'HuaweiCastToggle', 'dark_mode', 'camera', 'mic', 'sound'
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
      } finally {
        await driver.pressHome();
      }
    });

    it('ControlCenterComponentUiTest_showSubpage', 0, async (done: Function) => {
      try {
        // 下拉控制中心
        await driver.swipe(850, 10, 850, 400, 2000);
        await driver.delayMs(1500);

        let media = await driver.findComponent(ON.id('media_card'));
        await media.click();

        await driver.delayMs(1500);
        await driver.pressBack();
        await driver.delayMs(1500);

        // 上滑收起控制中心
        await driver.swipe(500, 2000, 500, 1000, 2000);
        await driver.delayMs(1500);
      } finally {
        await driver.pressHome();
        done();
      }
    });

    it('ControlCenterComponentUiTest_edit', 0, async (done: Function) => {
      try {
        // 下拉控制中心
        await driver.swipe(850, 10, 850, 400, 2000);
        await driver.delayMs(1500);

        let editBtn = await driver.findComponent(ON.id('Ctrl.HeaderLayout_Image_edit'));
        await editBtn.click();
        await driver.delayMs(3000);
        await driver.pressBack();
        await driver.delayMs(1500);
        // 上滑收起控制中心
        await driver.swipe(500, 2000, 500, 1000, 2000);
        await driver.delayMs(1500);
      } finally {
        await driver.pressHome();
        done();
      }
    });

    it('ControlCenterComponentUiTest_swipe_when_lock', 0, async (done: Function) => {
      try {
        // 电源键锁屏
        await driver.triggerKey(18);
        await driver.delayMs(2500);
        await driver.triggerKey(18);
        await driver.wakeUpDisplay();
        await driver.delayMs(1000);

        // 下拉控制中心
        await driver.swipe(850, 10, 850, 400, 2000);
        await driver.delayMs(1500);

        // 右滑到通知中心
        await driver.swipe(300, 300, 850, 300, 2000);
        await driver.delayMs(1500);

        // 上滑收起控制中心
        await driver.swipe(500, 2000, 500, 1000, 2000);
        await driver.delayMs(1500);
      } finally {
        await driver.delayMs(1000);
        await driver.fling({
          x: 500, y: 2000
        }, {
          x: 500, y: 900
        }, 1000, 2000);
        await driver.delayMs(1000);
        await driver.pressHome();
        done();
      }
    });

    it('ControlCenterComponentUiTest_slide_brightness_bar', 0, async (done: Function) => {
      try {
        // 下拉控制中心
        await driver.swipe(850, 10, 850, 400, 2000);
        await driver.delayMs(2000);

        // 右滑
        await driver.swipe(300, 2350, 1000, 2350, 1000);
        await driver.delayMs(1000);

        // 左滑
        await driver.swipe(1000, 2350, 300, 2350, 1000);
        await driver.delayMs(1000);

        // 上滑收起控制中心
        await driver.swipe(500, 2000, 500, 1000, 2000);
        await driver.delayMs(1500);
      } finally {
        await driver.pressHome();
        done();
      }
    });

    it('ControlCenterComponentUiTest_setting_to_nc', 0, async (done: Function) => {
      try {
        // 下拉控制中心
        await driver.swipe(850, 10, 850, 400, 2000);
        await driver.delayMs(1500);

        // 进入设置
        let editBtn = await driver.findComponent(ON.id('Ctrl.HeaderLayout_Image_settings'));
        await editBtn.click();
        await driver.delayMs(3000);

        // 下拉通知中心
        await driver.swipe(100, 10, 100, 500, 2000);
        await driver.delayMs(1500);

        // 上滑收起通知中心
        await driver.swipe(500, 2000, 500, 1000, 2000);
        await driver.delayMs(1500);
      } finally {
        await driver.pressHome();
        done();
      }
    });

    it('ControlCenterComponentUiTest_edit_to_nc', 0, async (done: Function) => {
      try {
        // 下拉控制中心
        await driver.swipe(850, 10, 850, 400, 2000);
        await driver.delayMs(1500);

        // 进入编辑
        let editBtn = await driver.findComponent(ON.id('Ctrl.HeaderLayout_Image_edit'));
        await editBtn.click();
        await driver.delayMs(3000);

        // 下拉通知中心
        await driver.swipe(100, 10, 100, 500, 2000);
        await driver.delayMs(1500);

        // 上滑收起通知中心
        await driver.swipe(500, 2000, 500, 1000, 2000);
        await driver.delayMs(1500);
      } finally {
        await driver.pressHome();
        done();
      }
    });

    it('ControlCenterComponentUiTest_hwshare_to_nc', 0, async (done: Function) => {
      try {
        // 下拉控制中心
        await driver.swipe(850, 10, 850, 400, 2000);
        await driver.delayMs(1500);

        // 进入分享二级页
        let editBtn = await driver.findComponent(ON.id('ToggleBaseComponent_Image_share'));
        await editBtn.longClick();
        await driver.delayMs(2000);

        // 下拉通知中心
        await driver.swipe(100, 10, 100, 500, 2000);
        await driver.delayMs(1500);

        // 上滑收起控制中心
        await driver.swipe(500, 2000, 500, 1000, 2000);
        await driver.delayMs(1500);
      } finally {
        await driver.pressHome();
        done();
      }
    });

    it('ControlCenterComponentUiTest_quit_cc', 0, async (done: Function) => {
      try {
        // 下拉控制中心
        await driver.swipe(850, 10, 850, 400, 2000);
        await driver.delayMs(1500);

        // home上滑收起控制中心
        await driver.swipe(500, 2720, 500, 2600, 1000);
        await driver.delayMs(1500);

        // 下拉控制中心
        await driver.swipe(850, 10, 850, 400, 2000);
        await driver.delayMs(1500);

        // 点击空白收起控制中心
        await driver.swipe(500, 2700, 500, 2701, 1000);
        await driver.delayMs(1500);
      } finally {
        await driver.pressHome();
        done();
      }
    });

    it('ControlCenterComponentUiTest_landscape', 0, async (done: Function) => {
      try {
        // 下拉控制中心
        await driver.swipe(850, 10, 850, 400, 2000);
        await driver.delayMs(1500);

        // 切换为横屏
        let controller = ControlCenterLayoutController.getInstance();
        (controller as object)['callback']?.(ControlCenterLayoutIndex.NORMAL_LANDSCAPE);
        await driver.delayMs(3000);

        // 切换为竖屏
        (controller as object)['callback']?.(ControlCenterLayoutIndex.NORMAL_PORTRAIT);
        await driver.delayMs(2000);

        // home上滑收起控制中心
        await driver.swipe(500, 2720, 500, 2600, 1000);
        await driver.delayMs(1500);
      } finally {
        await driver.pressHome();
        done();
      }
    });

    it('ControlCenterComponentUiTest_settings', 0, async (done: Function) => {
      try {
        // 下拉控制中心
        await driver.swipe(850, 10, 850, 400, 2000);
        await driver.delayMs(1500);

        let btn = await driver.findComponent(ON.id('Ctrl.HeaderLayout_Bg_settings'));
        await btn.click();
        await driver.delayMs(2000);
      } finally {
        await driver.pressHome();
        done();
      }
    });

    it('ControlCenterComponentUiTest_hotspot', 0, async (done: Function) => {
      try {
        // 下拉控制中心
        await driver.swipe(850, 10, 850, 400, 2000);
        await driver.delayMs(1500);

        let btn = await driver.findComponent(ON.id('ToggleBaseComponent_Image_hotspot'));
        await btn.click();
        await driver.delayMs(3000);

        btn = await driver.findComponent(ON.id('ToggleBaseComponent_Image_hotspot'));
        await btn.click();
        await driver.delayMs(2000);

        btn = await driver.findComponent(ON.id('ToggleBaseComponent_Image_hotspot'));
        await btn.longClick();
        await driver.delayMs(2000);
      } finally {
        await driver.pressHome();
        done();
      }
    });

    it('ControlCenterComponentUiTest_airplane', 0, async (done: Function) => {
      try {
        // 下拉控制中心
        await driver.swipe(850, 10, 850, 400, 2000);
        await driver.delayMs(1500);

        let btn = await driver.findComponent(ON.id('ToggleBaseComponent_Image_air_plane'));
        await btn.click();
        await driver.delayMs(3000);

        btn = await driver.findComponent(ON.id('ToggleBaseComponent_Image_air_plane'));
        await btn.click();
        await driver.delayMs(2000);

        btn = await driver.findComponent(ON.id('ToggleBaseComponent_Image_air_plane'));
        await btn.longClick();
        await driver.delayMs(2000);
      } finally {
        await driver.pressHome();
        done();
      }
    });

    it('ControlCenterComponentUiTest_mic', 0, async (done: Function) => {
      try {
        // 下拉控制中心
        await driver.swipe(850, 10, 850, 400, 2000);
        await driver.delayMs(1500);

        let btn = await driver.findComponent(ON.id('ToggleBaseComponent_Image_mic'));
        await btn.click();
        await driver.delayMs(500);
        let confirm = await driver.findComponent(ON.id('advanced_dialog_button_1'));
        await confirm.click();
        await driver.delayMs(3000);
        btn = await driver.findComponent(ON.id('ToggleBaseComponent_Image_mic'));
        await btn.click();
        await driver.delayMs(2000);
      } finally {
        await driver.pressHome();
        done();
      }
    });

    it('ControlCenterComponentUiTest_darkmode', 0, async (done: Function) => {
      try {
        // 下拉控制中心
        await driver.swipe(850, 10, 850, 400, 2000);
        await driver.delayMs(1500);

        let btn = await driver.findComponent(ON.id('ToggleBaseComponent_Image_dark_mode'));
        await btn.click();
        await driver.delayMs(3000);

        btn = await driver.findComponent(ON.id('ToggleBaseComponent_Image_dark_mode'));
        await btn.click();
        await driver.delayMs(2000);

        btn = await driver.findComponent(ON.id('ToggleBaseComponent_Image_dark_mode'));
        await btn.longClick();
        await driver.delayMs(2000);
      } finally {
        await driver.pressHome();
        done();
      }
    });

    it('ControlCenterComponentUiTest_rotate', 0, async (done: Function) => {
      try {
        // 下拉控制中心
        await driver.swipe(850, 10, 850, 400, 2000);
        await driver.delayMs(1500);

        let btn = await driver.findComponent(ON.id('ToggleBaseComponent_Image_auto_rotate'));
        await btn.click();
        btn = await driver.findComponent(ON.id('ToggleBaseComponent_Image_auto_rotate'));
        await btn.longClick();
        await driver.delayMs(2000);
      } finally {
        await driver.pressHome();
        done();
      }
    });

    it('ControlCenterComponentUiTest_sound', 0, async (done: Function) => {
      try {
        // 下拉控制中心
        await driver.swipe(850, 10, 850, 400, 2000);
        await driver.delayMs(1500);

        // 点击声音进入二级页面
        let btn = await driver.findComponent(ON.id('ToggleBaseComponent_Image_sound'));
        await btn.click();
        // 上滑收起通知中心
        await driver.swipe(500, 2000, 500, 1000, 2000);
        await driver.delayMs(1500);
      } finally {
        await driver.pressHome();
        done();
      }
    });

    it('ControlCenterComponentUiTest_HuaweiCastToggle', 0, async (done: Function) => {
      try {
        // 下拉控制中心
        await driver.swipe(850, 10, 850, 400, 2000);
        await driver.delayMs(1500);

        // 点击声音进入二级页面
        let btn = await driver.findComponent(ON.id('ToggleBaseComponent_Image_HuaweiCastToggle'));
        await btn.click();
        await driver.delayMs(3000);
        // 上滑收起控制中心
        await driver.swipe(850, 2000, 850, 1000, 2000);
        await driver.delayMs(1500);
      } finally {
        await driver.pressHome();
        done();
      }
    });
  })
}