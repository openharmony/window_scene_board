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
import { PluginSlot } from '@ohos/frameworkwrapper';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit } from '@ohos/hypium'
import constants, { WifiDetailState } from '@ohos/wificomponent/src/main/ets/default/common/Constants';
import { WifiDataPC } from '@ohos/wificomponent/src/main/ets/default/utils/WifiUtils';
import StatusBarResUtils from '@ohos/pcbase/src/main/ets/common/utils/StatusBarResourceUtils';

export default function StatusBarResourceTwoUtilsTest() {
  let mocker: MockKit;
  let wifiDataPc: WifiDataPC = new WifiDataPC();
  let isWhite: boolean = false;
  describe('StatusBarResourceTwoUtilsTest', () => {
    beforeAll(() => {
      mocker = new MockKit();
      wifiDataPc.isEthernetAvailable = false;
      wifiDataPc.isMetered = true;
      wifiDataPc.signalLevel = constants.DEFAULT_WIFI_INFO;
    })
    afterAll(() => {
      mocker.clearAll();
    })

    it('test_getIcon_wifi', 0, () => {
      try {
        let callback = StatusBarResUtils.getIcon(PluginSlot.SLOT_STATUS_WIFI_PANEL);
        expect(callback).assertEqual(StatusBarResUtils.getWifiIcon);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getIcon_capsule', 0, () => {
      try {
        let callback = StatusBarResUtils.getIcon(PluginSlot.SLOT_STATUS_CAPSULE_SCREENSHOT);
        expect(callback).assertEqual(StatusBarResUtils.getScreenShotIcon);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getIcon_smart', 0, () => {
      try {
        let callback = StatusBarResUtils.getIcon(PluginSlot.SLOT_STATUS_SMART_SCREENSHOT);
        expect(callback).assertEqual(StatusBarResUtils.getSmartScreenShotIcon);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getIcon_note', 0, () => {
      try {
        let callback = StatusBarResUtils.getIcon(PluginSlot.SLOT_STATUS_QUICK_NOTE);
        expect(callback).assertEqual(StatusBarResUtils.getNoteIcon);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })


    it('test_getIcon_search', 0, () => {
      try {
        let callback = StatusBarResUtils.getIcon(PluginSlot.SLOT_STATUS_SEARCH);
        expect(callback).assertEqual(StatusBarResUtils.getSearchIcon);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getIcon_default', 0, () => {
      try {
        let callback = StatusBarResUtils.getIcon('str');
        expect(callback).assertEqual(undefined);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getWifiIcon_ethernet', 0, () => {
      try {
        let result = StatusBarResUtils.getWifiIcon(wifiDataPc, isWhite);
        expect(result).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getWifiIcon_hotspot1', 0, () => {
      try {
        wifiDataPc.isEthernetAvailable = false;
        wifiDataPc.isMetered = true;
        let result = StatusBarResUtils.getWifiIcon(wifiDataPc, isWhite);
        expect(result).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getWifiIcon_hotspot2', 0, () => {
      try {
        wifiDataPc.isEthernetAvailable = false;
        wifiDataPc.isMetered = false;
        let result = StatusBarResUtils.getWifiIcon(wifiDataPc, isWhite);
        expect(result).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_hotspotImage_0', 0, () => {
      try {
        wifiDataPc.signalLevel = constants.WIFI_SIGNAL_NO;
        getHotspotImageTem(wifiDataPc, isWhite);
      } catch (e) {
        expect(e.message).assertEqual('error: ' + e.message);
      }
    })

    it('test_hotspotImage_1', 0, () => {
      try {
        wifiDataPc.signalLevel = constants.WIFI_SIGNAL_LOW;
        getHotspotImageTem(wifiDataPc, isWhite);
      } catch (e) {
        expect(e.message).assertEqual('error: ' + e.message);
      }
    })

    it('test_hotspotImage_2', 0, () => {
      try {
        wifiDataPc.signalLevel = constants.WIFI_SIGNAL_MID;
        getHotspotImageTem(wifiDataPc, isWhite);
      } catch (e) {
        expect(e.message).assertEqual('error: ' + e.message);
      }
    })

    it('test_hotspotImage_3', 0, () => {
      try {
        wifiDataPc.signalLevel = constants.WIFI_SIGNAL_HIGH;
        getHotspotImageTem(wifiDataPc, isWhite);
      } catch (e) {
        expect(e.message).assertEqual('error: ' + e.message);
      }
    })

    it('test_hotspotImage_4', 0, () => {
      try {
        wifiDataPc.signalLevel = constants.WIFI_SIGNAL_FULL;
        getHotspotImageTem(wifiDataPc, isWhite);
      } catch (e) {
        expect(e.message).assertEqual('error: ' + e.message);
      }
    })

    it('test_hotspot_default', 0, () => {
      try {
        wifiDataPc.signalLevel = -1;
        getHotspotImageTem(wifiDataPc, isWhite);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getActiveWifiIcon1', 0, () => {
      try {
        wifiDataPc.isNetworkAvailable = false;
        getActiveWifiIconTem(wifiDataPc, isWhite);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getActiveWifiIcon2', 0, () => {
      try {
        wifiDataPc.isNetworkAvailable = true;
        getActiveWifiIconTem(wifiDataPc, isWhite);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getImage_noActive', 0, () => {
      try {
        let isActive = WifiDetailState.STATE_UNKNOWN;
        getImageTem(isActive, wifiDataPc, isWhite);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getImage_default', 0, () => {
      try {
        let isActive = WifiDetailState.STATE_ACTIVE;
        wifiDataPc.signalLevel = constants.WIFI_SIGNAL_NO;
        wifiDataPc.supportedWifiCategory = constants.CATEGORY_DEFAULT;
        getImageTem(isActive, wifiDataPc, isWhite);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getImage_wifi6', 0, () => {
      try {
        let isActive = WifiDetailState.STATE_ACTIVE;
        wifiDataPc.signalLevel = constants.WIFI_SIGNAL_NO;
        wifiDataPc.supportedWifiCategory = constants.CATEGORY_WIFI6;
        getImageTem(isActive, wifiDataPc, isWhite);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getImage_wifi6Plus', 0, () => {
      try {
        let isActive = WifiDetailState.STATE_ACTIVE;
        wifiDataPc.signalLevel = constants.WIFI_SIGNAL_NO;
        wifiDataPc.supportedWifiCategory = constants.CATEGORY_WIFI6_PLUS;
        getImageTem(isActive, wifiDataPc, isWhite);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getImage_double', 0, () => {
      try {
        let isActive = WifiDetailState.STATE_ACTIVE;
        wifiDataPc.signalLevel = constants.WIFI_SIGNAL_NO;
        wifiDataPc.supportedWifiCategory = constants.CATEGORY_DOUBLE;
        getImageTem(isActive, wifiDataPc, isWhite);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getImage_doubleWifi6', 0, () => {
      try {
        let isActive = WifiDetailState.STATE_ACTIVE;
        wifiDataPc.signalLevel = constants.WIFI_SIGNAL_NO;
        wifiDataPc.supportedWifiCategory = constants.CATEGORY_DOUBLE_WIFI6;
        getImageTem(isActive, wifiDataPc, isWhite);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getImage_doubleWifi6Plus', 0, () => {
      try {
        let isActive = WifiDetailState.STATE_ACTIVE;
        wifiDataPc.signalLevel = constants.WIFI_SIGNAL_NO;
        wifiDataPc.supportedWifiCategory = constants.CATEGORY_DOUBLE_WIFI6_PLUS;
        getImageTem(isActive, wifiDataPc, isWhite);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getImage_others', 0, () => {
      try {
        let isActive = WifiDetailState.STATE_ACTIVE;
        wifiDataPc.signalLevel = constants.WIFI_SIGNAL_NO;
        wifiDataPc.supportedWifiCategory = constants.CATEGORY_DOUBLE_WIFI7;
        getImageTem(isActive, wifiDataPc, isWhite);
        wifiDataPc.supportedWifiCategory = constants.CATEGORY_DOUBLE_WIFI7_PLUS;
        getImageTem(isActive, wifiDataPc, isWhite);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getDefaultImage_all', 0, () => {
      try {
        wifiDataPc.signalLevel = -1;
        getDefaultImageTem(wifiDataPc, isWhite);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getWifi6Image_all', 0, () => {
      try {
        wifiDataPc.signalLevel = constants.WIFI_SIGNAL_NO;
        getWifi6ImageTem(wifiDataPc, isWhite);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getWifi6PlusImage_all', 0, () => {
      try {
        wifiDataPc.signalLevel = constants.WIFI_SIGNAL_LOW;
        getWifi6PlusImageTem(wifiDataPc, isWhite);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getWifiDoubleImage_all', 0, () => {
      try {
        wifiDataPc.signalLevel = constants.WIFI_SIGNAL_MID;
        getWifiDoubleImageTem(wifiDataPc, isWhite);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getDoubleWifi6image_all', 0, () => {
      try {
        wifiDataPc.signalLevel = constants.WIFI_SIGNAL_FULL;
        getDoubleWifi6imageTem(wifiDataPc, isWhite);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getDoubleWifi6PlusImage_all', 0, () => {
      try {
        wifiDataPc.signalLevel = constants.WIFI_SIGNAL_NO;
        getDoubleWifi6PlusImageTem(wifiDataPc, isWhite);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getFlowTypeImage', 0, () => {
      try {
        wifiDataPc.isMetered = false;
        StatusBarResUtils.getFlowTypeImage(wifiDataPc.dataFlowType, wifiDataPc.supportedWifiCategory, wifiDataPc.isMetered, isWhite);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getFlowTypeImageNormal_all', 0, () => {
      try {
        wifiDataPc.dataFlowType = -1;
        getFlowTypeImageNormalTem(wifiDataPc, isWhite);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getFlowTypeImageDouble_all', 0, () => {
      try {
        wifiDataPc.dataFlowType = constants.DATA_FLOW_TYPE_NONE;
        getFlowTypeImageDoubleTem(wifiDataPc, isWhite);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getNoNetImage', 0, () => {
      try {
        wifiDataPc.supportedWifiCategory = constants.CATEGORY_DOUBLE_WIFI7_PLUS;
        StatusBarResUtils.getNoNetImage(wifiDataPc.supportedWifiCategory, isWhite);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getNoNetImageNormal', 0, () => {
      try {
        let result = StatusBarResUtils.getNoNetImageNormal(isWhite);
        expect(result).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getNoNetImageDouble', 0, () => {
      try {
        let result = StatusBarResUtils.getNoNetImageDouble(isWhite);
        expect(result).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getEthernetImage', 0, () => {
      try {
        let result = StatusBarResUtils.getEthernetImage(!isWhite);
        expect(result).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getScreenShotIcon', 0, () => {
      try {
        let result = StatusBarResUtils.getScreenShotIcon(!isWhite);
        expect(result).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })

    it('test_getSmartScreenShotIcon', 0, () => {
      try {
        let result = StatusBarResUtils.getSmartScreenShotIcon(isWhite);
        expect(result).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
    })
  })
}

function getHotspotImageTem(wifiDataPc: WifiDataPC, isWhite: boolean) {
  let result = StatusBarResUtils.getHotspotImage(wifiDataPc.signalLevel, isWhite);
  expect(result).not().assertNull();
  result = StatusBarResUtils.getHotspotImage(wifiDataPc.signalLevel, !isWhite);
  expect(result).not().assertNull();
}

function getImageTem(isActive: WifiDetailState, wifiDataPc: WifiDataPC, isWhite: boolean) {
  let result = StatusBarResUtils.getImage(isActive, wifiDataPc.signalLevel, wifiDataPc.supportedWifiCategory, isWhite);
  expect(result).not().assertNull();
  result = StatusBarResUtils.getImage(isActive, wifiDataPc.signalLevel, wifiDataPc.supportedWifiCategory, !isWhite);
  expect(result).not().assertNull();
}

function getActiveWifiIconTem(wifiDataPc: WifiDataPC, isWhite: boolean) {
  let result = StatusBarResUtils.getActiveWifiIcon(wifiDataPc, isWhite);
  expect(result).not().assertNull();
  result = StatusBarResUtils.getActiveWifiIcon(wifiDataPc, !isWhite);
  expect(result).not().assertNull();
}

function getDefaultImageTem(wifiDataPc: WifiDataPC, isWhite: boolean) {
  let result = StatusBarResUtils.getDefaultImage(wifiDataPc.signalLevel, isWhite);
  expect(result).not().assertNull();
  result = StatusBarResUtils.getDefaultImage(wifiDataPc.signalLevel, !isWhite);
  expect(result).not().assertNull();
}

function getWifi6ImageTem(wifiDataPc: WifiDataPC, isWhite: boolean) {
  let result = StatusBarResUtils.getWifi6Image(wifiDataPc.signalLevel, isWhite);
  expect(result).not().assertNull();
  result = StatusBarResUtils.getWifi6Image(wifiDataPc.signalLevel, !isWhite);
  expect(result).not().assertNull();
}

function getWifi6PlusImageTem(wifiDataPc: WifiDataPC, isWhite: boolean) {
  let result = StatusBarResUtils.getWifi6PlusImage(wifiDataPc.signalLevel, isWhite);
  expect(result).not().assertNull();
  result = StatusBarResUtils.getWifi6PlusImage(wifiDataPc.signalLevel, !isWhite);
  expect(result).not().assertNull();
}
function getWifiDoubleImageTem(wifiDataPc: WifiDataPC, isWhite: boolean) {
  let result = StatusBarResUtils.getWifiDoubleImage(wifiDataPc.signalLevel, isWhite);
  expect(result).not().assertNull();
  result = StatusBarResUtils.getWifiDoubleImage(wifiDataPc.signalLevel, !isWhite);
  expect(result).not().assertNull();
}
function getDoubleWifi6imageTem(wifiDataPc: WifiDataPC, isWhite: boolean) {
  let result = StatusBarResUtils.getDoubleWifi6image(wifiDataPc.signalLevel, isWhite);
  expect(result).not().assertNull();
  result = StatusBarResUtils.getDoubleWifi6image(wifiDataPc.signalLevel, !isWhite);
  expect(result).not().assertNull();
}
function getDoubleWifi6PlusImageTem(wifiDataPc: WifiDataPC, isWhite: boolean) {
  let result = StatusBarResUtils.getDoubleWifi6PlusImage(wifiDataPc.signalLevel, isWhite);
  expect(result).not().assertNull();
  result = StatusBarResUtils.getDoubleWifi6PlusImage(wifiDataPc.signalLevel, !isWhite);
  expect(result).not().assertNull();
}
function getFlowTypeImageNormalTem(wifiDataPc: WifiDataPC, isWhite: boolean) {
  let result = StatusBarResUtils.getFlowTypeImageNormal(wifiDataPc.dataFlowType, isWhite);
  expect(result).not().assertNull();
  result = StatusBarResUtils.getFlowTypeImageNormal(wifiDataPc.dataFlowType, !isWhite);
  expect(result).not().assertNull();
}
function getFlowTypeImageDoubleTem(wifiDataPc: WifiDataPC, isWhite: boolean) {
  let result = StatusBarResUtils.getFlowTypeImageDouble(wifiDataPc.dataFlowType, isWhite);
  expect(result).not().assertNull();
  result = StatusBarResUtils.getFlowTypeImageDouble(wifiDataPc.dataFlowType, !isWhite);
  expect(result).not().assertNull();
}