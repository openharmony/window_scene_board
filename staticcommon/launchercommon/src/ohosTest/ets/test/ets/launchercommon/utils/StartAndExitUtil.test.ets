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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { DeviceHelper, ScreenStateMonitor, ScreenStateModel } from '@ohos/frameworkwrapper';
import { StartAndExitUtil, StartAndExitResponse } from '../../../../../../main/ets/TsIndex';

const NORMAL_START_RESPONSE_MAP = new Map<string, number>([
  ['F_landscape', 0.26],
  ['F_portrait', 0.26],
  ['M_landscape', 0.285],
  ['M_portrait', 0.285],
  ['G_landscape', 0.295],
  ['G_portrait', 0.314],
]);

const OTHER_START_RESPONSE_MAP = new Map<string, number>([
  ['F_landscape', 0.3],
  ['F_portrait', 0.3],
  ['M_landscape', 0.33],
  ['M_portrait', 0.33],
  ['G_landscape', 0.34],
  ['G_portrait', 0.36],
]);

const EXIT_RESPONSE_MAP = new Map<string, number>([
  ['F_landscape', 0.5],
  ['F_portrait', 0.5],
  ['M_landscape', 0.55],
  ['M_portrait', 0.55],
  ['G_landscape', 0.58],
  ['G_portrait', 0.61],
]);

export default function StartAndExitUtilTest() {
  describe('StartAndExitUtilTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterAll((): void => {
    })

    afterEach((): void => {
    })

    it('get_normal_start_response', 0, (): void => {
      let response: number = StartAndExitUtil.getResponse(StartAndExitResponse.NORMAL_START);
      let screenStateKey: string = 'F_portrait';
      if (!DeviceHelper.isPad()) {
        let screenModel: ScreenStateModel = ScreenStateMonitor.getInstance().getCurrentScreenStateModel();
        screenStateKey = screenModel.screenState + '_' + screenModel.orientation;
      }
      expect(response).assertEqual(NORMAL_START_RESPONSE_MAP.get(screenStateKey) || 0.26);
    })

    it('get_other_start_response', 0, (): void => {
      let response: number = StartAndExitUtil.getResponse(StartAndExitResponse.OTHER_START);
      let screenStateKey: string = 'F_portrait';
      if (!DeviceHelper.isPad()) {
        let screenModel: ScreenStateModel = ScreenStateMonitor.getInstance().getCurrentScreenStateModel();
        screenStateKey = screenModel.screenState + '_' + screenModel.orientation;
      }
      expect(response).assertEqual(OTHER_START_RESPONSE_MAP.get(screenStateKey) || 0.3);
    })

    it('get_exit_response', 0, (): void => {
      let response: number = StartAndExitUtil.getResponse(StartAndExitResponse.EXIT);
      let screenStateKey: string = 'F_portrait';
      if (!DeviceHelper.isPad()) {
        let screenModel: ScreenStateModel = ScreenStateMonitor.getInstance().getCurrentScreenStateModel();
        screenStateKey = screenModel.screenState + '_' + screenModel.orientation;
      }
      expect(response).assertEqual(EXIT_RESPONSE_MAP.get(screenStateKey) || 0.5);
    })
  })
}
