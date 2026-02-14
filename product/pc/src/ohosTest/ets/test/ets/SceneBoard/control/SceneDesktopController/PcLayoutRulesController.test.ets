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

import { hilog } from '@kit.PerformanceAnalysisKit';
import {
  describe, beforeEach,
  afterEach, it,
  expect, MockKit,
} from '@ohos/hypium';
import {
  BaseConfig,
  CalculateDockRst,
  CalculateFormRst,
  LauncherLayoutStyleConfig} from '@ohos/launchercommon';
import {
  PcLayoutRulesController
} from '@ohos/pcbase/src/main/ets/SceneBoard/control/SceneDesktopController/PcLayoutRulesController';

const TAG: string = 'PcLayoutRulesControllerTest';

export default function PcLayoutRulesControllerTest() {
  describe('PcLayoutRulesControllerTest', () => {

    let mocker: MockKit;
    let baseConfig: BaseConfig;
    let launcherLayoutStyleConfig = LauncherLayoutStyleConfig.getInstance();
    baseConfig = BaseConfig.getInstance(launcherLayoutStyleConfig);
    let pcLayoutRulesController: PcLayoutRulesController;
    beforeEach(() => {
      mocker = new MockKit();
      pcLayoutRulesController = PcLayoutRulesController.getInstance(baseConfig)
    });

    afterEach(() => {
    });

    it('toStringTAGTest', 0, () => {
      const result: String = pcLayoutRulesController.toString();
      expect(result).assertDeepEquals('PcLayoutRulesControllers');
    });

    it('getInstanceTest', 0, () => {
      let instance1: PcLayoutRulesController = PcLayoutRulesController.getInstance(baseConfig);
      (PcLayoutRulesController as object)['pcInstance'] = null;
      let instance2: PcLayoutRulesController = PcLayoutRulesController.getInstance(baseConfig);
    });

    it('calculateFormTest', 0, (): void => {
      try {
        const result1: CalculateFormRst = pcLayoutRulesController.calculateForm();
        const result2: CalculateFormRst = pcLayoutRulesController.calculateForm();
        expect(result1).assertDeepEquals(result2);
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'calculateForm error' + e);
      }
    });

    it('calculateDockTest', 0, (): void => {
      try {
        const result1: CalculateDockRst = pcLayoutRulesController.calculateDock();
        const result2: CalculateDockRst = pcLayoutRulesController.calculateDock();
        expect(result1).assertDeepEquals(result2);
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'calculateDock error' + e);
      }
    });

    it('recalculateMaxNumTest', 0, (): void => {
      try {
        let result: CalculateDockRst = {};
        let dockSpaceWidth: number = 0;
        pcLayoutRulesController.recalculateMaxNum(result, dockSpaceWidth);
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'recalculateMaxNum error' + e);
      }
    });

    it('calculateDesktopTest', 0, (): void => {
      try {
        (pcLayoutRulesController as object)['mBaseConfig'].mScreenWidth = 0;
        (pcLayoutRulesController as object)['mBaseConfig'].mScreenHeight = 0;
        (pcLayoutRulesController as object)['mBaseConfig'].mIsPad = true;
        pcLayoutRulesController.calculateDesktop();

      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'calculateDesktop error' + e);
      }
    });

    it('calculateDesktopForNoPadTest', 0, (): void => {
      try {
        (pcLayoutRulesController as object)['mBaseConfig'].mIsPad = false;
        (pcLayoutRulesController as object)['mBaseConfig'].mScreenWidth = 100;
        (pcLayoutRulesController as object)['mBaseConfig'].mScreenHeight = 100;
        pcLayoutRulesController.calculateDesktop();

      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'calculateDesktop error' + e);
      }
    });

    it('calculateAppCenterTest', 0, (): void => {
      try {
        (pcLayoutRulesController as object)['mBaseConfig'].mScreenWidth = 0;
        (pcLayoutRulesController as object)['mBaseConfig'].mScreenHeight = 0;
        pcLayoutRulesController.calculateAppCenter();
        (pcLayoutRulesController as object)['mBaseConfig'].mScreenWidth = 100;
        (pcLayoutRulesController as object)['mBaseConfig'].mScreenHeight = 10;
        pcLayoutRulesController.calculateAppCenter();
        let screenId: number = 0;
        pcLayoutRulesController.calculateAppCenter(screenId);
        let isRefresh: boolean = false;
        pcLayoutRulesController.calculateAppCenter(screenId, isRefresh);
        let screenWidth: number = 0;
        pcLayoutRulesController.calculateAppCenter(screenId, isRefresh, screenWidth);
        let screenHeight: number = 0;
        pcLayoutRulesController.calculateAppCenter(screenId, isRefresh, screenWidth, screenHeight);
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'calculateAppCenter error' + e);
      }
    });

  })
}