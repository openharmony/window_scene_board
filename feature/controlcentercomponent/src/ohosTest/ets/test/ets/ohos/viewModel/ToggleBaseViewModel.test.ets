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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { QuickToggleController } from '../../../../../../main/ets/com/ohos/controller/QuickToggleController';
import { FASlotName } from '@ohos/commonconstants';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { PhoneStyleFactory } from '../../../../../../main/ets/com/ohos/phoneStyle/PhoneStyleFactory';
import { SingleFoldFactory } from '../../../../../../main/ets/com/ohos/SingleFoldStyle/SingleFoldStyleFactory';
import StyleConfiguration from '@ohos/systemuicommon/src/main/ets/template/common/StyleConfiguration';

export function ToggleBaseViewModelTest() {

  /**
   * 验证开关的初始化功能是否正常
   */
  describe('CreateToggleViewModelTest', (): void => {
    beforeAll((): void => {
    })

    afterAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    // 创建不存在的开关，返回为undefined
    it('QuickToggleController_createToggleModelAndInit_Test01', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      expect(sQuickToggleController.createToggleModelAndInit('aitoggle')).assertUndefined();
    })

    // 创建存在的开关，返回为ToggleBaseViewModel的实例
    it('QuickToggleController_createToggleModelAndInit_Test02', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      expect(sQuickToggleController.createToggleModelAndInit(FASlotName.POWER_SAVE)).assertInstanceOf('ToggleBaseViewModel');
    })

    // 创建存在的开关，验证开关初始化是否成功
    // 判断开关初始化成功的标识是开关的状态是否和底层状态一致
    it('QuickToggleController_createToggleModelAndInit_Test03', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      SCBScreenSessionManager.getInstance().setScreenOrientationLocked(true);
      let autoRotateViewModel = sQuickToggleController.createToggleModelAndInit(FASlotName.AUTO_ROTATE);
      expect(autoRotateViewModel?.getViewData().isOn).assertTrue();
    })

    // 创建存在的开关，验证开关初始化是否成功
    // 判断开关初始化成功的标识是开关的状态是否和底层状态一致
    it('QuickToggleController_createToggleModelAndInit_Test04', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      SCBScreenSessionManager.getInstance().setScreenOrientationLocked(false);
      let autoRotateViewModel = sQuickToggleController.createToggleModelAndInit(FASlotName.AUTO_ROTATE);
      expect(autoRotateViewModel?.getViewData().isOn).assertFalse();
    })
  })

  /**
   * 开关UI和功能一致性验证
   */
  describe('ToggleUITest', (): void => {
    beforeAll((): void => {
    })

    afterAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    // 初始化飞行模式和个人热点，当打开飞行模式的时候，个人热点开关UI状态应为不可用
    it('ToggleUITest_Test01', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      let airplaneViewModel = sQuickToggleController.createToggleModelAndInit(FASlotName.AIR_PLANE);
      let hotSpotViewModel = sQuickToggleController.createToggleModelAndInit(FASlotName.HOTSPOT);
      if (!airplaneViewModel?.getViewData().isOn) {
        airplaneViewModel?.handleOneClick();
      }
      expect(airplaneViewModel?.getViewData().isOn).assertTrue();
      expect(hotSpotViewModel?.getViewData().isUnavailable).assertTrue();
    })

    // 初始化响铃模式开关，点击切换开关状态，开关UI状态按照预期显示
    it('ToggleUITest_Test02', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      let ringModeViewModel = sQuickToggleController.createToggleModelAndInit(FASlotName.RING_MODE);
      let jumpMap: Map<number, number> = new Map([[2, 1], [1, 0], [0, 2]]);
      let stateCur = ringModeViewModel?.getState();
      ringModeViewModel?.handleOneClick();
      if (stateCur) {
        expect(ringModeViewModel?.getState()).assertEqual(jumpMap.get(stateCur));
      }
    })

    // 初始化响铃模式开关，点击切换开关状态，开关UI状态按照预期显示
    it('ToggleUITest_Test02', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      let ringModeViewModel = sQuickToggleController.createToggleModelAndInit(FASlotName.RING_MODE);
      let jumpMap: Map<number, number> = new Map([[2, 1], [1, 0], [0, 2]]);
      let stateCur = ringModeViewModel?.getState();
      ringModeViewModel?.handleOneClick();
      if (stateCur) {
        expect(ringModeViewModel?.getState()).assertEqual(jumpMap.get(stateCur));
      }
    })
  })

  /**
   * 验证多设备场景开关的UI样式
   */
  describe('Multi_Device_Test', (): void => {
    beforeAll((): void => {
    })

    afterAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    // 验证不同设备场景同类型开关尺寸是否按照各自标准设置
    it('Multi_Device_Test_Test01', 0, (): void => {
      let phoneFactory = new PhoneStyleFactory();
      let singleFoldFactory = new SingleFoldFactory();
      expect(phoneFactory.createBasicStyle().toggleParam?.getIconDiameter()).assertEqual(StyleConfiguration.getStyle().iconDiameter);
      expect(singleFoldFactory.createBasicStyle().toggleParam?.getIconDiameter()).assertEqual(StyleConfiguration.getStyle().wifiButtonDiameter);
    })

    // 验证是否可以基于某个设备平台样式进行自定义
    it('Multi_Device_Test_Test02', 0, (): void => {
      let phoneFactory = new PhoneStyleFactory();
      // 自定义开关尺寸，区分于手机平台其他开关
      phoneFactory.createBasicStyle().toggleParam?.iconDiameter(80);
      expect(phoneFactory.createBasicStyle().toggleParam?.getIconDiameter()).assertEqual(80);
    })
  })
}
