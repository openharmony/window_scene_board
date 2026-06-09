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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
} from '@ohos/hypium'
import AVSessionManager from '@ohos.multimedia.avsession';

import { LogHelper, LogDomain } from '@ohos/basicutils';
import { RecentMediaPlay } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentMediaPlay'
const TAG = 'RecentMediaPlay';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export default function RecentMediaPlayTest() {
  describe('RecentMediaPlayTest', () => {
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


    it('recent_media_play_test_instance_is_same', 0, () => {
      let instance01 = RecentMediaPlay.getInstance();
      let instance02 = RecentMediaPlay.getInstance();
      expect(RecentMediaPlay.getInstance()).not().assertNull();
    })

    it('recent_media_play_test_map_is_empty', 0, () => {
      let instance = RecentMediaPlay.getInstance();
      let bundleName = 'com.ohos.music';
      let isPlay = instance.isContainerMediaPlay(bundleName);
      expect(isPlay).assertEqual(false);
    })

    it('recent_media_play_getPlayStateCallback_01', 0, () => {
      let descriptor: AVSessionManager.AVSessionDescriptor = {
        "sessionId":
        "DCE1C1AE292BA6852517B09F42A2164EEB7D90640F9AE7A4B43B0ACF4BFF8F28",
        "type": "audio",
        "sessionTag": "AVSessionPlayer",
        "elementName":
        {"deviceId":"", "bundleName":"com.ohos.music", "abilityName":"MainAbility"},
        "isActive": true,
        "isTopSession": true,
        "outputDevice":
        {"devices":[]}
      }
      let descriptor_: AVSessionManager.AVSessionDescriptor = {
        "sessionId": "E50ADEAEA8C40975A3CECB8D819566E23D5CEDFE6B49268254B886CA83570B8D",
        "type": "audio",
        "sessionTag": "QQMusic",
        "elementName":
        {"deviceId":"","bundleName":"com.tencent.hm.qqmusic","abilityName":"EntryAbility"},
        "isActive": true,
        "isTopSession": true,
        "outputDevice":{"devices":[]}
      }
      let descriptorArray = new Array<Readonly<AVSessionManager.AVSessionDescriptor>>();
      descriptorArray.push(descriptor);
      descriptorArray.push(descriptor_);
      let descriptors: Promise<Array<Readonly<AVSessionManager.AVSessionDescriptor>>> = new Promise((resolve) => {
        resolve(descriptorArray);
      });
      let instance = RecentMediaPlay.getInstance();
      let bundleName = 'com.ohos.music';
      instance.initAvSessionMap();
      (instance as object)['initControllerMap']()
      expect(instance).not().assertNull();
    })

    it('recent_media_play_test_init_controller_map', 0, () => {
      let descriptor: AVSessionManager.AVSessionDescriptor = {
        "sessionId":
            "DCE1C1AE292BA6852517B09F42A2164EEB7D90640F9AE7A4B43B0ACF4BFF8F28",
        "type": "audio",
        "sessionTag": "AVSessionPlayer",
        "elementName":
          {"deviceId":"", "bundleName":"com.ohos.music", "abilityName":"MainAbility"},
        "isActive": true,
        "isTopSession": true,
        "outputDevice":
          {"devices":[]}
      }
      let descriptor_: AVSessionManager.AVSessionDescriptor = {
        "sessionId": "E50ADEAEA8C40975A3CECB8D819566E23D5CEDFE6B49268254B886CA83570B8D",
        "type": "audio",
        "sessionTag": "QQMusic",
        "elementName":
        {"deviceId":"","bundleName":"com.tencent.hm.qqmusic","abilityName":"EntryAbility"},
        "isActive": true,
        "isTopSession": true,
        "outputDevice":{"devices":[]}
      }
      let descriptorArray = new Array<Readonly<AVSessionManager.AVSessionDescriptor>>();
      descriptorArray.push(descriptor);
      descriptorArray.push(descriptor_);
      let descriptors: Promise<Array<Readonly<AVSessionManager.AVSessionDescriptor>>> = new Promise((resolve) => {
        resolve(descriptorArray);
      });
      let instance = RecentMediaPlay.getInstance();
      let bundleName = 'com.tencent.hm.qqmusic';
      instance.initAvSessionMap();
      (instance as object)['monitorSessionAction']()
      expect(instance).not().assertNull();
    })

    it('recent_media_play_test_init_aVSession_map', 0, async () => {
      let descriptor: AVSessionManager.AVSessionDescriptor = {
        "sessionId":
        "DCE1C1AE292BA6852517B09F42A2164EEB7D90640F9AE7A4B43B0ACF4BFF8F28",
        "type": "audio",
        "sessionTag": "AVSessionPlayer",
        "elementName":
        {"deviceId":"", "bundleName":"com.ohos.music", "abilityName":"MainAbility"},
        "isActive": true,
        "isTopSession": true,
        "outputDevice":
        {"devices":[]}
      }
      let descriptor_: AVSessionManager.AVSessionDescriptor = {
        "sessionId": "E50ADEAEA8C40975A3CECB8D819566E23D5CEDFE6B49268254B886CA83570B8D",
        "type": "audio",
        "sessionTag": "QQMusic",
        "elementName":
        {"deviceId":"","bundleName":"com.tencent.hm.qqmusic","abilityName":"EntryAbility"},
        "isActive": true,
        "isTopSession": true,
        "outputDevice":{"devices":[]}
      }
      let descriptorArray = new Array<Readonly<AVSessionManager.AVSessionDescriptor>>();
      descriptorArray.push(descriptor);
      descriptorArray.push(descriptor_);
      let descriptors: Promise<Array<Readonly<AVSessionManager.AVSessionDescriptor>>> = new Promise((resolve) => {
        resolve(descriptorArray);
      });
      let instance = RecentMediaPlay.getInstance();
      expect(instance.initAvSessionMap() !== undefined).assertTrue()
    })
  })
}