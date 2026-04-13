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
import { it, describe, expect } from '@ohos/hypium';
import { DarkModeEvent,
  ThemeChangeEvent,
  ForegroundAppEvent,
  CapsuleExtendChangeEvent,
  HeadsUpChangeEvent,
  AirplaneStateEvent
} from '@ohos/systemuiutils/src/main/ets/sysdialog/CommonEvent';

export function CommonEventSystemuiTest() {
  describe('CommonEventSystemuiTest', (): void => {
    it('test_initDarkModeEvent', 0, (): void => {
      let testInstance: DarkModeEvent = new DarkModeEvent();
      expect(testInstance instanceof DarkModeEvent).assertTrue();
    });
    it('test_initThemeChangeEvent', 0, (): void => {
      let testInstance: ThemeChangeEvent = new ThemeChangeEvent();
      expect(testInstance instanceof ThemeChangeEvent).assertTrue();
    });


    it('test_initForegroundAppEvent', 0, (): void => {
      let testInstance: ForegroundAppEvent = new ForegroundAppEvent();
      expect(testInstance instanceof ForegroundAppEvent).assertTrue();
    });
    it('test_initCapsuleExtendChangeEvent', 0, (): void => {
      let testInstance: CapsuleExtendChangeEvent = new CapsuleExtendChangeEvent();
      expect(testInstance instanceof CapsuleExtendChangeEvent).assertTrue();
    });

    it('test_initHeadsUpChangeEvent', 0, (): void => {
      let testInstance: HeadsUpChangeEvent = new HeadsUpChangeEvent();
      expect(testInstance instanceof HeadsUpChangeEvent).assertTrue();
    });
    it('test_initAirplaneStateEvent', 0, (): void => {
      let testInstance: AirplaneStateEvent = new AirplaneStateEvent();
      expect(testInstance instanceof AirplaneStateEvent).assertTrue();
    });
  });
}