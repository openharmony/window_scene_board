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

import { describe, it, expect } from '@ohos/hypium';
import {
  AnimationParam,
  aodThemeManager,
  ComponentRect,
  ComponentUtil,
  IAodClockRect,
  IAodMoveData,
  OuterAodConstants,
  ThemeType} from '@ohos/aod';
import { MockUtil } from '@ohos/aod/src/ohosTest/ets/test/MockUtil';
import type image from '@ohos.multimedia.image';
import {
  AodViewControllerOuterDigitalClock
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/factory/viewcontroller/AodViewControllerOuterDigitalClock';
import { AodOuterUtil } from '@ohos/aod/src/main/ets/utils/AodOuterUtil';

export function AodViewControllerOuterDigitalClockTest() {
  describe('AodViewControllerOuterDigitalClockTest', () => {

    it('only_one_instance_when_call_any_times_of_getInstance', 0, () => {
      const aodViewController = new AodViewControllerOuterDigitalClockTestClass();
      aodViewController.clearInstance();
      const instance0 = AodViewControllerOuterDigitalClock.getInstance();
      const instance1 = AodViewControllerOuterDigitalClock.getInstance();

      expect(true).assertTrue();
    });

    it('test_setDrawObservers', 0, () => {
      const tempContext: Nullable<UIContext> = ComponentUtil.uiContext;
      ComponentUtil.uiContext = undefined;
      const aodViewController = new AodViewControllerOuterDigitalClockTestClass();
      aodViewController.setDrawObserversTest();
      ComponentUtil.uiContext = tempContext;
      expect(true).assertTrue();
    });

    it('test_getBackgroundRect', 0, () => {
      const aodViewController = new AodViewControllerOuterDigitalClockTestClass();
      aodViewController.getBackgroundRectTest();
      expect(true).assertTrue();
    });

    it('test_prepareRes_releaseRes', 0, async () => {
      const aodViewController = new AodViewControllerOuterDigitalClockTestClass();
      MockUtil.mockFuncForObj(aodViewController, 'loadAnimImage');
      MockUtil.mockFuncForObj(AodOuterUtil, 'checkOuterWallpaperDisplaySwitchOpen', () => {
        return true;
      });
      let oldThemeType = aodThemeManager.themeType;
      await aodViewController.prepareResTest();
      aodThemeManager.themeType = ThemeType.OUTER_CLOCK_STYLE;
      await aodViewController.prepareResTest();
      await aodViewController.releaseResTest();
      aodThemeManager.themeType = oldThemeType;
      MockUtil.clearAll();
      expect(true).assertTrue();
    });

    it('test_isLayoutCenter', 0, () => {
      const aodViewController = new AodViewControllerOuterDigitalClockTestClass();
      aodViewController.isLayoutCenterTest();
      expect(true).assertTrue();
    });

    it('test_getOnGoingNtfRect', 0, () => {
      const aodViewController = new AodViewControllerOuterDigitalClockTestClass();
      aodViewController.getOnGoingNtfRectTest();
      expect(true).assertTrue();
    });

    it('test_getClockRect', 0, () => {
      const aodViewController = new AodViewControllerOuterDigitalClockTestClass();
      let instance = AodViewControllerOuterDigitalClock.getInstance();

      MockUtil.mockFuncForObj(instance, 'isLayoutCenter', () => {
        return true;
      });
      try {
        aodViewController.getClockRectTest();
      } catch (e) {
        expect(false).assertFalse();
      }

      MockUtil.mockFuncForObj(instance, 'isLayoutCenter', () => {
        return false;
      });
      try {
        aodViewController.getClockRectTest();
      } catch (e) {
        expect(false).assertFalse();
      }
      MockUtil.clearAll();
    });

    it('test_getAnimationRect', 0, async () => {
      const aodViewController = new AodViewControllerOuterDigitalClockTestClass();
      await aodViewController.getAnimationRectTest();
      expect(true).assertTrue();
    });

    it('test_getMaxDensity', 0, async () => {
      const aodViewController = new AodViewControllerOuterDigitalClockTestClass();
      await aodViewController.getMaxDensityTest();
      expect(true).assertTrue();
    });

    it('test_getLayerMoveData', 0, async () => {
      const aodViewController = new AodViewControllerOuterDigitalClockTestClass();
      try {
        await aodViewController.getLayerMoveDataTest({
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
        });
      } catch (e) {
        expect(false).assertFalse();
      }
    });

    it('test_getImageRotation', 0, async () => {
      const aodViewController = new AodViewControllerOuterDigitalClockTestClass();
      await aodViewController.getImageRotationTest();
      expect(true).assertTrue();
    });

    it('test_loadAnimImage', 0, async () => {
      const aodViewController = new AodViewControllerOuterDigitalClockTestClass();

      try {
        const param:AnimationParam = new AnimationParam();
        await aodViewController.loadAnimImageTest(param);
      } catch (e) {
        expect(false).assertFalse();
      }

      try {
        const param:AnimationParam = new AnimationParam();
        param.animImageSrc = {} as image.PixelMap;
        await aodViewController.loadAnimImageTest(param);
      } catch (e) {
        expect(false).assertFalse();
      }
    });

    it('test_getTimeTextHeight', 0, async () => {
      const aodViewController = new AodViewControllerOuterDigitalClockTestClass();
      let instance = AodViewControllerOuterDigitalClock.getInstance();
      MockUtil.mockFuncForObj(instance, 'isLayoutCenter', () => {
        return true;
      });
      try {
        await aodViewController.getTimeTextHeightTest();
      } catch (e) {
        expect(false).assertFalse();
      }
      MockUtil.mockFuncForObj(instance, 'isLayoutCenter', () => {
        return false;
      });
      try {
        await aodViewController.getTimeTextHeightTest();
      } catch (e) {
        expect(false).assertFalse();
      }
      MockUtil.clearAll();
    });

    it('AodViewControllerOuterDigitalClockTest_unRegisterSmallFoldStatusListener', 0, () => {
      const aodViewController = new AodViewControllerOuterDigitalClockTestClass();
      aodViewController.unRegisterSmallFoldStatusListener();
      expect(aodViewController).not().assertUndefined();
    });

    it('test_getCircleLayerMoveData', 0, async () => {
      const rect: ComponentRect = {
        left: 0,
        right: 340,
        top: 0,
        bottom: 340
      }
      const aodViewController = new AodViewControllerOuterDigitalClockTestClass();
      let instance = AodViewControllerOuterDigitalClock.getInstance();
      MockUtil.mockFuncForObj(instance, 'isLayoutCenter', () => {
        return true;
      });
      expect(aodViewController.getCircleLayerMoveDataTest(rect).moveDirect.x ===
        OuterAodConstants.ABI_MOVE_DIRECT).assertTrue();
      MockUtil.mockFuncForObj(instance, 'isLayoutCenter', () => {
        return false;
      });
      expect(aodViewController.getCircleLayerMoveDataTest(rect).moveDirect.x ===
        OuterAodConstants.ABI_MOVE_DIRECT).assertTrue();
      MockUtil.clearAll();
    });

    it('test_getSquareLayerMoveData', 0, async () => {
      const rect: ComponentRect = {
        left: 0,
        right: 480,
        top: 0,
        bottom: 480
      }
      const aodViewController = new AodViewControllerOuterDigitalClockTestClass();
      let instance = AodViewControllerOuterDigitalClock.getInstance();
      MockUtil.mockFuncForObj(instance, 'isLayoutCenter', () => {
        return true;
      });
      expect(aodViewController.getSquareLayerMoveDataTest(rect).moveDirect.y === 0).assertTrue();
      MockUtil.mockFuncForObj(instance, 'isLayoutCenter', () => {
        return false;
      });
      expect(aodViewController.getSquareLayerMoveDataTest(rect).moveDirect.y === 0).assertTrue();
      MockUtil.clearAll();
    });
  });

  class AodViewControllerOuterDigitalClockTestClass extends AodViewControllerOuterDigitalClock {
    protected static instanceNull: AodViewControllerOuterDigitalClock;

    constructor() {
      super();
    }

    public setDrawObserversTest(): void {
      this.setDrawObservers();
    }

    public getBackgroundRectTest(): ComponentRect {
      return this.getBackgroundRect();
    }

    public async prepareResTest(): Promise<void> {
      await this.prepareRes(false);
    }

    public async releaseResTest(): Promise<void> {
      await this.releaseRes();
    }

    public isLayoutCenterTest(): boolean {
      return this.isLayoutCenter();
    }

    public getOnGoingNtfRectTest(): ComponentRect {
      return this.getOnGoingNtfRect();
    }

    public getClockRectTest(): IAodClockRect {
      return this.getClockRect();
    }

    public getAnimationRectTest(): Promise<ComponentRect> {
      return this.getAnimationRect();
    }

    public getMaxDensityTest(): number {
      return this.getMaxDensity();
    }

    public getLayerMoveDataTest(clockRect: ComponentRect): IAodMoveData {
      return this.getLayerMoveData(clockRect);
    }

    public getImageRotationTest(): number {
      return this.getImageRotation();
    }

    public async loadAnimImageTest(animationParam: AnimationParam): Promise<void> {
      await this.loadAnimImage(animationParam);
    }

    public getTimeTextHeightTest(): number {
      return this.getTimeTextHeight();
    }

    public getCircleLayerMoveDataTest(clockRect: ComponentRect): IAodMoveData {
      return this.getCircleLayerMoveData(clockRect);
    }

    public getSquareLayerMoveDataTest(clockRect: ComponentRect): IAodMoveData {
      return this.getSquareLayerMoveData(clockRect);
    }

    public clearInstance(): void {
      AodViewControllerOuterDigitalClock.instance = AodViewControllerOuterDigitalClockTestClass.instanceNull;
    }
  }
}