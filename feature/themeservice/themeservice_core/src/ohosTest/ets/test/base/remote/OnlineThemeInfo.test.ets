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

import { describe, expect, it } from '@ohos/hypium';
import { TContentPrivStatus } from '@ohos/themeservice_inner_api/Index';
import { getContentPrivStatus, OnlineThemeInfo } from '../../../../../main/ets/remote/model/OnlineThemeInfo';

export default function OnlineThemeInfoTest() {
  describe('OnlineThemeInfoTest', () => {
    it('getContentPrivStatus_undefined', 0, () => {
      const res: TContentPrivStatus = getContentPrivStatus();
      expect(res).assertEqual('disable');
    })
    it('getContentPrivStatus_0', 0, () => {
      const res: TContentPrivStatus = getContentPrivStatus({
        contentPrivStatus: 0
      } as OnlineThemeInfo);
      expect(res).assertEqual('disable');
    })
    it('getContentPrivStatus_1', 0, () => {
      const res: TContentPrivStatus = getContentPrivStatus({
        contentPrivStatus: 1
      } as OnlineThemeInfo);
      expect(res).assertEqual('enable');
    })
    it('getContentPrivStatus_2', 0, () => {
      const res: TContentPrivStatus = getContentPrivStatus({
        contentPrivStatus: 2
      } as OnlineThemeInfo);
      expect(res).assertEqual('vip');
    })
    it('getContentPrivStatus_3', 0, () => {
      const res: TContentPrivStatus = getContentPrivStatus({
        contentPrivStatus: 3
      } as OnlineThemeInfo);
      expect(res).assertEqual('disable');
    })
    it('getContentPrivStatus_4', 0, () => {
      const res: TContentPrivStatus = getContentPrivStatus({
        contentPrivStatus: -1
      } as OnlineThemeInfo);
      expect(res).assertEqual('disable');
    })
  })
}