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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { DockItemInfo } from '@ohos/launchercommon'
import { AppIconData } from '@ohos/launchercommon/Index'
import { PcDockAnimationMgr, DockCompanionEffect} from '../../../../../main/ets/default/manager/PcDockAnimationMgr'

export default function PcDockAnimationMgrTest() {
  describe('PcDockAnimationMgrTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
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
    it('test_getInstance', 0, () => {
      const screenId = 0;
      let instance = PcDockAnimationMgr.getInstance(screenId);
      expect(instance).not().assertNull();
    });

    it('test_release', 0, () => {
      try {
        const screenId = 0;
        PcDockAnimationMgr.release(screenId);
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_setScrolling', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        const isListScrolling = true;
        instance.setScrolling(isListScrolling);
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_isListScrolling', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        instance.isListScrolling();
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_setIsResidentArrowShow', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        const residentArrowShow = true;
        instance.setIsResidentArrowShow(residentArrowShow);
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_setIsRecentArrowShow', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        const recentArrowShow = true;
        instance.setIsRecentArrowShow(recentArrowShow);
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_setResidentVisibleList', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        const list: Array<DockItemInfo> = [];
        instance.setResidentVisibleList(list);
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_setRecentVisibleList', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        const list: Array<DockItemInfo> = [];
        instance.setRecentVisibleList(list);
      } catch {
        expect(false).assertTrue();
      }
    });


    it('test_getResidentVisibleList', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        instance.getResidentVisibleList();
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_getRecentVisibleList', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        instance.getRecentVisibleList();
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_setCommonVisibleList', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        const list: Array<DockItemInfo> = [];
        instance.setCommonVisibleList(list);
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_setSystemVisibleList', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        const list: Array<DockItemInfo> = [];
        instance.setSystemVisibleList(list);
      } catch {
        expect(false).assertTrue();
      }
    });


    it('test_setCollaborationVisibleList', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        const list: Array<DockItemInfo> = [];
        instance.setCollaborationVisibleList(list);
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_getIsHoveringDock', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        instance.getIsHoveringDock();
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_setIsHoveringDock', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        instance.setIsHoveringDock(true);
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_getPrevItemScale', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        instance.getPrevItemScale();
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_getNextItemScale', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        instance.getNextItemScale();
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_getCurrentItemScale', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        instance.getCurrentItemScale();
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_getCurrentIconShadowOffsetX', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        instance.getCurrentIconShadowOffsetX();
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_getCurrentIconShadowOffsetY', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        instance.getCurrentIconShadowOffsetY();
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_computeHoverScale', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        const item = new DockItemInfo();
        item.bundleName = 'test_BU'
        const leftDistance = 100;
        const padding = 10;
        const itemWidth = 100;
        instance.computeHoverScale(item, leftDistance, padding, itemWidth);
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_computeIconShadow_1', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        const leftDistance = 100;
        const topDistance = 100;
        const itemWidth = 10;
        const dockHeight = 100;
        instance.computeIconShadow(leftDistance, topDistance, itemWidth, dockHeight);
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_computeIconShadow_2', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        const leftDistance = 100;
        const topDistance = 100;
        const itemWidth = 100;
        const dockHeight = 100;
        instance.computeIconShadow(leftDistance, topDistance, itemWidth, dockHeight);
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_judgeEdgeItem', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        const item = new DockItemInfo();
        item.bundleName = 'test_BU'
        instance.judgeEdgeItem(item, true);
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_registerCompanionEffect', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        const item = new DockItemInfo();
        const companionEffect: DockCompanionEffect = {
          triggerCompanionEffect: null
        }
        instance.registerCompanionEffect(item, companionEffect);
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_unRegisterCompanionEffect', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        const item = new DockItemInfo();
        const companionEffect: DockCompanionEffect = {
          triggerCompanionEffect: null
        }
        instance.unRegisterCompanionEffect(item, companionEffect);
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_resetAllEffect', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        instance.resetAllEffect();
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_resetItemNearLeftArrowEffect', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        instance.resetItemNearLeftArrowEffect();
      } catch {
        expect(false).assertTrue();
      }
    });


    it('test_resetItemNearRightArrowEffect', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        instance.resetItemNearRightArrowEffect();
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_resetItemEffect', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        const item = new DockItemInfo();
        instance.resetItemEffect(item);
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_isInVisibleArea', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        const item = new DockItemInfo();
        instance.isInVisibleArea(item, true, true);
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_isInDockVisibleList', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        const item = new DockItemInfo();
        instance.isInDockVisibleList(item);
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_doCompanionEffect', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        const item = new DockItemInfo();
        instance.doCompanionEffect(item, true);
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_getIconRect', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        const item = new DockItemInfo();
        instance.getIconRect(item);
      } catch {
        expect(false).assertTrue();
      }
    });

    it('test_setHoverItemColumnId', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        instance.setHoverItemColumnId('test');
      } catch {
        expect(false).assertTrue();
      }
    });


    it('test_getHoverItemColumnId', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        instance.getHoverItemColumnId();
      } catch {
        expect(false).assertTrue();
      }
    });

    it('setIconDataTest', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        let dockItemInfo = new DockItemInfo();
        let iconData = new AppIconData();
        instance.setIconData(dockItemInfo, iconData);
      } catch {
        expect(false).assertTrue();
      }
    });

    it('deleteIconDataTest', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        let dockItemInfo = new DockItemInfo();
        instance.deleteIconData(dockItemInfo);
      } catch {
        expect(false).assertTrue();
      }
    });

    it('getIconDataTest', 0, () => {
      try {
        const screenId = 0;
        let instance = PcDockAnimationMgr.getInstance(screenId);
        let iconData = new AppIconData();
        let item = new DockItemInfo();
        const COMMON_ICON_TYPE: string = 'CommonIcon';
        const key: string = item?.bundleName + '_' + item?.appIndex + '_' + item?.abilityName + '_' +
          COMMON_ICON_TYPE + '_' + (item?.persistentId ?? '') + '_' + (item?.appInstanceKey ?? '');
        instance.setIconData(item, iconData);
        expect(instance.getIconData(key)).assertEqual(iconData);
      } catch {
        expect(false).assertTrue();
      }
    });
  })
}